// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Factory.sol";

contract WorldOfWarcraft is Ownable, Factory {
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
}
