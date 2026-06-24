import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum _CameraError { notFound, openFailed }

class FaceIdStepWidget extends StatefulWidget {
  const FaceIdStepWidget({super.key});

  @override
  State<FaceIdStepWidget> createState() => _FaceIdStepWidgetState();
}

class _FaceIdStepWidgetState extends State<FaceIdStepWidget> {
  CameraController? _controller;
  bool _isInitialized = false;
  _CameraError? _error;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        setState(() => _error = _CameraError.notFound);
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
      setState(() => _error = _CameraError.openFailed);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  String? get _errorMessage {
    return switch (_error) {
      _CameraError.notFound => 'main.face_id.camera_not_found'.tr(),
      _CameraError.openFailed => 'main.face_id.camera_error'.tr(),
      null => null,
    };
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
    final errorMessage = _errorMessage;
    if (errorMessage != null) {
      return _buildPlaceholder(
        icon: Icons.videocam_off_outlined,
        text: errorMessage,
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
