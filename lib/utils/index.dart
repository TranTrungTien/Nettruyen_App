import 'package:flutter/material.dart';

class RoutesName {
  static const String kSearch = '/search';
}

void showSearchInputDialog({
  required BuildContext context,
}) {
  final TextEditingController controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext dialogContext) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Tìm kiếm truyện',
                style: TextStyle(fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: Form(
                key: formKey,
                child: TextFormField(
                  controller: controller,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Nhập tên truyện, tác giả...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.grey[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide:
                          const BorderSide(color: Colors.blue, width: 2),
                    ),
                  ),
                  validator: (value) => value?.trim().isEmpty ?? true
                      ? 'Vui lòng nhập từ khóa'
                      : null,
                  onFieldSubmitted: (_) => _submitSearch(
                    mainContext: context,
                    dialogContext: dialogContext,
                    formKey: formKey,
                    controller: controller,
                    setState: setState,
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () => _submitSearch(
                  mainContext: context,
                  dialogContext: dialogContext,
                  formKey: formKey,
                  controller: controller,
                  setState: setState,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Tìm', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      );
    },
  );
}

void _submitSearch({
  required BuildContext mainContext,
  required BuildContext dialogContext,
  required GlobalKey<FormState> formKey,
  required TextEditingController controller,
  required StateSetter setState,
}) {
  if (!formKey.currentState!.validate()) return;

  final query = controller.text.trim();
  if (query.isEmpty) return;

  Navigator.pop(dialogContext);

  final currentRoute = ModalRoute.of(mainContext)?.settings.name;

  if (currentRoute == '/search') {
    Navigator.pushReplacementNamed(
      mainContext,
      '/search',
      arguments: query,
    );
  } else {
    Navigator.pushNamed(
      mainContext,
      '/search',
      arguments: query,
    );
  }
}
