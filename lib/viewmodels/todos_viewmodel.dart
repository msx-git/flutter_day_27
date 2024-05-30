import 'package:flutter_day_27/repositories/todos_repository.dart';

import '../models/todo.dart';

class TodosViewModel {
  final todosRepository = TodosRepository();

  List<Todo> _list = [];

  Future<List<Todo>> get todos async {
    _list = await todosRepository.getProducts();
    return [..._list];
  }

  Future<void> addTodo({
    required String title,
    required String date,
    required bool isDone,
  }) async {
    final newTodo =
        await todosRepository.addTodo(title: title, date: date, isDone: isDone);
    _list.add(newTodo);
  }
}
