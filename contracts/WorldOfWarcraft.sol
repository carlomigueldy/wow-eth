// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

contract WorldOfWarcraft is Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _characterIds;
    struct Character {
        string name;
        Class class;
        uint8 level;
        uint16 health;
        uint16 mana;
        Ability[] abilities;
    }
    struct Ability {
        string name;
        string description;
        uint8 damage;
        uint8 manaCost;
        uint8 cooldown;
    }

    Counters.Counter private _factionIds;
    Faction[] public factions;
    mapping(uint256 => address) public factionIdToOwner;
    mapping(address => uint256) public ownerToFactionsCount;
    mapping(uint256 => Counters.Counter) public factionIdToMemberCount;
    event FactionCreated(address owner, uint256 id, uint256 timestamp);

    struct Faction {
        uint256 id;
        address owner;
        string name;
        string description;
        address[] members;
        uint32 totalMembers;
    }

    enum Class {
        mage,
        priest,
        warlock,
        shaman
    }

    mapping(uint256 => address) public characterToOwner;

    constructor() {
        console.log(
            "WorldOfWarcraft | Deployed by '%s' at '%s'\n\n\n",
            owner(),
            address(this)
        );

        _seedFactions();
    }

    function _seedFactions() internal onlyOwner {
        createFaction(
            CreateFactionDto({
                name: "Alliance",
                description: "For the Alliance"
            })
        );

        createFaction(
            CreateFactionDto({name: "Horde", description: "FOR THE HORDE!!!"})
        );
    }

    struct CreateFactionDto {
        string name;
        string description;
    }

    /// @dev Creates a new Faction
    function createFaction(CreateFactionDto memory _dto)
        public
        returns (uint256)
    {
        uint256 _factionId = _factionIds.current();
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

        _factionIds.increment();

        return _factionId;
    }

    function _createFaction(address _owner, Faction memory _faction) private {
        uint256 _factionId = _faction.id;
        factions.push(_faction);
        factionIdToOwner[_factionId] = _owner;
        ownerToFactionsCount[_owner]++;
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
            ownerToFactionsCount[_owner]
        );
    }

    struct AddFactionMembersDto {
        address[] invited;
        uint256 factionId;
    }

    event FactionMemberAdded(
        address member,
        address addedBy,
        uint256 factionId
    );

    modifier onlyFactionOwner(uint256 _factionId) {
        require(
            factionIdToOwner[_factionId] == msg.sender,
            "Only the owner of this Faction."
        );
        _;
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

    struct AddFactionMemberDto {
        address invited;
        uint256 factionId;
    }

    /// @dev Individually adds a Faction member
    function addFactionMember(AddFactionMemberDto memory _dto)
        public
        onlyFactionOwner(_dto.factionId)
    {
        address _owner = factionIdToOwner[_dto.factionId];

        factions[_dto.factionId].members.push(_dto.invited);
        factions[_dto.factionId].totalMembers++;
        ownerToFactionsCount[_owner]++;

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

    /// @dev The total count of the Factions created
    function getTotalFactions() external view returns (uint256) {
        return _factionIds.current();
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
            ownerToFactionsCount[_owner]
        );

        for (uint256 index = 0; index < factions.length; index++) {
            if (factions[index].owner == _owner) {
                _factions[index] = factions[index];
            }
        }

        return _factions;
    }
}
