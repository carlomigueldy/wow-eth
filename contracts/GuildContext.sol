// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract GuildContext {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    Guild[] public guilds;

    mapping(uint256 => address) private _guildIdToOwner;

    mapping(address => uint256) private _ownerToGuildsCount;

    event GuildCreated(address owner, uint256 id, uint256 timestamp);

    event GuildMemberAdded(address member, address addedBy, uint256 guildId);

    struct Guild {
        uint256 id;
        address owner;
        string name;
        string description;
        address[] members;
        uint32 totalMembers;
    }

    struct CreateGuildDto {
        string name;
        string description;
    }

    struct AddGuildMembersDto {
        address[] invited;
        uint256 guildId;
    }

    struct AddGuildMemberDto {
        address invited;
        uint256 guildId;
    }

    modifier onlyGuildOwner(uint256 _guildId) {
        require(
            _guildIdToOwner[_guildId] == msg.sender,
            "Only the owner of this Guild."
        );
        _;
    }

    /// @dev Creates a new Guild
    function createGuild(CreateGuildDto memory _dto) public returns (uint256) {
        uint256 _guildId = _tokenIds.current();
        address _owner = msg.sender;

        Guild memory _Guild = Guild({
            id: _guildId,
            owner: _owner,
            name: _dto.name,
            description: _dto.description,
            members: new address[](0),
            totalMembers: 0
        });

        _createGuild(_owner, _Guild);
        addGuildMember(AddGuildMemberDto(_owner, _guildId));

        _tokenIds.increment();

        return _guildId;
    }

    function _createGuild(address _owner, Guild memory _guild) private {
        uint256 _guildId = _guild.id;

        guilds.push(_guild);
        _guildIdToOwner[_guildId] = _owner;
        _ownerToGuildsCount[_owner]++;
        // Broadcast that a new Guild has been created
        emit GuildCreated(_owner, _guildId, block.timestamp);

        console.log(
            "_createGuild | A new Guild has been created '%s' by '%s' with Guild ID '%s'\n",
            _guild.name,
            _owner,
            _guildId
        );
        console.log(
            "_createGuild | Total Guilds for '%s' is '%s'\n",
            _owner,
            _ownerToGuildsCount[_owner]
        );
    }

    /// @dev Adds multiple Guild members to a Guild
    function addGuildMembers(AddGuildMembersDto memory _dto)
        public
        onlyGuildOwner(_dto.guildId)
    {
        require(_dto.invited.length > 0, "Must invite at least 1 member.");

        for (uint256 index = 0; index < _dto.invited.length; index++) {
            address invited = _dto.invited[index];

            addGuildMember(AddGuildMemberDto(invited, _dto.guildId));
        }
    }

    /// @dev Individually adds a Guild member
    function addGuildMember(AddGuildMemberDto memory _dto)
        public
        onlyGuildOwner(_dto.guildId)
    {
        require(_dto.invited != address(0), "The address should not be 0");

        address _owner = _guildIdToOwner[_dto.guildId];

        guilds[_dto.guildId].members.push(_dto.invited);
        guilds[_dto.guildId].totalMembers++;

        console.log(
            "addGuildMember | A new Guild Member '%s' has been added by '%s'\n",
            _dto.invited,
            _owner
        );

        emit GuildMemberAdded(_dto.invited, msg.sender, _dto.guildId);
    }

    /// @dev The total count of the Guilds created
    function getTotalGuilds() external view returns (uint256) {
        return _tokenIds.current();
    }

    /// @dev All the Guilds that are created
    function getAllGuilds() public view returns (Guild[] memory) {
        return guilds;
    }

    function getGuild(uint256 _GuildId) public view returns (Guild memory) {
        return guilds[_GuildId];
    }

    /// @return all the Guilds that the given address has
    function getGuildsByOwner(address _owner)
        external
        view
        returns (Guild[] memory)
    {
        Guild[] memory _Guilds = new Guild[](_ownerToGuildsCount[_owner]);

        for (uint256 index = 0; index < guilds.length; index++) {
            if (guilds[index].owner == _owner) {
                _Guilds[index] = guilds[index];
            }
        }

        return _Guilds;
    }
}
