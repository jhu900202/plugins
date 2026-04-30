---
description: 지정한 챕터·leaf 의 본문을 .claude/docs/source/ 자료(또는 백지)로 작성·갱신
argument-hint: <chapter-id>
allowed-tools: ["Read", "Write", "Edit", "Glob", "Bash(${CLAUDE_PLUGIN_ROOT}/skills/arc42/scripts/validate-chapter-id.sh:*)", "Bash(${CLAUDE_PLUGIN_ROOT}/skills/arc42/scripts/find-leaf.sh:*)", "Bash(${CLAUDE_PLUGIN_ROOT}/skills/arc42/scripts/update-status.sh:*)"]
---

지정한 leaf 의 본문을 작성·갱신합니다. 인자: `$ARGUMENTS`.

## 0. 인자 검증·대상 leaf 조회 (스크립트 결정)

본문 작성 전 chapter-id 형식·존재 여부를 결정적 스크립트로 확인. 모델은 결과에 따라 분기만 수행하고 형식 추론은 하지 않는다.

```!
"${CLAUDE_PLUGIN_ROOT}/skills/arc42/scripts/validate-chapter-id.sh" "$ARGUMENTS" && \
  "${CLAUDE_PLUGIN_ROOT}/skills/arc42/scripts/find-leaf.sh" "$ARGUMENTS" .claude/docs/INDEX.md
```

종료 코드별 처리:
- `0`: stdout 의 leaf 경로 목록(한 줄당 1개)을 대상으로 아래 흐름 진행
- validate `2` (형식 오류): "chapter-id 형식이 잘못되었습니다. 예: `1`, `1-1`, `8-7`" 안내 후 중단
- find-leaf `2` (INDEX.md 없음): "INDEX.md 가 없습니다. `/arc42-create` 로 골격을 먼저 생성하세요." 안내 후 중단
- find-leaf `3` (매치 없음): "<chapter-id> 에 해당하는 leaf 가 INDEX.md 에 없습니다." 안내 후 중단

## 자료 입력 (source 선택적)

- `.claude/docs/source/` 에 .md 자료가 있으면 우선 읽어 **추출 기반 작성** (출처 anchor 명시).
- source/ 가 부재이거나 비어 있으면 arc42 표준 + `references/leaf-spec.md` + LLM 지식만으로 **백지 작성**. 사용자에게 source 부재를 명시 보고 후 진행.

## `<chapter-id>` 형식

- **서브섹션 포함** (예: `1-1`, `5-3`): 해당 leaf 1개만 작성·갱신.
- **챕터만** (예: `1`, `8`): 해당 챕터에 속한 모든 leaf 일괄 작성·갱신 (예: `update 1` → 1-1, 1-2, 1-3 모두). 평탄 챕터(2/4/6/9/11/12)는 단일 leaf 라 동일 동작.

## 흐름

본 절차의 leaf 작성 사양(산출물 구조·챕터별 절 패턴·위임 규칙·검증 항목·출처 라이프사이클)은 `references/leaf-spec.md` 가 단일 진실 소스다. 아래 단계는 그 사양 위에서 모드 동작만 기술한다. 대상 leaf 경로 목록은 §0 의 `find-leaf.sh` 결과를 사용한다.

1. `.claude/docs/source/` 존재·내용 확인. 자료가 있으면 전체 Read 하고 헤딩 인덱스 생성 (`references/leaf-spec.md` §0). 부재·빈 경우 다음 단계로 건너뛰며 사용자에게 source 부재를 보고.
2. `references/leaf-spec.md` §2 의 보고 형식(절 후보 / 위임 대상 / frontmatter / 결정 사항)에 따라 사용자에게 표로 보고. source 가 있을 때만 출처 anchor 후보·위임 매핑 포함. 챕터만 지정 시 해당 챕터의 모든 leaf 에 대해 일괄 보고.
3. 사용자 승인 후 본문 작성 — `references/leaf-spec.md` §1 (leaf 산출물 구조) 와 §4 (챕터별 권장 절 패턴) 를 따른다. source 부재 시 백지 작성 모드.
4. 대상 leaf 의 frontmatter `last_updated` 를 오늘 날짜(`YYYY-MM-DD`)로 갱신. 작성 후 `references/leaf-spec.md` §6 검증 6항목 자체 점검.
5. 인덱스 표 상태 열을 `review` 로 갱신 — 결정적 스크립트로 수행. 모델은 Edit 도구로 INDEX.md 를 직접 수정하지 않는다.

   ```!
   "${CLAUDE_PLUGIN_ROOT}/skills/arc42/scripts/update-status.sh" "$ARGUMENTS" review .claude/docs/INDEX.md
   ```

   종료 코드별 처리는 `/arc42-confirm` 의 §1 과 동일. 검증 실패(exit 4) 시 사용자에게 보고 후 중단.

## 예시

- `/arc42-update 1-1` → 1-1 단일 leaf
- `/arc42-update 1` → 1-1, 1-2, 1-3 일괄
- `/arc42-update 5-3` → 5-3 단일 leaf
- `/arc42-update 8` → 8-1 ~ 8-7 일괄

## 상태 효과

대상 leaf 가 인덱스 표에서 **`review`** (본문 작성 완료, 사용자 검토 대기) 로 전이. 이전 상태가 `confirm` 이었어도 `review` 로 되돌아간다 — 재작성된 본문은 사용자 재검토 후 다시 `/arc42-confirm` 으로 승인해야 한다.
