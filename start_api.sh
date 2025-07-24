#!/bin/bash

# Start FastAPI server for email integration
echo "🚀 Starting CovHack Email API Server..."
echo "📧 Email endpoint: http://localhost:8000/send-emails"
echo "🔍 Health check: http://localhost:8000/health"
echo ""
echo "📱 Flutter app should connect to: http://localhost:8000"
echo ""

# Install required dependencies
echo "📦 Installing Python dependencies..."
pip3 install fastapi uvicorn python-multipart

# Start the server
echo "🌐 Starting server on http://localhost:8000..."
uvicorn main:app --host 0.0.0.0 --port 8000 --reload

echo ""
echo "✅ API Server running!"
echo "📧 Ready to send emails via Flutter app"
