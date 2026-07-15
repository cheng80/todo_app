# 작업 Plan: Reference 자료 전체 추적

## 1. 기본 정보

- 관련 요구사항: 해당 없음
- 브랜치: `codex/chore/track-reference-assets`
- Worktree: `/Users/cheng80/Desktop/todo_app-reference-assets`
- 작업 목표: `reference/`의 게임 확장 템플릿까지 Git으로 추적한다.

## 2. 범위

### 포함

- `reference/간소화-프로젝트-기획-템플릿/extensions/game/`의 템플릿 2개를 추가한다.
- 현재 Git에서 추적하는 `reference/` 파일 목록을 확인한다.

### 제외

- macOS 메타데이터 파일 `.DS_Store`
- Todo 앱 기능 및 의존성 변경

## 3. 완료 조건

- [x] 게임 확장 안내와 기획 템플릿이 `reference/`에 포함된다.
- [x] `.DS_Store`는 추적하지 않는다.
- [x] Flutter 테스트와 정적 분석을 통과한다.

## 4. 구현 순서

1. 원본 `reference/`와 원격 기본 브랜치의 추적 목록을 비교한다.
2. 빠진 게임 확장 템플릿 2개를 추가한다.
3. 추적 목록과 변경 범위를 검토한다.
4. Flutter 테스트와 정적 분석을 실행한다.
5. 변경사항을 리뷰한다.

## 5. 검증

| 항목 | 명령어 또는 방법 | 결과 |
| --- | --- | --- |
| 테스트 | `flutter test` | 통과 |
| lint | `flutter analyze` | 통과 |
| typecheck | 해당 없음 (Dart 정적 분석에 포함) | 통과 |
| build | 해당 없음 (문서 변경) | 미실행 |
| 수동 검증 | 원본 파일 2개와 `cmp` 비교, `.DS_Store` ignore 규칙 확인 | 통과 |

## 6. 리뷰와 마무리

- [x] 범위 밖 변경사항이 포함되지 않았다.
- [x] 기존 사용자 변경사항을 보존했다.
- [x] 검증하지 못한 항목을 기록했다.
- [x] 커밋 메시지는 한국어로 작성할 준비가 됐다.
- [x] Pull Request에는 변경 내용, 이유, 검증 결과, 제외 범위를 작성할 수 있다.

## 7. 작업 결과와 세션 인수인계

- 현재 상태: 독립 검토 완료, Pull Request 생성 대기
- 변경 요약: 누락된 게임 확장 템플릿 2개를 추적 대상으로 추가했다.
- 변경 파일: `docs/plans/reference-assets.md`, `reference/간소화-프로젝트-기획-템플릿/extensions/game/README.md`, `reference/간소화-프로젝트-기획-템플릿/extensions/game/게임-기획-확장.md`
- 검증 결과: `flutter test`, `flutter analyze`, 원본 파일 `cmp`, `.DS_Store` ignore 규칙 확인 통과
- 다음 작업: Pull Request를 생성한다.
- 남은 위험·결정 필요 사항: 없음
