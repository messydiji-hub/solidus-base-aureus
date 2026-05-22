const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("AureusAirdrop", function () {
  let airdrop, token, owner, user;
  let merkleRoot, merkleProof;

  beforeEach(async () => {
    [owner, user] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("AureusToken");
    token = await Token.deploy();
    await token.waitForDeployment();
    const Airdrop = await ethers.getContractFactory("AureusAirdrop");
    airdrop = await Airdrop.deploy(await token.getAddress());
    await airdrop.waitForDeployment();
    await token.mint(owner.address, 10000);

    const leaf = ethers.solidityPackedKeccak256(["address", "uint256"], [user.address, 500]);
    const emptyProof = [];
    const { MerkleTree } = require("merkletreejs");
    const keccak256 = require("keccak256");
    const leaves = [keccak256(leaf)];
    const tree = new MerkleTree(leaves, keccak256, { sortPairs: true });
    merkleRoot = tree.getHexRoot();
    merkleProof = tree.getHexProof(keccak256(leaf));
  });

  it("should set merkle root", async () => {
    await airdrop.setMerkleRoot(merkleRoot);
    expect(await airdrop.merkleRoot()).to.equal(merkleRoot);
  });

  it("should allow claiming with proof", async () => {
    await airdrop.setMerkleRoot(merkleRoot);
    await token.transfer(await airdrop.getAddress(), 500);
    await airdrop.connect(user).claim(500, merkleProof);
    expect(await token.balanceOf(user.address)).to.equal(500);
    expect(await airdrop.hasClaimed(user.address)).to.be.true;
  });

  it("should reject double claim", async () => {
    await airdrop.setMerkleRoot(merkleRoot);
    await token.transfer(await airdrop.getAddress(), 500);
    await airdrop.connect(user).claim(500, merkleProof);
    await expect(airdrop.connect(user).claim(500, merkleProof)).to.be.revertedWith("Airdrop: already claimed");
  });
});
