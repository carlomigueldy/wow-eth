// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/access/Ownable.sol";

contract Util is Ownable {
    function generateId(uint256 _id) public pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(_id)));
    }
}
