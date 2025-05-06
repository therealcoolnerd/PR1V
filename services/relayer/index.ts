import express from 'express';
import axios from 'axios';
import { ethers } from 'ethers';

const app = express();
app.use(express.json());

// Configure provider and wallet
const provider = new ethers.providers.JsonRpcProvider(process.env.RPC_URL || 'http://anvil:8545');
const wallet = new ethers.Wallet(process.env.RELAYER_KEY || '0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80', provider);

app.post('/api/relay/gift-claim', async (req, res) => {
    try {
        const { proof, publicSignals, contractAddress } = req.body;
        
        if (!proof || !publicSignals || !contractAddress) {
            return res.status(400).json({ error: 'Missing required parameters' });
        }
        
        // Get proof from ZK-Prover service if not provided
        let finalProof = proof;
        if (!finalProof) {
            const proofResponse = await axios.post('http://zk-prover:3002/api/prove/gift-claim', req.body);
            finalProof = proofResponse.data.proof;
        }
        
        // Create contract instance
        const abi = ["function claim(bytes32 nullifier, bytes32 root, bytes32[] calldata proof, address recipient, tuple(uint8,address,uint256,uint256)[] calldata items)"];
        const contract = new ethers.Contract(contractAddress, abi, wallet);
        
        // Execute transaction
        const tx = await contract.claim(
            publicSignals[1], // nullifier
            publicSignals[0], // root
            proof,
            publicSignals[2], // recipient
            req.body.items || []
        );
        
        return res.json({ 
            success: true, 
            txHash: tx.hash,
            blockNumber: tx.blockNumber
        });
    } catch (error) {
        console.error('Error relaying gift claim:', error);
        return res.status(500).json({ error: 'Failed to relay transaction' });
    }
});

app.post('/api/relay/shield-withdraw', async (req, res) => {
    try {
        const { proof, publicSignals, contractAddress } = req.body;
        
        if (!proof || !publicSignals || !contractAddress) {
            return res.status(400).json({ error: 'Missing required parameters' });
        }
        
        // Get proof from ZK-Prover service if not provided
        let finalProof = proof;
        if (!finalProof) {
            const proofResponse = await axios.post('http://zk-prover:3002/api/prove/shield-withdraw', req.body);
            finalProof = proofResponse.data.proof;
        }
        
        // Create contract instance and execute transaction
        // Placeholder implementation
        return res.json({ 
            success: true, 
            txHash: "0x" + "0".repeat(64),
            message: "Shield withdraw relay not fully implemented yet"
        });
    } catch (error) {
        console.error('Error relaying shield withdraw:', error);
        return res.status(500).json({ error: 'Failed to relay transaction' });
    }
});

const PORT = process.env.PORT || 3003;
app.listen(PORT, () => console.log(`Relayer running on ${PORT}`));
