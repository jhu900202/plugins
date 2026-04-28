---
description: 지정한 챕터의 본문을 .claude/docs/source/ 자료를 기반으로 작성·갱신
argument-hint: <chapter-id>
allowed-tools: Read, Write, Edit, Glob
---

`arc42` 스킬의 **update** 모드를 실행합니다. 인자: `$ARGUMENTS` (예: `1-1`, `5-3`).

수행:
1. `.claude/docs/source/` 전체를 Read 하고 헤딩 인덱스 생성
2. `references/leaf-spec.md` 패턴에 따라 사용자에게 **절 구조 후보 + 출처 anchor 후보 + 위임 매핑** 을 표로 보고
3. 사용자 승인 후 본문 작성
4. 대상 leaf 의 frontmatter `last_updated` 를 오늘 날짜로 갱신
5. `.claude/docs/architecture/README.md` 진척 표에서 해당 챕터 상태를 `review` 로 갱신

예:
- `/arc42-update 1-1` → `.claude/docs/architecture/1_introduction_and_goals/1-1_requirements_overview.md`
- `/arc42-update 5-3` → `.claude/docs/architecture/5_building_block_view/5-3_level_3.md`

상세 절차와 자료 매칭 규칙은 `skills/arc42/SKILL.md` 의 "update" 섹션을 따르세요.
