import 'package:flutter/material.dart';
import 'package:nettruyen/core/constants/colors.dart';

class IndexPage extends StatelessWidget {
  const IndexPage({
    super.key,
    required this.totalPages,
    required this.currentPage,
    required this.onValue,
  });

  final int totalPages;
  final int currentPage;
  final void Function(int index) onValue;

  @override
  Widget build(BuildContext context) {
    final safeTotal = totalPages <= 0 ? 1 : totalPages;
    final safeCurrent = currentPage.clamp(1, safeTotal);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      child: Row(
        children: [
          const SizedBox(width: 10),
          // Prev
          Visibility(
            visible: safeCurrent > 1,
            child: InkWell(
              onTap: () => onValue(safeCurrent - 1),
              child: Container(
                width: 30,
                height: 30,
                margin: const EdgeInsets.all(1),
                alignment: Alignment.center,
                child: const Icon(Icons.arrow_back_ios),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Pages 1..N
          Expanded(
            child: SizedBox(
              height: 32,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: safeTotal,
                itemBuilder: (context, i) {
                  final page = i + 1;
                  final isActive = page == safeCurrent;
                  return InkWell(
                    onTap: () => onValue(page),
                    child: Container(
                      width: 30,
                      margin: const EdgeInsets.all(1),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isActive
                            ? AppColors.primary
                            : AppColors.textOnPrimary,
                        border: Border.all(width: 1, color: AppColors.primary),
                      ),
                      child: Text(
                        '$page',
                        style: TextStyle(
                          fontSize: 15,
                          color: isActive ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Next
          InkWell(
            onTap: () => onValue(
                safeCurrent + 1 > safeTotal ? safeTotal : safeCurrent + 1),
            child: Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.all(1),
              alignment: Alignment.center,
              child: const Icon(Icons.arrow_forward_ios),
            ),
          ),
        ],
      ),
    );
  }
}
