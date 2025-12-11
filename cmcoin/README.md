# cmcoin

A sample SIP-010 compatible fungible token smart contract called **cmcoin**, built with [Clarinet](https://docs.hiro.so/clarinet) for the Stacks blockchain.

## Project structure

- `Clarinet.toml` – Clarinet project configuration
- `contracts/cmcoin.clar` – main Clarity smart contract implementing the cmcoin fungible token
- `settings/` – network configuration (Devnet/Testnet/Mainnet)
- `tests/` – JavaScript/TypeScript tests for the contract

## Requirements

- Node.js (for running tests)
- Clarinet CLI

## Getting started

From the project root:

```bash path=null start=null
cd cmcoin
clarinet check
```

To run the TypeScript tests:

```bash path=null start=null
cd cmcoin
npm install
npm test
```

## Contract overview

The `cmcoin` contract implements a fungible token with:

- Name: `CM Coin`
- Symbol: `CMCOIN`
- Decimals: `6`
- SIP-010 compatible fungible token interface
- Support for allowances via `approve` and `transfer-from`
- Minting restricted to the contract owner
- Burning allowed by token holders on their own balance

### Key functions

- `get-name` / `get-symbol` / `get-decimals` – metadata accessors
- `get-balance-of` – read-only balance query
- `get-total-supply` – current total supply
- `get-allowance` – allowance from owner to spender
- `transfer` – direct token transfer initiated by the sender
- `approve` – set an allowance for a spender
- `transfer-from` – transfer tokens using an allowance
- `mint` – mint new tokens (owner only)
- `burn` – burn tokens from the caller’s balance

## Development workflow

1. Edit the contract in `contracts/cmcoin.clar`.
2. Run `clarinet check` frequently to validate the contract.
3. Add or update tests in `tests/cmcoin.test.ts`.
4. Run `npm test` to execute the test suite.

## Deployment

To deploy on a real network (Testnet/Mainnet):

1. Configure the desired network in `settings/*.toml`.
2. Use the deployment instructions from the Clarinet documentation or your preferred deployment tooling.
