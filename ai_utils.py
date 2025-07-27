import os
import openai
from typing import Optional
import requests
from fastapi import HTTPException

# Initialize OpenAI client (only if API key is available)
api_key = os.getenv("OPENAI_API_KEY")
client = openai.OpenAI(api_key=api_key) if api_key and api_key != "your-openai-api-key-here" else None

def generate_post_description(
    topic: str,
    club_name: str,
    tone: str = "informative",
    length: str = "medium"
) -> str:
    """
    Generate a post description using AI
    
    Args:
        topic: The main topic or request from user
        club_name: Name of the club for context
        tone: Writing tone (informative, casual, formal, exciting)
        length: Description length (short, medium, long)
    
    Returns:
        Generated description string
    """
    
    if not client:
        raise HTTPException(status_code=500, detail="OpenAI API key not configured")
    
    # Define length constraints
    length_constraints = {
        "short": "50-100 words",
        "medium": "100-200 words", 
        "long": "200-300 words"
    }
    
    # Create the prompt
    prompt = f"""
    You are a social media manager for the {club_name} club. 
    Generate an engaging post description based on the following request:
    
    Topic: {topic}
    Tone: {tone}
    Length: {length_constraints.get(length, "100-200 words")}
    
    Requirements:
    - Make it engaging and relevant to club members
    - Include relevant hashtags if appropriate
    - Keep the tone consistent with the requested style
    - Make it informative and valuable to readers
    
    Generate the description:
    """
    
    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are a helpful social media assistant for university clubs."},
                {"role": "user", "content": prompt}
            ],
            max_tokens=500,
            temperature=0.7
        )
        
        description = response.choices[0].message.content.strip()
        return description
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"AI generation failed: {str(e)}")

def generate_event_description(
    event_name: str,
    club_name: str,
    event_type: str = "general",
    include_details: bool = True
) -> str:
    """
    Generate an event description using AI
    
    Args:
        event_name: Name of the event
        club_name: Name of the club
        event_type: Type of event (workshop, meeting, competition, etc.)
        include_details: Whether to include call-to-action and details
    
    Returns:
        Generated event description
    """
    
    if not client:
        raise HTTPException(status_code=500, detail="OpenAI API key not configured")
    
    prompt = f"""
    Create an engaging event announcement for the {club_name} club.
    
    Event: {event_name}
    Type: {event_type}
    
    Make it exciting and informative. Include:
    - What the event is about
    - Why members should attend
    - What they can expect
    - A call to action to register/attend
    
    Keep it under 200 words and make it engaging!
    """
    
    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are an event marketing specialist for university clubs."},
                {"role": "user", "content": prompt}
            ],
            max_tokens=400,
            temperature=0.8
        )
        
        description = response.choices[0].message.content.strip()
        return description
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"AI generation failed: {str(e)}")

def generate_club_description(
    club_name: str,
    activities: str = "",
    target_audience: str = "students"
) -> str:
    """
    Generate a club description using AI
    
    Args:
        club_name: Name of the club
        activities: Main activities or focus areas
        target_audience: Target audience (students, faculty, etc.)
    
    Returns:
        Generated club description
    """
    
    if not client:
        raise HTTPException(status_code=500, detail="OpenAI API key not configured")
    
    prompt = f"""
    Create an engaging club description for {club_name}.
    
    Activities/Focus: {activities}
    Target Audience: {target_audience}
    
    Make it:
    - Welcoming and inclusive
    - Clear about what the club does
    - Appealing to potential members
    - Professional but friendly
    
    Keep it under 150 words.
    """
    
    try:
        response = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": "system", "content": "You are a university club coordinator helping create engaging club descriptions."},
                {"role": "user", "content": prompt}
            ],
            max_tokens=300,
            temperature=0.7
        )
        
        description = response.choices[0].message.content.strip()
        return description
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"AI generation failed: {str(e)}")

# Alternative: Free AI service (if OpenAI is not available)
def generate_description_free(
    topic: str,
    club_name: str,
    service: str = "huggingface"
) -> str:
    """
    Generate description using free AI services as fallback
    """
    
    if service == "huggingface":
        # Using Hugging Face Inference API (free tier available)
        API_URL = "https://api-inference.huggingface.co/models/gpt2"
        headers = {"Authorization": f"Bearer {os.getenv('HUGGINGFACE_API_KEY', '')}"}
        
        prompt = f"Generate a social media post for {club_name} about: {topic}"
        
        try:
            response = requests.post(API_URL, headers=headers, json={"inputs": prompt})
            if response.status_code == 200:
                return response.json()[0]["generated_text"]
            else:
                return f"Join {club_name} for an exciting event about {topic}! Don't miss out on this amazing opportunity."
        except:
            return f"Join {club_name} for an exciting event about {topic}! Don't miss out on this amazing opportunity."
    
    # Fallback to template-based generation
    templates = [
        f"🎉 Exciting news from {club_name}! {topic} - Don't miss this amazing opportunity!",
        f"📢 {club_name} presents: {topic}. Join us for an unforgettable experience!",
        f"🌟 {club_name} is thrilled to announce: {topic}. Be part of something special!",
        f"🔥 {club_name} brings you: {topic}. This is going to be epic!",
        f"💫 {club_name} invites you to: {topic}. Let's make memories together!"
    ]
    
    import random
    return random.choice(templates) 