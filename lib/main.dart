import 'package:flutter/material.dart';

import 'features/todos/todo_list_page.dart';
import 'features/todos/todo_repository.dart';

/// 앱을 시작하고 기본 SQLite 저장소를 목록 화면에 제공합니다.
void main() {
  runApp(TodoApp(repository: TodoRepository()));
}

/// Todo 기능 모듈을 감싸는 앱 최상위 컴포넌트입니다.
class TodoApp extends StatelessWidget {
  const TodoApp({super.key, required this.repository});

  /// 모든 화면이 공유하는 Todo 저장소입니다.
  final TodoRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: TodoListPage(repository: repository),
    );
  }
}
