pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/merkleproof.circom";
include "../node_modules/circomlib/circuits/merkleexclusionproof.circom";

template ShieldWithdraw(treeHeight, exclusionSetSize) {
    signal input secret;
    signal input randomNullifier;
    signal input pathElements[treeHeight];
    signal input pathIndices[treeHeight];
    signal input exclusionPathElements[exclusionSetSize][treeHeight];
    signal input exclusionPathIndices[exclusionSetSize][treeHeight];
    signal input root;
    signal input nullifier;
    signal input recipient;
    signal input token;
    signal input denomination;
    signal input exclusionRoot;

    // TODO: Add circuit logic
}

component main {public [root, nullifier, recipient, token, denomination, exclusionRoot]} = ShieldWithdraw(20, 10);
