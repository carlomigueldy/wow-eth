import { BigNumberish } from "@ethersproject/bignumber";
import { assert, expect } from "chai";
import { useLogger } from "../utils/logger";
import { ethers } from "hardhat";

describe("WorldOfWarcraft", () => {
  describe("createGuild", () => {
    const log = useLogger("createGuild");

    it("should return 3 when a new Guild is created", async () => {
      // const owner = await getOwner();
      const contract = await getContract();

      let guilds = await contract.getAllGuilds();
      log.v("getAllGuilds", { guilds });

      await contract.createGuild({
        description: "We are the Scourge, all hail Arthas!",
        name: "The Scourge",
      });

      guilds = await contract.getAllGuilds();
      log.i("getAllGuilds", { guilds });

      expect(guilds).to.be.not.undefined;
      expect(guilds).to.be.not.null;
      expect(guilds).to.be.not.empty;
      expect(guilds).to.have.lengthOf(2);
    });
  });

  describe("getGuild", () => {
    const log = useLogger("getGuild");

    it("should return a Guild when given provided an existing Guild ID", async () => {
      const contract = await getContract();

      const guild = await contract.getGuild(0);

      assert(guild != null);
    });
  });

  describe("addGuildMember", () => {
    const log = useLogger("addGuildMember");

    it("should add a new team member when called addMember", async () => {
      const [, invited] = await ethers.getSigners();
      const contract = await getContract();
      const guildId = 1;

      await contract.createGuild({
        description: "We are the Scourge, all hail Arthas!",
        name: "The Scourge",
      });
      await contract.addGuildMember({
        invited: invited.address,
        guildId,
      });
      const Guild = await contract.getGuild(guildId);
      const members = Guild.members;
      log.i(members);

      contract.on("GuildCreated", (...args) => {
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
      const guildId = 1;

      await contract.createGuild({
        description: "We are the Scourge, all hail Arthas!",
        name: "The Scourge",
      });
      await contract.addGuildMember({
        invited: invited.address,
        guildId,
      });
      const guild = await contract.getGuild(guildId);
      const members = guild.members;

      log.i({ members });

      expect(guild).to.be.not.undefined;
      expect(guild).to.be.not.null;
      assert(members.length == 2);
    });
  });

  describe("addGuildMembers", () => {
    const log = useLogger("addGuildMembers");

    it("should total to 5 members when given 4 invited addresses", async () => {
      const [owner, invitedOne, invitedTwo, invitedThree, invitedFour] =
        await ethers.getSigners();
      const contract = await getContract();
      const guildId = 1;

      let balance = toEther(await owner.getBalance());
      log.i("owner.balance", { balance });

      const estimatedGasForCreateGuild = await contract.estimateGas.createGuild(
        {
          description: "We are the Scourge, all hail Arthas!",
          name: "The Scourge",
        }
      );
      console.log(
        "estimatedGasForCreateGuild:",
        toEther(estimatedGasForCreateGuild),
        "ETH\n"
      );

      await contract.createGuild({
        description: "We are the Scourge, all hail Arthas!",
        name: "The Scourge",
      });

      await contract.addGuildMembers({
        invited: [
          invitedOne.address,
          invitedTwo.address,
          invitedThree.address,
          invitedFour.address,
        ],
        guildId,
      });

      const guild = await contract.getGuild(guildId);
      const members = guild.members;

      log.i("getGuildMembers", { members });

      balance = toEther(await owner.getBalance());
      log.i("owner.balance", { balance });

      expect(members.length).equal(5);
    });

    it("should revert execution when given empty array", async () => {
      const [owner] = await ethers.getSigners();
      const contract = await getContract();
      const guildId = 1;

      let balance = toEther(await owner.getBalance());
      log.i("owner.balance", { balance });

      await contract.createGuild({
        description: "We are the Scourge, all hail Arthas!",
        name: "The Scourge",
      });

      const addGuildMembers = contract.addGuildMembers({
        invited: [],
        guildId,
      });

      await expect(addGuildMembers).revertedWith(
        "Must invite at least 1 member."
      );
    });
  });

  describe("getTotalGuilds", () => {
    //
  });

  describe("getGuildsByOwner", () => {
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
