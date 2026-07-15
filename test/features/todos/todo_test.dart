import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/features/todos/todo.dart';

// Todo 모델과 SQLite 행 변환 규칙을 검증하는 단위 테스트 모듈입니다.
void main() {
  test('Todo는 SQLite 행으로 변환한 뒤 다시 복원된다', () {
    const todo = Todo(
      id: 7,
      title: '우유 사기',
      content: '저지방 우유',
      isCompleted: true,
    );

    expect(Todo.fromMap(todo.toMap()), todo);
  });
}
