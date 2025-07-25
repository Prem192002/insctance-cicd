#!/bin/bash

cd ~/instance-cicd/instance-code/process-calling

BRANCH=$(git rev-parse --abbrev-ref HEAD)

# Choose port based on branch
if [ "$BRANCH" == "main" ]; then
  PORT=8000
elif [ "$BRANCH" == "stage" ]; then
  PORT=8001
elif [ "$BRANCH" == "develop" ]; then
  PORT=8002
else
  PORT=8003  # fallback
fi

echo "Using port: $PORT for branch: $BRANCH"

# Kill any process using this port
PID=$(lsof -t -i:$PORT)
if [ ! -z "$PID" ]; then
  echo "Killing process on port $PORT (PID: $PID)"
  kill -9 $PID
fi

# Run FastAPI app in background
nohup uvicorn main:app --host 0.0.0.0 --port $PORT > app.log 2>&1 &
echo "FastAPI app started on port $PORT"
