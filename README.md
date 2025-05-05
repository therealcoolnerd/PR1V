# Priv Privacy Suite

A blueprint for a web-based privacy suite with:
- Wallet Scrubber
- Secret Gift Sender
- Private Send (Mixer)

## Structure

- `contracts/` - Solidity smart contracts
- `circuits/` - Circom circuits
- `services/` - Node.js microservices (Threat DB, ZK Prover, Relayer)
- `frontend/` - Next.js frontend
- `scripts/` - Deployment scripts

## TODOs

- Complete contract logic and tests
- Implement all service endpoints
- Build frontend UI
- Write deployment and integration scripts

## Quick Start (local)

```bash
# start DB, local chain, and services
docker-compose -f docker-compose.dev.yml up --build

# run contracts unit tests
npx hardhat test

# compile circuits (needs circom & snarkjs installed)
cd priv/circuits && ./build-circuits.sh
```

## Deployment

1. `cp .env.example .env` and fill RPC keys.  
2. `npx hardhat run scripts/deploy.js --network sepolia`  
3. Copy contract addresses into `frontend/.env.local`.

## Audit Readiness

```bash
slither .
myth analyze .
npx hardhat coverage
```
