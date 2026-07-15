# 1인 개발 Flutter Todo 앱 하네스 시나리오

## 목표

사람이 처음 아는 사실은 하나다.

```text
Flutter로 SQLite 기반 CRUD Todo 앱을 만들고 싶다.
```

Codex는 이 한 줄만으로 구조나 디자인을 미리 정하지 않는다. 현재 작업 공간과 Flutter 환경을 먼저 확인하고, 전체 기획서를 한 번 작성한 뒤 기능별 Plan에 따라 구현한다.

## 사용하는 문서

```text
todo_app/
├── reference/
│   ├── 1인-개발-작업-워크플로우와-Codex-지침서.md
│   ├── 1인-개발-플러터-Todo-앱-하네스-시나리오.md
│   └── 간소화-프로젝트-기획-템플릿/
├── START_HERE.md
├── AGENTS.md
└── docs/
    ├── product/기획서.md
    └── plans/todo-crud.md
```

- `AGENTS.md`: 실제 Flutter 명령어와 반복 규칙
- `START_HERE.md`: 새 세션의 읽기 순서와 시작 규칙
- `기획서.md`: Todo 앱 전체 MVP와 기술 결정
- `todo-crud.md`: 이번 CRUD 기능의 구현·검증 Plan

전체 기획서는 시작할 때 한 번 작성한다. 이후 기능마다 기획서를 다시 만들지 않고 `docs/plans/`에 Plan만 추가한다.

`reference/`는 읽기 전용 참고 폴더다. Codex는 이곳의 지침서와 템플릿을 읽고, 실제 작업 문서는 루트 `AGENTS.md`와 `docs/`에 작성한다. 기능 작업 중 `reference/`를 수정하지 않는다.

템플릿 원본:

- [최소 기획 템플릿 사용법](./간소화-프로젝트-기획-템플릿/README.md)
- [AGENTS.md 템플릿](./간소화-프로젝트-기획-템플릿/templates/AGENTS.md)
- [전체 기획서 템플릿](./간소화-프로젝트-기획-템플릿/templates/docs/product/기획서.md)
- [작업 Plan 템플릿](./간소화-프로젝트-기획-템플릿/templates/docs/plans/작업-Plan.md)

## 하네스 역할

| 단계 | 기본 담당 | 사람의 역할 |
| --- | --- | --- |
| 환경·구조 확인 | Codex | 한 줄로 목표 전달 |
| 설계와 전체 기획 | Superpowers | 설계·기획 승인 |
| 기능별 Plan | Superpowers 또는 LazyCodex | Plan 승인 |
| 구현·테스트·리뷰 | Goal 또는 LazyCodex | 구현 시작 요청 |
| 커밋·PR·Merge | Codex와 사람 | 명시적으로 요청·확인 |

한 기능에는 Plan 하나만 유지한다. Superpowers와 LazyCodex의 Plan을 같은 기능에 둘 다 만들지 않는다.

## 실제 진행 순서

### 0. 현재 상태 확인

사람:

```text
Flutter로 SQLite를 사용하는 간단한 CRUD Todo 앱을 만들고 싶어. 현재 작업 공간과 Flutter 환경을 확인하고 첫 단계를 제안해줘.
```

Codex는 현재 폴더, 기존 프로젝트, Git 상태, Flutter·Dart 설치 상태, 실행 플랫폼, 기존 `AGENTS.md`와 문서를 확인한다. 빈 폴더면 Flutter 프로젝트 초기화를 제안한다.

### 1. 기본 Flutter 앱 만들기

사람:

```text
좋아. 현재 폴더에 최소 Flutter 프로젝트만 만들고 실행과 기본 테스트를 확인해줘. Todo 기능은 아직 만들지 마.
```

기본 앱을 실행·검증한 뒤에만 다음 단계로 간다.

### 2. 최소 문서 템플릿 적용

Codex가 `reference/간소화-프로젝트-기획-템플릿/templates/`를 읽어 루트 `AGENTS.md`, `START_HERE.md`, `docs/`를 만든다. 템플릿 원본은 수정하지 않는다.

```text
reference/1인-개발-작업-워크플로우와-Codex-지침서.md와 reference/간소화-프로젝트-기획-템플릿/templates/를 읽어줘. reference는 수정하지 말고, 방금 확인한 실제 프로젝트 정보로 루트 AGENTS.md와 START_HERE.md를 만들고 docs/product/기획서.md에는 Todo 앱의 전체 MVP 초안만 작성해줘. 실행 명령은 확인한 것만 넣고, 기능 코드는 수정하지 마.
```

Codex는 다음만 기록한다.

- 실제 Flutter 실행·테스트·분석·빌드 명령
- 목표, MVP, 제외 범위, 흐름, 요구사항, 데이터, 검증 기준
- 불확실한 선택은 임시 가정 또는 미정

검색, 카테고리, 로그인, 동기화처럼 요청되지 않은 기능은 MVP에서 제외한다.

사람:

```text
기획서를 검토했어. 로컬 SQLite만 사용하고, 검색·카테고리·로그인은 이번 MVP에서 제외해.
```

기본 앱과 문서가 안정되면 기준 커밋을 만든다.

```text
설정: Flutter 프로젝트와 Todo 앱 기획서 초기화
```

### 3. Worktree와 feature 브랜치, 작업 Plan

첫 기능은 `feature/todo-crud` Worktree에서 진행한다. 기본 checkout은 `main` 확인·병합·정리에만 사용하고, 기능 구현은 항상 독립 Worktree에서 진행한다.

사람:

```text
루트 AGENTS.md와 docs/product/기획서.md, reference/간소화-프로젝트-기획-템플릿/templates/docs/plans/작업-Plan.md를 읽어줘. reference는 수정하지 말고, 현재 브랜치와 변경사항, 기존 Worktree를 확인해줘. 문제 없으면 최신 main 기준으로 feature/todo-crud Worktree와 브랜치를 만들고 docs/plans/todo-crud.md만 작성해줘. 코드 수정은 하지 마.
```

Plan에는 Todo 생성·조회·수정·삭제, SQLite 저장 흐름, 빈 제목·빈 목록·저장 실패, 검증, 제외 범위만 포함한다.

사람:

```text
Plan을 승인한다. SQLite Todo CRUD 구현을 시작해. 커밋, PR, 원격 변경은 하지 마.
```

### 4. 구현과 검증

구현은 가장 단순한 흐름으로 진행한다.

```text
SQLite 데이터베이스
→ Todo 모델과 저장소
→ 상태 처리
→ Todo 화면
→ 테스트와 수동 검증
```

수동 검증 최소 흐름:

```text
Todo 추가 → 완료 처리 → 제목 수정 → 앱 재실행 → 삭제
```

사람:

```text
현재 feature 브랜치를 리뷰하고, 문제를 수정한 뒤 테스트·분석·빌드와 수동 검증 결과를 알려줘.
```

확인 기준:

- 생성·조회·수정·삭제가 동작한다.
- 앱 재실행 후 데이터가 남는다.
- 빈 제목 입력을 막는다.
- 빈 목록과 저장 실패가 이해 가능한 상태로 보인다.
- 요청하지 않은 의존성이나 구조를 추가하지 않았다.

### 5. 커밋, PR, Merge

검증이 끝난 뒤에만 요청한다.

```text
관련 변경만 한국어 커밋으로 만들어줘.
```

```text
검토 가능한 한국어 Pull Request를 만들어줘. 변경 내용, 변경 이유, 검증 결과, 제외 범위를 포함해.
```

```text
PR의 CI와 diff를 확인했어. 스쿼시 Merge하고 feature 브랜치를 정리해줘.
```

1인 개발에서는 본인이 PR을 검토·승인하고 Merge할 수 있다. CI가 실패했거나 검증 결과가 불명확하면 병합하지 않는다.

## 새 세션 재개

기능이 끝나지 않은 채 새 세션을 열면 별도 `HANDOFF.md`를 만들지 않는다. 현재 `docs/plans/todo-crud.md`의 `작업 결과와 세션 인수인계`를 갱신하고, 새 세션에서 읽는다.

```text
START_HERE.md와 docs/plans/todo-crud.md를 읽고, 진행 상태와 다음 작업만 보고해줘. 코드 수정은 하지 마.
```

## 최종 구조 예시

```text
todo_app/
├── reference/
│   ├── 1인-개발-작업-워크플로우와-Codex-지침서.md
│   ├── 1인-개발-플러터-Todo-앱-하네스-시나리오.md
│   └── 간소화-프로젝트-기획-템플릿/
├── START_HERE.md
├── AGENTS.md
├── docs/
│   ├── product/기획서.md
│   └── plans/todo-crud.md
├── lib/features/todos/
└── test/features/todos/
```

## 사람이 기억할 요청 세 줄

```text
기획서만 작성해줘. 코드 수정은 하지 마.
```

```text
이번 기능의 Plan만 작성해줘. 코드 수정은 하지 마.
```

```text
Plan을 승인한다. 구현·검증·리뷰까지 진행해줘. 원격 변경은 하지 마.
```
