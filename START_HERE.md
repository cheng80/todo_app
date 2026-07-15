# 새 세션 시작 안내

새 Codex session은 다음 순서로 확인한다.

1. 루트 `AGENTS.md`를 읽는다.
2. `reference/`의 워크플로우 지침서와 필요한 템플릿을 읽는다. `reference/`는 수정하지 않는다.
3. `docs/product/기획서.md`에서 전체 목표와 현재 범위를 확인한다.
4. 현재 기능의 `docs/plans/기능명.md`를 읽고, `작업 결과와 세션 인수인계`를 확인한다.
5. 코드 수정 전 현재 브랜치, 변경사항, Worktree를 확인한다.

## 작업 원칙

- 구현은 항상 기능별 Worktree와 feature 브랜치에서 진행한다.
- Plan이 없거나 완료 조건이 불명확하면 구현하지 않고 Plan부터 작성하거나 갱신한다.
- 현재 상태와 다음 작업을 먼저 짧게 보고하고, 코드 수정은 요청받은 뒤 시작한다.
- 커밋, Pull Request, Merge, push는 명시적으로 요청받은 뒤 실행한다.

## 현재 단계

- 기준 Flutter 앱 생성과 iOS 시뮬레이터 검증을 마쳤다.
- 기준 검증: `flutter test`, `flutter analyze`, `flutter build ios --simulator`를 통과했고, iPhone 17 Pro에서 기본 카운터를 `0`에서 `1`로 전환했다.
- Todo CRUD 기능의 Plan 승인 전에는 Todo 코드를 구현하지 않는다.
