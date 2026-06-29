import 'package:camera/camera.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum _CameraError { notFound, openFailed }

class FaceIdStepWidget extends StatefulWidget {
  final void Function(List<int> photoBytes)? onPhotoCaptured;

  const FaceIdStepWidget({
    super.key,
    this.onPhotoCaptured,
  });

  @override
  State<FaceIdStepWidget> createState() => _FaceIdStepWidgetState();
}

class _FaceIdStepWidgetState extends State<FaceIdStepWidget> {
  CameraController? _controller;
  bool _isInitialized = false;
  bool _isCapturing = false;
  bool _hasPhoto = false;
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
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = _CameraError.openFailed);
    }
  }

  Future<void> _capturePhoto() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) {
      return;
    }

    setState(() => _isCapturing = true);

    try {
      final photo = await controller.takePicture();
      final bytes = await photo.readAsBytes();
      if (!mounted) return;

      widget.onPhotoCaptured?.call(bytes);
      setState(() {
        _hasPhoto = true;
        _isCapturing = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isCapturing = false);
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: Center(child: _buildCameraArea())),
            Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: ElevatedButton(
                onPressed: _isInitialized && !_isCapturing ? _capturePhoto : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF28C711),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFF28C711).withValues(alpha: 0.5),
                ),
                child: _isCapturing
                    ? SizedBox(
                        width: 18.w,
                        height: 18.w,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _hasPhoto
                            ? 'main.face_id.retake'.tr()
                            : 'main.face_id.capture'.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
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

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipOval(
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
        ),
        if (_hasPhoto)
          Positioned(
            bottom: 8.h,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: const Color(0xFF28C711),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'main.face_id.captured'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
      ],
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
