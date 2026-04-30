#!/bin/bash
# update-status.sh
# chapter-id 에 해당하는 모든 leaf 행의 INDEX.md 인덱스 표 상태 열을 일괄 갱신.
# 단일 atomic 쓰기: 전체 변환 결과를 tmp 에 작성 → 검증 → mv. 검증 실패 시 INDEX.md 미변경.
#
# 사용 예:
#   update-status.sh 1-1 confirm
#   update-status.sh 8 confirm   # 8-1 ~ 8-7 일괄
#
# 종료 코드:
#   0 성공
#   1 인자 잘못 (형식·상태값)
#   2 INDEX.md 없음
#   3 chapter-id 매치 없음 (find-leaf 결과 0건)
#   4 검증 실패 — INDEX.md 미변경

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

show_usage() {
  cat <<'EOF'
Usage: update-status.sh <chapter-id> <new-status> [INDEX.md]

chapter-id 에 해당하는 모든 leaf 행의 INDEX.md 인덱스 표 상태 열을 일괄 갱신.

Arguments:
  <chapter-id>   "N" 또는 "N-M" (validate-chapter-id.sh 형식 검증)
  <new-status>   draft | review | confirm
  [INDEX.md]     기본값: .claude/docs/INDEX.md

Atomic write:
  - 전체 변환 결과를 INDEX.md.tmp.$$ 에 작성
  - 모든 대상 leaf 의 상태가 갱신되었는지 검증
  - 검증 통과 시에만 mv 로 INDEX.md 교체 (단일 파일시스템 내 mv 는 원자적)
  - 검증 실패 시 tmp 파기, INDEX.md 미변경

Exit codes:
  0  성공
  1  잘못된 인자
  2  INDEX.md 없음
  3  chapter-id 매치 없음
  4  검증 실패 (INDEX.md 미변경)
EOF
  exit 0
}

if [ $# -eq 0 ] || [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  show_usage
fi

if [ $# -lt 2 ]; then
  echo "Error: missing arguments (need <chapter-id> <new-status>)" >&2
  exit 1
fi

CHAPTER_ID="$1"
NEW_STATUS="$2"
INDEX="${3:-.claude/docs/INDEX.md}"

if ! "$SCRIPT_DIR/validate-chapter-id.sh" "$CHAPTER_ID" 2>/dev/null; then
  echo "Error: invalid chapter-id format: $CHAPTER_ID" >&2
  echo "Allowed: N (1-12) or N-M (N: 1-12, M: 1-9)" >&2
  exit 1
fi

case "$NEW_STATUS" in
  draft|review|confirm) ;;
  *)
    echo "Error: invalid new-status: $NEW_STATUS (allowed: draft, review, confirm)" >&2
    exit 1
    ;;
esac

if [ ! -f "$INDEX" ]; then
  echo "Error: INDEX.md not found: $INDEX" >&2
  exit 2
fi

set +e
LEAVES=$("$SCRIPT_DIR/find-leaf.sh" "$CHAPTER_ID" "$INDEX")
FIND_RC=$?
set -e

if [ "$FIND_RC" -ne 0 ]; then
  exit "$FIND_RC"
fi

EXPECTED=$(printf '%s\n' "$LEAVES" | grep -c . || true)

TMP="${INDEX}.tmp.$$"
trap 'rm -f "$TMP"' EXIT

awk -v leaves="$LEAVES" -v new="$NEW_STATUS" '
  BEGIN {
    n = split(leaves, arr, "\n")
    for (i = 1; i <= n; i++) {
      if (arr[i] != "") leafmap["(" arr[i] ")"] = 1
    }
  }
  {
    line = $0
    for (l in leafmap) {
      if (index(line, l) > 0) {
        if (match(line, /\| (draft|review|confirm) \|[[:space:]]*$/)) {
          line = substr(line, 1, RSTART - 1) "| " new " |"
        }
        break
      }
    }
    print line
  }
' "$INDEX" > "$TMP"

if [ ! -s "$TMP" ]; then
  echo "Error: tmp file empty after transform (aborting, INDEX.md unchanged)" >&2
  exit 4
fi

ACTUAL=0
while IFS= read -r leaf; do
  [ -z "$leaf" ] && continue
  if grep -F "(${leaf})" "$TMP" 2>/dev/null | grep -qE "\| ${NEW_STATUS} \|[[:space:]]*\$"; then
    ACTUAL=$((ACTUAL + 1))
  fi
done <<< "$LEAVES"

if [ "$ACTUAL" -ne "$EXPECTED" ]; then
  echo "Error: expected $EXPECTED status updates, got $ACTUAL (aborting, INDEX.md unchanged)" >&2
  exit 4
fi

mv "$TMP" "$INDEX"
trap - EXIT
echo "Updated $ACTUAL leaf row(s) to '$NEW_STATUS' in $INDEX"
exit 0
