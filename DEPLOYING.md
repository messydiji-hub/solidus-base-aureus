# Deploying Aureus Protocol

## Prerequisites

- Node.js >= 18
- Base mainnet or Base Sepolia RPC URL
- Deployer wallet with ETH for gas

## Setup

```bash
npm install
cp .env.example .env
# Edit .env with your RPC URL and private key
```

## Deploy

```bash
npx hardhat run scripts/deploy.js --network baseSepolia
```

## Verify

```bash
npx hardhat verify --network baseSepolia <CONTRACT_ADDRESS> [constructor args]
```

## Contracts (Deploy Order)

1. `AureusToken` — ERC20 reward token
2. `AureusFarm` — Staking farm
3. `AureusPool` — Liquidity pool
4. `AureusDistributor` — Reward distributor
5. `AureusVesting` — Vesting schedule
6. `AureusAirdrop` — Airdrop claims
7. `AureusTreasury` — Protocol treasury
