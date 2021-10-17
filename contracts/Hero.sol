//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;

import "./libs/Util.sol";

contract Hero {
    uint8 public overflow = 250;
    uint256 public balance = 10000 ether;

    constructor() {
        console.log("Hero %s", msg.sender);
    }

    function sayHelloWorld() external view {
        console.log("Hello World %s", msg.sender);
    }

    function getOverflow() external view returns (uint8) {
        return overflow;
    }

    function getBalance() external view returns (uint256) {
        return balance;
    }

    function incrementOverflow() public {
        overflow = overflow + 1;
    }
}
