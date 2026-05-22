const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AureusToken", function () {
  let token, owner, addr1;

  beforeEach(async () => {
    [owner, addr1] = await ethers.getSigners();
    const AureusToken = await ethers.getContractFactory("AureusToken");
    token = await AureusToken.deploy();
    await token.waitForDeployment();
  });

  it("should have correct name and symbol", async () => {
    expect(await token.name()).to.equal("Aureus");
    expect(await token.symbol()).to.equal("AVS");
  });

  it("should mint tokens to owner", async () => {
    await token.mint(owner.address, 1000);
    expect(await token.balanceOf(owner.address)).to.equal(1000);
  });

  it("should not exceed max supply", async () => {
    const max = await token.MAX_SUPPLY();
    await expect(token.mint(addr1.address, max + 1n)).to.be.revertedWith("AVS: max supply exceeded");
  });

  it("should burn tokens", async () => {
    await token.mint(owner.address, 500);
    await token.burn(200);
    expect(await token.balanceOf(owner.address)).to.equal(300);
  });
});
