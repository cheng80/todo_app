import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

import 'todo.dart';

/// Todo 테이블 생성과 SQLite CRUD를 담당하는 저장소 모듈입니다.
class TodoRepository {
  TodoRepository({DatabaseFactory? factory, this.databasePath})
    : _factory = factory ?? databaseFactory;

  /// 실행 환경별 데이터베이스를 만들며 테스트에서는 인메모리 팩토리를 받습니다.
  final DatabaseFactory _factory;

  /// 테스트용 경로가 없으면 iOS 기본 데이터베이스 경로를 사용합니다.
  final String? databasePath;

  /// 앱 수명 동안 재사용할 데이터베이스 연결입니다.
  Database? _database;

  /// 저장된 Todo를 생성 순서로 조회합니다.
  Future<List<Todo>> getTodos() async {
    final rows = await (await _getDatabase()).query('todos', orderBy: 'id ASC');
    return rows.map(Todo.fromMap).toList();
  }

  /// 제목과 선택 본문으로 Todo를 생성하고 생성된 식별자를 반환합니다.
  Future<Todo> create({required String title, String content = ''}) async {
    final todo = Todo(title: title, content: content);
    final id = await (await _getDatabase()).insert('todos', _withoutId(todo));
    return todo.copyWith(id: id);
  }

  /// 이미 저장된 Todo의 제목·본문·완료 상태를 갱신합니다.
  Future<void> update(Todo todo) async {
    final id = todo.id;
    if (id == null) {
      throw ArgumentError.value(todo, 'todo', '저장된 Todo만 수정할 수 있습니다.');
    }

    await (await _getDatabase()).update(
      'todos',
      _withoutId(todo),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 체크박스 변경에 맞춰 완료 상태만 갱신합니다.
  Future<void> setCompleted(Todo todo, bool isCompleted) {
    return update(todo.copyWith(isCompleted: isCompleted));
  }

  /// 지정한 Todo를 SQLite와 목록에서 제거합니다.
  Future<void> delete(int id) async {
    await (await _getDatabase()).delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 테스트가 끝난 뒤 열려 있는 데이터베이스 연결을 닫습니다.
  Future<void> close() async {
    final database = _database;
    _database = null;
    if (database != null) {
      await database.close();
    }
  }

  /// 연결이 없을 때만 데이터베이스를 열어 재사용합니다.
  Future<Database> _getDatabase() async {
    return _database ??= await _openDatabase();
  }

  /// 버전 1의 todos 테이블을 만들고 로컬 데이터베이스를 엽니다.
  Future<Database> _openDatabase() async {
    final pathToDatabase =
        databasePath ?? path.join(await getDatabasesPath(), 'todos.db');
    return _factory.openDatabase(
      pathToDatabase,
      options: OpenDatabaseOptions(
        version: 1,
        onCreate: (database, version) async {
          await database.execute('''
            CREATE TABLE todos(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              title TEXT NOT NULL,
              content TEXT NOT NULL,
              is_completed INTEGER NOT NULL
            )
          ''');
        },
      ),
    );
  }

  /// 자동 증가 식별자는 제외하고 삽입·수정용 SQLite 행을 만듭니다.
  Map<String, Object?> _withoutId(Todo todo) {
    final values = todo.toMap();
    values.remove('id');
    return values;
  }
}
