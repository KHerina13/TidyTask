import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Model/task.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  TaskProvider() {
    _loadTasks();
  }

  void addTask(String title) {
    _tasks.add(Task(title: title));
    _saveTask();
    notifyListeners();
  }

  void toggleTask(int index) {
    _tasks[index].isComplete = !_tasks[index].isComplete;
    _saveTask();
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    _saveTask();
    notifyListeners();
  }

  void _saveTask() async {
    final pref = await SharedPreferences.getInstance();
    pref.setString(
        'tasks',
        jsonEncode(_tasks
            .map((task) => {'title': task.title, 'isComplete': task.isComplete})
            .toList()));
  }

  void _loadTasks() async {
    final pref = await SharedPreferences.getInstance();
    String? taskString = pref.getString('tasks');
    if (taskString != null) {
      List<dynamic> jsonData = jsonDecode(taskString);
      _tasks = jsonData
          .map((task) =>
              Task(title: task['title'], isComplete: task['isComplete']))
          .toList();
      notifyListeners();
    }
  }
  void insertTask(int index,Task task){
    _tasks.insert(index, task);
    _saveTask();
    notifyListeners();
  }
}
