---
description: 지정한 챕터·leaf 의 진척 상태를 confirm 으로 확정 (사용자 명시 슬래시 호출 전용)
argument-hint: <chapter-id>
allowed-tools: Read, Edit
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

1. `.claude/docs/INDEX.md` 를 Read.
2. 인덱스 표에서 `<chapter-id>` 에 매칭되는 행(들)의 `상태` 열을 `confirm` 으로 Edit.
3. 다른 행·다른 열·표 외 부분은 변경하지 않는다.

## 상태 효과

대상 leaf 가 인덱스 표에서 **`confirm`** (사용자 검토·승인 완료) 로 전이. 이후 같은 leaf 에 `/arc42-update` 가 호출되면 본문이 다시 작성되며 상태가 `review` 로 되돌아간다.
