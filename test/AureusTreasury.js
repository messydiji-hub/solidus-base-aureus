const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AureusTreasury", function () {
  let treasury, token, owner, strategist, user;

  beforeEach(async () => {
    [owner, strategist, user] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("AureusToken");
    token = await Token.deploy();
    await token.waitForDeployment();
    const Treasury = await ethers.getContractFactory("AureusTreasury");
    treasury = await Treasury.deploy();
    await treasury.waitForDeployment();
    await token.mint(owner.address, 10000);
    await token.approve(await treasury.getAddress(), 10000);
    const STRATEGIST_ROLE = ethers.keccak256(ethers.toUtf8Bytes("STRATEGIST_ROLE"));
    await treasury.grantRole(STRATEGIST_ROLE, strategist.address);
  });

  it("should deposit tokens", async () => {
    await treasury.deposit(await token.getAddress(), 1000);
    expect(await treasury.tokenBalances(await token.getAddress())).to.equal(1000);
  });

  it("should withdraw tokens", async () => {
    await treasury.deposit(await token.getAddress(), 1000);
    await treasury.withdraw(await token.getAddress(), user.address, 500);
    expect(await token.balanceOf(user.address)).to.equal(500);
  });

  it("should add a strategy", async () => {
    await treasury.connect(strategist).addStrategy(owner.address, "0x", 0);
    expect(await treasury.strategyCount()).to.equal(1);
  });
});
