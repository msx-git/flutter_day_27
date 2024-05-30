import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_day_27/viewmodels/todos_viewmodel.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final todosViewmodel = TodosViewModel();

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
                              onPressed: () {},
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
          await todosViewmodel.addTodo(
            title: "title",
            date: "${DateTime.now()}",
            isDone: false,
          );
          setState(() {});
        },
        child: const Icon(CupertinoIcons.add),
      ),
    );
  }
}
