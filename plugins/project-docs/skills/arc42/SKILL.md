---
name: arc42
description: 프로젝트 문서를 arc42 v8 표준 아키텍처 구조로 생성·관리. 자연어 트리거는 **"아키42" 접두사**로 시작해야 한다. 예 "아키42 골격 만들어줘", "아키42 진척 보여줘", "아키42 1-1 챕터 작성해줘", "아키42 8 챕터 일괄 작성", "아키42 챕터 본문 추출". confirm(검토 승인)은 자연어 진입 금지 — 사용자가 직접 `/arc42-confirm <chapter-id>` 슬래시 호출.
allowed-tools: Read, Write, Edit, Bash, Glob
---

## 자연어 트리거 규칙

- 정규 접두사: **`아키42`** (공백 없음). 변형("아키 42", "Archi42" 등)은 정규형으로 해석하되 사용자에게 정규 표기 안내.
- 접두사 없는 발화는 본 스킬로 라우팅하지 않는다. 모델은 "아키42" 접두사 사용 또는 슬래시 커맨드 직접 호출을 안내한다.

## 진입 매핑

각 동작의 절차는 슬래시 커맨드 본문에 자체완결로 정의된다. 자연어 트리거로 진입한 경우에도 모델은 해당 커맨드 본문을 그대로 따른다.

| 자연어 트리거 예시 | 슬래시 커맨드 | 절차 정의 |
|---|---|---|
| "아키42 골격 만들어줘" | `/arc42-create` | `commands/arc42-create.md` |
| "아키42 진척 보여줘" | `/arc42-list` | `commands/arc42-list.md` |
| "아키42 1-1 챕터 작성해줘", "아키42 8 챕터 일괄 작성" | `/arc42-update <chapter-id>` | `commands/arc42-update.md` |
| **자연어 진입 금지** | `/arc42-confirm <chapter-id>` | `commands/arc42-confirm.md` |

### confirm 자연어 진입 차단

"아키42 1-1 확정", "아키42 confirm" 같은 발화로 confirm 절차에 진입하려는 경우, 모델은 **`/arc42-confirm <chapter-id>` 슬래시 호출이 필요함을 안내하고 자체 실행을 거부**한다.

## Bundled Scripts

`skills/arc42/scripts/` — 결정적 보조 스크립트. 발췌·검증 등 LLM 추론이 노이즈를 만드는 작업을 결정적으로 처리.

- **`extract-section.sh <file> <header>`** — 마크다운 섹션을 변형 없이 stdout 출력 (`/arc42-list` 사용)
- **`validate-chapter-id.sh <chapter-id>`** — chapter-id 형식 검증, exit 코드만 반환 (`/arc42-update`, `/arc42-confirm` 사용)
- **`find-leaf.sh <chapter-id> [INDEX.md]`** — chapter-id 에 해당하는 leaf 파일 경로 출력 (`/arc42-update`, `/arc42-confirm` 사용)
- **`update-status.sh <chapter-id> <new-status> [INDEX.md]`** — 인덱스 표 상태 열 원자적 갱신 (tmp + mv, 검증 실패 시 미변경) (`/arc42-update` review, `/arc42-confirm` confirm 사용)
