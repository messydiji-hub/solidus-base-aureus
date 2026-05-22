const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AureusVesting", function () {
  let vesting, token, owner, user;

  beforeEach(async () => {
    [owner, user] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("AureusToken");
    token = await Token.deploy();
    await token.waitForDeployment();
    const Vesting = await ethers.getContractFactory("AureusVesting");
    vesting = await Vesting.deploy(await token.getAddress());
    await vesting.waitForDeployment();
    await token.mint(owner.address, 10000);
    await token.approve(await vesting.getAddress(), 10000);
  });

  it("should create a vesting schedule", async () => {
    const duration = 365 * 24 * 3600;
    await vesting.createSchedule(user.address, 1000, 0, duration, false);
    const s = await vesting.schedules(user.address);
    expect(s.totalAmount).to.equal(1000);
  });

  it("should release tokens after cliff", async () => {
    const duration = 365 * 24 * 3600;
    await vesting.createSchedule(user.address, 1000, 0, duration, false);
    await ethers.provider.send("evm_increaseTime", [duration]);
    await ethers.provider.send("evm_mine");
    const balBefore = await token.balanceOf(user.address);
    await vesting.connect(user).release();
    const balAfter = await token.balanceOf(user.address);
    expect(balAfter - balBefore).to.equal(1000);
  });
});
