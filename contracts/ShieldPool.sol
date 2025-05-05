// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract ShieldPool is Ownable {
    uint256 public denomination; // fixed denom
    IERC20  public immutable token;
    uint256 public feeBps = 500; // 5%
    bytes32[] public leaves;
    mapping(bytes32 => bool) public nullifiers;

    constructor(IERC20 _token, uint256 _denom) {
        token = _token;
        denomination = _denom;
    }

    event Deposit(bytes32 indexed commitment);
    event Withdraw(address indexed to, bytes32 nullifierHash);

    /* ------------------------------- deposit -------------------------------- */
    function deposit(bytes32 commitment) external {
        token.transferFrom(msg.sender, address(this), denomination);
        leaves.push(commitment);
        emit Deposit(commitment);
    }

    /* ------------------------------- withdraw ------------------------------- */
    function withdraw(
        address to,
        bytes32 nullifierHash,
        bytes32 root,
        bytes32[] calldata proof
    ) external {
        require(!nullifiers[nullifierHash], "spent");
        require(MerkleProof.verify(proof, root, nullifierHash), "bad proof");
        nullifiers[nullifierHash] = true;

        uint256 fee = (denomination * feeBps) / 10000;
        token.transfer(owner(), fee);
        token.transfer(to, denomination - fee);
        emit Withdraw(to, nullifierHash);
    }
}
