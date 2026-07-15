import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:todo_app/main.dart' as app;

void main() {
  // 실제 iOS 시뮬레이터에서 스와이프 삭제가 SQLite에 반영되는지 확인합니다.
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // 플랫폼 SQLite 작업이 끝나 실제 화면이 갱신될 때까지 프레임을 진행합니다.
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

  testWidgets('Todo를 왼쪽으로 밀면 목록과 SQLite에서 삭제된다', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    await pumpUntil(
      tester,
      () => find.text('등록된 Todo가 없습니다.').evaluate().isNotEmpty,
      '빈 Todo 목록',
    );
    await tester.tap(find.byIcon(Icons.add));
    await pumpUntil(
      tester,
      () => find.text('Todo 추가').evaluate().isNotEmpty,
      'Todo 추가 화면',
    );
    await tester.enterText(find.byKey(const Key('todoTitle')), '스와이프 삭제 검증');
    await tester.tap(find.text('저장'));
    await pumpUntil(
      tester,
      () => find.byType(ListTile).evaluate().length == 1,
      '생성된 Todo 한 건',
    );
    expect(find.byType(ListTile), findsOneWidget);

    await tester.drag(find.byType(ListTile), const Offset(-500, 0));
    await pumpUntil(
      tester,
      () => find.text('등록된 Todo가 없습니다.').evaluate().isNotEmpty,
      '삭제된 Todo 목록',
    );

    expect(find.text('등록된 Todo가 없습니다.'), findsOneWidget);
  });
}
