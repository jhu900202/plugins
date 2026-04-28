---
description: 지정한 챕터의 진척 상태를 confirm 으로 확정 (사용자 명시 호출 전용)
argument-hint: <chapter-id>
allowed-tools: Read, Edit
---

`arc42` 스킬의 **confirm** 모드를 실행합니다. 인자: `$ARGUMENTS` (예: `1-1`).

수행:
1. `.claude/docs/architecture/README.md` 의 진척 표에서 해당 챕터 상태를 `confirm` 으로 변경

원칙:
- LLM 자율 변경 금지 — 본 명령은 **사용자 명시 호출에서만** 실행
- 본문 검토를 마쳤음을 명시적으로 기록하는 단계

상세 정의는 `skills/arc42/SKILL.md` 의 "confirm" 섹션을 따르세요.
