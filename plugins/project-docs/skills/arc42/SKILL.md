---
name: arc42
description: 프로젝트 문서를 arc42 v8 표준 아키텍처 구조로 생성·관리. 사용자가 "arc42 골격 만들어줘", "arc42 골격", "아키텍처 문서 만들어줘", "arc42 진척 보여줘", "1-1 챕터 작성해줘", "5-3 챕터 갱신", "8 챕터 일괄 작성", "챕터 본문 추출" 같은 요청을 할 때 사용. confirm(검토 승인)은 자연어 진입 금지 — 사용자가 직접 `/arc42-confirm <chapter-id>` 슬래시 명시 호출을 입력해야 한다.
allowed-tools: Read, Write, Edit, Bash, Glob
---

## 진입 매핑

각 동작의 실제 절차는 슬래시 커맨드 본문에 자체완결로 정의된다. 자연어 트리거로 활성화된 경우에도 모델은 해당 커맨드 본문을 그대로 읽고 따른다.

| 자연어 트리거 예시 | 슬래시 커맨드 | 절차 정의 |
|---|---|---|
| "arc42 골격 만들어줘" | `/arc42-create` | `commands/arc42-create.md` |
| "arc42 진척 보여줘" | `/arc42-list` | `commands/arc42-list.md` |
| "1-1 챕터 작성해줘", "8 챕터 일괄 작성" | `/arc42-update <chapter-id>` | `commands/arc42-update.md` |
| **자연어 진입 금지** | `/arc42-confirm <chapter-id>` | `commands/arc42-confirm.md` |

### confirm 자연어 진입 차단

"1-1 확정", "arc42 confirm" 같은 자연어 발화로 confirm 절차에 진입하려는 경우, 모델은 **사용자에게 `/arc42-confirm <chapter-id>` 슬래시 명시 호출이 필요함을 안내하고 자체 실행을 거부**해야 한다. 자연어 진입은 검토·승인이라는 사용자 명시 행위를 우회할 위험이 있어 차단된다.
