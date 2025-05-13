// services/threat-db/index.ts

import express, { Express, Request, Response, NextFunction } from "express";
import postgres from "postgres";
import dotenv from "dotenv";

console.log("Threat-DB Service: Starting...");

dotenv.config(); // Load environment variables from .env file

// Global error handlers
process.on("uncaughtException", (error) => {
  console.error("Threat-DB Service: UNCAUGHT EXCEPTION!", error.stack || error);
  process.exit(1);
});

process.on("unhandledRejection", (reason, promise) => {
  console.error("Threat-DB Service: UNHANDLED REJECTION! Reason:", reason);
  console.error("Promise:", promise);
  process.exit(1);
});

const app: Express = express();
const port = process.env.THREAT_DB_PORT || 3002;

app.use(express.json());

// Initialize PostgreSQL client using Postgres.js
// Connection details will be picked up from environment variables
// (PGHOST, PGUSER, PGPASSWORD, PGDATABASE, PGPORT)
// or a connection string process.env.DATABASE_URL
let sql: postgres.Sql;

try {
  console.log("Threat-DB Service: Attempting to initialize Postgres.js client...");
  const connectionString = process.env.DATABASE_URL || 
                           `postgres://${process.env.PGUSER || 'priv'}:${process.env.PGPASSWORD || 'priv'}@${process.env.PGHOST || 'localhost'}:${process.env.PGPORT || 5432}/${process.env.PGDATABASE || 'privdb'}`;
  
  console.log(`Threat-DB Service: Using connection string: ${connectionString.replace(/:[^:]*@/, ':[REDACTED]@')}`); // Log connection string safely

  sql = postgres(connectionString, {
    onnotice: (notice) => console.log("Threat-DB Service: PostgreSQL Notice:", notice.message),
    transform: {
      undefined: null // Ensure undefined values are sent as NULL to Postgres
    },
    // Add any other necessary options here, e.g., SSL, timeouts
    connect_timeout: 10, // seconds
    idle_timeout: 30, // seconds
    max: 10 // max number of connections
  });
  console.log("Threat-DB Service: Postgres.js client initialized.");
} catch (error) {
  const err = error as Error;
  console.error("Threat-DB Service: FATAL - Failed to initialize Postgres.js client:", err.message);
  console.error(err.stack);
  process.exit(1);
}

// Function to initialize database schema
async function initializeDatabase() {
  console.log("Threat-DB Service: Initializing database schema...");
  try {
    await sql`
      CREATE TABLE IF NOT EXISTS threats (
        id SERIAL PRIMARY KEY,
        type VARCHAR(255) NOT NULL,
        description TEXT,
        source VARCHAR(255),
        created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
      );
    `;
    console.log("Threat-DB Service: 'threats' table checked/created successfully.");

    // You can add more table initializations here if needed

  } catch (error) {
    const err = error as Error;
    console.error("Threat-DB Service: Error initializing database schema:", err.message);
    console.error(err.stack);
    // Depending on the error, you might want to exit or retry
    process.exit(1); // Exit if schema initialization fails critically
  }
}

// --- API Routes ---

app.get("/health", (req: Request, res: Response) => {
  console.log("Threat-DB Service: Health check endpoint hit.");
  res.status(200).json({ status: "UP", message: "Threat-DB service is running" });
});

// Example route: Get all threats
app.get("/threats", async (req: Request, res: Response, next: NextFunction) => {
  try {
    console.log("Threat-DB Service: GET /threats endpoint hit.");
    const threats = await sql`SELECT * FROM threats ORDER BY created_at DESC`;
    res.status(200).json(threats);
  } catch (error) {
    console.error("Threat-DB Service: Error fetching threats:", error);
    next(error);
  }
});

// Example route: Add a new threat
app.post("/threats", async (req: Request, res: Response, next: NextFunction) => {
  try {
    const { type, description, source } = req.body;
    console.log(`Threat-DB Service: POST /threats endpoint hit with body:`, req.body);
    if (!type) {
      return res.status(400).json({ error: "Threat 'type' is required." });
    }
    const newThreat = await sql`
      INSERT INTO threats (type, description, source)
      VALUES (${type}, ${description}, ${source})
      RETURNING *
    `;
    res.status(201).json(newThreat[0]);
  } catch (error) {
    console.error("Threat-DB Service: Error adding threat:", error);
    next(error);
  }
});

// --- Error Handling Middleware ---
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error("Threat-DB Service: An error occurred in an Express route:", err.stack || err);
  res.status(500).json({ error: "Internal Server Error", message: err.message });
});

// Start the server after ensuring database is initialized
async function startServer() {
  try {
    await initializeDatabase();
    app.listen(port, () => {
      console.log(`Threat-DB Service: Server is running on http://localhost:${port}`);
    });
  } catch (error) {
    const err = error as Error;
    console.error("Threat-DB Service: Failed to start server:", err.message);
    process.exit(1);
  }
}

startServer();

console.log("Threat-DB Service: Script execution finished. Server startup process initiated.");

