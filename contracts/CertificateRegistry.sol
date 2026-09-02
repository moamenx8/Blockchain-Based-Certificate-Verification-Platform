// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract CertificateRegistry {
    enum Status { Issued, Revoked } //certificates states
    struct Certificate { //each certificate contain 5 piece of information
        address issuer;  //wallet address of university
        address student; //wallet address of student
        bytes32 certificateHash; // hash of the certificate data/file(Instead of putting the actual PDF certificate on-chain)
        uint256 issueDate; //time when certificate was issued
        Status status; //certificate status
    }

    //mapping certificate id(byte32) to certificate
    //other contracts can't directly access the mapping variable (private)
    mapping(bytes32 => Certificate) private certificates;

    // Only these addresses can issue certs (e.g. university admin wallets)
    mapping(address => bool) public authorizedIssuers;

    //stores the wallet that controls the issuer permissions.
    address public owner;

    //we have 4 events, frontend can listen for it
    event CertificateIssued(bytes32 indexed certificateID, address indexed issuer, address indexed student);
    event CertificateRevoked(bytes32 indexed certificateID, address indexed revokedBy);
    event IssuerAuthorized(address indexed issuer);
    event IssuerRevoked(address indexed issuer);

    //Only the contract owner can execute functions using onlyOwner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    //checks if the caller is an authorized issuer.
    modifier onlyAuthorizedIssuer() {
        require(authorizedIssuers[msg.sender], "Not authorized issuer");
        _;
    }

    //constructor runs only once, when the contract is deployed.
    constructor() {
        owner = msg.sender;
        authorizedIssuers[msg.sender] = true; // deployer is an issuer by default
    }

    //Only the owner can call this
    function authorizeIssuer(address issuer) external onlyOwner {
        authorizedIssuers[issuer] = true;
        emit IssuerAuthorized(issuer);
    }

    function revokeIssuer(address issuer) external onlyOwner {
        authorizedIssuers[issuer] = false;
        emit IssuerRevoked(issuer);
    }

    /// @notice Issues a certificate and returns its unique ID
    function issueCertificate(address student, bytes32 certificateHash)
        external
        onlyAuthorizedIssuer
        returns (bytes32 certificateID)
    {   //generate a unique certificate ID using keccak256 hash function
        certificateID = keccak256(
            abi.encodePacked(msg.sender, student, certificateHash, block.timestamp, block.number)
        );

        // Ensure the certificate doesn't already exist
        require(certificates[certificateID].issueDate == 0, "Certificate already exists");
    //store certificate data in the mapping using the generated certificateID as the key
        certificates[certificateID] = Certificate({
            issuer: msg.sender,
            student: student,
            certificateHash: certificateHash,
            issueDate: block.timestamp,
            status: Status.Issued
        });
    //creates a blockchain event.
        emit CertificateIssued(certificateID, msg.sender, student);
    }

    /// @notice Returns true only if the cert exists AND is still Issued (not revoked)
    function verifyCertificate(bytes32 certificateID) external view returns (bool isValid) {
        Certificate memory cert = certificates[certificateID];
        return cert.issueDate != 0 && cert.status == Status.Issued;
    }

    /// @notice Full details for a certificate (useful for a frontend)
    function getCertificate(bytes32 certificateID) external view returns (Certificate memory) {
        require(certificates[certificateID].issueDate != 0, "Certificate does not exist");
        return certificates[certificateID];
    }

    /// @notice Revokes a certificate. Only the issuer can revoke their own certificates.
    function revokeCertificate(bytes32 certificateID) external {
        Certificate storage cert = certificates[certificateID];
        require(cert.issueDate != 0, "Certificate does not exist");
        require(cert.issuer == msg.sender, "Only issuer can revoke");
        require(cert.status == Status.Issued, "Already revoked");

        cert.status = Status.Revoked;
        emit CertificateRevoked(certificateID, msg.sender);
    }
}