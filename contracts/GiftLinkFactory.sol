// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "./BundleVault.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GiftLinkFactory is Ownable {
    BundleVault public immutable vault;
    uint256 private constant NFT_FEE_USD = 20e18; // placeholder; convert off‑chain
    uint256 private constant FEE_BPS = 500; // 5%

    struct Asset { uint8 assetType; address token; uint256 tokenId; uint256 amount; }
    struct Bundle {
        address creator;
        uint256 expires;
        bool claimed;
    }

    mapping(bytes32 => Bundle) public bundles;   // commitmentHash => Bundle
    mapping(bytes32 => bool) public nullifiers;  // spent nullifiers
    bytes32[] public merkleLeaves;

    event BundleCreated(bytes32 indexed commitment, address indexed creator, uint256 expires);
    event BundleClaimed(bytes32 indexed commitment, address indexed recipient);

    constructor() {
        vault = new BundleVault();
    }

    /* -------------------------------------------------------------------------- */
    /*                               Create bundle                                */
    /* -------------------------------------------------------------------------- */
    function createBundle(
        bytes32 commitment,
        Asset[] calldata items,
        uint256 expires
    ) external payable {
        require(bundles[commitment].creator == address(0), "exists");
        // simplistic fee: send ETH equal to 5% of ERC20 value or flat if NFT present
        // assume fee paid off‑chain for now
        bundles[commitment] = Bundle({creator: msg.sender, expires: expires, claimed: false});
        merkleLeaves.push(commitment);

        for (uint256 i; i < items.length; i++) {
            Asset calldata a = items[i];
            if (a.assetType == 0) vault.depositERC20(a.token, a.amount);
            else if (a.assetType == 1) vault.depositERC721(a.token, a.tokenId);
            else vault.depositERC1155(a.token, a.tokenId, a.amount);
        }

        emit BundleCreated(commitment, msg.sender, expires);
    }

    /* -------------------------------------------------------------------------- */
    /*                                   Claim                                    */
    /* -------------------------------------------------------------------------- */
    function claim(
        bytes32 nullifier,
        bytes32 root,
        bytes32[] calldata proof,
        address recipient,
        Asset[] calldata items
    ) external {
        require(!nullifiers[nullifier], "spent");
        bytes32 commitment = keccak256(abi.encodePacked(nullifier)); // placeholder: should be poseidon
        require(bundles[commitment].creator != address(0), "unknown bundle");
        require(!bundles[commitment].claimed, "claimed");
        require(block.timestamp <= bundles[commitment].expires, "expired");
        require(MerkleProof.verify(proof, root, commitment), "bad proof");

        nullifiers[nullifier] = true;
        bundles[commitment].claimed = true;

        // transfer assets from vault
        for (uint256 i; i < items.length; i++) {
            Asset calldata a = items[i];
            if (a.assetType == 0) vault.withdrawERC20(a.token, a.amount, recipient);
            else if (a.assetType == 1) vault.withdrawERC721(a.token, a.tokenId, recipient);
            else vault.withdrawERC1155(a.token, a.tokenId, a.amount, recipient);
        }

        emit BundleClaimed(commitment, recipient);
    }
}
