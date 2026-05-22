const hre = require('hardhat');

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log('Verifying with account:', deployer.address);

  const contracts = [
    'AureusToken',
    'AureusFarm',
    'AureusPool',
    'AureusDistributor',
    'AureusVesting',
    'AureusAirdrop',
    'AureusTreasury',
    'AureusFactory',
  ];

  for (const name of contracts) {
    try {
      const contract = await hre.ethers.getContract(name);
      await hre.run('verify:verify', {
        address: await contract.getAddress(),
        constructorArguments: [],
      });
      console.log(`✓ ${name} verified`);
    } catch (e) {
      if (e.message.includes('Already Verified')) {
        console.log(`✓ ${name} already verified`);
      } else {
        console.error(`✗ ${name} verification failed:`, e.message);
      }
    }
  }
}

main().catch(console.error);
