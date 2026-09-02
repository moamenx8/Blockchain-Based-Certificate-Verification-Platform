# 🔐 Blockchain-Based Certificate Verification Platform

A decentralized certificate issuance and verification platform built using **Blockchain, Smart Contracts, and Web3 technologies**.

The platform allows authorized organizations such as universities, educational institutions, and certification providers to issue digital certificates that can be securely verified through the blockchain.

---

## 📌 Overview

Traditional certificates can be forged, modified, or difficult to verify. This project provides a blockchain-based solution where certificate information is registered on-chain using a cryptographic hash.

Each certificate is associated with a unique blockchain-generated ID, allowing anyone with the certificate ID or QR code to verify its authenticity.

The system provides:

- 🔐 Blockchain-based certificate registration
- ✅ Certificate authenticity verification
- 🚫 Certificate revocation
- 👤 Authorized issuer management
- 📄 Certificate details retrieval
- 📱 QR code generation
- 📷 QR code scanning
- 🦊 MetaMask wallet integration
- 📊 Activity logging
- 🌐 Web3-based interaction with the smart contract

---

## ✨ Features

### 🎓 Certificate Issuance

Authorized issuers can issue certificates by providing:

- Student wallet address
- Certificate hash

The smart contract generates a unique `certificateID` for every certificate.

---

### 🔍 Certificate Verification

Users can verify a certificate using its unique blockchain certificate ID.

The platform checks whether:

1. The certificate exists.
2. The certificate has not been revoked.

A valid certificate is displayed as:

> ✅ Certificate is Valid

A revoked or nonexistent certificate is rejected.

---

### 📱 QR Code Verification

Every issued certificate can generate a QR code containing the certificate ID.

Users can:

- Upload a QR code image.
- Scan a QR code using their camera.
- Automatically retrieve the certificate ID.
- Verify the certificate on the blockchain.

---

### 👥 Issuer Management

The contract owner can manage authorized issuers.

#### Authorize Issuer

The owner can add a wallet address as an authorized certificate issuer.

```solidity
authorizeIssuer(address issuer)