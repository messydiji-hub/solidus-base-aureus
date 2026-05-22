const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  const AureusToken = await ethers.getContractFactory("AureusToken");
  const token = await AureusToken.deploy();
  await token.waitForDeployment();
  const addr = await token.getAddress();
  console.log("AureusToken deployed to:", addr);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
