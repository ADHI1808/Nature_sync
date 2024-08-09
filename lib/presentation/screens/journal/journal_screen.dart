import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Import Hive

import '../../../data/models/themes_model.dart';
import '../../../data/providers/theme_provider.dart';
import '../../../logic/localization/localization_handler.dart';
import '../../../logic/setting_logic/setting_handler.dart';
import '../../widgets/buttons/appbar_leading_button.dart';

final scoreProvider = StateProvider<int>((ref) {
  final box = Hive.box('scoreBox');
  return box.get('score', defaultValue: 0);
}); // Provider for score
final tasksProvider = StateProvider<List<Map<String, dynamic>>>((ref) => []); // Provider for tasks

class JournalScreen extends HookConsumerWidget {
  const JournalScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Themes theme = ref.watch(themesProvider);
    SettingsHandler settingsHandler = SettingsHandler();
    LocalizationHandler localizationHandler = LocalizationHandler();

    TextEditingController journalController = useTextEditingController();
    int score = ref.watch(scoreProvider);
    List<Map<String, dynamic>> tasks = ref.watch(tasksProvider);

    final scoreBox = Hive.box('scoreBox');

    // Function to handle task creation
    void _createTask() {
      if (journalController.text.isNotEmpty) {
        // Add task to the list with a checkbox status
        ref.read(tasksProvider.notifier).state = [
          ...tasks,
          {'task': journalController.text, 'completed': false}
        ];
        // Clear the text field
        journalController.clear();
      }
    }

    // Function to handle task completion toggle
    void _toggleTaskCompletion(int index) {
      final updatedTasks = List<Map<String, dynamic>>.from(tasks);
      final taskCompleted = updatedTasks[index]['completed'];

      if (!taskCompleted) {
        // Update the task as completed and increment the score
        updatedTasks[index]['completed'] = true;
        scoreBox.put('score', scoreBox.get('score', defaultValue: 0) + 5);
      } else {
        // Update the task as incomplete and decrement the score
        updatedTasks[index]['completed'] = false;
        scoreBox.put('score', scoreBox.get('score', defaultValue: 0) - 5);
      }

      // Update the task list with the modified status
      ref.read(tasksProvider.notifier).state = updatedTasks;
      ref.read(scoreProvider.notifier).state = scoreBox.get('score', defaultValue: 0);
    }

    // Function to handle task deletion
    void _deleteTask(int index) {
      final updatedTasks = List<Map<String, dynamic>>.from(tasks);
      final taskCompleted = updatedTasks[index]['completed'];

      // Adjust score based on task completion status before deleting
      if (taskCompleted) {
        scoreBox.put('score', scoreBox.get('score', defaultValue: 0) - 5);
      }

      updatedTasks.removeAt(index);
      ref.read(tasksProvider.notifier).state = updatedTasks;
      ref.read(scoreProvider.notifier).state = scoreBox.get('score', defaultValue: 0);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: LeadingButton(
          iconColor: Colors.white, // Set the color to the previous green
          backgroundColor: Colors.green,
        ),
        title: Text(
          localizationHandler.getMessage(ref, "journal").toUpperCase(),
          style: GoogleFonts.rubik(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
        elevation: 4.0,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      'Current Score: $score',
                      style: GoogleFonts.openSans(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Enter your tasks below',
                    style: GoogleFonts.openSans(
                      color: Colors.black,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: journalController,
                    decoration: InputDecoration(
                      labelText: 'Task Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _createTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.yellow[700],
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    child: Text(
                      'Create Task',
                      style: GoogleFonts.openSans(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Display tasks in a ListView
                  SizedBox(
                    height: 400, // Adjust height as needed
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: task['completed']
                                  ? [Colors.green[400]!, Colors.green[300]!]
                                  : [Colors.red[400]!, Colors.red[300]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 8,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Checkbox(
                                value: task['completed'],
                                onChanged: (bool? value) {
                                  if (value != null) {
                                    _toggleTaskCompletion(index);
                                  }
                                },
                              ),
                              Expanded(
                                child: Text(
                                  task['task'],
                                  style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    decoration: task['completed']
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.white),
                                onPressed: () => _deleteTask(index),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
