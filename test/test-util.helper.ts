import { BigNumberish } from "@ethersproject/bignumber";
import { ethers } from "hardhat";

export class TestHelper {
  static async toEther(value: BigNumberish) {
    return ethers.utils.formatUnits(value, "ether");
  }

  static async getContract() {
    const WorldOfWarcraft = await ethers.getContractFactory("WorldOfWarcraft");
    return await WorldOfWarcraft.deploy();
  }

  static async getOwner() {
    const [owner] = await ethers.getSigners();
    return owner;
  }
}
