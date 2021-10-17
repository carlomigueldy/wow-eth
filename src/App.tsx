import { useEffect, useState } from "react";
import { ethers } from "ethers";
import { abi } from "../artifacts/contracts/WorldOfWarcraft.sol/WorldOfWarcraft.json";
import "./App.css";
import { WorldOfWarcraft } from "../typechain";

const SMART_CONTRACT_ADDRESS = "0x5FbDB2315678afecb367f032d93F642f64180aa3";

async function useContract(): Promise<WorldOfWarcraft> {
  const provider = new ethers.providers.Web3Provider(window.ethereum);
  const signer = provider.getSigner();
  console.log({ signer });
  const contract = new ethers.Contract(
    SMART_CONTRACT_ADDRESS,
    abi,
    signer
  ) as WorldOfWarcraft;
  return contract;
}

function App() {
  const [accounts, setAccounts] = useState<string[]>([]);

  useEffect(() => {}, []);

  async function connectWallet() {
    const { ethereum } = window;
    const accounts = await ethereum.request({ method: "eth_requestAccounts" });
    console.log({ accounts });
    setAccounts(accounts);
  }

  async function getAllFactions() {
    const contract = await useContract();
    const factions = await contract.getAllFactions();
    console.log({ factions });
  }

  async function addFactionMember() {
    const contract = await useContract();
    contract.addFactionMember({
      factionId: 1,
      invited: "",
    });
  }

  return (
    <>
      <h1>Hello</h1>

      <button onClick={connectWallet}>Connect Wallet</button>
      <button onClick={getAllFactions}>Get All Factions</button>

      <pre>{JSON.stringify(accounts, null, 4)}</pre>
    </>
  );
}

export default App;
