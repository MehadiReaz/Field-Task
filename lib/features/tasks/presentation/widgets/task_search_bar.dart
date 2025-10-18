import 'package:flutter/material.dart';

class TaskSearchBar extends StatefulWidget {
  final Function(String) onSearch;
  final String hintText;

  const TaskSearchBar({
    super.key,
    required this.onSearch,
    this.hintText = 'Search tasks...',
  });

  @override
  State<TaskSearchBar> createState() => _TaskSearchBarState();
}

class _TaskSearchBarState extends State<TaskSearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            color: Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              onChanged: widget.onSearch,
            ),
          ),
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(
                Icons.clear,
                color: Colors.grey,
                size: 20,
              ),
              onPressed: () {
                _controller.clear();
                widget.onSearch('');
              },
            ),
        ],
      ),
    );
  }
}
