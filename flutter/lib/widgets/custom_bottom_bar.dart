import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomBottomBarVariant {
  navigation,
  booking,
  search,
}

class CustomBottomBar extends StatefulWidget {
  final CustomBottomBarVariant variant;
  final int currentIndex;
  final ValueChanged<int>? onTap;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? elevation;

  const CustomBottomBar({
    super.key,
    this.variant = CustomBottomBarVariant.navigation,
    this.currentIndex = 0,
    this.onTap,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.elevation,
  });

  @override
  State<CustomBottomBar> createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  void didUpdateWidget(CustomBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentIndex != oldWidget.currentIndex) {
      _currentIndex = widget.currentIndex;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    switch (widget.variant) {
      case CustomBottomBarVariant.booking:
        return _buildBookingBottomBar(context, colorScheme);
      case CustomBottomBarVariant.search:
        return _buildSearchBottomBar(context, colorScheme);
      case CustomBottomBarVariant.navigation:
      default:
        return _buildNavigationBottomBar(context, colorScheme);
    }
  }

  Widget _buildNavigationBottomBar(
      BuildContext context, ColorScheme colorScheme) {
    final items = [
      _BottomNavItem(
        icon: Icons.search_outlined,
        activeIcon: Icons.search,
        label: 'Search',
        route: '/hotel-search-home',
      ),
      _BottomNavItem(
        icon: Icons.favorite_border,
        activeIcon: Icons.favorite,
        label: 'Favorites',
        route: '/hotel-search-results',
      ),
      _BottomNavItem(
        icon: Icons.book_outlined,
        activeIcon: Icons.book,
        label: 'Bookings',
        route: '/my-bookings',
      ),
      _BottomNavItem(
        icon: Icons.account_circle_outlined,
        activeIcon: Icons.account_circle,
        label: 'Profile',
        route: '/login-screen',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
          height: 60,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isSelected = _currentIndex == index;

              return Expanded(
                child: InkWell(
                  onTap: () => _handleNavigation(context, index, item.route),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? item.activeIcon : item.icon,
                          color: isSelected
                              ? (widget.selectedItemColor ??
                                  colorScheme.primary)
                              : (widget.unselectedItemColor ??
                                  colorScheme.onSurfaceVariant),
                          size: 24,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.label,
                          style: GoogleFonts.roboto(
                            fontSize: 11,
                            fontWeight:
                                isSelected ? FontWeight.w500 : FontWeight.w400,
                            color: isSelected
                                ? (widget.selectedItemColor ??
                                    colorScheme.primary)
                                : (widget.unselectedItemColor ??
                                    colorScheme.onSurfaceVariant),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingBottomBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.12),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Price',
                      style: GoogleFonts.roboto(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '\$299/night',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/booking-checkout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Book Now',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBottomBar(BuildContext context, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: widget.backgroundColor ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Handle filter
                  },
                  icon: const Icon(Icons.tune, size: 20),
                  label: Text(
                    'Filter',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    // Handle sort
                  },
                  icon: const Icon(Icons.sort, size: 20),
                  label: Text(
                    'Sort',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () =>
                      Navigator.pushNamed(context, '/hotel-search-results'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Search',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNavigation(BuildContext context, int index, String route) {
    setState(() {
      _currentIndex = index;
    });

    if (widget.onTap != null) {
      widget.onTap!(index);
    }

    Navigator.pushNamed(context, route);
  }
}

class _BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String route;

  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.route,
  });
}
