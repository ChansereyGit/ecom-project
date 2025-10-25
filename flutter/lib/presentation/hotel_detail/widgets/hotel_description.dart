import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class HotelDescription extends StatefulWidget {
  final String description;

  const HotelDescription({
    super.key,
    required this.description,
  });

  @override
  State<HotelDescription> createState() => _HotelDescriptionState();
}

class _HotelDescriptionState extends State<HotelDescription> {
  bool _isExpanded = false;
  static const int _maxLines = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About This Hotel',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          AnimatedCrossFade(
            firstChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  maxLines: _maxLines,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = true;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Read More',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'keyboard_arrow_down',
                        color: colorScheme.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 1.h),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isExpanded = false;
                    });
                  },
                  child: Row(
                    children: [
                      Text(
                        'Read Less',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'keyboard_arrow_up',
                        color: colorScheme.primary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            crossFadeState: _isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 300),
          ),
        ],
      ),
    );
  }
}
