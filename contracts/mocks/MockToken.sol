// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract MockToken is ERC20 {
    constructor(string memory n,string memory s) ERC20(n,s) {_mint(msg.sender, 1e24);}
}
