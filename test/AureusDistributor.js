const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AureusDistributor", function () {
  let distributor, token, owner, users;

  beforeEach(async () => {
    [owner, ...users] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("AureusToken");
    token = await Token.deploy();
    await token.waitForDeployment();
    const Distributor = await ethers.getContractFactory("AureusDistributor");
    distributor = await Distributor.deploy(await token.getAddress());
    await distributor.waitForDeployment();
    await token.mint(owner.address, 10000);
    await token.approve(await distributor.getAddress(), 10000);
  });

  it("should set allocations", async () => {
    await distributor.setAllocations([users[0].address, users[1].address], [500, 300]);
    expect(await distributor.totalAllocation()).to.equal(800);
  });

  it("should allow claiming", async () => {
    await distributor.setAllocations([users[0].address], [500]);
    await token.transfer(await distributor.getAddress(), 500);
    const balBefore = await token.balanceOf(users[0].address);
    await distributor.connect(users[0]).claim();
    const balAfter = await token.balanceOf(users[0].address);
    expect(balAfter - balBefore).to.equal(500);
  });
});
