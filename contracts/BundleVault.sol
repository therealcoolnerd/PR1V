// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/token/ERC721/utils/ERC721Holder.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BundleVault is ERC721Holder, ERC1155Holder, Ownable {
    address public factory;

    modifier onlyFactory() {
        require(msg.sender == factory, "only factory");
        _;
    }

    constructor() {
        factory = msg.sender;
    }

    enum AssetType { ERC20, ERC721, ERC1155 }

    function depositERC20(address token, uint256 amount) external onlyFactory {
        IERC20(token).transferFrom(tx.origin, address(this), amount); // tx.origin = creator
    }

    function withdrawERC20(address token, uint256 amount, address to) external onlyFactory {
        IERC20(token).transfer(to, amount);
    }

    function depositERC721(address token, uint256 id) external onlyFactory {
        ERC721(token).transferFrom(tx.origin, address(this), id);
    }

    function withdrawERC721(address token, uint256 id, address to) external onlyFactory {
        ERC721(token).transferFrom(address(this), to, id);
    }

    function depositERC1155(address token, uint256 id, uint256 amount) external onlyFactory {
        IERC1155(token).safeTransferFrom(tx.origin, address(this), id, amount, "");
    }

    function withdrawERC1155(address token, uint256 id, uint256 amount, address to) external onlyFactory {
        IERC1155(token).safeTransferFrom(address(this), to, id, amount, "");
    }
}
