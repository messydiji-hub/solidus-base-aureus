const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AureusPool", function () {
  let pool, tokenA, tokenB, owner, user;

  beforeEach(async () => {
    [owner, user] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("AureusToken");
    tokenA = await Token.deploy();
    await tokenA.waitForDeployment();
    tokenB = await Token.deploy();
    await tokenB.waitForDeployment();
    const AureusPool = await ethers.getContractFactory("AureusPool");
    pool = await AureusPool.deploy(await tokenA.getAddress(), await tokenB.getAddress());
    await pool.waitForDeployment();
    await tokenA.mint(user.address, 10000);
    await tokenB.mint(user.address, 10000);
    await tokenA.connect(user).approve(await pool.getAddress(), 10000);
    await tokenB.connect(user).approve(await pool.getAddress(), 10000);
  });

  it("should add liquidity", async () => {
    await pool.connect(user).addLiquidity(1000, 1000);
    expect(await pool.totalLiquidity()).to.equal(1000);
    expect(await pool.liquidity(user.address)).to.equal(1000);
  });

  it("should remove liquidity", async () => {
    await pool.connect(user).addLiquidity(1000, 1000);
    await pool.connect(user).removeLiquidity(500);
    expect(await pool.totalLiquidity()).to.equal(500);
  });

  it("should swap tokens", async () => {
    await pool.connect(user).addLiquidity(1000, 1000);
    const balBefore = await tokenB.balanceOf(user.address);
    await pool.connect(user).swap(await tokenA.getAddress(), 100);
    const balAfter = await tokenB.balanceOf(user.address);
    expect(balAfter).to.be.gt(balBefore);
  });
});
