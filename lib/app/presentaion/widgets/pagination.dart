import 'package:flutter/material.dart';
import 'package:minh_nguyet_truyen/core/constants/colors.dart';

class SmartPagination extends StatefulWidget {
  final int totalPages;
  final int activePage;
  final Function(int) onPageChanged;

  const SmartPagination({
    Key? key,
    required this.totalPages,
    required this.activePage,
    required this.onPageChanged,
  }) : super(key: key);

  @override
  State<SmartPagination> createState() => _SmartPaginationState();
}

class _SmartPaginationState extends State<SmartPagination> {
  // Keeping the controller and dialog logic, even though Dropdown was suggested,
  // as the original code was not removed by the user in the latest request.
  final TextEditingController _pageController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Calculates the list of page numbers to be displayed (max 3 pages).
  /// Displays a window of 3 pages around the active page, handling boundary conditions.
  List<int> _getVisiblePages() {
    final int totalPages = widget.totalPages;
    final int current = widget.activePage;

    if (totalPages <= 3) {
      // If total pages are 3 or less, show all pages
      return List.generate(totalPages, (i) => i + 1);
    }

    if (current <= 2) {
      // Case 1: Active page is 1 or 2 (start of the list)
      // Always show [1, 2, 3]
      return [1, 2, 3];
    } else if (current >= totalPages - 1) {
      // Case 2: Active page is totalPages or totalPages - 1 (end of the list)
      // Always show [n-2, n-1, n]
      return [totalPages - 2, totalPages - 1, totalPages];
    } else {
      // Case 3: Active page is in the middle
      // Show [current-1, current, current+1]
      return [current - 1, current, current + 1];
    }
  }

  /// Displays a dialog for the user to input a page number to navigate to.
  void _showGoToPageDialog() {
    _pageController.text = widget.activePage.toString();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Nhập page (1-${widget.totalPages})',
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ), // Updated text to English
        content: TextField(
          controller: _pageController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText:
                'Nhập page (1-${widget.totalPages})', // Updated text to English
            border: const OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Quay lại',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
          ),
          TextButton(
            onPressed: () {
              int? page = int.tryParse(_pageController.text);
              if (page != null && page >= 1 && page <= widget.totalPages) {
                widget.onPageChanged(page);
                Navigator.pop(context);
              }
            },
            child: const Text('Đi tới',
                style: TextStyle(
                    fontWeight: FontWeight.bold)), // Updated text to English
          ),
        ],
      ),
    );
  }

  // In the _SmartPaginationState class:

  @override
  Widget build(BuildContext context) {
    final visiblePages = _getVisiblePages();
    final int totalPages = widget.totalPages;

    // Determine if leading (start) ellipsis should be shown
    final bool showLeadingEllipsis = totalPages > 3 &&
        (visiblePages.isNotEmpty ? visiblePages.first > 1 : false);
    // Determine if trailing (end) ellipsis should be shown
    final bool showTrailingEllipsis = totalPages > 3 &&
        (visiblePages.isNotEmpty ? visiblePages.last < totalPages : false);

    return Container(
      color: AppColors.backgroundLight,
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Make the column wrap its content
        children: [
          // --- 1. Main Pagination Controls (Wrap for dynamic wrapping) ---
          // Using Wrap allows the buttons to automatically move to the next line
          // if they exceed the screen width.
          Wrap(
            // Alignment of items when they are on the same line
            alignment: WrapAlignment.center,
            // Spacing between lines/rows
            runSpacing: 10,
            // Spacing between items on the same line
            spacing: 5,
            children: [
              // Button to go to the first page (<<)
              _buildNavigationButton(
                icon: Icons.keyboard_double_arrow_left,
                onTap: widget.activePage > 1
                    ? () => widget.onPageChanged(1)
                    : null,
              ),

              // Button to go to the previous page (<)
              _buildNavigationButton(
                icon: Icons.chevron_left,
                onTap: widget.activePage > 1
                    ? () => widget.onPageChanged(widget.activePage - 1)
                    : null,
              ),

              // Show leading ellipsis if not at the start
              if (showLeadingEllipsis) _buildEllipsis(),

              // Display visible page numbers
              ...visiblePages.map((page) => _itemChapter(page)).toList(),

              // Show trailing ellipsis if not at the end
              if (showTrailingEllipsis) _buildEllipsis(),

              // Button to go to the next page (>)
              _buildNavigationButton(
                icon: Icons.chevron_right,
                onTap: widget.activePage < widget.totalPages
                    ? () => widget.onPageChanged(widget.activePage + 1)
                    : null,
              ),

              // Button to go to the last page (>>)
              _buildNavigationButton(
                icon: Icons.keyboard_double_arrow_right,
                onTap: widget.activePage < widget.totalPages
                    ? () => widget.onPageChanged(widget.totalPages)
                    : null,
              ),
              _buildGoToPage()
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the navigation buttons (<<, <, >, >>)
  Widget _buildNavigationButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    final isEnabled = onTap != null;
    return InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            width: 1,
            color: isEnabled
                ? AppColors.primary.withOpacity(0.5)
                : AppColors.primary.withOpacity(0.2),
          ),
          color: AppColors.backgroundLight,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isEnabled
              ? AppColors.primary
              : AppColors.primary.withOpacity(0.3),
        ),
      ),
    );
  }

  /// Builds a single page number button.
  Widget _itemChapter(int page) {
    final isActive = widget.activePage == page;

    return InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        if (!isActive) {
          widget.onPageChanged(page);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(width: 1, color: AppColors.primary),
          color: isActive ? AppColors.primary : AppColors.backgroundLight,
        ),
        child: Text(
          "$page",
          style: TextStyle(
            color: isActive ? AppColors.textOnPrimary : AppColors.primary,
            fontSize: 15,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  /// Builds the '...' ellipsis widget to indicate hidden pages.
  Widget _buildEllipsis() {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.0),
      child: Text(
        '...',
        style: TextStyle(
          color: AppColors.primary,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Builds the Go to Page input/button (retained the original implementation)
  Widget _buildGoToPage() {
    return InkWell(
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: _showGoToPageDialog,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: AppColors.primary,
        ),
        child: const Text(
          "GO TO PAGE",
          style: TextStyle(
            color: AppColors.textOnPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
