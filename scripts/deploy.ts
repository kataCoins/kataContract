import { ethers } from "hardhat";
async function main() {

  const KataCoins = await ethers.getContractFactory("KataCoins");
  //Adresse de test fourni par hardhat
  const deployer = await ethers.getSigner("0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266");

  console.log(
      "Deploying the contracts with the account:",
      await deployer.getAddress()
  );

  const kataCoins = await KataCoins.connect(deployer).deploy();
  await kataCoins.deployed();


  console.log(`Lock with 1 ETH and unlock timestamp deployed to ${kataCoins.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
