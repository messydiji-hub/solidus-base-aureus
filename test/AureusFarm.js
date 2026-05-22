const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AureusFarm", function () {
  let farm, stakingToken, rewardToken, owner, user;

  beforeEach(async () => {
    [owner, user] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("AureusToken");
    stakingToken = await Token.deploy();
    await stakingToken.waitForDeployment();
    rewardToken = await Token.deploy();
    await rewardToken.waitForDeployment();
    const AureusFarm = await ethers.getContractFactory("AureusFarm");
    farm = await AureusFarm.deploy(await stakingToken.getAddress(), await rewardToken.getAddress());
    await farm.waitForDeployment();
    await stakingToken.mint(user.address, 1000);
    await stakingToken.connect(user).approve(await farm.getAddress(), 1000);
  });

  it("should allow staking", async () => {
    await farm.connect(user).stake(500);
    const s = await farm.stakes(user.address);
    expect(s.amount).to.equal(500);
  });

  it("should allow unstaking", async () => {
    await farm.connect(user).stake(500);
    await farm.connect(user).unstake(200);
    const s = await farm.stakes(user.address);
    expect(s.amount).to.equal(300);
  });

  it("should reject unstaking more than staked", async () => {
    await farm.connect(user).stake(500);
    await expect(farm.connect(user).unstake(600)).to.be.revertedWith("Farm: insufficient stake");
  });
});
