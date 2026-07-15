import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_app/features/todos/todo_list_page.dart';
import 'package:todo_app/features/todos/todo.dart';
import 'package:todo_app/features/todos/todo_repository.dart';

// 화면 동작만 독립적으로 확인하기 위한 메모리 기반 테스트 저장소입니다.
class FakeTodoRepository extends TodoRepository {
  FakeTodoRepository() : super(factory: databaseFactoryFfi);

  final _todos = <Todo>[];
  var _nextId = 1;

  @override
  Future<Todo> create({required String title, String content = ''}) async {
    final todo = Todo(id: _nextId++, title: title, content: content);
    _todos.add(todo);
    return todo;
  }

  @override
  Future<void> delete(int id) async {
    _todos.removeWhere((todo) => todo.id == id);
  }

  @override
  Future<List<Todo>> getTodos() async => List.of(_todos);

  @override
  Future<void> setCompleted(Todo todo, bool isCompleted) {
    return update(todo.copyWith(isCompleted: isCompleted));
  }

  @override
  Future<void> update(Todo todo) async {
    final index = _todos.indexWhere((item) => item.id == todo.id);
    _todos[index] = todo;
  }
}

// 목록 조회 실패 시 사용자 안내를 검증하기 위한 저장소입니다.
class FetchFailingTodoRepository extends TodoRepository {
  FetchFailingTodoRepository() : super(factory: databaseFactoryFfi);

  @override
  Future<List<Todo>> getTodos() async {
    throw StateError('조회 실패');
  }
}

// 저장 실패 시 사용자 안내를 검증하기 위한 저장소입니다.
class CreateFailingTodoRepository extends FakeTodoRepository {
  @override
  Future<Todo> create({required String title, String content = ''}) async {
    throw StateError('저장 실패');
  }
}

void main() {
  late FakeTodoRepository repository;

  // 각 테스트가 서로 다른 Todo 목록을 사용하도록 저장소를 새로 만듭니다.
  setUp(() {
    repository = FakeTodoRepository();
  });

  // 목록 화면을 앱 루트로 제공하는 공통 테스트 컴포넌트입니다.
  Widget buildApp([TodoRepository? todoRepository]) {
    return MaterialApp(
      home: TodoListPage(repository: todoRepository ?? repository),
    );
  }

  // 비동기 화면 전환이 실제 조건을 만족할 때까지 프레임을 진행합니다.
  Future<void> pumpUntil(
    WidgetTester tester,
    bool Function() condition,
    String description,
  ) async {
    for (var attempt = 0; attempt < 50; attempt++) {
      if (condition()) {
        return;
      }
      await tester.pump(const Duration(milliseconds: 100));
    }
    fail('$description 상태를 기다리는 동안 시간이 초과되었습니다.');
  }

  testWidgets('빈 목록 안내를 표시한다', (tester) async {
    await tester.pumpWidget(buildApp());
    await pumpUntil(
      tester,
      () => find.text('등록된 Todo가 없습니다.').evaluate().isNotEmpty,
      '빈 목록',
    );

    expect(find.text('등록된 Todo가 없습니다.'), findsOneWidget);
  });

  testWidgets('빈 제목은 저장하지 않는다', (tester) async {
    await tester.pumpWidget(buildApp());
    await pumpUntil(
      tester,
      () => find.text('등록된 Todo가 없습니다.').evaluate().isNotEmpty,
      '빈 목록',
    );

    await tester.tap(find.byIcon(Icons.add));
    await pumpUntil(
      tester,
      () => find.text('Todo 추가').evaluate().isNotEmpty,
      'Todo 추가 화면',
    );
    await tester.tap(find.text('저장'));
    await tester.pump();

    expect(find.text('제목을 입력해 주세요.'), findsOneWidget);
    expect(await repository.getTodos(), isEmpty);
  });

  testWidgets('조회 실패 안내를 표시한다', (tester) async {
    await tester.pumpWidget(buildApp(FetchFailingTodoRepository()));
    await pumpUntil(
      tester,
      () => find.text('Todo를 불러오지 못했습니다.').evaluate().isNotEmpty,
      '조회 실패 안내',
    );

    expect(find.text('다시 시도'), findsOneWidget);
  });

  testWidgets('저장 실패 안내를 표시한다', (tester) async {
    await tester.pumpWidget(buildApp(CreateFailingTodoRepository()));
    await pumpUntil(
      tester,
      () => find.text('등록된 Todo가 없습니다.').evaluate().isNotEmpty,
      '빈 목록',
    );
    await tester.tap(find.byIcon(Icons.add));
    await pumpUntil(
      tester,
      () => find.text('Todo 추가').evaluate().isNotEmpty,
      'Todo 추가 화면',
    );
    await tester.enterText(find.byKey(const Key('todoTitle')), '저장 실패 검증');
    await tester.tap(find.text('저장'));
    await pumpUntil(
      tester,
      () => find.text('Todo를 저장하지 못했습니다.').evaluate().isNotEmpty,
      '저장 실패 안내',
    );

    expect(find.text('Todo 추가'), findsOneWidget);
  });

  testWidgets('Todo를 생성하고 완료 처리한 뒤 스와이프로 삭제한다', (tester) async {
    await tester.pumpWidget(buildApp());
    await pumpUntil(
      tester,
      () => find.text('등록된 Todo가 없습니다.').evaluate().isNotEmpty,
      '빈 목록',
    );

    await tester.tap(find.byIcon(Icons.add));
    await pumpUntil(
      tester,
      () => find.text('Todo 추가').evaluate().isNotEmpty,
      'Todo 추가 화면',
    );
    await tester.enterText(find.byKey(const Key('todoTitle')), '물 마시기');
    await tester.tap(find.text('저장'));
    await pumpUntil(
      tester,
      () =>
          find.byKey(const Key('todoTitle')).evaluate().isEmpty &&
          find.byType(Checkbox).evaluate().isNotEmpty,
      '생성된 Todo',
    );

    expect((await repository.getTodos()).single.title, '물 마시기');

    await tester.tap(find.byType(Checkbox));
    await pumpUntil(
      tester,
      () => tester.widget<Checkbox>(find.byType(Checkbox)).value == true,
      '완료 상태',
    );
    expect((await repository.getTodos()).single.isCompleted, isTrue);

    await tester.drag(find.byType(ListTile), const Offset(-500, 0));
    await pumpUntil(
      tester,
      () => find.text('등록된 Todo가 없습니다.').evaluate().isNotEmpty,
      '삭제된 Todo 목록',
    );
    expect(await repository.getTodos(), isEmpty);
  });
}
