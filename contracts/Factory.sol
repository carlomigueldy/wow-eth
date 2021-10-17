// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract Factory {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    Faction[] public factions;

    mapping(uint256 => address) private _factionIdToOwner;

    mapping(address => uint256) private _ownerToFactionsCount;

    mapping(uint256 => Counters.Counter) private _factionIdToMemberCount;

    event FactionCreated(address owner, uint256 id, uint256 timestamp);

    event FactionMemberAdded(
        address member,
        address addedBy,
        uint256 factionId
    );

    struct Faction {
        uint256 id;
        address owner;
        string name;
        string description;
        address[] members;
        uint32 totalMembers;
    }

    struct CreateFactionDto {
        string name;
        string description;
    }

    struct AddFactionMembersDto {
        address[] invited;
        uint256 factionId;
    }

    struct AddFactionMemberDto {
        address invited;
        uint256 factionId;
    }

    modifier onlyFactionOwner(uint256 _factionId) {
        require(
            _factionIdToOwner[_factionId] == msg.sender,
            "Only the owner of this Faction."
        );
        _;
    }

    /// @dev Creates a new Faction
    function createFaction(CreateFactionDto memory _dto)
        public
        returns (uint256)
    {
        uint256 _factionId = _tokenIds.current();
        address _owner = msg.sender;

        Faction memory _faction = Faction({
            id: _factionId,
            owner: _owner,
            name: _dto.name,
            description: _dto.description,
            members: new address[](0),
            totalMembers: 0
        });

        _createFaction(_owner, _faction);
        addFactionMember(AddFactionMemberDto(_owner, _factionId));

        _tokenIds.increment();

        return _factionId;
    }

    function _createFaction(address _owner, Faction memory _faction) private {
        uint256 _factionId = _faction.id;

        factions.push(_faction);
        _factionIdToOwner[_factionId] = _owner;
        _ownerToFactionsCount[_owner]++;
        // Broadcast that a new Faction has been created
        emit FactionCreated(_owner, _factionId, block.timestamp);

        console.log(
            "_createFaction | A new Faction has been created '%s' by '%s' with Faction ID '%s'\n",
            _faction.name,
            _owner,
            _factionId
        );
        console.log(
            "_createFaction | Total Factions for '%s' is '%s'\n",
            _owner,
            _ownerToFactionsCount[_owner]
        );
    }

    /// @dev Adds multiple Faction members to a Faction
    function addFactionMembers(AddFactionMembersDto memory _dto)
        public
        onlyFactionOwner(_dto.factionId)
    {
        for (uint256 index = 0; index < _dto.invited.length; index++) {
            address invited = _dto.invited[index];

            addFactionMember(AddFactionMemberDto(invited, _dto.factionId));
        }
    }

    /// @dev Individually adds a Faction member
    function addFactionMember(AddFactionMemberDto memory _dto)
        public
        onlyFactionOwner(_dto.factionId)
    {
        address _owner = _factionIdToOwner[_dto.factionId];

        factions[_dto.factionId].members.push(_dto.invited);
        factions[_dto.factionId].totalMembers++;
        _factionIdToMemberCount[_dto.factionId].increment();

        console.log(
            "addFactionMember | A new Faction Member '%s' has been added by '%s'\n",
            _dto.invited,
            _owner
        );

        emit FactionMemberAdded(_dto.invited, msg.sender, _dto.factionId);
    }

    /// @dev Retrieve a list of all Faction members
    function getFactionMembers(uint256 _factionId)
        public
        view
        returns (address[] memory)
    {
        return factions[_factionId].members;
    }

    /// @dev Get the total member count of a Faction
    function getFactionTotalMember(uint256 _factionId)
        external
        view
        returns (uint256)
    {
        return _factionIdToMemberCount[_factionId].current();
    }

    /// @dev The total count of the Factions created
    function getTotalFactions() external view returns (uint256) {
        return _tokenIds.current();
    }

    /// @dev All the Factions that are created
    function getAllFactions() public view returns (Faction[] memory) {
        return factions;
    }

    function getFaction(uint256 _factionId)
        public
        view
        returns (Faction memory)
    {
        return factions[_factionId];
    }

    /// @return all the Factions that the given address has
    function getFactionsByOwner(address _owner)
        external
        view
        returns (Faction[] memory)
    {
        Faction[] memory _factions = new Faction[](
            _ownerToFactionsCount[_owner]
        );

        for (uint256 index = 0; index < factions.length; index++) {
            if (factions[index].owner == _owner) {
                _factions[index] = factions[index];
            }
        }

        return _factions;
    }
}
