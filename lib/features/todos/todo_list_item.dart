import 'package:flutter/material.dart';

import 'todo.dart';

/// 목록의 Todo 한 건을 완료·수정·삭제할 수 있게 보여 주는 UI 컴포넌트입니다.
class TodoListItem extends StatelessWidget {
  const TodoListItem({
    super.key,
    required this.todo,
    required this.onCompletionChanged,
    required this.onTap,
    required this.onDismissed,
  });

  /// 화면에 표시할 Todo 데이터입니다.
  final Todo todo;

  /// 체크박스 변경을 목록 화면에 전달합니다.
  final ValueChanged<bool> onCompletionChanged;

  /// 항목 탭으로 수정 화면을 엽니다.
  final VoidCallback onTap;

  /// 왼쪽 스와이프가 끝나면 삭제를 요청합니다.
  final VoidCallback onDismissed;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(todo.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        color: Theme.of(context).colorScheme.error,
        padding: const EdgeInsets.only(right: 24),
        child: Icon(Icons.delete, color: Theme.of(context).colorScheme.onError),
      ),
      onDismissed: (_) => onDismissed(),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) => onCompletionChanged(value ?? false),
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: todo.content.isEmpty ? null : Text(todo.content),
        onTap: onTap,
      ),
    );
  }
}
