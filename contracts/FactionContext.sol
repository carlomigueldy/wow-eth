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
    }

    Faction[] public factions;

    mapping(address => uint256) public memberToFactionId;

    enum FactionType {
        Horde,
        Alliance
    }

    function _seedFactions() internal onlyOwner {
        factions.push(
            Faction({
                name: "Alliance",
                factionType: FactionType.Alliance,
                members: new address[](0),
                totalMembers: 0
            })
        );

        factions.push(
            Faction({
                name: "Horde",
                factionType: FactionType.Horde,
                members: new address[](0),
                totalMembers: 0
            })
        );
    }

    function getFactions() external view returns (Faction[] memory) {
        return factions;
    }
}
