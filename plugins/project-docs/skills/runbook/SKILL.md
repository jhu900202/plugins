---
name: runbook
description: 프로젝트 설치·구현·운영 절차를 runbook 표준으로 작성·관리. 사용자가 "K8s 설치 절차", "PostGIS 셋업 매뉴얼", "인프라 부트스트랩", "기능 구현 단계", "데이터 적재 절차", "운영 매뉴얼", "백업 절차", "모니터링 알림", "runbook 진척", "installation 갱신", "implementation 추가" 같은 요청을 할 때 사용. 본 스킬은 architecture 진술서를 직접 Read 하여 procedures 를 도출하므로, /arc42-source 같은 외부 자료 추출 파이프라인을 거치지 않는다.
allowed-tools: Read, Write, Edit, Bash, Glob
---

# runbook

프로젝트의 "어떻게(HOW)" — 설치·구현·운영 절차 — 를 단계 단위로 작성·갱신한다. arc42 스킬이 산출한 `.claude/docs/architecture/` 를 입력으로 직접 소비하며, 별도 source 파이프라인을 갖지 않는다.

## 진입 매핑

| 자연어 | 동작 |
|---|---|
| "K8s 설치 절차 추가", "PostGIS 셋업" | `installation/<n>_<topic>.md` 작성 |
| "기능 구현 단계", "Auth.js 설정 절차" | `implementation/<n>_<feature>.md` 작성 |
| "runbook 진척", "운영 매뉴얼 진척" | `INDEX.md` 표 출력 |
| "백업·모니터링·알림 운영" | `implementation/<n>_operations.md` 작성 |

## 도메인 경계

| 본 스킬 | 다른 스킬 |
|---|---|
| 명령행·yml·shell·DDL — "어떻게" | arc42 스킬 — "왜·무엇" (decisions, building blocks, deployment view) |
| installation/ — 1회성 플랫폼 셋업 (OS·K8s·인프라) | architecture/ — 의사결정·정책·다이어그램 |
| implementation/ — 기능 구현·일상 운영 절차 | architecture/ — 절차의 근거가 되는 결정 |

## 입력 출처

- `.claude/docs/architecture/` 의 leaf 들 (arc42-update 가 작성한 markdown). 직접 Read 로 소비.
- 외부 vendor 문서·OCR 자료 추출이 필요해지면 본 스킬 범위 외 (별도 결정 필요).

## confirm 자연어 진입 차단

`confirm`(검토 승인)은 자연어 진입 금지 — 사용자가 직접 `/runbook-confirm <item-id>` 슬래시 명시 호출을 입력해야 한다 (해당 커맨드는 점진적 추가 시점에 정의).
