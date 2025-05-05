#!/usr/bin/env bash
set -euo pipefail
mkdir -p build
echo "👉  NOTE: install circom & snarkjs before running"
circom gift_claim.circom --r1cs --wasm --sym -o build
snarkjs groth16 setup build/gift_claim.r1cs powersOfTau28_hez_final_10.ptau build/gift_claim_0000.zkey
snarkjs zkey export solidityverifier build/gift_claim_0000.zkey ../contracts/verifiers/GiftClaimVerifier.sol

circom shield_withdraw.circom --r1cs --wasm --sym -o build
snarkjs groth16 setup build/shield_withdraw.r1cs powersOfTau28_hez_final_10.ptau build/shield_withdraw_0000.zkey
snarkjs zkey export solidityverifier build/shield_withdraw_0000.zkey ../contracts/verifiers/ShieldVerifier.sol
