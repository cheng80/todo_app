// 앱 시작 시 Todo 목록 화면이 연결되는지 확인하는 위젯 테스트 모듈입니다.

import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:todo_app/main.dart';
import 'package:todo_app/features/todos/todo_repository.dart';

void main() {
  // 데스크톱 테스트에서 SQLite FFI를 한 번 초기화합니다.
  setUpAll(sqfliteFfiInit);

  testWidgets('Todo 앱은 목록 화면을 표시한다', (WidgetTester tester) async {
    final repository = TodoRepository(
      factory: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
    );
    addTearDown(repository.close);

    await tester.pumpWidget(TodoApp(repository: repository));

    expect(find.text('Todo'), findsOneWidget);
  });
}
