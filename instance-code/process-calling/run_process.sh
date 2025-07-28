#!/bin/bash
set -e

# Go to the script directory
cd "$(dirname "$0")"

# Get the folder name (main/stage/develop)
DEPLOY_DIR=$(basename "$(dirname "$(dirname "$PWD")")")

# Map folder to port
case "$DEPLOY_DIR" in
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
    echo " Unknown deploy directory: $DEPLOY_DIR"
    exit 1
    ;;
esac

echo " Starting FastAPI app from $DEPLOY_DIR on port $PORT"

# Kill old process running on the port
PID=$(lsof -ti tcp:$PORT) || true
if [ -n "$PID" ]; then
  echo " Killing existing process on port $PORT (PID: $PID)"
  kill -9 $PID
fi

# Start FastAPI using uvicorn (adjust main:app if needed)
nohup uvicorn main:app --host 0.0.0.0 --port $PORT --reload > fastapi.log 2>&1 &
echo " FastAPI running at http://<ec2-public-ip>:$PORT"
