import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Task Manager",
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
      home: const Scaffold(
        body: TaskListWidget(),
      ),
    );
  }
}

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: TaskSchema(),
    );
  }
}

class TaskSchema extends StatefulWidget {


  const TaskSchema({
    super.key,
  });

  @override
  State<TaskSchema> createState() => _TaskSchemaState();
}

class _TaskSchemaState extends State<TaskSchema> {
  List<Task> tasks = [];

  void _addTask(String title, String description){
    setState(() {
      tasks.add(Task(title: title, description: description));
    });
  }

  void _delTask(int index){
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _toggleTask(int index){
    setState(() {
      tasks[index].isComplete = !tasks[index].isComplete;
    });
  }

  void _editTask(String title, String description, int index){
    setState(() {
      tasks[index].title = title;
      tasks[index].description = description;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder:(context,index) {
          final task = tasks[index];
          return Card(
            margin: const EdgeInsets.fromLTRB(15, 10, 15, 0),
            color: Theme.of(context).primaryColor,
            child: Row(
              children: [
                IconButton(
                  onPressed:(){
                    _toggleTask(index);
                    },
                  icon: Icon(
                    Icons.check_box,
                    color: task.isComplete == true? Colors.green: Colors.grey[300],
                  )
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        task.description,
                        style: const TextStyle(
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                IconButton(
                  color: Colors.grey[300],
                  onPressed: (){
                    _showEditTaskDialog(context, index);
                  },
                  hoverColor: Colors.blueGrey,
                  icon: const Icon(
                    Icons.edit,
                  )
                ),
                IconButton(
                  color: Colors.grey[300],
                  onPressed: (){
                    _delTask(index);
                  },
                  hoverColor: Colors.red,
                  icon: const Icon(
                    Icons.delete_forever,
                  )
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddTaskDialog(context);
          },
            child: const Text("+"),
        ),
    );
  }

  void _showEditTaskDialog(BuildContext context, int index){
    final _titleController = TextEditingController(text: tasks[index].title);
    final _descriptionController = TextEditingController(text: tasks[index].description);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit task ${index + 1}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _editTask(_titleController.text, _descriptionController.text, index);
                Navigator.of(context).pop();
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
  }
  void _showAddTaskDialog(BuildContext context) {
    final _titleController = TextEditingController();
    final _descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addTask(_titleController.text, _descriptionController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class Task{
  String title;
  String description;
  bool isComplete;

  Task({required this.title, required this.description, this.isComplete = false});
}