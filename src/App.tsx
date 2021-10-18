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
  const [guilds, setGuilds] = useState<any[]>([]);

  useEffect(() => {}, []);

  async function connectWallet() {
    const { ethereum } = window;
    const accounts = await ethereum.request({ method: "eth_requestAccounts" });
    console.log({ accounts });
    setAccounts(accounts);
  }

  async function getAllGuilds() {
    const contract = await useContract();
    const Guilds = await contract.getAllGuilds();
    console.log({ Guilds });
    setGuilds(Guilds);
  }

  async function addGuildMember() {
    const contract = await useContract();
    contract.addGuildMember({
      guildId: 1,
      invited: "",
    });
  }

  return (
    <>
      <h1>Hello</h1>

      <button onClick={connectWallet}>Connect Wallet</button>
      <pre>{JSON.stringify(accounts, null, 4)}</pre>

      <button onClick={getAllGuilds}>Get All Guilds</button>
      <pre>{JSON.stringify(guilds, null, 4)}</pre>
    </>
  );
}

export default App;
