import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class ImageUploadWidget extends StatefulWidget {
  final String title;
  final String uploadType; // 'event' or 'club'
  final int? itemId; // event_id or club_id for saving image URL
  final Function(String)? onImageUploaded;
  final String? currentImageUrl;

  const ImageUploadWidget({
    super.key,
    required this.title,
    required this.uploadType,
    this.itemId,
    this.onImageUploaded,
    this.currentImageUrl,
  });

  @override
  State<ImageUploadWidget> createState() => _ImageUploadWidgetState();
}

class _ImageUploadWidgetState extends State<ImageUploadWidget> {
  File? _selectedImage;
  bool _isUploading = false;
  final ApiService _apiService = ApiService();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      String? imageUrl;
      
      // Upload image based on type
      if (widget.uploadType == 'event') {
        imageUrl = await _apiService.uploadEventImage(_selectedImage!);
      } else if (widget.uploadType == 'club') {
        imageUrl = await _apiService.uploadClubImage(_selectedImage!);
      }

      if (imageUrl != null) {
        // Save image URL to database if itemId is provided
        if (widget.itemId != null) {
          bool success = false;
          if (widget.uploadType == 'event') {
            success = await _apiService.saveEventImage(widget.itemId!, imageUrl);
          } else if (widget.uploadType == 'club') {
            success = await _apiService.saveClubImage(widget.itemId!, imageUrl);
          }

          if (success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image uploaded and saved successfully!')),
            );
            widget.onImageUploaded?.call(imageUrl);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image uploaded but failed to save URL')),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Image uploaded successfully!')),
          );
          widget.onImageUploaded?.call(imageUrl);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image Source'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            
            // Current image display
            if (widget.currentImageUrl != null && widget.currentImageUrl!.isNotEmpty)
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    'http://localhost:8000${widget.currentImageUrl}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image_not_supported, size: 50),
                      );
                    },
                  ),
                ),
              ),
            
            // Selected image preview
            if (_selectedImage != null)
              Container(
                width: double.infinity,
                height: 200,
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    _selectedImage!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isUploading ? null : _showImageSourceDialog,
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text('Pick Image'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade50,
                      foregroundColor: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _selectedImage == null || _isUploading ? null : _uploadImage,
                    icon: _isUploading 
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.upload),
                    label: Text(_isUploading ? 'Uploading...' : 'Upload'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 