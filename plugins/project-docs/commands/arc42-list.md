---
description: arc42 인덱스 표(챕터·leaf 진척 상태)를 발췌하여 출력
allowed-tools: ["Bash(${CLAUDE_PLUGIN_ROOT}/skills/arc42/scripts/extract-section.sh:*)"]
---

`.claude/docs/INDEX.md` 의 `## 인덱스` 섹션을 변형 없이 그대로 출력합니다.

스크립트가 모든 발췌·출력을 처리하며, 모델은 결과를 재포맷·요약·해설하지 않고 그대로 사용자에게 노출합니다.

```!
"${CLAUDE_PLUGIN_ROOT}/skills/arc42/scripts/extract-section.sh" .claude/docs/INDEX.md "## 인덱스"
```

종료 코드별 처리:
- `0`: stdout 출력 그대로 사용자에게 표시
- `2` (파일 없음): "INDEX.md 가 아직 생성되지 않았습니다. `/arc42-create` 로 골격을 생성하세요." 안내
- `3` (헤더 없음): "INDEX.md 에 `## 인덱스` 섹션이 없습니다. 골격이 손상되었을 수 있습니다." 안내
