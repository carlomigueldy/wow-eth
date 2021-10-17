import { useEffect, useState } from "react";
import { ethers } from "ethers";
import WorldOfWarcraft from "../artifacts/contracts/WorldOfWarcraft.sol/WorldOfWarcraft.json";
import "./App.css";

const SMART_CONTRACT_ADDRESS = "0xDc64a140Aa3E981100a9becA4E685f962f0cF6C9";

function App() {
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  const signer = provider.getSigner();

  useEffect(() => {
    new ethers.Contract(SMART_CONTRACT_ADDRESS, WorldOfWarcraft, signer);
  }, []);

  return <> </>;
}

export default App;
