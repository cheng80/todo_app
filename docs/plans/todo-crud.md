# 작업 Plan: Todo CRUD

## 1. 기본 정보

- 관련 요구사항: REQ-001, REQ-002, REQ-003, REQ-004, REQ-005, REQ-006
- 브랜치: `codex/feature/todo-crud`
- Worktree: `/Users/cheng80/Desktop/todo_app-todo-crud`
- 작업 목표: iOS Flutter 앱에서 SQLite로 Todo를 생성·조회·수정·완료 전환·삭제하고, 앱 재실행 뒤에도 저장 상태를 유지한다.

## 2. 범위

### 포함

- `Todo` 모델과 `todos` SQLite 테이블(`id`, `title`, `content`, `is_completed`)을 만든다.
- `TodoRepository`에 목록 조회, 생성, 수정, 완료 전환, 삭제를 구현한다.
- 목록, 추가·수정 화면, 체크박스, 왼쪽 스와이프 삭제, 빈 목록·빈 제목·저장 또는 조회 실패 안내를 구현한다.
- `sqflite`와 `path`를 앱 의존성에, SQLite 저장소 테스트용 `sqflite_common_ffi`를 개발 의존성에 추가한다.
- 모델·저장소·화면 핵심 흐름을 테스트하고 iOS 시뮬레이터에서 추가 → 완료 처리 → 제목 수정 → 앱 재실행 → 삭제를 확인한다.

### 제외

- 검색, 카테고리, 마감일, 우선순위, 알림
- 로그인, 동기화, 공유, 별도 상태관리 패키지
- 삭제 취소, 정렬·필터, 데이터 마이그레이션 버전 2 이상

## 3. 완료 조건

- [x] 제목과 선택 본문을 저장하면 목록에 표시되고, 앱을 다시 열어도 남는다.
- [x] 체크박스로 완료 여부를 바꾸고, 항목을 열어 수정하며, 왼쪽 스와이프로 삭제할 수 있다.
- [x] 빈 제목은 저장되지 않고, 빈 목록과 저장·조회 실패는 사용자가 이해할 수 있는 안내를 표시한다.
- [x] 모델·저장소·화면 핵심 흐름 테스트, `flutter analyze`, `flutter build ios --simulator`, iOS 시뮬레이터 수동 검증을 통과한다.

## 4. 구현 순서

1. 최신 `main` 기준 Worktree에서 기존 카운터 화면과 기본 테스트를 확인하고, `sqflite`, `path`, `sqflite_common_ffi` 의존성을 추가한다.
2. `lib/features/todos/todo.dart`에 SQLite 행 변환을 포함한 불변 `Todo` 모델을 만들고, `test/features/todos/todo_test.dart`로 변환을 검증한다.
3. `lib/features/todos/todo_repository.dart`에 `todos.db`의 버전 1 스키마와 CRUD를 구현한다. 생성자에서 `DatabaseFactory`를 주입할 수 있게 하여 `sqflite_common_ffi` 인메모리 DB로 `test/features/todos/todo_repository_test.dart`의 CRUD를 검증한다.
4. `lib/features/todos/todo_list_page.dart`와 `lib/features/todos/todo_editor_page.dart`에 목록·추가·수정 UI를 만든다. 작업 성공 뒤 저장소에서 목록을 다시 조회하고, `test/features/todos/todo_list_page_test.dart`로 빈 목록·제목 검증·완료 전환·삭제 흐름을 검증한다.
5. `lib/main.dart`를 Todo 앱 진입점으로 바꾸고 기본 카운터 테스트를 Todo 화면 테스트로 교체한다.
6. `flutter test`, `flutter analyze`, `flutter build ios --simulator`를 실행하고 iPhone 17 Pro에서 추가 → 완료 처리 → 제목 수정 → 앱 재실행 → 삭제와 빈 제목·빈 목록·저장 실패 안내를 확인한다.
7. 변경 diff를 검토하고 이 Plan의 결과·검증·인수인계를 갱신한다. 커밋과 Pull Request는 별도 요청이 있을 때만 진행한다.

## 5. 검증

| 항목 | 명령어 또는 방법 | 결과 |
| --- | --- | --- |
| 테스트 | `flutter test` | 통과: 8개 테스트 |
| 시뮬레이터 통합 테스트 | `flutter test integration_test/todo_swipe_delete_test.dart -d 690514C8-D269-4B41-82C2-1DCBA643C8C6` | 통과: Todo 1건 생성 → 왼쪽 스와이프 삭제 → SQLite 재조회 후 빈 목록 |
| lint | `flutter analyze` | 통과: No issues found |
| typecheck | `flutter analyze` | 통과: Dart 정적 분석에 포함 |
| build | `flutter build ios --simulator` | 통과: `Runner.app` 생성 |
| 수동 검증 | iPhone 17 Pro에서 추가 → 완료 처리 → 제목 수정 → 앱 재실행 → 삭제, 빈 제목·빈 목록 확인 | 통과: 삭제 뒤 앱을 다시 실행해 빈 목록을 화면에서 확인 |

## 6. 리뷰와 마무리

- [x] 범위 밖 변경사항이 포함되지 않았다.
- [x] 기존 사용자 변경사항을 보존했다.
- [x] 검증하지 못한 항목이 없다.
- [x] 커밋 메시지는 한국어로 작성할 준비가 됐다.
- [x] Pull Request에는 변경 내용, 이유, 검증 결과, 제외 범위를 작성할 수 있다.

## 7. 작업 결과와 세션 인수인계

- 현재 상태: Todo CRUD 구현과 검증 완료. 커밋·Pull Request는 별도 요청이 있을 때만 진행한다.
- 변경 요약: SQLite 기반 Todo 모델·저장소·목록·편집 화면을 모듈로 나누고, 목록 항목은 `TodoListItem` 컴포넌트로 분리했다. Todo 기능 코드와 테스트의 역할 주석을 한글로 정리했다.
- 변경 파일: `pubspec.yaml`, `pubspec.lock`, `lib/main.dart`, `lib/features/todos/`, `test/`, `integration_test/todo_swipe_delete_test.dart`, `docs/plans/todo-crud.md`
- 검증 결과: 단위·위젯 테스트 8개, iOS 시뮬레이터 통합 테스트, 정적 분석, iOS 시뮬레이터 빌드가 모두 통과했다. iPhone 17 Pro에서 삭제 후 빈 목록을 확인했다.
- 다음 작업: 변경사항을 커밋하거나 Pull Request로 만들려면 사용자 요청을 기다린다.
- 남은 위험·결정 필요 사항: 삭제 취소와 데이터 마이그레이션 버전 2 이상은 Plan 범위에서 제외했다. 기존 `codex/todo-sqlite-crud` Worktree는 보존만 하고 사용하지 않았다.
