---
description: arc42 v8 표준 12 챕터 골격을 .claude/docs/ 로 생성
allowed-tools: Bash, Read, Glob
---

arc42 v8 표준 12 챕터 골격을 프로젝트의 `.claude/docs/` 로 복사하고 사용자 자료 폴더를 보장합니다.

경로 표기 규약:
- `.claude/...` — 프로젝트 루트 기준 (Claude 는 cwd 또는 cwd 상위에서 `.claude/` 를 탐색하여 프로젝트 루트 산출, 모호하면 사용자 확인).
- `references/...` — 본 스킬 디렉토리 기준 (`SKILL.md` 가 로드된 위치).
- Bash 실행 시 두 경로를 실제 절대경로(`$PROJECT_ROOT` / `$SKILL_DIR`)로 치환.

동작:

```bash
PROJECT_ROOT="<프로젝트 루트 절대경로>"
SKILL_DIR="<본 스킬 디렉토리 절대경로>"

# 1. 충돌 확인 — 프로젝트 루트의 .claude/docs 가 어떤 형태로든 이미 존재하면 차단
if [ -e "$PROJECT_ROOT/.claude/docs" ]; then
  echo "차단: $PROJECT_ROOT/.claude/docs 가 이미 존재합니다."
  exit 1
fi

# 2. 부모 디렉토리 보장
mkdir -p "$PROJECT_ROOT/.claude"

# 3. 템플릿 복사
cp -r "$SKILL_DIR/references/docs" "$PROJECT_ROOT/.claude/docs"

# 4. 사용자 자료 작업 폴더 보장 (git 추적되지 않는 빈 디렉토리)
mkdir -p "$PROJECT_ROOT/.claude/docs/source"

# 5. {{TODAY}} placeholder 일괄 치환 (강제)
TODAY=$(date +%Y-%m-%d)
find "$PROJECT_ROOT/.claude/docs" -type f -name "*.md" -exec sed -i "s/{{TODAY}}/$TODAY/g" {} +

# 6. 성공 여부 출력
```

산출물:
- `.claude/docs/INDEX.md` — 진척 상태를 단일 진실 소스로 관리하는 인덱스 (architecture + 향후 workflow)
- `.claude/docs/architecture/` — 12 챕터 디렉토리 + 25 leaf 파일
- `.claude/docs/source/` — 사용자가 원본 자료를 둘 빈 폴더 (`update` 가 우선 스캔)
- `.claude/docs/workflow/` — workflow 영역 (arc42 범위 외, 자체 README 시드 포함)

상태 효과: 모든 leaf 가 **`draft`** (골격만 존재, 본문은 placeholder) 로 인덱스 표에 등록됨.

디렉토리 트리 전체 사양·명명 규칙(snake_case + 챕터 번호 prefix)·언어 정책(파일명 영문, 본문 한국어)·기존 파일 충돌 처리는 `references/structure.md` 참조.
