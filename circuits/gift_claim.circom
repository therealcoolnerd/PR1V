pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";
include "../node_modules/circomlib/circuits/merkleproof.circom";

template GiftClaim(treeHeight) {
    signal input secret;
    signal input randomNullifier;
    signal input pathElements[treeHeight];
    signal input pathIndices[treeHeight];
    signal input root;
    signal input nullifier;
    signal input recipient;

    component hasher = Poseidon(1);
    hasher.inputs[0] <== secret;
    signal commitment <== hasher.out;

    component merkleProof = MerkleProof(treeHeight);
    merkleProof.leaf <== commitment;
    merkleProof.root <== root;
    for (var i = 0; i < treeHeight; i++) {
        merkleProof.pathElements[i] <== pathElements[i];
        merkleProof.pathIndices[i] <== pathIndices[i];
    }

    component nullifierHasher = Poseidon(2);
    nullifierHasher.inputs[0] <== secret;
    nullifierHasher.inputs[1] <== randomNullifier;
    nullifierHasher.out === nullifier;
}

component main {public [root, nullifier, recipient]} = GiftClaim(20);
