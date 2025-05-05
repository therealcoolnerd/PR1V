#!/usr/bin/env bash
set -euo pipefail
TREE_HEIGHT=20

echo "🛠️  Compiling GiftClaim circuit..."
circom gift_claim.circom --r1cs --wasm --sym -o build

echo "🛠️  Compiling ShieldWithdraw circuit..."
circom shield_withdraw.circom --r1cs --wasm --sym -o build

echo "✅  Circuits compiled into priv/circuits/build/"
