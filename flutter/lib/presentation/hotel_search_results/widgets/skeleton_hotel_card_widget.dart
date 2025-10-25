import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SkeletonHotelCardWidget extends StatefulWidget {
  const SkeletonHotelCardWidget({super.key});

  @override
  State<SkeletonHotelCardWidget> createState() =>
      _SkeletonHotelCardWidgetState();
}

class _SkeletonHotelCardWidgetState extends State<SkeletonHotelCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSkeletonImage(context),
            _buildSkeletonContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonImage(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 25.h,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest
                .withValues(alpha: _animation.value),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSkeletonContent(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.all(3.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Container(
                      height: 2.h,
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest
                            .withValues(alpha: _animation.value),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(width: 4.w),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    width: 20.w,
                    height: 2.h,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: _animation.value),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 1.h),
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: 60.w,
                height: 1.5.h,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest
                      .withValues(alpha: _animation.value),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            },
          ),
          SizedBox(height: 1.h),
          Row(
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    width: 15.w,
                    height: 1.5.h,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: _animation.value),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
              SizedBox(width: 2.w),
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Container(
                    width: 25.w,
                    height: 1.5.h,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest
                          .withValues(alpha: _animation.value),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        width: 12.w,
                        height: 1.5.h,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest
                              .withValues(alpha: _animation.value),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 2.w),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        width: 12.w,
                        height: 1.5.h,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest
                              .withValues(alpha: _animation.value),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      );
                    },
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        width: 20.w,
                        height: 2.h,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest
                              .withValues(alpha: _animation.value),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 0.5.h),
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Container(
                        width: 15.w,
                        height: 1.h,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest
                              .withValues(alpha: _animation.value),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
