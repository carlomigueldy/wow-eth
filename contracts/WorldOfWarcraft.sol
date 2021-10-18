// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Util.sol";
import "./GuildContext.sol";
import "./FactionContext.sol";

contract WorldOfWarcraft is Util, GuildContext, FactionContext {
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

        _seed();
    }

    function _seed() private onlyOwner {
        _seedFactions();
        createGuild(
            CreateGuildDto({name: "Genesis", description: "The first Guild"})
        );
    }
}
