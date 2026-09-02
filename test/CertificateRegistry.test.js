import { expect } from "chai";
import { network } from "hardhat";

const { ethers } = await network.getOrCreate();

describe("CertificateRegistry", function () {
  let registry, owner, student;

  beforeEach(async () => {
    [owner, student] = await ethers.getSigners();
    const Registry = await ethers.getContractFactory("CertificateRegistry");
    registry = await Registry.deploy();
  });

  it("issues, verifies, then revokes a certificate", async () => {
    const certHash = ethers.keccak256(ethers.toUtf8Bytes("cert-data-example"));

    // Issue
    const tx = await registry.issueCertificate(student.address, certHash);
    const receipt = await tx.wait();
    const event = receipt.logs
      .map(l => registry.interface.parseLog(l))
      .find(e => e && e.name === "CertificateIssued");
    const certID = event.args.certificateID;

    // Verify - should be true
    expect(await registry.verifyCertificate(certID)).to.equal(true);

    // Revoke
    await registry.revokeCertificate(certID);

    // Verify - should now be false
    expect(await registry.verifyCertificate(certID)).to.equal(false);
  });

  it("rejects revoke from a non-issuer", async () => {
    const certHash = ethers.keccak256(ethers.toUtf8Bytes("cert-2"));
    const tx = await registry.issueCertificate(student.address, certHash);
    const receipt = await tx.wait();
    const certID = receipt.logs
      .map(l => registry.interface.parseLog(l))
      .find(e => e && e.name === "CertificateIssued").args.certificateID;

    const registryAsStudent = registry.connect(student);
    await expect(registryAsStudent.revokeCertificate(certID)).to.be.revert(ethers);
  });
});