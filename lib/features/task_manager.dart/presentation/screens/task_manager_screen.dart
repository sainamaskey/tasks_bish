import 'dart:async';
import 'package:flutter/material.dart';
import 'package:task1/features/task_manager.dart/data/model/task_model.dart';
import 'package:task1/features/task_manager.dart/presentation/widgets/empty_task_widget.dart';
import 'package:task1/features/task_manager.dart/presentation/widgets/status_widget.dart';
import 'package:task1/features/task_manager.dart/presentation/widgets/task_tile_widget.dart';

class TaskManagerScreen extends StatefulWidget {
  const TaskManagerScreen({super.key});

  @override
  State<TaskManagerScreen> createState() => _TaskManagerScreenState();
}

class _TaskManagerScreenState extends State<TaskManagerScreen> {
  final ValueNotifier<List<Task>> _tasksNotifier = ValueNotifier([
    //default tasks
    Task(id: '1', title: 'Review PRs'),
    Task(id: '2', title: 'Fix Overflow'),
    Task(id: '3', title: 'Write Tests'),
  ]);

  final ValueNotifier<bool> _isLoadingNotifier = ValueNotifier(false);

  @override
  void dispose() {
    _tasksNotifier.dispose();
    _isLoadingNotifier.dispose();
    super.dispose();
  }

  void _toggleTaskCompletion(int index) {
    final updatedList = List<Task>.from(_tasksNotifier.value);
    updatedList[index] = updatedList[index].copyWith(
      isCompleted: !updatedList[index].isCompleted,
    );
    _tasksNotifier.value = updatedList;
  }

  void _deleteTask(int index) {
    _tasksNotifier.value = List.from(_tasksNotifier.value)..removeAt(index);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Task deleted successfully!')));
  }

  void _editTask(int index) {
    final task = _tasksNotifier.value[index];
    final textController = TextEditingController(text: task.title);

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        insetPadding: const EdgeInsets.all(40.0),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            spacing: 16,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Edit Task',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
              TextField(
                controller: textController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Task Name',
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    _updateTaskName(index, value.trim());
                    Navigator.of(context).pop();
                  }
                },
              ),
              ElevatedButton(
                onPressed: () {
                  final newTitle = textController.text.trim();
                  if (newTitle.isNotEmpty) {
                    _updateTaskName(index, newTitle);
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                child: const Text('Save', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _updateTaskName(int index, String newTitle) {
    final updatedList = List<Task>.from(_tasksNotifier.value);
    updatedList[index] = updatedList[index].copyWith(title: newTitle);
    _tasksNotifier.value = updatedList;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Task updated successfully!')));
  }

  Future<void> _addTask() async {
    if (_isLoadingNotifier.value) return;

    _isLoadingNotifier.value = true;

    try {
      final delay = 2;
      await Future.delayed(Duration(milliseconds: (delay * 1000).round()));

      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'New Task ${_tasksNotifier.value.length + 1}',
      );
      _tasksNotifier.value = [..._tasksNotifier.value, newTask];
      _isLoadingNotifier.value = false;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Task added successfully!')));
    } catch (e) {
      _isLoadingNotifier.value = false;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Task Manager', style: TextStyle(color: Colors.white)),
        ),
        backgroundColor: Colors.blue[900],
      ),
      body: SafeArea(
        child: Column(
          children: [
            ValueListenableBuilder<List<Task>>(
              valueListenable: _tasksNotifier,
              builder: (context, tasks, _) {
                final completedCount = tasks.where((t) => t.isCompleted).length;
                return Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StatusWidget(
                        icon: Icons.list_alt,
                        label: 'Total',
                        value: tasks.length.toString(),
                      ),
                      StatusWidget(
                        icon: Icons.pending_outlined,
                        label: 'Pending',
                        value: (tasks.length - completedCount).toString(),
                        color: Colors.orange,
                      ),
                      StatusWidget(
                        icon: Icons.check_circle,
                        label: 'Completed',
                        value: completedCount.toString(),
                        color: Colors.green,
                      ),
                    ],
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'Tasks',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  ValueListenableBuilder<bool>(
                    valueListenable: _isLoadingNotifier,
                    builder: (context, isLoading, _) {
                      return isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),

            Expanded(
              child: ValueListenableBuilder<List<Task>>(
                valueListenable: _tasksNotifier,
                builder: (context, tasks, _) {
                  if (tasks.isEmpty) return EmptyTaskWidget();
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) => TaskTileWidget(
                      task: tasks[index],
                      index: index,
                      toggleTaskCompletion: _toggleTaskCompletion,
                      deleteTask: _deleteTask,
                      editTask: _editTask,
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ValueListenableBuilder<bool>(
                valueListenable: _isLoadingNotifier,
                builder: (context, isLoading, _) {
                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: isLoading ? null : _addTask,
                      icon: isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.add),
                      label: Text(
                        isLoading ? 'Adding..' : 'Add Task',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: Colors.blue[900],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
