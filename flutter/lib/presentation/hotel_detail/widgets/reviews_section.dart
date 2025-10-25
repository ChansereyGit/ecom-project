import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ReviewsSection extends StatelessWidget {
  final double overallRating;
  final int totalReviews;
  final Map<String, double> ratingBreakdown;
  final List<Map<String, dynamic>> recentReviews;

  const ReviewsSection({
    super.key,
    required this.overallRating,
    required this.totalReviews,
    required this.ratingBreakdown,
    required this.recentReviews,
  });

  void _showAllReviews(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _AllReviewsScreen(
          overallRating: overallRating,
          totalReviews: totalReviews,
          ratingBreakdown: ratingBreakdown,
          reviews: recentReviews,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Guest Reviews',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () => _showAllReviews(context),
                child: Row(
                  children: [
                    Text(
                      'Read All Reviews',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: 'arrow_forward_ios',
                      color: colorScheme.primary,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),

          // Overall rating summary
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Text(
                      overallRating.toStringAsFixed(1),
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        5,
                        (index) => CustomIconWidget(
                          iconName: index < overallRating.floor()
                              ? 'star'
                              : 'star_border',
                          color: AppTheme.warningLight,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$totalReviews Reviews',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    ...ratingBreakdown.entries.map((entry) {
                      return _buildRatingBar(context, entry.key, entry.value);
                    }).toList(),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 3.h),

          // Recent reviews
          Text(
            'Recent Reviews',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 2.h),
          ...recentReviews.take(3).map((review) {
            return _buildReviewCard(context, review);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRatingBar(BuildContext context, String category, double rating) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 0.5.h),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              category,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 0.5.h,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: rating / 5.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            rating.toStringAsFixed(1),
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Map<String, dynamic> review) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                child: CustomImageWidget(
                  imageUrl: review['userAvatar'] as String,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['userName'] as String,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (index) => CustomIconWidget(
                              iconName:
                                  index < (review['rating'] as double).floor()
                                      ? 'star'
                                      : 'star_border',
                              color: AppTheme.warningLight,
                              size: 14,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          review['date'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            review['comment'] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          if (review['helpful'] as int > 0) ...[
            SizedBox(height: 1.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'thumb_up',
                  color: colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  '${review['helpful']} found this helpful',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _AllReviewsScreen extends StatelessWidget {
  final double overallRating;
  final int totalReviews;
  final Map<String, double> ratingBreakdown;
  final List<Map<String, dynamic>> reviews;

  const _AllReviewsScreen({
    required this.overallRating,
    required this.totalReviews,
    required this.ratingBreakdown,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Guest Reviews'),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              // Handle filter reviews
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(4.w),
        children: [
          // Rating summary
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        overallRating.toStringAsFixed(1),
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          5,
                          (index) => CustomIconWidget(
                            iconName: index < overallRating.floor()
                                ? 'star'
                                : 'star_border',
                            color: AppTheme.warningLight,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$totalReviews Reviews',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      ...ratingBreakdown.entries.map((entry) {
                        return _buildRatingBar(context, entry.key, entry.value);
                      }).toList(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // All reviews
          ...reviews.map((review) {
            return _buildReviewCard(context, review);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRatingBar(BuildContext context, String category, double rating) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 1.h),
      child: Row(
        children: [
          SizedBox(
            width: 20.w,
            child: Text(
              category,
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 0.5.h,
              decoration: BoxDecoration(
                color: colorScheme.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: rating / 5.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 2.w),
          Text(
            rating.toStringAsFixed(1),
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(BuildContext context, Map<String, dynamic> review) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                child: CustomImageWidget(
                  imageUrl: review['userAvatar'] as String,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review['userName'] as String,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(
                            5,
                            (index) => CustomIconWidget(
                              iconName:
                                  index < (review['rating'] as double).floor()
                                      ? 'star'
                                      : 'star_border',
                              color: AppTheme.warningLight,
                              size: 14,
                            ),
                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          review['date'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            review['comment'] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          if (review['helpful'] as int > 0) ...[
            SizedBox(height: 2.h),
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'thumb_up',
                  color: colorScheme.onSurfaceVariant,
                  size: 16,
                ),
                SizedBox(width: 1.w),
                Text(
                  '${review['helpful']} found this helpful',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
