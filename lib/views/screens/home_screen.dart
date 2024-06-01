import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_day_27/viewmodels/todos_viewmodel.dart';
import 'package:intl/intl.dart';

import '../../models/todo.dart';
import '../widgets/manage_todo_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final todosViewmodel = TodosViewModel();

  void deleteTodo(Todo todo) async {
    final response = await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Deleting todo"),
          content: Text("You are deleting [ ${todo.title} ] todo!"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancel"),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent.withOpacity(0.7),
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Yes, delete it."),
            ),
          ],
        );
      },
    );

    if (response) {
      await todosViewmodel.deleteTodo(todo.id);
      setState(() {});
    }
  }

  void addTodo() async {
    final data = await showDialog(
      context: context,
      builder: (ctx) {
        return const ManageTodoDialog();
      },
    );
    if (data != null) {
      try {
        todosViewmodel.addTodo(
          title: data['title'],
          date: data['date'],
          isDone: data['isDone'],
        );
        setState(() {});
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: todosViewmodel.todos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text("Couldn't get todos."),
            );
          }
          final todos = snapshot.data;
          return todos == null || todos.isEmpty
              ? const Text("There are no todos")
              : ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (context, index) {
                    final todo = todos[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.black26)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 16),
                        title: Text(todo.title),
                        subtitle: Text(
                            "${DateFormat('dd-MMMM, yyyy').format(DateTime.parse(todo.date))}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.edit,
                                color: Colors.deepPurple,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                deleteTodo(todo);
                              },
                              icon: const Icon(
                                CupertinoIcons.delete_simple,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // await todosViewmodel.addTodo(
          //   title: "New Todo",
          //   date: "${DateTime.now()}",
          //   isDone: false,
          // );
          // setState(() {});
           addTodo();
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
