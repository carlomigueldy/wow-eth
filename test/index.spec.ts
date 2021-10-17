import { BigNumberish } from "@ethersproject/bignumber";
import { assert, expect } from "chai";
import { useLogger } from "../utils/logger";
import { ethers } from "hardhat";

describe("WorldOfWarcraft", () => {
  describe("createFaction", () => {
    const log = useLogger("createFaction");

    it("should return 3 when a new Faction is created", async () => {
      // const owner = await getOwner();
      const contract = await getContract();

      let factions = await contract.getAllFactions();
      log.v("getAllFactions", { factions });

      await contract.createFaction({
        description: "We are the Scourge, all hail Arthas!",
        name: "The Scourge",
      });

      factions = await contract.getAllFactions();
      log.i("getAllFactions", { factions });

      expect(factions.length == 3).true;
    });
  });

  describe("getFaction", () => {
    const log = useLogger("getFaction");

    it("should return a Faction when given provided an existing Faction ID", async () => {
      const contract = await getContract();

      const faction = await contract.getFaction(1);

      assert(faction != null);
    });
  });

  describe("addFactionMember", () => {
    const log = useLogger("addFactionMember");

    it("should add a new team member when called addMember", async () => {
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
      const faction = await contract.getFaction(factionId);
      const members = faction.members;
      log.i(members);

      contract.on("FactionCreated", (...args) => {
        log.i(args);
      });

      expect(members).to.be.not.NaN;
      expect(members).to.be.not.undefined;
      expect(members).to.be.not.null;
      expect(members).to.have.lengthOf(2);
    });

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
      const faction = await contract.getFaction(factionId);
      const members = faction.members;

      log.i(members);

      assert(members.length == 2);
    });
  });

  describe("addFactionMembers", () => {
    const log = useLogger("addFactionMembers");

    it("should total to 5 members when given 4 invited addresses", async () => {
      const [owner, invitedOne, invitedTwo, invitedThree, invitedFour] =
        await ethers.getSigners();
      const contract = await getContract();
      const factionId = 2;

      let balance = toEther(await owner.getBalance());
      log.i("owner.balance", { balance });

      const estimatedGasForCreateFaction =
        await contract.estimateGas.createFaction({
          description: "We are the Scourge, all hail Arthas!",
          name: "The Scourge",
        });
      console.log(
        "estimatedGasForCreateFaction:",
        toEther(estimatedGasForCreateFaction),
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

      const faction = await contract.getFaction(factionId);
      const members = faction.members;

      log.i("getFactionMembers", { members });

      balance = toEther(await owner.getBalance());
      log.i("owner.balance", { balance });

      expect(members.length).equal(5);
    });

    it("should revert execution when given empty array", async () => {
      const [owner] = await ethers.getSigners();
      const contract = await getContract();
      const factionId = 2;

      let balance = toEther(await owner.getBalance());
      log.i("owner.balance", { balance });

      await contract.createFaction({
        description: "We are the Scourge, all hail Arthas!",
        name: "The Scourge",
      });

      const addFactionMembers = contract.addFactionMembers({
        invited: [],
        factionId,
      });

      await expect(addFactionMembers).revertedWith(
        "Must invite at least 1 member."
      );
    });
  });

  describe("getTotalFactions", () => {
    //
  });

  describe("getFactionsByOwner", () => {
    //
  });
});

function toEther(value: BigNumberish) {
  return ethers.utils.formatUnits(value, "ether");
}

async function getContract() {
  const WorldOfWarcraft = await ethers.getContractFactory("WorldOfWarcraft");
  return await WorldOfWarcraft.deploy();
}

async function getOwner() {
  const [owner] = await ethers.getSigners();
  return owner;
}
