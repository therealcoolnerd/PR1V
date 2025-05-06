import express, { Request, Response } from 'express';
import { Pool } from 'pg';
import axios from 'axios';

const app = express();
app.use(express.json());

// Configure database connection
const pool = new Pool({
  connectionString: process.env.DATABASE_URL || 'postgres://priv:priv@db:5432/privdb'
});

// ───── schema bootstrap ───── 
(async () => { 
  await pool.query(` 
    CREATE TABLE IF NOT EXISTS risk_items( 
      id SERIAL PRIMARY KEY, 
      addr TEXT UNIQUE, 
      risk_level INT DEFAULT 0, 
      reason TEXT, 
      updated_at TIMESTAMP DEFAULT NOW() 
    ); 
    
    CREATE TABLE IF NOT EXISTS address_risks(
      address TEXT PRIMARY KEY,
      level TEXT NOT NULL,
      reason TEXT,
      updated_at TIMESTAMP DEFAULT NOW()
    );
    
    CREATE TABLE IF NOT EXISTS token_risks(
      address TEXT PRIMARY KEY,
      level TEXT NOT NULL,
      reason TEXT,
      updated_at TIMESTAMP DEFAULT NOW()
    );
  `); 
})().catch(console.error);

app.get('/api/check-address/:address', async (req: Request, res: Response) => {
    try {
        const { address } = req.params;
        const result = await pool.query('SELECT * FROM address_risks WHERE address = $1', [address]);
        return res.json({ 
            address, 
            risk: result.rows.length > 0 ? result.rows[0] : { level: 'unknown' } 
        });
    } catch (error) {
        console.error('Error checking address:', error);
        return res.status(500).json({ error: 'Failed to check address' });
    }
});

app.get('/api/check-token/:address', async (req: Request, res: Response) => {
    try {
        const { address } = req.params;
        const result = await pool.query('SELECT * FROM token_risks WHERE address = $1', [address]);
        return res.json({ 
            address, 
            risk: result.rows.length > 0 ? result.rows[0] : { level: 'unknown' } 
        });
    } catch (error) {
        console.error('Error checking token:', error);
        return res.status(500).json({ error: 'Failed to check token' });
    }
});

app.get('/api/dust-patterns/:wallet', async (req: Request, res: Response) => {
    try {
        const { wallet } = req.params;
        // Placeholder implementation
        return res.json({ wallet, patterns: [] });
    } catch (error) {
        console.error('Error detecting dust patterns:', error);
        return res.status(500).json({ error: 'Failed to detect dust patterns' });
    }
});

app.post('/api/refresh', async (_req: Request, res: Response) => {
    try {
        const { data } = await axios.get(
            'https://raw.githubusercontent.com/ChainAgnostic/risk-lists/main/eth.json'
        );
        for (const item of data) {
            await pool.query(
                `
                INSERT INTO risk_items(addr,risk_level,reason)
                VALUES($1,$2,$3)
                ON CONFLICT (addr)
                DO UPDATE SET risk_level=$2, reason=$3, updated_at=NOW();
              `,
                [item.address.toLowerCase(), item.risk, item.reason || 'list']
            );
        }
        res.json({ ok: true, imported: data.length });
    } catch (e) {
        console.error(e);
        res.status(500).json({ ok: false });
    }
});
app.listen(3001, () => console.log('Threat-DB running on 3001'));
