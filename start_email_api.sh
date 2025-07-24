#!/bin/bash

echo "🚀 Starting CovHack Email API Server..."
echo "📧 Email endpoint: http://localhost:8000/send-emails"
echo "🔍 Health check: http://localhost:8000/health"
echo ""

# Create virtual environment if it doesn't exist
if [ ! -d "email_env" ]; then
    echo "📦 Creating virtual environment..."
    python3 -m venv email_env
fi

# Activate virtual environment and install dependencies
echo "📦 Setting up dependencies..."
source email_env/bin/activate
pip install fastapi uvicorn > /dev/null 2>&1

echo "🌐 Starting server on http://localhost:8000..."
echo ""
echo "✅ Email API ready for Flutter app!"
echo "� Flutter should connect to: http://localhost:8000"
echo ""

# Start the email API server
python3 email_api.py
