//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "hardhat/console.sol";

library Util {
    /// @dev just says "Cool" :)
    function sayCool() external pure returns (string memory) {
        return "Cool";
    }
}
