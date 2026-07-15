# 프로젝트 작업 지침

## 프로젝트 개요

- 프로젝트 목적: iOS에서 로컬 SQLite로 Todo를 관리하는 Flutter 앱을 만든다.
- 주요 기술: Flutter 3.44, Dart 3.12, SQLite(`sqflite` 예정), iOS 시뮬레이터
- 주요 디렉터리: `lib/`, `test/`, `ios/`, `docs/`, `reference/`(읽기 전용)

## 실행 및 검증

- 개발 실행: `flutter run -d <iOS Simulator Device ID>` (`flutter devices`로 ID 확인)
- 테스트: `flutter test`
- lint와 typecheck: `flutter analyze`
- build: `flutter build ios --simulator`
- 수동 검증: iOS 시뮬레이터에서 Todo 추가 → 완료 처리 → 제목 수정 → 앱 재실행 → 삭제

## 작업 방식

- 작업 전 기존 코드, 문서, 현재 변경사항을 먼저 확인한다.
- 작업은 `기획서 확인 → Plan 작성 → 범위 확정 → 구현 → 테스트·검증 → 코드 리뷰 → 커밋 → Pull Request` 순서로 진행한다.
- 기능 하나를 하나의 작업 단위, Worktree, feature 브랜치, Pull Request로 관리한다.
- 기본 checkout은 `main` 확인·병합·정리에만 사용하고, 구현은 독립 Worktree에서 진행한다.
- `main` 브랜치에 직접 작업하거나 직접 push하지 않는다.
- `reference/`는 읽기 전용이며 수정하지 않는다.
- 기존 패턴과 도구를 재사용하고, 가장 작고 단순한 변경을 선택한다.
- 사용자 변경사항을 덮어쓰거나 되돌리지 않는다.
- 범위를 벗어난 변경, 원격 저장소 변경, Pull Request 생성, Merge는 명시적인 요청 없이 실행하지 않는다.

## 커밋 및 Pull Request

- 커밋 메시지와 Pull Request 제목·본문은 한국어로 작성한다.
- 코드 식별자, 파일 경로, 명령어처럼 번역하면 안 되는 항목만 원문을 유지한다.
- 커밋은 하나의 목적을 가진 논리적인 변경 단위로 작성한다.
- Pull Request에는 변경 내용, 변경 이유, 검증 결과, 제외 범위를 작성한다.
- 실행하지 않은 검증을 통과했다고 작성하지 않는다.

## 완료 조건

- [ ] Plan의 범위와 완료 조건을 충족했다.
- [ ] 관련 테스트를 실행했다.
- [ ] lint, typecheck, build를 실행했거나 해당 없음을 확인했다.
- [ ] 필요한 수동 검증을 실행했다.
- [ ] 변경사항을 리뷰했다.
- [ ] 검증하지 못한 항목을 명확히 기록했다.
