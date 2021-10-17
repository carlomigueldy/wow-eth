import { assert, expect } from "chai";
import { ethers } from "hardhat";

describe("WorldOfWarcraft", () => {
  describe("createFaction", () => {
    it("should return 3 when a new Faction is created", async () => {
      // const owner = await getOwner();
      const contract = await getContract();

      let factions = await contract.getAllFactions();
      console.log("getAllFactions", { factions });

      await contract.createFaction({
        description: "We are the Scourge, all hail Arthas!",
        name: "The Scourge",
      });

      factions = await contract.getAllFactions();
      console.log("getAllFactions", { factions });

      expect(factions.length == 3).true;
    });
  });

  describe("getFaction", () => {
    it("should return a Faction when given provided an existing Faction ID", async () => {
      const contract = await getContract();

      const faction = await contract.getFaction(1);

      assert(faction != null);
    });
  });

  describe("addFactionMember", () => {
    it("should add a new team member when called addMember", async () => {
      const owner = await getOwner();
      const [, invited] = await ethers.getSigners();
      const contract = await getContract();
      const factionId = 2;

      await contract.createFaction({
        description: "We are the Scourge, all hail Arthas!",
        name: "The Scourge",
      });

      await contract.addFactionMember({
        invited: invited.address,
        factionId,
      });
      const members = await contract.getFactionMembers(factionId);

      assert(members.length == 2);
    });
  });

  describe("addFactionMembers", () => {
    it("should total to 5 members when given 4 invited addresses", async () => {
      const [, invitedOne, invitedTwo, invitedThree, invitedFour] =
        await ethers.getSigners();
      const contract = await getContract();
      const factionId = 2;

      const estimatedGasForCreateFaction =
        await contract.estimateGas.createFaction({
          description: "We are the Scourge, all hail Arthas!",
          name: "The Scourge",
        });
      console.log(
        "estimatedGasForCreateFaction:",
        ethers.utils.formatUnits(estimatedGasForCreateFaction, "ether"),
        "ETH\n"
      );

      await contract.createFaction({
        description: "We are the Scourge, all hail Arthas!",
        name: "The Scourge",
      });

      await contract.addFactionMembers({
        invited: [
          invitedOne.address,
          invitedTwo.address,
          invitedThree.address,
          invitedFour.address,
        ],
        factionId,
      });

      const members = await contract.getFactionMembers(factionId);

      console.log("getFactionMembers", { members });

      expect(members.length).equal(5);
    });
  });
});

async function getContract() {
  const WorldOfWarcraft = await ethers.getContractFactory("WorldOfWarcraft");
  return await WorldOfWarcraft.deploy();
}

async function getOwner() {
  const [owner] = await ethers.getSigners();
  return owner;
}
