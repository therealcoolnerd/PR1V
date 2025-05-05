// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ShieldPool is Ownable {
    uint256 private constant FEE_PERCENT = 50;
    uint256[] public denominations;
    mapping(uint256 => bytes32) public merkleTree;
    mapping(bytes32 => bool) public nullifiers;

    // TODO: Implement deposit, withdraw, and proof verification
}
