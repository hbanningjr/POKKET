POKKET

Protocol for On-chain Kategory-based Key Eligibility Tracking

A lightweight on-chain wallet categorization layer for composable identity and authorization systems.

POKKET is a self-sovereign wallet registry that provides an on-chain categorization layer for Ethereum addresses. It answers a single question: "What kind of wallet is this?"

It allows wallet owners to self-register Ethereum addresses with a category and human-readable label, creating a lightweight routing layer that other smart contracts can query without storing or exposing personally identifiable information (PII).

Why POKKET?

Blockchain applications often need to distinguish between different types of wallets without storing personal information.

Rather than embedding wallet categorization logic into every application, POKKET provides a reusable registry that any smart contract can query.

This keeps identity, wallet categorization, and authorization as independent, composable concerns.

Design Philosophy

POKKET follows the principle of single responsibility.

Rather than combining identity, wallet ownership, and authorization into one contract, POKKET focuses solely on wallet categorization.

Other contracts can compose this information without inheriting unnecessary complexity.

Where POKKET Fits
text
┌──────────────────┐
│   CivicPass      │
│   Who is this?   │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   POKKET         │
│   Which wallet   │
│   is this?       │
└────────┬─────────┘
         │
         ▼
┌──────────────────┐
│   MINE           │
│   Should this    │
│   wallet         │
│   participate?   │
└──────────────────┘
Wallet Categories
Category	Use Case
None	Default / unregistered
Voting	Governance and election eligibility
NFT	Digital asset and collectible wallets
DeFi	Decentralized finance participation
RealEstate	Real world asset and property tokenization
Test	Development and testing purposes
Public Interface

src/WalletRegistry.sol

Function	Description
registerWallet	Register caller's wallet with a category and label
getWalletInfo	Retrieve full wallet info for any address
isCategory	Check if a wallet belongs to a specific category
Design Decisions
Registration is permanent and cannot be silently overwritten
Future wallet changes will be handled through a dedicated updateWallet function
isCategory() verifies wallet existence before comparing categories, preventing false positives from Solidity's default mapping values
Registration emits WalletRegistered events for off-chain indexing and observability
Testing

Built with Foundry using a comprehensive unit test suite covering registration, retrieval, wallet isolation, authorization checks, and edge cases.

✓ 9 unit tests
✓ 9 passing
bash
forge test -v
Deployment

Sepolia testnet — address coming soon.

Related Projects
CivicPass — Privacy-preserving credential verification
MINE — Decentralized authorization layer
