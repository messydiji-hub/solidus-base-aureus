const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AureusGovernor", function () {
  let governor, timelock, guardian1, guardian2, user;

  beforeEach(async () => {
    [guardian1, guardian2, user] = await ethers.getSigners();

    const Timelock = await ethers.getContractFactory("AureusTimelock");
    timelock = await Timelock.deploy(2 * 24 * 60 * 60); // 2 day delay

    const Governor = await ethers.getContractFactory("AureusGovernor");
    governor = await Governor.deploy(
      [guardian1.address, guardian2.address],
      timelock.target
    );
  });

  it("should deploy with correct guardians", async () => {
    expect(await governor.guardians(0)).to.equal(guardian1.address);
    expect(await governor.guardians(1)).to.equal(guardian2.address);
  });

  it("should allow guardians to approve", async () => {
    const tx = await governor.connect(guardian1).propose(user.address, "0x");
    const receipt = await tx.wait();
    const event = receipt.logs.find(l => l.fragment?.name === "ProposalCreated");
    const id = event.args[0];

    await governor.connect(guardian1).approve(id);
    expect(await governor.approvals(id)).to.equal(1);
  });
});
