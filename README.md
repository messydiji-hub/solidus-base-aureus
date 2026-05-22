# solidus-base-aureus

Aureus — Yield & Rewards ecosystem on Base L2.

Named after the Roman gold coin, Aureus represents value generation through DeFi yield strategies.

## Contracts

- **AureusToken** (AVS) — Yield-bearing token with auto-compounding
- **AureusFarm** — Staking farm with tiered reward multipliers
- **AureusPool** — Liquidity pool for yield generation
- **AureusDistributor** — Reward distribution contract
- **AureusVesting** — Token vesting with cliff and linear release
- **AureusAirdrop** — Merkle-based airdrop distribution
- **AureusTreasury** — Multi-asset treasury management

## Setup

```bash
npm install
cp .env.example .env
```

## Test

```bash
npx hardhat test
```

## Network

Base L2 (mainnet.base.org)
