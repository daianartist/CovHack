# Certificate Generation Integration

This Flutter app integrates with the Python certificate generation system located in `/Users/user1/Desktop/cert_verifier_project/`.

## Python Script Structure

The Python script (`generate.py`) performs the following operations:

1. **Reads CSV file** - Loads participant data from `participants.csv`
2. **Generates unique codes** - Creates hash-based verification codes for each participant
3. **Creates QR codes** - Generates QR codes linking to verification URL
4. **Generates PDF certificates** - Creates certificates with participant names and QR codes
5. **Updates JSON file** - Creates `public/participants.json` for web verification
6. **Prepares for deployment** - Files are ready for Vercel hosting

## Flutter App Features

### 1. Certificate Management Screen (`certificates.dart`)
- **Generate certificates** - Add individual participants
- **Verify certificates** - Validate certificates using verification codes
- **View certificate list** - Display all generated certificates
- **Share certificates** - Copy verification links to clipboard

### 2. Certificate Generator Screen (`certificate_generator_screen.dart`)
- **Configuration** - Set base URL for verification
- **CSV Upload** - Simulate uploading participant CSV file
- **Batch Generation** - Run the Python script simulation
- **Preview** - View participants before generation

## Integration Points

### Data Flow
```
1. CSV Upload → Python Script → PDF + QR + JSON
2. Flutter App → Read JSON → Display Certificates
3. QR Code Scan → Vercel Website → Verification
```

### Files Structure
```
cert_verifier_project/
├── generate_cert/
│   ├── generate.py          # Main Python script
│   └── certificates_batch/  # Generated PDFs and QR codes
├── participants.csv         # Input data
├── participants_with_code.csv # Output with codes
├── public/
│   ├── participants.json    # Verification data
│   └── verify.html         # Web verification page
└── cert.png                # Certificate template
```

### Verification Process
1. **Generate Certificate** - Python script creates unique code
2. **QR Code Creation** - Links to: `https://certificateverifier.vercel.app/verify?code=XXXXXX`
3. **Web Verification** - HTML page checks code against JSON file
4. **Result Display** - Shows participant name if valid

## Usage in Flutter App

### Access Points
- **Profile Screen** → "Certificate" → Opens certificate management
- **Certificate Screen** → Settings icon → Opens generator tools

### Key Features
- ✅ Individual certificate generation
- ✅ Batch processing simulation  
- ✅ Real-time verification
- ✅ QR code sharing
- ✅ Certificate status tracking
- ✅ Copy-to-clipboard functionality

## Future Enhancements
- Direct Python script execution from Flutter
- File picker for real CSV uploads
- PDF preview and download
- Email certificate distribution
- Certificate template customization
