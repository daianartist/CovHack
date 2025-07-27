# 🤖 AI Integration Guide for CampusCore

## **Overview**
This guide explains how to integrate AI-powered description generation into your CampusCore application.

## **Features**
- **AI Post Descriptions**: Generate engaging social media posts for clubs
- **AI Event Descriptions**: Create compelling event announcements
- **AI Club Descriptions**: Generate welcoming club descriptions
- **Fallback Services**: Multiple AI providers for reliability

## **Setup**

### **1. Install Dependencies**
```bash
pip install openai requests
```

### **2. Environment Variables**
Add to your `.env` file:
```env
# OpenAI (Primary AI Service)
OPENAI_API_KEY=your-openai-api-key-here

# Hugging Face (Free Fallback)
HUGGINGFACE_API_KEY=your-huggingface-api-key-here
```

### **3. Get API Keys**

#### **OpenAI API Key:**
1. Go to [OpenAI Platform](https://platform.openai.com/)
2. Sign up/Login
3. Go to API Keys section
4. Create a new API key
5. Copy the key to your `.env` file

#### **Hugging Face API Key (Optional):**
1. Go to [Hugging Face](https://huggingface.co/)
2. Sign up/Login
3. Go to Settings → Access Tokens
4. Create a new token
5. Copy the token to your `.env` file

## **API Endpoints**

### **1. Generate Post Description**
```bash
POST /ai/generate-post-description
```

**Request:**
```json
{
  "topic": "Chess tournament announcement",
  "tone": "exciting",
  "length": "medium",
  "use_free_service": false
}
```

**Response:**
```json
{
  "generated_description": "🎉 Chess Club is thrilled to announce our upcoming tournament! Get ready for an epic battle of wits and strategy. Whether you're a grandmaster or just learning the game, this tournament is for everyone! 🏆\n\n📅 Date: TBD\n📍 Location: Student Center\n🏆 Prizes for winners!\n\nDon't miss this chance to showcase your skills and meet fellow chess enthusiasts. Register now! #ChessTournament #CampusLife #StudentEvents",
  "club_name": "Chess Club",
  "topic": "Chess tournament announcement",
  "tone": "exciting",
  "length": "medium"
}
```

### **2. Generate Event Description**
```bash
POST /ai/generate-event-description
```

**Request:**
```json
{
  "event_name": "Chess Tournament 2024",
  "event_type": "competition",
  "include_details": true
}
```

### **3. Generate Club Description**
```bash
POST /ai/generate-club-description
```

**Request:**
```json
{
  "activities": "chess tournaments, strategy games, skill development",
  "target_audience": "students"
}
```

## **Frontend Integration**

### **Flutter Example:**
```dart
class AIDescriptionGenerator {
  static Future<String> generatePostDescription({
    required int clubId,
    required String topic,
    String tone = "informative",
    String length = "medium",
    bool useFreeService = false,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:8000/ai/generate-post-description'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'topic': topic,
          'tone': tone,
          'length': length,
          'use_free_service': useFreeService,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['generated_description'];
      } else {
        throw Exception('Failed to generate description');
      }
    } catch (e) {
      throw Exception('AI service error: $e');
    }
  }
}

// Usage in UI
class CreatePostScreen extends StatefulWidget {
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  String? generatedDescription;
  bool isGenerating = false;

  Future<void> generateDescription() async {
    setState(() {
      isGenerating = true;
    });

    try {
      final description = await AIDescriptionGenerator.generatePostDescription(
        clubId: widget.clubId,
        topic: topicController.text,
        tone: selectedTone,
        length: selectedLength,
      );

      setState(() {
        generatedDescription = description;
        isGenerating = false;
      });
    } catch (e) {
      setState(() {
        isGenerating = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Post')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: topicController,
              decoration: InputDecoration(
                labelText: 'What would you like to post about?',
                hintText: 'e.g., Chess tournament announcement',
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isGenerating ? null : generateDescription,
                    child: isGenerating 
                      ? CircularProgressIndicator()
                      : Text('Generate with AI'),
                  ),
                ),
              ],
            ),
            if (generatedDescription != null) ...[
              SizedBox(height: 16),
              Text('Generated Description:'),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(generatedDescription!),
              ),
              ElevatedButton(
                onPressed: () {
                  // Use the generated description
                  descriptionController.text = generatedDescription!;
                },
                child: Text('Use This Description'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

## **Configuration Options**

### **Tone Options:**
- `informative` - Factual and educational
- `casual` - Friendly and relaxed
- `formal` - Professional and business-like
- `exciting` - Energetic and enthusiastic

### **Length Options:**
- `short` - 50-100 words
- `medium` - 100-200 words
- `long` - 200-300 words

### **Event Types:**
- `workshop` - Educational sessions
- `meeting` - Regular club meetings
- `competition` - Competitive events
- `social` - Social gatherings
- `general` - General events

## **Error Handling**

The system includes multiple fallback mechanisms:

1. **Primary**: OpenAI GPT-3.5-turbo
2. **Secondary**: Hugging Face Inference API
3. **Fallback**: Template-based generation

If all AI services fail, the system will return a template-based description to ensure the feature always works.

## **Cost Considerations**

### **OpenAI Pricing:**
- GPT-3.5-turbo: ~$0.002 per 1K tokens
- Typical post generation: ~$0.01-0.02 per request

### **Hugging Face:**
- Free tier available
- Limited requests per month
- Good for development/testing

## **Best Practices**

1. **Cache Results**: Store generated descriptions to avoid repeated API calls
2. **Rate Limiting**: Implement rate limiting to control costs
3. **User Feedback**: Allow users to regenerate if they're not satisfied
4. **Preview Mode**: Show generated content before publishing
5. **Edit Capability**: Always allow manual editing of AI-generated content

## **Security Considerations**

1. **API Key Protection**: Never expose API keys in frontend code
2. **Input Validation**: Validate all user inputs before sending to AI
3. **Content Filtering**: Review AI-generated content for appropriateness
4. **Rate Limiting**: Prevent abuse of AI services

## **Testing**

Test the AI integration with various inputs:

```bash
# Test post generation
curl -X POST "http://localhost:8000/ai/generate-post-description" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "topic": "Welcome new members",
    "tone": "casual",
    "length": "short"
  }'

# Test event generation
curl -X POST "http://localhost:8000/ai/generate-event-description" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "event_name": "Welcome Party",
    "event_type": "social"
  }'
```

The AI integration is now ready to use! 🚀 