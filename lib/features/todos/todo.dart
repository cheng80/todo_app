/// SQLite에 저장되는 Todo 한 건을 표현하는 불변 데이터 모델입니다.
class Todo {
  const Todo({
    this.id,
    required this.title,
    this.content = '',
    this.isCompleted = false,
  });

  /// SQLite가 생성한 식별자이며, 저장 전에는 비어 있을 수 있습니다.
  final int? id;

  /// 사용자가 반드시 입력해야 하는 Todo 제목입니다.
  final String title;

  /// 사용자가 선택적으로 입력하는 본문입니다.
  final String content;

  /// 완료 여부를 나타내는 상태값입니다.
  final bool isCompleted;

  /// 일부 값만 바꾼 새 Todo를 만들어 화면 상태를 안전하게 갱신합니다.
  Todo copyWith({int? id, String? title, String? content, bool? isCompleted}) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  /// 모델을 SQLite의 열 이름과 값으로 변환합니다.
  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'is_completed': isCompleted ? 1 : 0,
    };
  }

  /// SQLite 조회 결과를 Todo 모델로 복원합니다.
  factory Todo.fromMap(Map<String, Object?> map) {
    return Todo(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String? ?? '',
      isCompleted: (map['is_completed'] as int) == 1,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Todo &&
        other.id == id &&
        other.title == title &&
        other.content == content &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode => Object.hash(id, title, content, isCompleted);
}
