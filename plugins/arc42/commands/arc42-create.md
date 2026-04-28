---
description: arc42 표준 문서 골격을 .claude/docs/ 로 생성
allowed-tools: Bash, Read, Glob
user-invocable: true
disable-model-invocation: false
---

`arc42` 스킬의 **create** 모드를 실행합니다.

수행:
1. 프로젝트 루트와 본 스킬 디렉토리의 절대경로를 산출
2. 충돌 검사 — `$PROJECT_ROOT/.claude/docs` 가 어떤 형태로든 존재하면 차단
3. `references/docs/` 템플릿을 `.claude/docs/` 로 복사
4. 사용자 작업 폴더 `.claude/docs/source/` 를 `mkdir -p` 로 보장
5. 모든 `.md` 파일 안의 `{{TODAY}}` placeholder 를 오늘 날짜(`YYYY-MM-DD`)로 일괄 치환
6. 결과를 사용자에게 보고

상세 절차는 `skills/arc42/SKILL.md` 의 "create" 섹션을 따르세요.
