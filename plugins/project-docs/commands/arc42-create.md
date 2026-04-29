---
description: arc42 v8 표준 12 챕터 + runbook 절차 골격을 .claude/docs/ 로 생성
allowed-tools: Bash, Read, Glob
---

arc42 v8 표준 12 챕터 + runbook (installation + implementation) 골격을 프로젝트의 `.claude/docs/` 로 복사한다. 두 스킬(`arc42` + `runbook`)의 templates 를 균일하게 시드한다.

경로 표기 규약 (Claude Code 표준 env var):
- `${CLAUDE_PROJECT_DIR}` — 프로젝트 루트 절대경로 (Claude Code 가 자동 노출).
- `${CLAUDE_PLUGIN_ROOT}` — 본 플러그인 루트 절대경로 (Claude Code 가 자동 노출). 멀티 스킬 경로는 `${CLAUDE_PLUGIN_ROOT}/skills/<skill-name>/...` 로 구성.

동작:

```bash
# 1. 충돌 확인 — 프로젝트 루트의 .claude/docs 가 어떤 형태로든 이미 존재하면 차단
if [ -e "${CLAUDE_PROJECT_DIR}/.claude/docs" ]; then
  echo "차단: ${CLAUDE_PROJECT_DIR}/.claude/docs 가 이미 존재합니다."
  exit 1
fi

# 2. 부모 디렉토리 보장
mkdir -p "${CLAUDE_PROJECT_DIR}/.claude/docs"

# 3. 두 스킬의 templates 균일 복사
cp -r "${CLAUDE_PLUGIN_ROOT}/skills/arc42/templates/architecture"   "${CLAUDE_PROJECT_DIR}/.claude/docs/architecture"
cp -r "${CLAUDE_PLUGIN_ROOT}/skills/runbook/templates/runbook"      "${CLAUDE_PROJECT_DIR}/.claude/docs/runbook"

# 4. {{TODAY}} placeholder 일괄 치환 (강제)
TODAY=$(date +%Y-%m-%d)
find "${CLAUDE_PROJECT_DIR}/.claude/docs" -type f -name "*.md" -exec sed -i "s/{{TODAY}}/$TODAY/g" {} +

# 5. 성공 여부 출력
echo "✓ .claude/docs/architecture/ + .claude/docs/runbook/ 시드 완료"
```

산출물:

```
.claude/docs/
├── architecture/                ← arc42 스킬 templates 시드
│   ├── INDEX.md                 (arc42 진척 단일 진실 소스)
│   ├── source/                  (사용자가 원본 자료를 둘 빈 폴더 — /arc42-source 가 처리)
│   └── (12 챕터 디렉토리, 25 leaf)
└── runbook/                     ← runbook 스킬 templates 시드
    ├── INDEX.md                 (runbook 진척 단일 진실 소스)
    ├── README.md                (runbook 도메인 진입 가이드)
    ├── installation/            (1회성 플랫폼 셋업 절차)
    └── implementation/          (기능 구현 + 일상 운영 절차)
```

상태 효과: 모든 arc42 leaf 가 **`draft`** (골격만 존재, 본문은 placeholder) 로 architecture INDEX 표에 등록됨. runbook INDEX 는 빈 표 상태 (항목 추가 시 채워짐).
