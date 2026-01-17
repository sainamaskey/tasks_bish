import 'package:flutter/material.dart';
import 'package:task1/features/task_manager.dart/data/model/task_model.dart';

class TaskTileWidget extends StatelessWidget {
  const TaskTileWidget({
    super.key,
    required this.task,
    required this.index,
    this.toggleTaskCompletion,
    this.deleteTask,
    this.editTask,
  });

  final Task task;
  final int index;
  final Function(int)? toggleTaskCompletion;
  final Function(int)? deleteTask;
  final Function(int)? editTask;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: IconButton(
          icon: Icon(
            task.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
            color: task.isCompleted ? Colors.green : null,
          ),
          onPressed: () => toggleTaskCompletion?.call(index),
        ),
        title: GestureDetector(
          onTap: () => editTask?.call(index),
          child: Text(
            task.title,
            style: TextStyle(
              decoration: task.isCompleted ? TextDecoration.lineThrough : null,
              color: task.isCompleted ? Colors.grey : null,
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, color: Colors.blue),
              onPressed: () => editTask?.call(index),
              tooltip: 'Edit task',
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => deleteTask?.call(index),
              tooltip: 'Delete task',
            ),
          ],
        ),
      ),
    );
  }
}
