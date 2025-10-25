import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomTabBarVariant {
  standard,
  segmented,
  pills,
  underline,
}

class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final CustomTabBarVariant variant;
  final int initialIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? indicatorColor;
  final bool isScrollable;
  final EdgeInsetsGeometry? padding;
  final double? height;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.variant = CustomTabBarVariant.standard,
    this.initialIndex = 0,
    this.onTap,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.indicatorColor,
    this.isScrollable = false,
    this.padding,
    this.height,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();

  @override
  Size get preferredSize => Size.fromHeight(height ?? 48.0);
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );
    _tabController.addListener(_handleTabChange);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    super.dispose();
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;
      });
      if (widget.onTap != null) {
        widget.onTap!(_tabController.index);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (widget.variant) {
      case CustomTabBarVariant.segmented:
        return _buildSegmentedTabBar(context, colorScheme);
      case CustomTabBarVariant.pills:
        return _buildPillsTabBar(context, colorScheme);
      case CustomTabBarVariant.underline:
        return _buildUnderlineTabBar(context, colorScheme);
      case CustomTabBarVariant.standard:
      default:
        return _buildStandardTabBar(context, colorScheme);
    }
  }

  Widget _buildStandardTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      color: widget.backgroundColor ?? colorScheme.surface,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        labelColor: widget.selectedColor ?? colorScheme.primary,
        unselectedLabelColor:
            widget.unselectedColor ?? colorScheme.onSurfaceVariant,
        indicatorColor: widget.indicatorColor ?? colorScheme.primary,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        tabs: widget.tabs.map((tab) => Tab(text: tab)).toList(),
      ),
    );
  }

  Widget _buildSegmentedTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      color: widget.backgroundColor ?? colorScheme.surface,
      padding: widget.padding ?? const EdgeInsets.all(16),
      child: Container(
        height: widget.height ?? 40,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: widget.tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;
            final isSelected = _currentIndex == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  _tabController.animateTo(index);
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? (widget.selectedColor ?? colorScheme.primary)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Center(
                    child: Text(
                      tab,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? colorScheme.onPrimary
                            : (widget.unselectedColor ??
                                colorScheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPillsTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      color: widget.backgroundColor ?? colorScheme.surface,
      padding: widget.padding ?? const EdgeInsets.all(16),
      height: widget.height ?? 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: widget.tabs.length,
        separatorBuilder: (context, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final tab = widget.tabs[index];
          final isSelected = _currentIndex == index;

          return GestureDetector(
            onTap: () {
              _tabController.animateTo(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? (widget.selectedColor ?? colorScheme.primary)
                    : colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? (widget.selectedColor ?? colorScheme.primary)
                      : colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              child: Center(
                child: Text(
                  tab,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? colorScheme.onPrimary
                        : (widget.unselectedColor ??
                            colorScheme.onSurfaceVariant),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildUnderlineTabBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      color: widget.backgroundColor ?? colorScheme.surface,
      padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 16),
      child: TabBar(
        controller: _tabController,
        isScrollable: widget.isScrollable,
        labelColor: widget.selectedColor ?? colorScheme.primary,
        unselectedLabelColor:
            widget.unselectedColor ?? colorScheme.onSurfaceVariant,
        indicatorColor: widget.indicatorColor ?? colorScheme.primary,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: widget.indicatorColor ?? colorScheme.primary,
            width: 3,
          ),
          insets: const EdgeInsets.symmetric(horizontal: 16),
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
        tabs: widget.tabs
            .map((tab) => Tab(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(tab),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

// Helper widget for hotel-specific tab scenarios
class HotelTabBar extends StatelessWidget {
  final TabController? controller;
  final ValueChanged<int>? onTap;

  const HotelTabBar({
    super.key,
    this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTabBar(
      tabs: const ['Overview', 'Rooms', 'Amenities', 'Reviews', 'Location'],
      variant: CustomTabBarVariant.underline,
      onTap: onTap,
      isScrollable: true,
    );
  }
}

// Helper widget for search results filtering
class SearchFilterTabBar extends StatelessWidget {
  final TabController? controller;
  final ValueChanged<int>? onTap;

  const SearchFilterTabBar({
    super.key,
    this.controller,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomTabBar(
      tabs: const ['All', 'Budget', 'Mid-range', 'Luxury', 'Boutique'],
      variant: CustomTabBarVariant.pills,
      onTap: onTap,
      isScrollable: true,
      height: 40,
    );
  }
}
