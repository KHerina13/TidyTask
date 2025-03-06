import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tidy_task/Provider/task_provider.dart';
import 'package:tidy_task/Provider/theme_provider.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tidy Task"),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
            icon: Icon(Icons.brightness_6),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                        hintText: "Enter Task...",
                        border: OutlineInputBorder()),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      Provider.of<TaskProvider>(context, listen: false)
                          .addTask(_controller.text);
                      _controller.clear();
                    }
                  },
                  child: Text("Add"),
                )
              ],
            ),
          ),
          Expanded(child:
              Consumer<TaskProvider>(builder: (context, taskProvider, child) {
            return ListView.builder(
                itemCount: taskProvider.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskProvider.tasks[index];
                  return ListTile(
                      title: Text(
                        task.title,
                        style: TextStyle(
                            decoration: task.isComplete
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            // color: Theme.of(context).textTheme.bodyLarge!.color
                        ),
                      ),
                      leading: Checkbox(
                        value: task.isComplete,
                        onChanged: (_) {
                          taskProvider.toggleTask(index);
                        },
                      ),
                      trailing: IconButton(
                          onPressed: () {
                            final deletedTask = task;
                            final index = taskProvider.tasks.indexOf(task);
                            taskProvider.deleteTask(index);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Task deleted."),
                              action: SnackBarAction(
                                  label: 'Undo',
                                  onPressed: () {
                                    taskProvider.insertTask(index, deletedTask);
                                  }),
                            ));
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Theme.of(context).colorScheme.error,
                          )),
                    );
                });
          }))
        ],
      ),
    );
  }
}
