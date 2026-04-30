#!/bin/bash
# find-leaf.sh
# INDEX.md 표에서 chapter-id 에 해당하는 leaf 파일 경로(들)을 출력.
#
# 입력:
#   "1-1" → 정확히 일치하는 단일 leaf 경로
#   "1"   → 1 챕터의 모든 leaf (평탄 챕터는 단일 leaf)
#
# 출력: 한 줄당 하나의 경로 (INDEX.md 표 안의 마크다운 링크 path 그대로)
#
# 종료 코드:
#   0  매치 1개 이상
#   1  인자 누락 또는 형식 오류
#   2  INDEX.md 없음
#   3  매치 없음

set -euo pipefail

show_usage() {
  cat <<'EOF'
Usage: find-leaf.sh <chapter-id> [INDEX.md]

INDEX.md 인덱스 표에서 chapter-id 에 해당하는 leaf 파일 경로(들)을 출력.

Arguments:
  <chapter-id>  형식: "N" (1~12) 또는 "N-M" (1<=N<=12, 1<=M<=9)
  [INDEX.md]    INDEX.md 경로. 기본값: .claude/docs/INDEX.md

Behavior:
  "1-1" → 정확히 일치하는 단일 leaf 경로 출력
  "1"   → 1 챕터의 모든 leaf 출력 (평탄 챕터는 단일 leaf)
  챕터 요약 행(상태 "-")은 마크다운 링크가 없어 자동 제외됨.

Exit codes:
  0  매치 1개 이상
  1  잘못된 인자
  2  INDEX.md 없음
  3  매치 없음
EOF
  exit 0
}

if [ $# -eq 0 ] || [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  show_usage
fi

ID="$1"
INDEX="${2:-.claude/docs/INDEX.md}"

if [[ "$ID" =~ ^([1-9]|1[0-2])-[1-9]$ ]]; then
  ROW_PATTERN="^\| ${ID} \|"
elif [[ "$ID" =~ ^([1-9]|1[0-2])$ ]]; then
  ROW_PATTERN="^\| ${ID}(-[1-9])? \|"
else
  echo "Error: invalid chapter-id format: $ID" >&2
  echo "Allowed: N (1-12) or N-M (N: 1-12, M: 1-9)" >&2
  exit 1
fi

if [ ! -f "$INDEX" ]; then
  echo "Error: INDEX.md not found: $INDEX" >&2
  exit 2
fi

RESULTS=$(grep -E "$ROW_PATTERN" "$INDEX" | grep -oE '\([^)]+\.md\)' | sed -e 's/^(//' -e 's/)$//' || true)

if [ -z "$RESULTS" ]; then
  echo "Error: no leaf found for chapter-id: $ID (in $INDEX)" >&2
  exit 3
fi

echo "$RESULTS"
exit 0
