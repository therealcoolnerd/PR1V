import express from 'express';
const app = express();

app.post('/api/prove/gift-claim', async (req, res) => {
    // TODO: Implement proof generation
});
app.post('/api/prove/shield-withdraw', async (req, res) => {
    // TODO: Implement proof generation
});
app.listen(3002, () => console.log('ZK-Prover running on 3002'));
