import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/scanner_cubit.dart';
import '../cubit/pdf_generation_cubit.dart';
import '../cubit/pdf_list_cubit.dart';
import 'image_crop_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _cameraController;
  List<CameraDescription>? _cameras;
  bool _isInitializing = true;
  bool _isTakingPhoto = false;
  double _currentZoomLevel = 1.0;
  double _minZoomLevel = 1.0;
  double _maxZoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
        _cameraController = CameraController(
          _cameras![0],
          ResolutionPreset.high,
          enableAudio: false,
        );

        await _cameraController!.initialize();
        
        // Get zoom levels
        _minZoomLevel = await _cameraController!.getMinZoomLevel();
        _maxZoomLevel = await _cameraController!.getMaxZoomLevel();

        setState(() {
          _isInitializing = false;
        });
      }
    } catch (e) {
      // Error initializing camera
      setState(() {
        _isInitializing = false;
      });
    }
  }

  Future<void> _takePicture() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized || _isTakingPhoto) {
      return;
    }

    try {
      setState(() {
        _isTakingPhoto = true;
      });
      
      // Add haptic feedback
      HapticFeedback.mediumImpact();

      final XFile image = await _cameraController!.takePicture();
      
      if (mounted) {
        // Navigate to crop page with BLoC context preserved
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: context.read<ScannerCubit>(),
                ),
                BlocProvider.value(
                  value: context.read<PdfGenerationCubit>(),
                ),
                BlocProvider.value(
                  value: context.read<PdfListCubit>(),
                ),
              ],
              child: ImageCropPage(imagePath: image.path),
            ),
          ),
        );
      }
    } catch (e) {
      // Error taking picture
    } finally {
      setState(() {
        _isTakingPhoto = false;
      });
    }
  }

  void _onZoomChanged(double scale) {
    final double newZoomLevel = (_currentZoomLevel * scale).clamp(_minZoomLevel, _maxZoomLevel);
    _cameraController?.setZoomLevel(newZoomLevel);
    setState(() {
      _currentZoomLevel = newZoomLevel;
    });
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Camera Preview
          if (_isInitializing)
            _buildLoadingState()
          else if (_cameraController != null && _cameraController!.value.isInitialized)
            _buildCameraPreview()
          else
            _buildErrorState(),

          // UI Overlay
          _buildOverlay(),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: Colors.white,
          ),
          SizedBox(height: 24),
          Text(
            'Initializing Camera...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red.withValues(alpha: 0.2),
            ),
            child: const Icon(
              Icons.error_outline,
              color: Colors.red,
              size: 48,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Camera not available',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    return GestureDetector(
      onScaleUpdate: (details) {
        _onZoomChanged(details.scale);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Camera Preview
          CameraPreview(_cameraController!),
          
          // Simple Viewfinder Overlay
          CustomPaint(
            painter: _SimpleViewfinderPainter(),
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget _buildOverlay() {
    return SafeArea(
      child: Stack(
        children: [
          // Top Bar
          Positioned(
            top: 20,
            left: 20,
            right: 20,
            child: _buildTopBar(),
          ),

          // Bottom Controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomControls(),
          ),

          // Zoom Indicator
          if (_currentZoomLevel > 1.0)
            Positioned(
              bottom: 180,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_currentZoomLevel.toStringAsFixed(1)}x',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Close Button
        Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),

        // Title
        const Text(
          'Scan Document',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        // Flash Button
        Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.flash_auto,
              color: Colors.white,
            ),
            onPressed: () {
              // Toggle flash
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withValues(alpha: 0.7),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Spacer for symmetry
          const SizedBox(width: 60),

          // Capture Button
          GestureDetector(
            onTap: _isTakingPhoto ? null : _takePicture,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
              ),
              child: Container(
                margin: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.black87,
                  size: 36,
                ),
              ),
            ),
          ),

          // Switch Camera Button
          GestureDetector(
            onTap: () {
              // Switch camera
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.flip_camera_ios,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Simple Viewfinder Painter
class _SimpleViewfinderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2);
    final width = size.width * 0.8;
    final height = width * 1.4; // A4 aspect ratio
    final rect = Rect.fromCenter(
      center: center,
      width: width,
      height: height,
    );

    // Draw corners
    const cornerLength = 30.0;
    final path = Path();

    // Top-left corner
    path.moveTo(rect.left, rect.top + cornerLength);
    path.lineTo(rect.left, rect.top);
    path.lineTo(rect.left + cornerLength, rect.top);

    // Top-right corner
    path.moveTo(rect.right - cornerLength, rect.top);
    path.lineTo(rect.right, rect.top);
    path.lineTo(rect.right, rect.top + cornerLength);

    // Bottom-right corner
    path.moveTo(rect.right, rect.bottom - cornerLength);
    path.lineTo(rect.right, rect.bottom);
    path.lineTo(rect.right - cornerLength, rect.bottom);

    // Bottom-left corner
    path.moveTo(rect.left + cornerLength, rect.bottom);
    path.lineTo(rect.left, rect.bottom);
    path.lineTo(rect.left, rect.bottom - cornerLength);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}