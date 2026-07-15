import 'package:flutter/material.dart';

import 'todo.dart';
import 'todo_editor_page.dart';
import 'todo_list_item.dart';
import 'todo_repository.dart';

/// SQLite Todo 목록을 조회하고 CRUD 동작을 화면에 연결하는 페이지입니다.
class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key, required this.repository});

  /// Todo 저장소와 목록 화면을 연결합니다.
  final TodoRepository repository;

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  /// 저장소에서 마지막으로 조회한 목록입니다.
  var _todos = const <Todo>[];

  /// 초기 조회와 새로 고침 중인 상태입니다.
  var _isLoading = true;

  /// 조회 실패 시 사용자에게 보여 줄 메시지입니다.
  String? _errorMessage;

  @override
  /// 첫 화면 표시 시 SQLite에서 Todo 목록을 읽습니다.
  void initState() {
    super.initState();
    _loadTodos();
  }

  /// 저장소 결과로 목록·로딩·오류 상태를 함께 갱신합니다.
  Future<void> _loadTodos() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final todos = await widget.repository.getTodos();
      if (mounted) {
        setState(() => _todos = todos);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage = 'Todo를 불러오지 못했습니다.');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// 추가 또는 수정 화면이 저장을 마치면 최신 목록을 다시 읽습니다.
  Future<void> _openEditor([Todo? todo]) async {
    final didSave = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            TodoEditorPage(repository: widget.repository, todo: todo),
      ),
    );
    if (didSave == true) {
      await _loadTodos();
    }
  }

  /// 체크박스 조작 결과를 저장한 뒤 목록을 새로 고칩니다.
  Future<void> _toggle(Todo todo, bool isCompleted) async {
    try {
      await widget.repository.setCompleted(todo, isCompleted);
      await _loadTodos();
    } catch (_) {
      _showError('Todo 상태를 변경하지 못했습니다.');
    }
  }

  /// 왼쪽 스와이프한 Todo를 삭제하고 실패 시 목록을 복구합니다.
  Future<void> _delete(Todo todo) async {
    try {
      await widget.repository.delete(todo.id!);
      await _loadTodos();
    } catch (_) {
      _showError('Todo를 삭제하지 못했습니다.');
      await _loadTodos();
    }
  }

  /// 저장소 오류를 화면 하단 메시지로 안내합니다.
  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Todo')),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _openEditor,
        tooltip: 'Todo 추가',
        child: const Icon(Icons.add),
      ),
    );
  }

  /// 로딩·오류·빈 목록·Todo 목록 중 현재 상태에 맞는 본문을 반환합니다.
  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 8),
            OutlinedButton(onPressed: _loadTodos, child: const Text('다시 시도')),
          ],
        ),
      );
    }
    if (_todos.isEmpty) {
      return const Center(child: Text('등록된 Todo가 없습니다.'));
    }
    return ListView.builder(
      itemCount: _todos.length,
      itemBuilder: (context, index) {
        final todo = _todos[index];
        return TodoListItem(
          todo: todo,
          onCompletionChanged: (isCompleted) => _toggle(todo, isCompleted),
          onTap: () => _openEditor(todo),
          onDismissed: () => _delete(todo),
        );
      },
    );
  }
}
