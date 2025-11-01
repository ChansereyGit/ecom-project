import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum CustomAppBarVariant {
  standard,
  search,
  detail,
  booking,
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final CustomAppBarVariant variant;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final double? elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    required this.title,
    this.variant = CustomAppBarVariant.standard,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.onBackPressed,
    this.centerTitle = true,
    this.elevation,
    this.backgroundColor,
    this.foregroundColor,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AppBar(
      title: _buildTitle(context),
      leading: _buildLeading(context),
      actions: _buildActions(context),
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: centerTitle,
      elevation: elevation ?? _getElevationForVariant(),
      backgroundColor:
          backgroundColor ?? _getBackgroundColorForVariant(colorScheme),
      foregroundColor:
          foregroundColor ?? _getForegroundColorForVariant(colorScheme),
      surfaceTintColor: Colors.transparent,
      bottom: bottom,
      titleTextStyle: _getTitleTextStyle(context),
      iconTheme: IconThemeData(
        color: foregroundColor ?? _getForegroundColorForVariant(colorScheme),
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: foregroundColor ?? _getForegroundColorForVariant(colorScheme),
        size: 24,
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    switch (variant) {
      case CustomAppBarVariant.search:
        return Container(
          height: 40,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color:
                  Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Icon(
                Icons.search,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title.isEmpty ? 'Search hotels...' : title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        );
      default:
        return Text(title);
    }
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;

    if (automaticallyImplyLeading && Navigator.of(context).canPop()) {
      return IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
        tooltip: 'Back',
      );
    }

    return null;
  }

  List<Widget>? _buildActions(BuildContext context) {
    final defaultActions = _getDefaultActionsForVariant(context);

    if (actions != null) {
      return [...defaultActions, ...actions!];
    }

    return defaultActions.isNotEmpty ? defaultActions : null;
  }

  List<Widget> _getDefaultActionsForVariant(BuildContext context) {
    switch (variant) {
      case CustomAppBarVariant.standard:
        return [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Handle notifications
            },
            tooltip: 'Notifications',
          ),
          IconButton(
            icon: const Icon(Icons.account_circle_outlined),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
            tooltip: 'Profile',
          ),
        ];

      case CustomAppBarVariant.search:
        return [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // Handle filter
            },
            tooltip: 'Filter',
          ),
          IconButton(
            icon: const Icon(Icons.map_outlined),
            onPressed: () {
              // Handle map view
            },
            tooltip: 'Map View',
          ),
        ];

      case CustomAppBarVariant.detail:
        return [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              // Handle share
            },
            tooltip: 'Share',
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {
              // Handle favorite
            },
            tooltip: 'Add to Favorites',
          ),
        ];

      case CustomAppBarVariant.booking:
        return [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              // Handle help
            },
            tooltip: 'Help',
          ),
        ];

      default:
        return [];
    }
  }

  double _getElevationForVariant() {
    switch (variant) {
      case CustomAppBarVariant.search:
        return 0;
      case CustomAppBarVariant.detail:
        return 0;
      default:
        return 0;
    }
  }

  Color _getBackgroundColorForVariant(ColorScheme colorScheme) {
    switch (variant) {
      case CustomAppBarVariant.detail:
        return Colors.transparent;
      default:
        return colorScheme.surface;
    }
  }

  Color _getForegroundColorForVariant(ColorScheme colorScheme) {
    return colorScheme.onSurface;
  }

  TextStyle _getTitleTextStyle(BuildContext context) {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: _getForegroundColorForVariant(Theme.of(context).colorScheme),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}
