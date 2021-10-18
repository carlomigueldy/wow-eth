import { assert, expect } from "chai";
import { useLogger } from "../utils/logger";
import { ethers } from "hardhat";
import { TestHelper } from "./test-util.helper";
import { WorldOfWarcraft } from "../typechain";

describe("FactionContext", () => {
  let contract: WorldOfWarcraft;

  beforeEach(async () => {
    contract = await TestHelper.getContract();
  });

  describe("getFactions", () => {
    const log = useLogger("getFactions");

    it("should return the seed factions when deployed", async () => {
      const factions = await contract.getFactions();

      expect(factions).to.be.not.null;
      expect(factions).to.be.not.undefined;
      expect(factions).to.be.not.NaN;
      expect(factions).to.be.not.empty;
      expect(factions).to.have.lengthOf(2);
    });
  });
});
