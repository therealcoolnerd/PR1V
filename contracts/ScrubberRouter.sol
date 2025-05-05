// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ScrubberRouter is Ownable {
    address private constant DEAD_ADDRESS = 0x000000000000000000000000000000000000dEaD;
    uint256 public scrubFeePercent = 1; // 0.1%

    event Scrubbed(address indexed user, address indexed token, uint256 amount, bool isBurn);

    constructor() Ownable(msg.sender) {}

    function burnERC20(address token, uint256 amount) external {
        uint256 fee = (amount * scrubFeePercent) / 1000;
        uint256 burnAmount = amount - fee;

        IERC20(token).transferFrom(msg.sender, address(this), amount);
        if (fee > 0) {
            IERC20(token).transfer(owner(), fee);
        }
        IERC20(token).transfer(DEAD_ADDRESS, burnAmount);
        emit Scrubbed(msg.sender, token, amount, true);
    }
    // TODO: Add ERC721, ERC1155, and migrate functions
}
