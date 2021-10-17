import { useEffect, useState } from "react";
import { ethers } from "ethers";
import { abi as WorldOfWarcraft } from "../artifacts/contracts/WorldOfWarcraft.sol/WorldOfWarcraft.json";
import "./App.css";
import { useLogger } from "../utils/logger";

const SMART_CONTRACT_ADDRESS = "0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0";

function App() {
  useEffect(() => {
    getAllFactions();
  }, []);

  async function getAllFactions() {
    const log = useLogger("getAllFactions", true);
    log.v("called");
    const provider = new ethers.providers.Web3Provider(window.ethereum);
    const signer = provider.getSigner();
    const contract = new ethers.Contract(
      SMART_CONTRACT_ADDRESS,
      WorldOfWarcraft,
      signer
    );

    const factions = await contract.getAllFactions();
    log.i(factions);
  }

  return (
    <>
      <h1>Hello</h1>
    </>
  );
}

export default App;
