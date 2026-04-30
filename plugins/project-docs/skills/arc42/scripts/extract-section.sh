#!/bin/bash
# extract-section.sh
# 마크다운 파일에서 지정 헤더 섹션의 본문을 변형 없이 stdout 으로 출력.
# 시작 경계: <header> 라인 직후
# 종료 경계: 다음 "## " 로 시작하는 같은 레벨 헤더 직전 (또는 EOF)
#
# 사용 예:
#   extract-section.sh .claude/docs/INDEX.md "## 인덱스"
#
# 종료 코드:
#   0  성공
#   1  잘못된 인자
#   2  파일 없음
#   3  헤더 없음

set -euo pipefail

show_usage() {
  cat <<'EOF'
Usage: extract-section.sh <file> <header>

마크다운 파일에서 <header> 라인 다음부터 다음 "## " 헤더 직전까지를 변형 없이 출력.

Arguments:
  <file>    마크다운 파일 경로
  <header>  정확한 헤더 라인 (예: "## 인덱스")

Examples:
  extract-section.sh .claude/docs/INDEX.md "## 인덱스"

Exit codes:
  0  성공
  1  인자 누락
  2  파일 없음
  3  헤더 없음
EOF
  exit 0
}

if [ $# -eq 0 ] || [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  show_usage
fi

if [ $# -lt 2 ]; then
  echo "Error: missing arguments (need <file> <header>)" >&2
  echo "Run with -h for usage" >&2
  exit 1
fi

FILE="$1"
HEADER="$2"

if [ ! -f "$FILE" ]; then
  echo "Error: file not found: $FILE" >&2
  exit 2
fi

if ! grep -Fxq "$HEADER" "$FILE"; then
  echo "Error: header not found in $FILE: $HEADER" >&2
  exit 3
fi

awk -v target="$HEADER" '
  $0 == target { flag=1; next }
  flag && /^## / { exit }
  flag { print }
' "$FILE"
