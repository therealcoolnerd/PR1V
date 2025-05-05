const hre = require("hardhat");
async function main() {
  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with", deployer.address);

  // Example token for ShieldPool
  const MockToken = await hre.ethers.getContractFactory("contracts/mocks/MockToken.sol:MockToken");
  const token = await MockToken.deploy("Mock", "MOCK");
  await token.deployed();

  const denom = hre.ethers.utils.parseEther("1");
  const ShieldPool = await hre.ethers.getContractFactory("ShieldPool");
  const pool = await ShieldPool.deploy(token.address, denom);
  await pool.deployed();
  console.log("ShieldPool:", pool.address);

  const GiftLinkFactory = await hre.ethers.getContractFactory("GiftLinkFactory");
  const gift = await GiftLinkFactory.deploy();
  await gift.deployed();
  console.log("GiftLinkFactory:", gift.address);
}
main().catch((e) => {
  console.error(e);
  process.exit(1);
});
