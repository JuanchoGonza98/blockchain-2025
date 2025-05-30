import { useEffect, useState } from "react";
import { ethers } from "ethers";
import MarketplaceABI from "../abis/Marketplace.json";

const CONTRACT_ADDRESS = "0x123...abc"; // Ponés la dirección real si tuvieras

function App() {
  const [nfts, setNfts] = useState([]);
  const [contract, setContract] = useState(null);

  useEffect(() => {
    const loadBlockchain = async () => {
      const provider = new ethers.providers.Web3Provider(window.ethereum);
      const signer = provider.getSigner();
      const mkt = new ethers.Contract(CONTRACT_ADDRESS, MarketplaceABI.abi, signer);
      setContract(mkt);

      const items = await mkt.getAllNFTs();
      setNfts(items);
    };
    loadBlockchain();
  }, []);

  return (
    <div>
      <h1>NFT Marketplace</h1>
      {nfts.map((nft, i) => (
        <div key={i}>
          <p>ID: {nft.tokenId.toString()}</p>
          <p>Owner: {nft.owner}</p>
          <p>Price: {ethers.utils.formatEther(nft.price)} ETH</p>
          <p>Listed: {nft.listed ? "Yes" : "No"}</p>
        </div>
      ))}
    </div>
  );
}

export default App;

