import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import '../cubit/pdf_generation_cubit.dart';
import '../cubit/pdf_generation_state.dart';
import '../cubit/pdf_list_cubit.dart';
import '../cubit/scanner_cubit.dart';
import '../cubit/scanner_state.dart';

class ImageCropPage extends StatefulWidget {
  final String imagePath;

  const ImageCropPage({
    super.key,
    required this.imagePath,
  });

  @override
  State<ImageCropPage> createState() => _ImageCropPageState();
}

class _ImageCropPageState extends State<ImageCropPage> {
  late String _currentImagePath;
  bool _isCropping = false;
  bool _isRotating = false;
  bool _isEnhancing = false;
  int _rotationAngle = 0; // Track rotation angle
  final TextEditingController _fileNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentImagePath = widget.imagePath;
    
    // Generate default filename
    final now = DateTime.now();
    final defaultName = 'scan_${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
    _fileNameController.text = defaultName;
  }

  @override
  void dispose() {
    _fileNameController.dispose();
    super.dispose();
  }

  Future<void> _cropImage() async {
    if (_isCropping) return;
    
    setState(() {
      _isCropping = true;
    });
    
    // Add haptic feedback
    HapticFeedback.mediumImpact();

    context.read<ScannerCubit>().cropDocument(_currentImagePath);
  }
  
  // Isolate function for rotating image
  static Future<String> _rotateImageInIsolate(Map<String, dynamic> params) async {
    final String imagePath = params['imagePath'];
    final int timestamp = params['timestamp'];
    
    // Read and decode image
    final bytes = await File(imagePath).readAsBytes();
    final image = img.decodeImage(bytes);
    
    if (image == null) {
      throw Exception('Failed to decode image');
    }
    
    // Rotate 90 degrees clockwise
    final rotated = img.copyRotate(image, angle: 90);
    
    // Save to temporary file
    final tempPath = '${Directory.systemTemp.path}/rotated_$timestamp.jpg';
    await File(tempPath).writeAsBytes(img.encodeJpg(rotated, quality: 85));
    
    return tempPath;
  }
  
  Future<void> _rotateImage() async {
    if (_isRotating) return;
    
    setState(() {
      _isRotating = true;
    });
    
    try {
      HapticFeedback.mediumImpact();
      
      // Show loading indicator
      _showSnackBar('Processing image...');
      
      // Process image in isolate
      final rotatedPath = await compute(_rotateImageInIsolate, {
        'imagePath': _currentImagePath,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      
      setState(() {
        _currentImagePath = rotatedPath;
        _rotationAngle = (_rotationAngle + 90) % 360;
        _isRotating = false;
      });
      
      _showSnackBar('Image rotated successfully');
    } catch (e) {
      setState(() {
        _isRotating = false;
      });
      _showSnackBar('Failed to rotate image', isError: true);
    }
  }
  
  // Isolate function for enhancing image
  static Future<String> _enhanceImageInIsolate(Map<String, dynamic> params) async {
    final String imagePath = params['imagePath'];
    final int timestamp = params['timestamp'];
    
    // Read and decode image
    final bytes = await File(imagePath).readAsBytes();
    final image = img.decodeImage(bytes);
    
    if (image == null) {
      throw Exception('Failed to decode image');
    }
    
    // Apply auto-enhancement
    // 1. Adjust brightness/contrast
    img.adjustColor(image, brightness: 1.1, contrast: 1.2);
    
    // 2. Normalize the image (stretch histogram)
    img.normalize(image, min: 0, max: 255);
    
    // Save to temporary file with slightly lower quality for faster processing
    final tempPath = '${Directory.systemTemp.path}/enhanced_$timestamp.jpg';
    await File(tempPath).writeAsBytes(img.encodeJpg(image, quality: 85));
    
    return tempPath;
  }
  
  Future<void> _enhanceImage() async {
    if (_isEnhancing) return;
    
    setState(() {
      _isEnhancing = true;
    });
    
    try {
      HapticFeedback.mediumImpact();
      
      // Show loading indicator
      _showSnackBar('Enhancing image...');
      
      // Process image in isolate
      final enhancedPath = await compute(_enhanceImageInIsolate, {
        'imagePath': _currentImagePath,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
      
      setState(() {
        _currentImagePath = enhancedPath;
        _isEnhancing = false;
      });
      
      _showSnackBar('Image enhanced successfully');
    } catch (e) {
      setState(() {
        _isEnhancing = false;
      });
      _showSnackBar('Failed to enhance image', isError: true);
    }
  }

  void _generatePdf() {
    final fileName = _fileNameController.text.trim();
    if (fileName.isEmpty) {
      _showSnackBar('Please enter a file name', isError: true);
      return;
    }
    
    HapticFeedback.mediumImpact();

    context.read<PdfGenerationCubit>().generateAndSave(
      imagePath: _currentImagePath,
      suggestedName: fileName,
    );
  }

  void _showSnackBar(String message, {bool isError = false}) {
    // Hide any existing snackbar before showing a new one
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2), // Set specific duration
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ScannerCubit, ScannerState>(
          listener: (context, state) {
            if (state is ScannerCropped) {
              setState(() {
                _isCropping = false;
                // Only update path if it's different (not cancelled)
                if (state.imagePath != _currentImagePath) {
                  _currentImagePath = state.imagePath;
                  _showSnackBar('Image cropped successfully');
                }
              });
            } else if (state is ScannerError) {
              setState(() {
                _isCropping = false;
              });
              _showSnackBar(state.message, isError: true);
            }
          },
        ),
        BlocListener<PdfGenerationCubit, PdfGenerationState>(
          listener: (context, state) {
            if (state is PdfGenerationLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (_) => _buildLoadingDialog(),
              );
            } else if (state is PdfGenerationSuccess) {
              Navigator.of(context).pop(); // Close loading dialog
              
              // Refresh PDF list
              context.read<PdfListCubit>().loadPdfs();
              
              // Navigate back to home
              Navigator.of(context).popUntil((route) => route.isFirst);
              
              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                      SizedBox(width: 12),
                      Text('PDF saved successfully'),
                    ],
                  ),
                  backgroundColor: Colors.green,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.all(16),
                ),
              );
            } else if (state is PdfGenerationError) {
              // Close loading dialog if open
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              }
              
              _showSnackBar(state.message, isError: true);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: _buildAppBar(),
        body: Column(
          children: [
            // Image Preview
            Expanded(
              child: _buildImagePreview(),
            ),
            
            // Controls
            _buildControls(),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Finalize Document'),
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Card(
        elevation: 4,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(_currentImagePath),
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Failed to load image',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Edit Tools Overlay
            Positioned(
              top: 16,
              right: 16,
              child: Column(
                children: [
                  _buildEditButton(
                    icon: Icons.crop,
                    onTap: _isCropping ? null : _cropImage,
                    isActive: _isCropping,
                    tooltip: 'قص الصورة',
                  ),
                  const SizedBox(height: 12),
                  _buildEditButton(
                    icon: Icons.rotate_right,
                    onTap: _isRotating ? null : _rotateImage,
                    isActive: _isRotating,
                    tooltip: 'تدوير الصورة',
                  ),
                  const SizedBox(height: 12),
                  _buildEditButton(
                    icon: Icons.auto_fix_high,
                    onTap: _isEnhancing ? null : _enhanceImage,
                    isActive: _isEnhancing,
                    tooltip: 'تحسين الصورة',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEditButton({
    required IconData icon,
    VoidCallback? onTap,
    bool isActive = false,
    String? tooltip,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive
              ? Theme.of(context).colorScheme.primary
              : Colors.white.withValues(alpha: 0.9),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: IconButton(
          icon: Icon(
            icon,
            color: isActive ? Colors.white : Colors.black87,
          ),
          onPressed: onTap,
        ),
      ),
    );
  }

  Widget _buildControls() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          // File Name Input
          TextField(
            controller: _fileNameController,
            decoration: InputDecoration(
              labelText: 'Document Name',
              hintText: 'Enter document name',
              prefixIcon: const Icon(Icons.edit_document),
              suffixText: '.pdf',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 24),
          
          // Action Buttons
          Row(
            children: [
              // Cancel Button
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              
              // Save Button
              Expanded(
                flex: 2,
                child: FilledButton.icon(
                  onPressed: _generatePdf,
                  icon: const Icon(Icons.save),
                  label: const Text('Save as PDF'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingDialog() {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 24),
            const Text(
              'Creating your PDF...',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This won\'t take long',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}