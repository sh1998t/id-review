import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaceIdStepWidget extends StatefulWidget {
  const FaceIdStepWidget({super.key});

  @override
  State<FaceIdStepWidget> createState() => _FaceIdStepWidgetState();
}

class _FaceIdStepWidgetState extends State<FaceIdStepWidget> {
  CameraController? _controller;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _errorMessage = 'Kamera topilmadi');
        return;
      }

      final camera = cameras.firstWhere(
        (item) => item.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller.initialize();

      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() {
        _controller = controller;
        _isInitialized = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Kamerani ochib bo\'lmadi');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 480.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFF2F3448),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(child: _buildCameraArea()),
      ),
    );
  }

  Widget _buildCameraArea() {
    if (_errorMessage != null) {
      return _buildPlaceholder(
        icon: Icons.videocam_off_outlined,
        text: _errorMessage!,
      );
    }

    if (!_isInitialized || _controller == null) {
      return const CircularProgressIndicator(color: Colors.white);
    }

    return ClipOval(
      child: SizedBox(
        width: 280.w,
        height: 280.w,
        child: FittedBox(
          fit: BoxFit.cover,
          child: SizedBox(
            width: _controller!.value.previewSize?.height ?? 280.w,
            height: _controller!.value.previewSize?.width ?? 280.w,
            child: CameraPreview(_controller!),
          ),
        ),
      ),
    );
  }

  Widget _buildPlaceholder({
    required IconData icon,
    required String text,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white54, size: 48.sp),
        SizedBox(height: 12.h),
        Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 13.sp,
          ),
        ),
      ],
    );
  }
}
