# Security Policy

Aureus Protocol takes the security of its smart contracts and user funds seriously.

## Supported Versions

| Version | Supported |
|---------|-----------|
| Latest (main) | ✅ Active development |
| < 1.0 | ⚠️ Pre-audit, use at your own risk |

## Reporting a Vulnerability

**Do not open a public GitHub issue.** Report privately:

| Channel | Contact |
|---------|---------|
| **GitHub Security Advisory** | [Report here](https://github.com/messydiji-hub/solidus-base-aureus/security/advisories/new) |
| **Email (maintainer)** | Reachable via GitHub profile |
| **DM** | @ on GitHub |

### Disclosure Timeline

1. **Report received** → acknowledged within 48 hours
2. **Triage** → 3 business days (severity + impact assessment)
3. **Patch** → 5-10 business days (depending on complexity)
4. **Coordinated disclosure** → 24 hours after patch deployment

If a fix cannot be delivered within 14 days, the reporter will be informed and the timeline renegotiated.

## Scope

| In Scope | Out of Scope |
|----------|--------------|
| `contracts/` — all Solidity source files | Frontend / UI repositories |
| Deploy scripts (`scripts/`, `ignition/`) | Third-party dependencies (report upstream) |
| On-chain configuration (`hardhat.config.js`) | Infrastructure outside this repo |
| Interfaces (`interfaces/`) | Off-chain wallets or exchanges |

## Bug Bounty Program

Qualifying vulnerabilities are eligible for rewards based on severity:

| Severity | Max Payout (USD) | Examples |
|----------|-----------------|----------|
| **Critical** | $5,000 | Direct loss of user funds, permanent freeze, infinite mint |
| **High** | $2,000 | Theft of yield/protocol fees, privilege escalation, griefing |
| **Medium** | $500 | Front-running that causes <$1K loss, rounding errors |
| **Low** | $100 | Gas griefing, informational findings |

### Rules

- ✅ First report only — duplicate findings are not paid
- ✅ Must be a previously undisclosed vulnerability
- ✅ Reporter must provide a clear reproduction or PoC
- ❌ No rewards for automated tool output without analysis
- ❌ No rewards for theoretical attacks requiring unrealistic conditions
- ❌ Do not test on mainnet; use `hardhat` or `baseSepolia`

### Payment

Bounties are paid in ETH or USDC on Base within 7 business days of patch deployment.

## Safe Harbor

Any activities conducted in good faith and in accordance with this policy will be considered authorised. You will not face legal action for researching vulnerabilities under this policy.

## Changelog

- **2026-05-22** — Initial security policy with bug bounty program
