const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Upgrading contracts with account:", deployer.address);

  const proxyAddress = process.env.PROXY_ADDRESS;
  if (!proxyAddress) {
    console.error("PROXY_ADDRESS not set in .env");
    process.exit(1);
  }

  const AureusTokenV2 = await hre.ethers.getContractFactory("AureusToken");
  const upgraded = await hre.upgrades.upgradeProxy(proxyAddress, AureusTokenV2);
  await upgraded.waitForDeployment();

  const implAddress = await hre.upgrades.erc1967.getImplementationAddress(
    await upgraded.getAddress()
  );

  console.log("Upgraded to:", implAddress);

  if (process.env.BASESCAN_API_KEY) {
    await hre.run("verify:verify", { address: implAddress });
  }
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
