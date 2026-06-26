import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StepItem {
  final String number;
  final String title;
  final String subtitle;

  const StepItem({
    required this.number,
    required this.title,
    required this.subtitle,
  });
}

class CustomStepper extends StatefulWidget {
  final List<StepItem> steps;
  final int currentStep;
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const CustomStepper({
    super.key,
    required this.steps,
    required this.currentStep,
    this.onNext,
    this.onBack,
  });

  @override
  State<CustomStepper> createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  final ScrollController _scrollController = ScrollController();
  late final List<GlobalKey> _stepKeys;
  List<double> _stepLeftPositions = [];
  double _totalVisualWidth = 0;
  bool _isMeasured = false;

  @override
  void initState() {
    super.initState();
    _stepKeys = List.generate(widget.steps.length, (_) => GlobalKey());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _measureSteps();
      _scrollToActiveStep();
    });
  }

  @override
  void didUpdateWidget(CustomStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentStep != widget.currentStep ||
        oldWidget.steps.length != widget.steps.length) {
      if (oldWidget.steps.length != widget.steps.length) {
        _stepKeys = List.generate(widget.steps.length, (_) => GlobalKey());
        _isMeasured = false;
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _measureSteps();
        _scrollToActiveStep();
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _measureSteps() {
    if (!mounted || widget.steps.isEmpty) return;

    final overlap = 14.w;
    final widths = <double>[];
    for (final key in _stepKeys) {
      final context = key.currentContext;
      if (context == null) return;
      final box = context.findRenderObject() as RenderBox?;
      if (box == null || !box.hasSize) return;
      widths.add(box.size.width);
    }

    if (widths.length != widget.steps.length) return;

    final positions = <double>[];
    var left = 0.0;
    for (var i = 0; i < widths.length; i++) {
      positions.add(left);
      left += widths[i] - (i < widths.length - 1 ? overlap : 0);
    }

    setState(() {
      _stepLeftPositions = positions;
      _totalVisualWidth = left;
      _isMeasured = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToActiveStep());
  }

  void _scrollToActiveStep() {
    if (!mounted) return;
    if (widget.currentStep < 0 || widget.currentStep >= _stepKeys.length) {
      return;
    }

    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    if (maxScroll <= 0) return;

    if (widget.currentStep == widget.steps.length - 1) {
      _scrollController.animateTo(
        maxScroll,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    if (widget.currentStep == 0) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      return;
    }

    final stepContext = _stepKeys[widget.currentStep].currentContext;
    if (stepContext == null) return;

    Scrollable.ensureVisible(
      stepContext,
      alignment: 0.5,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  List<Widget> _buildSteps(double overlap) {
    final sortedIndices = List.generate(widget.steps.length, (index) => index)
      ..sort((a, b) {
        if (a == widget.currentStep) return 1;
        if (b == widget.currentStep) return -1;
        return a.compareTo(b);
      });

    if (!_isMeasured || _stepLeftPositions.length != widget.steps.length) {
      return [
        for (final index in sortedIndices)
          Transform.translate(
            key: _stepKeys[index],
            offset: Offset(-index * overlap, 0),
            child: _StepShape(
              item: widget.steps[index],
              isActive: index == widget.currentStep,
              isCompleted: index < widget.currentStep,
              isFirst: index == 0,
              isLast: index == widget.steps.length - 1,
              arrowWidth: overlap,
            ),
          ),
      ];
    }

    return [
      for (final index in sortedIndices)
        Positioned(
          key: _stepKeys[index],
          left: _stepLeftPositions[index],
          top: 0,
          bottom: 0,
          child: _StepShape(
            item: widget.steps[index],
            isActive: index == widget.currentStep,
            isCompleted: index < widget.currentStep,
            isFirst: index == 0,
            isLast: index == widget.steps.length - 1,
            arrowWidth: overlap,
          ),
        ),
    ];
  }

  Widget _buildStepsArea(double overlap) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final viewportWidth = constraints.maxWidth;
        final needsScroll =
            _isMeasured && _totalVisualWidth > viewportWidth + 1;

        if (!_isMeasured) {
          return SingleChildScrollView(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _buildSteps(overlap),
            ),
          );
        }

        final stepsStack = SizedBox(
          width: needsScroll ? _totalVisualWidth : viewportWidth,
          height: 60.h,
          child: Stack(
            clipBehavior: Clip.none,
            children: _buildSteps(overlap),
          ),
        );

        if (!needsScroll) {
          return Align(
            alignment: Alignment.centerLeft,
            child: stepsStack,
          );
        }

        return SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: stepsStack,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final overlap = 14.w;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;

    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 12.h + bottomPadding),
        child: SizedBox(
          height: 76.h,
          child: Container(
            clipBehavior: Clip.antiAlias,
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                _arrowButton(
                  icon: Icons.arrow_back,
                  onTap: widget.onBack,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: ClipRect(
                    child: _buildStepsArea(overlap),
                  ),
                ),
                SizedBox(width: 8.w),
                _arrowButton(
                  icon: Icons.arrow_forward,
                  onTap: widget.onNext,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _arrowButton({
    required IconData icon,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8.r),
        child: Container(
          width: 55.w,
          height: 70.h,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 22.sp,
          ),
        ),
      ),
    );
  }
}

class _StepShape extends StatelessWidget {
  final StepItem item;
  final bool isActive;
  final bool isCompleted;
  final bool isFirst;
  final bool isLast;
  final double arrowWidth;

  const _StepShape({
    super.key,
    required this.item,
    required this.isActive,
    required this.isCompleted,
    required this.isFirst,
    required this.isLast,
    required this.arrowWidth,
  });

  @override
  Widget build(BuildContext context) {
    final contentOpacity = isActive || isCompleted ? 1.0 : 0.75;

    return SizedBox(
      height: 60.h,
      child: CustomPaint(
        painter: _StepShapePainter(
          isActive: isActive,
          isCompleted: isCompleted,
          isFirst: isFirst,
          isLast: isLast,
          arrowWidth: arrowWidth,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: isFirst ? 10.w : arrowWidth + 6.w,
            right: isLast ? 12.w : arrowWidth + 2.w,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: contentOpacity),
                  ),
                ),
                child: Text(
                  item.number,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: contentOpacity),
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: contentOpacity),
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    item.subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(
                        alpha: isActive ? 0.85 : 0.55,
                      ),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepShapePainter extends CustomPainter {
  final bool isActive;
  final bool isCompleted;
  final bool isFirst;
  final bool isLast;
  final double arrowWidth;

  _StepShapePainter({
    required this.isActive,
    required this.isCompleted,
    required this.isFirst,
    required this.isLast,
    required this.arrowWidth,
  });

  Path _buildPath(Size size) {
    final path = Path();

    if (isFirst && isLast) {
      path.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(4),
        ),
      );
      return path;
    }

    if (isFirst) {
      path.moveTo(0, 0);
      path.lineTo(size.width - arrowWidth, 0);
      path.lineTo(size.width, size.height / 2);
      path.lineTo(size.width - arrowWidth, size.height);
      path.lineTo(0, size.height);
      path.close();
      return path;
    }

    if (isLast) {
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.lineTo(arrowWidth, size.height / 2);
      path.close();
      return path;
    }

    path.moveTo(0, 0);
    path.lineTo(size.width - arrowWidth, 0);
    path.lineTo(size.width, size.height / 2);
    path.lineTo(size.width - arrowWidth, size.height);
    path.lineTo(0, size.height);
    path.lineTo(arrowWidth, size.height / 2);
    path.close();
    return path;
  }

  Color get _fillColor {
    if (isActive) return const Color(0xFF2D7CF6);
    if (isCompleted) return const Color(0xFF2EAE4E);
    return Colors.white.withValues(alpha: 0.12);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final path = _buildPath(size);

    canvas.drawPath(
      path,
      Paint()
        ..color = _fillColor
        ..style = PaintingStyle.fill,
    );

    canvas.drawPath(
      path,
      Paint()
        ..color = Colors.white.withValues(
          alpha: isActive || isCompleted ? 0.35 : 0.2,
        )
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
  }

  @override
  bool shouldRepaint(covariant _StepShapePainter oldDelegate) {
    return oldDelegate.isActive != isActive ||
        oldDelegate.isCompleted != isCompleted ||
        oldDelegate.isFirst != isFirst ||
        oldDelegate.isLast != isLast ||
        oldDelegate.arrowWidth != arrowWidth;
  }
}
