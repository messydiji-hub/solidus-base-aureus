# Testing Aureus Protocol

## Setup

```bash
npm install
npx hardhat compile
```

## Run All Tests

```bash
npx hardhat test
```

## Run Single Test

```bash
npx hardhat test test/AureusToken.js
npx hardhat test test/AureusFarm.js
npx hardhat test test/AureusPool.js
```

## Coverage

```bash
npx hardhat coverage
```

## Gas Report

```bash
REPORT_GAS=true npx hardhat test
```
