import express from 'express';
const app = express();

app.post('/api/relay/gift-claim', async (req, res) => {
    // TODO: Implement relay logic
});
app.post('/api/relay/shield-withdraw', async (req, res) => {
    // TODO: Implement relay logic
});
app.listen(3003, () => console.log('Relayer running on 3003'));
