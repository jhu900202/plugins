---
description: 지정한 챕터·leaf 의 진척 상태를 confirm 으로 확정 (사용자 명시 슬래시 호출 전용)
argument-hint: <chapter-id>
allowed-tools: ["Read", "Bash(${CLAUDE_PLUGIN_ROOT}/skills/arc42/scripts/validate-chapter-id.sh:*)", "Bash(${CLAUDE_PLUGIN_ROOT}/skills/arc42/scripts/find-leaf.sh:*)", "Bash(${CLAUDE_PLUGIN_ROOT}/skills/arc42/scripts/update-status.sh:*)"]
disable-model-invocation: true
---

지정한 leaf 의 진척 상태를 `.claude/docs/INDEX.md` 인덱스 표에서 `confirm` 으로 변경합니다. 사용자가 본문 검토 후 승인했음을 명시적으로 기록하는 단계.

## 호출 정책 — 사용자 명시 슬래시 호출만 허용

- **허용 경로**: `/arc42-confirm <chapter-id>` 슬래시 입력 (사용자 직접 타이핑).
- **차단 경로 1**: 자연어 트리거(예: "1-1 확정", "arc42 confirm")로 진입한 경우 — 모델은 **사용자에게 `/arc42-confirm <chapter-id>` 슬래시 명시 호출이 필요함을 안내하고 자체 실행을 거부**해야 한다.
- **차단 경로 2**: 다른 모드(`update` 등) 작업 중 모델이 추론으로 본 절차에 진입 — 금지. 사용자 명시 슬래시 호출 없이는 절대 인덱스 표를 `confirm` 으로 변경하지 않는다.
- 프론트매터 `disable-model-invocation: true` 가 SlashCommand 도구 경로 자동 호출을 추가로 차단함 (defense-in-depth).

## `<chapter-id>` 형식

- **서브섹션 포함** (예: `1-1`, `5-3`): 단일 leaf 행만 갱신.
- **챕터만** (예: `1`, `8`): 해당 챕터의 모든 leaf 행 일괄 갱신.

## 수행

### 0. 인자 검증·대상 leaf 조회 (스크립트 결정)

상태 변경 전 chapter-id 형식·존재 여부를 결정적 스크립트로 확인. 모델은 결과에 따라 분기만 수행하고 형식 추론은 하지 않는다.

```!
"${CLAUDE_PLUGIN_ROOT}/skills/arc42/scripts/validate-chapter-id.sh" "$ARGUMENTS" && \
  "${CLAUDE_PLUGIN_ROOT}/skills/arc42/scripts/find-leaf.sh" "$ARGUMENTS" .claude/docs/INDEX.md
```

종료 코드별 처리:
- `0`: stdout 의 leaf 경로 목록을 대상으로 아래 단계 진행
- validate `2` (형식 오류): "chapter-id 형식이 잘못되었습니다. 예: `1`, `1-1`, `8-7`" 안내 후 중단
- find-leaf `2` (INDEX.md 없음): "INDEX.md 가 없습니다." 안내 후 중단
- find-leaf `3` (매치 없음): "<chapter-id> 에 해당하는 leaf 가 INDEX.md 에 없습니다." 안내 후 중단

### 1. 상태 갱신 (스크립트 결정·원자적 쓰기)

상태 변경은 결정적 스크립트로 수행한다. 모델은 Edit 도구로 INDEX.md 를 직접 수정하지 않는다 — 부분 쓰기·범위 외 변경 위험을 차단한다.

```!
"${CLAUDE_PLUGIN_ROOT}/skills/arc42/scripts/update-status.sh" "$ARGUMENTS" confirm .claude/docs/INDEX.md
```

종료 코드별 처리:
- `0`: stdout 의 "Updated N leaf row(s)..." 메시지를 사용자에게 전달
- `1`/`2`/`3`: §0 에서 이미 검증되었으므로 도달 시 스크립트 내부 일관성 문제 — 사용자에게 보고 후 중단
- `4` (검증 실패): "INDEX.md 갱신 검증에 실패했습니다. 파일은 변경되지 않았습니다." 안내 후 중단

## 상태 효과

대상 leaf 가 인덱스 표에서 **`confirm`** (사용자 검토·승인 완료) 로 전이. 이후 같은 leaf 에 `/arc42-update` 가 호출되면 본문이 다시 작성되며 상태가 `review` 로 되돌아간다.
