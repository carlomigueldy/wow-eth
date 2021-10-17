import { expect } from "chai";
import { ethers } from "hardhat";

describe("WorldOfWarcraft", () => {
  it("should return 3 when a new Faction is created", async () => {
    // const owner = await getOwner();
    const contract = await getContract();

    let factions = await contract.allFactions();
    console.log("allFactions", { factions });

    await contract.createFaction({
      description: "We are the Scourge, all hail Arthas!",
      name: "The Scourge",
    });

    factions = await contract.allFactions();
    console.log("allFactions", { factions });

    expect(factions.length == 3).true;
  });

  // it("should add a new team member when called addMember", async () => {
  //   const owner = await getOwner();
  //   const [, invited] = await ethers.getSigners();
  //   const contract = await getContract();

  //   await contract.addMember({
  //     target: invited,
  //     factionId: 3,
  //   });
  // });
});

async function getContract() {
  const WorldOfWarcraft = await ethers.getContractFactory("WorldOfWarcraft");
  return await WorldOfWarcraft.deploy();
}

async function getOwner() {
  const [owner] = await ethers.getSigners();
  return owner;
}
