import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PhotoGalleryGrid extends StatelessWidget {
  final List<String> photos;
  final String hotelName;

  const PhotoGalleryGrid({
    super.key,
    required this.photos,
    required this.hotelName,
  });

  void _showAllPhotos(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _AllPhotosScreen(
          photos: photos,
          hotelName: hotelName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Show only first 4 photos in grid
    final displayPhotos = photos.take(4).toList();
    final remainingCount = photos.length - 4;

    return Container(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Photos',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () => _showAllPhotos(context),
                child: Row(
                  children: [
                    Text(
                      'View All (${photos.length})',
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
          Container(
            height: 40.h,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 2.w,
                mainAxisSpacing: 1.h,
                childAspectRatio: 1.2,
              ),
              itemCount: displayPhotos.length,
              itemBuilder: (context, index) {
                final isLastItem = index == 3 && remainingCount > 0;

                return GestureDetector(
                  onTap: () => _showAllPhotos(context),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CustomImageWidget(
                            imageUrl: displayPhotos[index],
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          if (isLastItem)
                            Container(
                              color: Colors.black.withValues(alpha: 0.6),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CustomIconWidget(
                                      iconName: 'photo_library',
                                      color: Colors.white,
                                      size: 32,
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      '+${remainingCount} more',
                                      style:
                                          theme.textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AllPhotosScreen extends StatelessWidget {
  final List<String> photos;
  final String hotelName;

  const _AllPhotosScreen({
    required this.photos,
    required this.hotelName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Photos - $hotelName'),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: () {
              // Handle share
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(4.w),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 2.w,
          mainAxisSpacing: 1.h,
          childAspectRatio: 1.0,
        ),
        itemCount: photos.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => _PhotoViewScreen(
                    photos: photos,
                    initialIndex: index,
                    hotelName: hotelName,
                  ),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CustomImageWidget(
                  imageUrl: photos[index],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PhotoViewScreen extends StatefulWidget {
  final List<String> photos;
  final int initialIndex;
  final String hotelName;

  const _PhotoViewScreen({
    required this.photos,
    required this.initialIndex,
    required this.hotelName,
  });

  @override
  State<_PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<_PhotoViewScreen> {
  late PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'close',
            color: Colors.white,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '${_currentIndex + 1} of ${widget.photos.length}',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: CustomIconWidget(
              iconName: 'share',
              color: Colors.white,
              size: 24,
            ),
            onPressed: () {
              // Handle share
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemCount: widget.photos.length,
        itemBuilder: (context, index) {
          return InteractiveViewer(
            child: Center(
              child: CustomImageWidget(
                imageUrl: widget.photos[index],
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
