---
name: arc42
description: >
  프로젝트에 사용할 **arc42 표준 문서 구조**를 생성.
  트리거: "arc42 골격", "arc42 create", "arc42 list", "arc42 update", "arc42 confirm", "/arc42"
argument-hint: |
  create: 템플릿 복사.
  list: 진척 현황 조회.
  update <chapter-id>: 참고자료를 기반으로 챕터 본문 작성.
  confirm <chapter-id>: 챕터 진척 상태를 확정.
user-invocable: true
disable-model-invocation: false
allowed-tools: Read, Write, Edit, Bash, Glob
---

## 모드

본 절의 모든 경로 표기 컨벤션:
- `.claude/...` — **프로젝트 루트** 기준 (Claude는 cwd 또는 cwd 상위에서 `.claude/`를 탐색하여 프로젝트 루트 산출, 모호하면 사용자 확인).
- `references/...` — **본 스킬 디렉토리** 기준 (SKILL.md가 로드된 위치. 플러그인 설치·로컬 어디든 동일 상대 구조).
- Bash 실행 시 Claude는 두 경로를 실제 절대경로(`$PROJECT_ROOT` / `$SKILL_DIR`)로 치환.

### create

골격 템플릿(`references/docs/`)을 `.claude/docs/`로 복사.

동작 (Bash):
```bash
PROJECT_ROOT="<프로젝트 루트 절대경로>"
SKILL_DIR="<본 SKILL.md가 위치한 디렉토리 절대경로>"

# 1. 충돌 확인 — 프로젝트 루트의 .claude/docs 가 어떤 형태로든 이미 존재하면 차단
if [ -e "$PROJECT_ROOT/.claude/docs" ]; then
  echo "차단: $PROJECT_ROOT/.claude/docs 가 이미 존재합니다."
  exit 1
fi

# 2. 부모 디렉토리 보장
mkdir -p "$PROJECT_ROOT/.claude"

# 3. 템플릿 복사 (.gitkeep 포함, 빈 디렉토리도 보존)
cp -r "$SKILL_DIR/references/docs" "$PROJECT_ROOT/.claude/docs"

# 4. {{TODAY}} placeholder 일괄 치환 (강제)
TODAY=$(date +%Y-%m-%d)
find "$PROJECT_ROOT/.claude/docs" -type f -name "*.md" -exec sed -i "s/{{TODAY}}/$TODAY/g" {} +

# 5. 성공 여부 출력
```

### list

`.claude/docs/architecture/README.md`를 Read하고 **진척 표 섹션만 발췌**하여 사용자에게 출력. 챕터별 현재 상태(`draft`/`review`/`confirm`)와 leaf 경로 표시.

### update <chapter-id>

지정한 leaf의 본문 작성·갱신. 사용 자료는 `.claude/docs/source/` 내 모든 .md 파일.

흐름:
1. `.claude/docs/source/` 전체를 Read하고 헤딩 인덱스 생성.
2. `references/leaf-spec.md` 패턴에 따라 사용자에게 **절 구조 후보 + 출처 anchor 후보 + 위임 매핑**을 표로 보고.
3. 사용자 승인 후 본문 작성.
4. 대상 leaf의 frontmatter `last_updated`를 오늘 날짜(`YYYY-MM-DD`)로 갱신.
5. `.claude/docs/architecture/README.md` 진척 표에서 해당 챕터 상태를 `review`로 갱신.

예시:
- `update 1-1` → `.claude/docs/architecture/1_introduction_and_goals/1-1_requirements_overview.md`
- `update 5-3` → `.claude/docs/architecture/5_building_block_view/5-3_level_3.md`

### confirm <chapter-id>

지정한 챕터의 진척 상태를 `confirm`으로 변경. 사용자가 본문 검토 후 승인했음을 명시적으로 기록하는 단계. LLM 자율 변경 금지 — 본 명령은 사용자 명시 호출에서만 실행.

## 진척 상태 (3단계)

이모지 없이 텍스트만 사용:

| 상태 | 의미 | 전이 트리거 |
|------|------|------------|
| `draft` | 골격만 존재. 본문은 placeholder. | `create` 시 자동 부여 |
| `review` | 본문이 작성되어 사용자 검토 대기. | `update <chapter-id>` 완료 시 자동 부여 |
| `confirm` | 사용자가 검토·승인 완료. | `confirm <chapter-id>` 명령에서만 부여 |

전이는 단방향 권장: `draft` → `review` → `confirm`. 재작성 필요 시 `update` 재호출 (상태는 `review`로 되돌아감).

## 참조

- 표준 템플릿: `references/templates/` (leaf, README, workflow-readme)
- 디렉토리 구조: `references/structure.md`
- leaf 작성 가이드: `references/leaf-spec.md`

## 원칙

1. **arc42 표준 외 항목 명시.** workflow/installation/runbook은 arc42 범위 외 — README에 명시.
2. **frontmatter 통일 표준 1종 + 3 키 고정**(`file`/`title`/`last_updated`). 추출 단계 임시 정보(원본 anchor)는 frontmatter 대신 **본문 H1 직후 출처 인용 블록**에 배치 — `references/docs/architecture/`의 leaf 파일이 자체 템플릿.
3. **상태는 README 진척 표 1곳에서만 관리**. frontmatter에 status 키 두지 않음. 이중 진실 금지.
4. **`confirm` 상태 부여는 사용자 명시 명령에서만**. LLM 자율 부여 금지. `draft`→`review`는 `update` 동작의 부산물로 자동.
5. **`update`는 항상 `.claude/docs/source/` 전체 우선 스캔**. 자료 발견 실패 시 사용자 보고 후 백지 작성 여부 확인.
6. **삭제·이동·rename 등 파괴적 변경은 사용자 확인 후**.

## 트리거 예시

- "/arc42 create" — 골격 생성
- "/arc42 list" — 진척 확인
- "/arc42 update 1-1" — 1-1 본문 작성
- "/arc42 confirm 1-1" — 1-1 검토 승인
- "arc42 골격 만들어줘"
- "1-1 챕터 작성해줘"
- "1-1 확정"
