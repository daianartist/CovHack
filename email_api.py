#!/usr/bin/env python3
# email_api.py - Simple FastAPI server for email sending only
from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List
import json
import os
import subprocess
import tempfile

app = FastAPI(title="CovHack Email API", version="1.0.0")

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

# Email request models
class EmailConfig(BaseModel):
    email: str
    password: str
    smtp_server: str
    smtp_port: int

class Participant(BaseModel):
    name: str
    email: str
    verification_code: str

class EmailRequest(BaseModel):
    config: EmailConfig
    participants: List[Participant]
    event_name: str = "CovHack"
    base_url: str = "https://certificateverifier.vercel.app/verify?code="

@app.get("/")
def root():
    """Root endpoint"""
    return {
        "message": "CovHack Email API", 
        "version": "1.0.0",
        "endpoints": {
            "health": "/health",
            "send_emails": "/send-emails"
        }
    }

@app.get("/health")
def health_check():
    """Health check endpoint for Flutter app"""
    return {
        "status": "healthy", 
        "message": "Email API is running",
        "email_script": os.path.exists("/Users/user1/Desktop/cert_verifier_project/send_emails.py")
    }

@app.post("/send-emails")
def send_emails_endpoint(request: EmailRequest):
    """
    Send certificates via email using Python script
    """
    try:
        print(f"📧 Received email request for {len(request.participants)} participants")
        
        # Create temporary config file
        with tempfile.NamedTemporaryFile(mode='w', suffix='.json', delete=False) as config_file:
            config_data = {
                "email": request.config.email,
                "password": request.config.password,
                "smtp_server": request.config.smtp_server,
                "smtp_port": request.config.smtp_port,
                "event_name": request.event_name,
                "base_url": request.base_url
            }
            json.dump(config_data, config_file, indent=2)
            config_path = config_file.name
            print(f"📁 Config file created: {config_path}")

        # Create temporary participants file
        with tempfile.NamedTemporaryFile(mode='w', suffix='.json', delete=False) as participants_file:
            participants_data = [
                {
                    "name": p.name,
                    "email": p.email,
                    "verification_code": p.verification_code
                }
                for p in request.participants
            ]
            json.dump(participants_data, participants_file, indent=2)
            participants_path = participants_file.name
            print(f"👥 Participants file created: {participants_path}")

        # Call Python email script
        script_path = "/Users/user1/Desktop/cert_verifier_project/send_emails.py"
        print(f"🐍 Calling email script: {script_path}")
        
        # Change to correct working directory for PDF files
        script_dir = "/Users/user1/Desktop/cert_verifier_project"
        
        result = subprocess.run([
            "python3", script_path, config_path, participants_path
        ], capture_output=True, text=True, timeout=30, cwd=script_dir)

        print(f"📊 Script exit code: {result.returncode}")
        print(f"📤 Script stdout: {result.stdout}")
        if result.stderr:
            print(f"❌ Script stderr: {result.stderr}")

        # Clean up temporary files
        os.unlink(config_path)
        os.unlink(participants_path)

        if result.returncode == 0:
            # Parse successful output
            successful_count = len(request.participants)
            failed_count = 0
            
            return {
                "success": True,
                "message": "Emails sent successfully",
                "successful": successful_count,
                "failed": failed_count,
                "total": len(request.participants),
                "results": {
                    "successful_sends": [
                        {"name": p.name, "email": p.email}
                        for p in request.participants
                    ],
                    "failed_sends": []
                },
                "output": result.stdout,
                "debug": {
                    "script_path": script_path,
                    "config_data": config_data,
                    "participants_count": len(request.participants)
                }
            }
        else:
            return {
                "success": False,
                "message": "Email sending failed",
                "error": result.stderr,
                "output": result.stdout,
                "help": "Check your SMTP settings and App Password",
                "debug": {
                    "exit_code": result.returncode,
                    "script_path": script_path
                }
            }

    except subprocess.TimeoutExpired:
        # Clean up files if timeout
        try:
            os.unlink(config_path)
            os.unlink(participants_path)
        except:
            pass
            
        return {
            "success": False,
            "message": "Email sending timed out",
            "help": "The operation took too long. Try with fewer participants.",
            "timeout": 30
        }
    except Exception as e:
        print(f"💥 Unexpected error: {e}")
        return {
            "success": False,
            "message": f"Unexpected error: {str(e)}",
            "help": "Please check your configuration and try again.",
            "error_type": type(e).__name__
        }

if __name__ == "__main__":
    import uvicorn
    print("🚀 Starting CovHack Email API...")
    print("📧 Email endpoint: http://localhost:8000/send-emails")
    print("🔍 Health check: http://localhost:8000/health")
    uvicorn.run(app, host="0.0.0.0", port=8000)
