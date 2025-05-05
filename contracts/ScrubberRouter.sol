// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ScrubberRouter is Ownable {
    address private constant DEAD_ADDRESS = 0x000000000000000000000000000000000000dEaD;
    uint256 public scrubFeeMilliPercent = 1; // 0.1% (milli‑percent to avoid truncation)

    event Scrubbed(address indexed user, address indexed token, uint256 idOrAmount, bool isBurn);

    constructor() Ownable(msg.sender) {}

    /* -------------------------------------------------------------------------- */
    /*                                   ERC‑20                                   */
    /* -------------------------------------------------------------------------- */
    function burnERC20(address token, uint256 amount) external {
        uint256 fee = (amount * scrubFeeMilliPercent) / 1000;
        uint256 burnAmount = amount - fee;
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        if (fee > 0) IERC20(token).transfer(owner(), fee);
        IERC20(token).transfer(DEAD_ADDRESS, burnAmount);
        emit Scrubbed(msg.sender, token, amount, true);
    }

    /* -------------------------------------------------------------------------- */
    /*                                   ERC‑721                                  */
    /* -------------------------------------------------------------------------- */
    function burnERC721(address token, uint256 tokenId) external {
        IERC721(token).transferFrom(msg.sender, DEAD_ADDRESS, tokenId);
        emit Scrubbed(msg.sender, token, tokenId, true);
    }

    /* -------------------------------------------------------------------------- */
    /*                                   ERC‑1155                                 */
    /* -------------------------------------------------------------------------- */
    function burnERC1155(address token, uint256 tokenId, uint256 amount) external {
        IERC1155(token).safeTransferFrom(msg.sender, DEAD_ADDRESS, tokenId, amount, "");
        emit Scrubbed(msg.sender, token, amount, true);
    }

    /* -------------------------------------------------------------------------- */
    /*                           Safe‑migrate (entire wallet)                     */
    /* -------------------------------------------------------------------------- */

    function migrateERC20(address token, uint256 amount, address destination) external {
        require(destination != address(0), "bad dest");
        IERC20(token).transferFrom(msg.sender, destination, amount);
    }
}
