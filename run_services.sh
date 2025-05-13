#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# Get the absolute path of the script's directory
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "Script directory: $SCRIPT_DIR"
cd "$SCRIPT_DIR" # Ensure we are in the script's directory (repo root)
echo "Current working directory: $(pwd)"

# Function to kill processes on specified ports
cleanup() {
    echo "Cleaning up old processes..."
    lsof -t -i:3000 -i:3001 -i:3002 -i:3003 | xargs --no-run-if-empty kill -9
    echo "Cleanup complete."
}

# Trap SIGINT (Ctrl+C) and SIGTERM to run cleanup function
trap cleanup SIGINT SIGTERM

# Initial cleanup
cleanup

# Define service directories and commands
# Paths are relative to SCRIPT_DIR (repo root)
FRONTEND_DIR="."
FRONTEND_CMD="npm run dev"

RELAYER_DIR="services/relayer"
RELAYER_CMD="node --loader ts-node/esm index.ts"

THREAT_DB_DIR="services/threat-db"
THREAT_DB_CMD="node --loader ts-node/esm index.ts"

ZK_PROVER_DIR="services/zk-prover"
ZK_PROVER_CMD="node --loader ts-node/esm index.ts"

# Create log directory if it doesn't exist (relative to SCRIPT_DIR)
LOG_DIR_NAME="logs"
mkdir -p "$LOG_DIR_NAME"
echo "Log directory '$LOG_DIR_NAME' ensured at $(pwd)/$LOG_DIR_NAME"

# Store PIDs
PIDS=()

# Start Frontend
echo "Starting Frontend service..."
pushd "$FRONTEND_DIR" > /dev/null # Use pushd/popd for safer directory changes
echo "Frontend CWD: $(pwd)"
($FRONTEND_CMD > "$SCRIPT_DIR/$LOG_DIR_NAME/frontend.log" 2>&1) &
FRONTEND_PID=$!
PIDS+=($FRONTEND_PID)
echo "Frontend service started with PID $FRONTEND_PID. Logging to $SCRIPT_DIR/$LOG_DIR_NAME/frontend.log"
popd > /dev/null

# Start Relayer Service
echo "Starting Relayer service..."
pushd "$RELAYER_DIR" > /dev/null
echo "Relayer CWD: $(pwd)"
($RELAYER_CMD > "$SCRIPT_DIR/$LOG_DIR_NAME/relayer.log" 2>&1) &
RELAYER_PID=$!
PIDS+=($RELAYER_PID)
echo "Relayer service started with PID $RELAYER_PID. Logging to $SCRIPT_DIR/$LOG_DIR_NAME/relayer.log"
popd > /dev/null

# Start Threat DB Service
echo "Starting Threat DB service..."
pushd "$THREAT_DB_DIR" > /dev/null
echo "Threat DB CWD: $(pwd)"
($THREAT_DB_CMD > "$SCRIPT_DIR/$LOG_DIR_NAME/threat-db.log" 2>&1) &
THREAT_DB_PID=$!
PIDS+=($THREAT_DB_PID)
echo "Threat DB service started with PID $THREAT_DB_PID. Logging to $SCRIPT_DIR/$LOG_DIR_NAME/threat-db.log"
popd > /dev/null

# Start ZK Prover Service
echo "Starting ZK Prover service..."
pushd "$ZK_PROVER_DIR" > /dev/null
echo "ZK Prover CWD: $(pwd)"
($ZK_PROVER_CMD > "$SCRIPT_DIR/$LOG_DIR_NAME/zk-prover.log" 2>&1) &
ZK_PROVER_PID=$!
PIDS+=($ZK_PROVER_PID)
echo "ZK Prover service started with PID $ZK_PROVER_PID. Logging to $SCRIPT_DIR/$LOG_DIR_NAME/zk-prover.log"
popd > /dev/null

echo "All services started."
echo "PIDs: ${PIDS[@]}"
echo "Press Ctrl+C to stop all services."

# Wait for any process to exit. If one exits, the script will exit due to `wait -n` and `set -e` if the exit was an error.
# If a service exits cleanly, `wait -n` will also cause the script to proceed.
# The trap will handle cleanup.
wait -n "${PIDS[@]}"

echo "A service has exited. Script will now terminate."
# Cleanup will be called by the trap on exit if not already called by signal

