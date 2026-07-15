import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_app/features/todos/todo_repository.dart';

// 실제 인메모리 SQLite에서 Todo CRUD를 검증하는 저장소 테스트 모듈입니다.
void main() {
  // 모바일 플러그인 대신 테스트용 SQLite FFI를 초기화합니다.
  setUpAll(sqfliteFfiInit);

  test('TodoRepository는 Todo를 생성·조회·수정·완료 전환·삭제한다', () async {
    final repository = TodoRepository(
      factory: databaseFactoryFfi,
      databasePath: inMemoryDatabasePath,
    );
    addTearDown(repository.close);

    final created = await repository.create(title: '우유 사기', content: '저지방 우유');
    expect((await repository.getTodos()).single, created);

    final updated = created.copyWith(title: '우유와 빵 사기');
    await repository.update(updated);
    expect((await repository.getTodos()).single.title, '우유와 빵 사기');

    await repository.setCompleted(updated, true);
    expect((await repository.getTodos()).single.isCompleted, isTrue);

    await repository.delete(updated.id!);
    expect(await repository.getTodos(), isEmpty);
  });
}
