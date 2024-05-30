import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/todo.dart';

class TodosHttpService {
  Future<List<Todo>> fetchTodos() async {
    Uri url = Uri.parse(
        "https://flutter-day-26-default-rtdb.firebaseio.com/todos.json");
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    List<Todo> loadedTodos = [];
    if (data != null) {
      data.forEach(
        (key, value) {
          value['id'] = key;
          loadedTodos.add(Todo.fromJson(value));
        },
      );
    }
    return loadedTodos;
  }

  Future<Todo> addTodo({
    required String title,
    required String date,
    required bool isDone,
  }) async {
    Uri url = Uri.parse(
        "https://flutter-day-26-default-rtdb.firebaseio.com/todos.json");

    Map<String, dynamic> todoData = {
      "title": title,
      "date": date,
      "isDone": isDone
    };

    final response = await http.post(url, body: jsonEncode(todoData));

    final data = jsonDecode(response.body);

    todoData['id'] = data['name'].toString();
    Todo newTodo = Todo.fromJson(todoData);
    return newTodo;
  }
}
