#!/bin/bash

# Navigate to script directory (ensures script works no matter where it's called from)
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR" || exit 1

# Activate virtual environment if using one (optional)
# source venv/bin/activate

# Detect current branch
BRANCH=$(git rev-parse --abbrev-ref HEAD)
echo "Current branch: $BRANCH"

# Decide port based on branch
PORT=8000
if [ "$BRANCH" == "develop" ]; then
    PORT=8002
elif [ "$BRANCH" == "stage" ]; then
    PORT=8001
fi

echo "Using port: $PORT for branch: $BRANCH"

# Kill any existing process on this port
PID=$(lsof -t -i:$PORT)
if [ -n "$PID" ]; then
    echo "Killing process on port $PORT (PID: $PID)"
    kill -9 $PID
else
    echo "No existing process on port $PORT"
fi

# Ensure logs directory exists
mkdir -p logs

# Start FastAPI app with uvicorn in background and log output
echo "Starting FastAPI app on port $PORT..."
nohup uvicorn main:app --host 0.0.0.0 --port $PORT > logs/fastapi_$PORT.log 2>&1 &

echo "FastAPI app started on port $PORT"
