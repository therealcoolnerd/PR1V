// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BundleVault.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GiftLinkFactory is Ownable {
    struct Asset {
        uint8 assetType;
        address token;
        uint256 tokenId;
        uint256 amount;
    }
    struct Bundle {
        bytes32 secretHash;
        uint256 expires;
        address creator;
        bool claimed;
        uint256 leafIndex;
    }

    uint256 private constant NFT_FEE = 20e18;
    uint256 private constant FEE_PERCENT = 50;

    BundleVault public vault;
    mapping(bytes32 => Bundle) public bundles;
    mapping(bytes32 => bool) public nullifiers;
    bytes32[] public merkleTree;

    event BundleCreated(bytes32 indexed commitmentHash, address indexed creator, uint256 expires);
    event BundleClaimed(bytes32 indexed commitmentHash, address indexed recipient, bytes32 nullifier);

    // TODO: Implement createBundle, claim, and Merkle logic
}
