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

        seedFactions();
    }

    function seedFactions() internal onlyOwner {
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
    function createFaction(CreateFactionDto memory dto)
        public
        returns (uint256)
    {
        uint256 _id = _factionIds.current();
        address _owner = msg.sender;

        Faction memory newFaction = Faction({
            id: _id,
            owner: _owner,
            name: dto.name,
            description: dto.description,
            members: new address[](0),
            totalMembers: 0
        });

        factions.push(newFaction);

        console.log(
            "_createFaction | A new faction has been created '%s' by '%s' with id '%s'",
            newFaction.name,
            _owner,
            _id
        );
        console.log(
            "_createFaction | Total Factions for '%s' is '%s'\n",
            _owner,
            ownerToFactionsCount[_owner]
        );

        // Add the first member as the owner
        // and increment it when a new member is added
        factions[_id].members.push(_owner);
        factions[_id].totalMembers++;

        // Attach the identifier to the mapping
        // that easily tells who is the Faction owner
        factionIdToOwner[_id] = _owner;
        ownerToFactionsCount[_owner]++;

        // Broadcast that a new Faction has been created
        emit FactionCreated(_owner, _id, block.timestamp);

        _factionIds.increment();

        return newFaction.id;
    }

    struct AddMemberDto {
        address target;
        uint256 factionId;
    }

    // function addMember(AddMemberDto memory dto) public returns (uint256) {
    //     require(
    //         factionIdToOwner[dto.factionId] == msg.sender,
    //         "Only the owner of this Faction can add new members."
    //     );

    //     address _owner = factionIdToOwner[dto.factionId];
    // }

    /// @dev The total count of the Factions created
    function totalFactions() external view returns (uint256) {
        return _factionIds.current();
    }

    /// @dev All the Factions that are created
    function allFactions() external view returns (Faction[] memory) {
        return factions;
    }

    function findFaction(uint256 _factionId)
        public
        view
        returns (Faction memory)
    {
        return factions[_factionId];
    }

    /// @return all the Factions that the given address has
    function findFactionByOwner(address _owner)
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
