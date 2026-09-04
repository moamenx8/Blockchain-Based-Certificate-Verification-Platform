# 🎓 Certificate Registry

A minimal blockchain-based certificate issuance and verification system, built as a learning project to understand core smart contract concepts: on-chain state, access control, and event-driven data lookup.

Universities (or any authorized issuer) can issue tamper-proof certificates on-chain. Anyone can verify a certificate's authenticity instantly — including by scanning a QR code — without needing to trust a central database.

## How it works

```
University → Issue Certificate → Blockchain → Certificate ID (+ QR Code)
                                                      ↓
                                          Anyone → Verify → VALID / INVALID
```

- **Issue** — an authorized issuer creates a certificate for a student's wallet address. The contract generates a unique `certificateID` and stores the issuer, student, a hash of the certificate data, and the issue date.
- **Verify** — anyone can check a certificate ID and get `true`/`false` back. No login, no central server — just the blockchain.
- **Revoke** — only the original issuer can revoke a certificate they issued. Revoked certificates return `false` on verification but are never deleted (the blockchain is append-only).

## Tech stack

- **Solidity** — smart contract logic
- **Hardhat 3** — compilation, local test network, deployment
- **Ethers.js v6** — contract interaction
- **MetaMask** — wallet connection in the browser
- **qrcodejs** / **jsQR** — QR code generation and scanning for certificate verification
- Plain **HTML/CSS/JS** frontend (Arabic UI) — no framework required

## Project structure

```
contracts/CertificateRegistry.sol   → the smart contract
test/CertificateRegistry.test.js    → automated tests (issue → verify → revoke)
scripts/deploy.js                   → deployment script for local/test networks
index.html                          → frontend (issue, verify, revoke, QR scan/generate)
```

## Getting started

### 1. Install dependencies
```bash
npm install
```

### 2. Run the tests
```bash
npx hardhat test
```

### 3. Start a local blockchain
```bash
npx hardhat node
```
Keep this terminal running — it starts a local Ethereum network with 20 pre-funded test accounts.

### 4. Deploy the contract (in a new terminal)
```bash
npx hardhat run scripts/deploy.js --network localhost
```
This prints the deployed contract address — copy it.

### 5. Configure the frontend
Open `index.html` and update:
```javascript
const CONTRACT_ADDRESS = "0xYourDeployedAddressHere";
```

### 6. Connect MetaMask to your local network
- Network Name: `Hardhat Local`
- RPC URL: `http://127.0.0.1:8545`
- Chain ID: `31337`
- Import an account using one of the private keys printed by `npx hardhat node`

### 7. Serve the frontend
```bash
npx serve .
```
Open the printed `localhost` URL in your browser.

## Usage

1. Connect MetaMask (use the account that deployed the contract — it's the default authorized issuer).
2. **Issue**: enter a student wallet address and certificate details → get a Certificate ID + downloadable QR code.
3. **Verify**: paste a Certificate ID, or scan its QR code (upload an image or use your camera) → instantly see VALID/INVALID.
4. **Revoke**: only the issuer who created a certificate can revoke it.

## ⚠️ Important notes

- This runs on a **local test network only**. The pre-funded test accounts from `npx hardhat node` use publicly known private keys — never send real funds to them or reuse them on a live network.
- This is a learning project, not an audited production system. Before any real-world use, the contract would need a security review, gas optimization, and a proper deployment/verification pipeline for a public testnet or mainnet.

## License

MIT
