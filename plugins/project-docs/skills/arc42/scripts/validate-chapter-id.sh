#!/bin/bash
# validate-chapter-id.sh
# arc42 chapter-id 형식 검증.
# 허용 형식:
#   N      — N 은 1~12 (예: 1, 8, 12) — 챕터 또는 평탄 챕터의 단일 leaf
#   N-M    — N 은 1~12, M 은 1~9   (예: 1-1, 8-7, 10-2) — 단일 sub leaf
#
# 종료 코드:
#   0  유효
#   1  인자 누락
#   2  형식 오류

set -euo pipefail

show_usage() {
  cat <<'EOF'
Usage: validate-chapter-id.sh <chapter-id>

arc42 chapter-id 형식 검증.

Allowed formats:
  N      where 1 <= N <= 12              (예: 1, 8, 12)
  N-M    where 1 <= N <= 12, 1 <= M <= 9 (예: 1-1, 8-7, 10-2)

Exit codes:
  0  유효
  1  인자 누락
  2  형식 오류
EOF
  exit 0
}

if [ $# -eq 0 ] || [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  show_usage
fi

ID="$1"

if [[ "$ID" =~ ^([1-9]|1[0-2])(-[1-9])?$ ]]; then
  exit 0
fi

echo "Error: invalid chapter-id format: $ID" >&2
echo "Allowed: N (1-12) or N-M (N: 1-12, M: 1-9). Examples: 1, 1-1, 8-7, 10-2, 12" >&2
exit 2
