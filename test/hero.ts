import { expect } from "chai";
import { ethers } from "hardhat";

describe("Hero", () => {
  it("should not overflow when called", async () => {
    const Hero = await ethers.getContractFactory("Hero");
    const heroContract = await Hero.deploy();
    let overflow = await heroContract.getOverflow();
    console.log({ overflow });

    await heroContract.incrementOverflow();

    overflow = await heroContract.getOverflow();
    console.log({ overflow });

    expect(overflow).equal(255);
  });
});
