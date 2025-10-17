import 'package:flutter/material.dart';

class TaskFormPage extends StatelessWidget {
  final String? taskId;

  const TaskFormPage({super.key, this.taskId});

  @override
  Widget build(BuildContext context) {
    final isEditing = taskId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Task' : 'Create Task'),
      ),
      body: Center(
        child: Text(isEditing
            ? 'Edit Task Form - Coming Soon'
            : 'Create Task Form - Coming Soon'),
      ),
    );
  }
}
