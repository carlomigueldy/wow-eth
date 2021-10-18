// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "./Util.sol";

contract FactionContext is Util {
    struct Faction {
        string name;
        FactionType factionType;
        address[] members;
        uint64 totalMembers;
        uint256 balance;
    }

    mapping(FactionType => Faction) public factions;

    mapping(address => FactionType) public memberToFactionType;

    enum FactionType {
        Horde,
        Alliance
    }

    event NewFactionMember(
        address member,
        FactionType factionType,
        uint256 timestamp
    );

    event FactionSeeded(Faction[] factions, uint256 timestamp);

    function joinFaction(FactionType _factionType) public {
        memberToFactionType[msg.sender] = _factionType;

        emit NewFactionMember(msg.sender, _factionType, block.timestamp);
    }

    /// @dev Seed Factions on init
    function _seedFactions() internal onlyOwner {
        factions[FactionType.Alliance] = Faction({
            name: "Alliance",
            factionType: FactionType.Alliance,
            members: new address[](0),
            totalMembers: 0,
            balance: 100 ether
        });

        factions[FactionType.Horde] = Faction({
            name: "Horde",
            factionType: FactionType.Horde,
            members: new address[](0),
            totalMembers: 0,
            balance: 100 ether
        });

        emit FactionSeeded(getFactions(), block.timestamp);
    }

    /// @dev Get all available Factions
    function getFactions() public view returns (Faction[] memory) {
        Faction[] memory _factions = new Faction[](2);

        _factions[0] = factions[FactionType.Alliance];
        _factions[1] = factions[FactionType.Horde];

        return _factions;
    }
}
