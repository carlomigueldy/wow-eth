import { expect } from "chai";
import { ethers } from "hardhat";
import { WorldOfWarcraft__factory } from "../typechain";

async function getContract() {
  const WorldOfWarcraft = await ethers.getContractFactory("WorldOfWarcraft");
  const contract = await WorldOfWarcraft.deploy();
  return contract;
}

describe("WorldOfWarcraft", () => {
  beforeEach(async () => {});

  it("should deploy", async () => {
    const contract = await getContract();

    expect((await contract.deployed()) !== null).true;
  });

  it("should create factions", async () => {
    const [owner] = await ethers.getSigners();
    const contract = await getContract();

    let factions = await contract.getAllFactions();
    console.log("getAllFactions", { factions });

    await contract.createFaction({
      description: "We are the Scourge, all hail Arthas!",
      name: "The Scourge",
      owner: owner.address,
    });

    factions = await contract.getAllFactions();
    console.log("getAllFactions", { factions });

    expect(factions.length > 0).true;
  });
});
