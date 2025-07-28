#!/bin/bash
set -e

cd "$(dirname "$0")"  # Go to the script directory

# Accept branch name as argument
BRANCH_NAME=$1

if [ -z "$BRANCH_NAME" ]; then
  echo "Error: Branch name not provided as argument."
  exit 1
fi

# Map branch to port
case "$BRANCH_NAME" in
  main)
    PORT=8000
    ;;
  stage)
    PORT=8001
    ;;
  develop)
    PORT=8002
    ;;
  *)
    echo "Unknown branch: $BRANCH_NAME"
    exit 1
    ;;
esac

echo "Starting FastAPI app for branch '$BRANCH_NAME' on port $PORT"

# Kill any existing process on that port
PID=$(lsof -ti tcp:$PORT) || true
if [ -n "$PID" ]; then
  echo "Killing existing process on port $PORT (PID: $PID)"
  kill -9 $PID
fi

# Start FastAPI using uvicorn
nohup uvicorn main:app --host 0.0.0.0 --port $PORT --reload > fastapi.log 2>&1 &

echo "FastAPI is now running at http://<ec2-public-ip>:$PORT"
