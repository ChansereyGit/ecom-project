import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int currentStep;
  final List<String> steps;

  const ProgressIndicatorWidget({
    super.key,
    required this.currentStep,
    required this.steps,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: List.generate(steps.length, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;
              final isUpcoming = index > currentStep;

              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: isCompleted || isCurrent
                              ? colorScheme.primary
                              : colorScheme.outline.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    if (index < steps.length - 1) SizedBox(width: 2.w),
                  ],
                ),
              );
            }),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length, (index) {
              final isCompleted = index < currentStep;
              final isCurrent = index == currentStep;
              final isUpcoming = index > currentStep;

              return Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? colorScheme.primary
                            : isCurrent
                                ? colorScheme.primary
                                : colorScheme.outline.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                        border: isCurrent
                            ? Border.all(
                                color: colorScheme.primary,
                                width: 2,
                              )
                            : null,
                      ),
                      child: Center(
                        child: isCompleted
                            ? CustomIconWidget(
                                iconName: 'check',
                                color: colorScheme.onPrimary,
                                size: 16,
                              )
                            : Text(
                                '${index + 1}',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: isCurrent
                                      ? colorScheme.onPrimary
                                      : isUpcoming
                                          ? colorScheme.onSurfaceVariant
                                          : colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      steps[index],
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isCurrent
                            ? colorScheme.primary
                            : isCompleted
                                ? colorScheme.onSurface
                                : colorScheme.onSurfaceVariant,
                        fontWeight: isCurrent || isCompleted
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
