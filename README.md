# PR1V: Privacy Suite for Ethereum

A comprehensive privacy toolkit for Ethereum, featuring:
- **Wallet Scrubber**: Clean your transaction history
- **Secret Gift Sender**: Send assets privately
- **Private Send (Mixer)**: Shield your transfers

## Architecture

PR1V consists of several components:
- Smart contracts (Solidity)
- ZK circuits (Circom)
- Microservices (TypeScript/Node.js)
  - Threat DB: Risk assessment for addresses and tokens
  - ZK Prover: Generate zero-knowledge proofs
  - Relayer: Submit transactions to the blockchain

## Development Setup

### Prerequisites
- Node.js 18+
- Docker and Docker Compose
- Circom 2.0.0+
- SnarkJS

### Installation

1. Clone the repository:
```bash
git clone https://github.com/therealcoolnerd/PR1V.git
cd PR1V
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
