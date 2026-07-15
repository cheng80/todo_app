# 1인 개발 최소 기획 템플릿

전체 기획서는 프로젝트 시작 때 한 번 작성하고, 기능마다 작업 Plan을 추가하는 템플릿이다. 기본 문서로 시작하되, 실제 관리할 정보가 생기면 필요한 문서를 확장한다.

## 기본 구조

```text
todo_app/
├── reference/
│   └── 간소화-프로젝트-기획-템플릿/
│       └── templates/
├── START_HERE.md
├── AGENTS.md
└── docs/
    ├── product/
    │   └── 기획서.md
    └── plans/
        └── TASK-001-기능명.md
```

`reference/`는 템플릿과 운영 문서를 보관하는 읽기 전용 참고 폴더다. 실제 작업 문서는 프로젝트 루트의 `AGENTS.md`와 `docs/`에 만들며, Codex는 `reference/` 원본을 수정하지 않는다.

## 새 프로젝트에서 사용하는 방법

1. `reference/간소화-프로젝트-기획-템플릿/templates/AGENTS.md`를 프로젝트 루트의 `AGENTS.md`로 복사한다.
2. `reference/간소화-프로젝트-기획-템플릿/templates/START_HERE.md`를 프로젝트 루트의 `START_HERE.md`로 복사한다.
3. `reference/간소화-프로젝트-기획-템플릿/templates/docs/`를 프로젝트의 `docs/`로 복사한다.
4. `AGENTS.md`의 프로젝트 개요와 실행·검증 명령을 채운다.
5. `docs/product/기획서.md`에 전체 MVP와 제외 범위를 작성한다.
6. 첫 기능을 시작할 때 `docs/plans/작업-Plan.md`를 복사해 `TASK-001-기능명.md`로 바꾼다.

## Worktree와 브랜치

기능 작업은 항상 Worktree와 feature 브랜치를 함께 만든다. 기본 checkout은 `main` 확인·병합·정리에만 사용하고, 구현은 Worktree에서 진행한다.

```text
작업 하나 = Codex task 하나 = Worktree 하나 = feature 브랜치 하나 = Pull Request 하나
```

작업 ID는 `docs/plans/`과 열린 Pull Request에서 가장 큰 번호 다음으로 `TASK-001`, `TASK-002`처럼 부여한다. 취소된 작업 Plan도 삭제하지 않고 보존하며, ID는 재사용하지 않는다. 같은 ID를 Worktree, 브랜치, Plan, 커밋, Pull Request에 사용한다. 요구사항 ID인 `REQ-001`과는 별개다.

## 기본 문서와 확장 문서

| 문서 | 언제 작성하나 | 무엇을 적나 |
| --- | --- | --- |
| `AGENTS.md` | 프로젝트 시작 | 반복 규칙, 명령어, 검증 기준 |
| `START_HERE.md` | 프로젝트 시작 | 새 세션의 읽기 순서와 시작 규칙 |
| `docs/product/기획서.md` | 프로젝트 시작 | 전체 목표, MVP, 요구사항, 기술 결정 |
| `docs/plans/TASK-001-기능명.md` | 기능 시작 | 이번 기능의 범위, 구현 순서, 검증 |

다음 문서는 필요할 때만 추가한다.

| 상황 | 추가 문서 예시 |
| --- | --- |
| 요구사항과 수용 기준이 많음 | `docs/product/요구사항.md` |
| 기술 선택·구조 결정이 많음 | `docs/product/기술-설계.md` |
| 배포·운영 검증이 필요함 | `docs/release/QA-릴리스.md` |
| 게임 프로젝트 | `docs/product/게임-기획-확장.md` |

전체 기획서는 기능마다 새로 만들지 않는다. 확정된 목표·범위·기술 결정이 바뀔 때만 갱신한다.

## Codex에 보내는 짧은 요청 예시

### 1. 프로젝트 기획 시작

```text
reference/간소화-프로젝트-기획-템플릿/templates/의 AGENTS.md와 기획서 템플릿을 읽어줘. reference는 수정하지 말고, 실제 프로젝트 정보로 루트 AGENTS.md와 docs/product/기획서.md 초안만 작성해줘. 코드 변경은 하지 마.
```

### 2. 기능 Plan 작성

```text
루트 AGENTS.md와 docs/product/기획서.md, reference/간소화-프로젝트-기획-템플릿/templates/docs/plans/작업-Plan.md를 읽어줘. reference는 수정하지 말고, 새 작업 ID를 부여한 뒤 [기능 이름]의 범위와 완료 조건을 docs/plans/TASK-001-[기능 이름].md에만 작성해줘. 코드 변경은 하지 마.
```

### 3. 기능 구현

```text
Plan을 승인한다. [기능 이름]을 구현하고 테스트·검증·리뷰 결과를 보고해줘. 커밋, PR, 원격 변경은 하지 마.
```

### 4. 새 세션 재개

```text
START_HERE.md와 현재 기능 Plan을 읽고, 진행 상태와 다음 작업만 보고해줘. 코드 수정은 하지 마.
```

## 게임 프로젝트일 때만

`extensions/game/`의 두 파일을 프로젝트로 복사한다. 게임이 아니면 이 폴더는 사용하지 않는다.

```text
프로젝트/
└── docs/product/
    └── 게임-기획-확장.md
```

게임 확장은 핵심 루프·규칙·콘텐츠·밸런스만 보완한다. 기능별 구현 계획은 기존 `docs/plans/`를 그대로 사용한다.
