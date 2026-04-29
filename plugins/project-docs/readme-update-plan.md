# README.md 갱신 계획

본 문서는 `plugins/project-docs/README.md` 의 갱신 항목 작업 계획이다. `arc42-update-plan.md` / `arc42-source-plan.md` 의 내부 구현이 완료된 직후 본 계획을 실행한다. 갱신 완료 후 본 파일은 삭제된다.

`README.md` 자체는 플러그인 단일 진입점 문서로 영구 유지되며, 본 문서는 그 갱신 작업의 임시 메모일 뿐이다.

본 README 는 이제 **두 스킬(`arc42` + `runbook`)** 을 안내해야 한다 (플러그인 멀티 스킬 분화 후).

## 갱신 시점 (선행 조건)

다음이 모두 끝난 직후 본 계획을 실행:

1. `arc42-update-plan.md` 내용을 `commands/arc42-update.md` 로 인라인 이전 + 깨진 참조 정정
2. `commands/arc42-source.md` 신규 생성
3. `plugins/project-docs/skills/arc42/scripts/` 구현 (또는 최소 스켈레톤)
4. `skills/arc42/SKILL.md` 갱신 (스크립트 진입점·새 커맨드 명시)
5. 두 plan 파일(`arc42-update-plan.md`, `arc42-source-plan.md`) 삭제

이 단계 이전에 README 를 갱신하면 구현과 표류할 위험이 크다.

## 갱신 항목 체크리스트

### 1. 플러그인 이름·범위 (README 인트로)

- [ ] 플러그인 이름 `arc42` → `project-docs` 갱신
- [ ] 플러그인 범위를 "프로젝트 문서 (arc42 아키텍처 + runbook 절차)" 로 재기술
- [ ] 두 스킬 안내 한 단락 추가 — `arc42` 스킬 (architecture 문서) + `runbook` 스킬 (installation + implementation 절차)

### 2. "## 모드" 표 (현재 README L7~12)

- [ ] `/arc42-source` 항목 신규 추가 — 동작: "`.claude/docs/architecture/source/` 의 다양한 확장자 산출물을 파편화된 .md 로 추출·검증하는 파이프라인 실행"
- [ ] `/arc42-update <chapter-id>` 항목 동작 설명 갱신 — "`.claude/docs/source/` 자료를 기반으로" → "`/arc42-source` 산출물(파편화된 .md) 또는 source/ 부재 시 백지 작성으로 챕터 본문 작성"
- [ ] runbook 스킬 자연어 활성화 안내 ("K8s 설치 절차", "기능 구현 단계" 등 트리거)

### 2. "## 진척 상태" 섹션 (현재 README L16~20)

- [ ] 변경 없음 예상 — 진척 상태 모델은 그대로

### 3. "## 표준 경로 (생성물)" 섹션 (현재 README L22~29)

- [ ] 두 스킬 분리 트리로 재작성:
  ```
  .claude/docs/
  ├── architecture/             ← arc42 스킬 산출
  │   ├── INDEX.md
  │   ├── source/               (/arc42-source 입력 작업 공간)
  │   │   ├── _pipeline-state.md
  │   │   ├── _file-list.md
  │   │   ├── _converted/
  │   │   ├── _fragments/
  │   │   ├── _fragment-list.md
  │   │   ├── _verify/
  │   │   └── _verify-report.md
  │   └── (12 챕터 디렉토리)
  └── runbook/                  ← runbook 스킬 산출
      ├── INDEX.md
      ├── README.md
      ├── installation/
      └── implementation/
  ```
- [ ] 산출물 표시 정책 결정 — 위 전체 표시 vs. "파이프라인 산출물 디렉토리/파일은 SKILL.md 참조" 한 줄로 단축

### 4. "## 트리거 예시" 섹션 (현재 README L31~35)

- [ ] arc42 스킬 트리거 (기존): `/arc42-update 1-1`, "1-1 챕터 작성해줘"
- [ ] `/arc42-source` 트리거 추가 — `/arc42-source` 또는 "source 자료 처리"
- [ ] runbook 스킬 자연어 트리거 추가 — "K8s 설치 절차 추가", "PostGIS 셋업 매뉴얼", "Auth.js 설정 절차" 등
- [ ] 라우팅 충돌 회피 가이드: "챕터" / "leaf" / "arc42" 키워드 → arc42, "절차" / "매뉴얼" / "설치" / "구현" / "운영" → runbook

### 5. "## 원칙" 섹션 (현재 README L37~44)

- [ ] **L43 "5. `update`는 항상 source 전체 우선 스캔" 갱신** — 새 동작에 맞게 변경:
  - 후보 1: "5. `update`는 source 파이프라인 산출물(`/arc42-source` 결과)을 우선 진입, 부재 시 source/ 디렉토리 직접 스캔(구버전 호환)"
  - 후보 2: "5. source 파이프라인 우선 진입, 부재 시 백지 작성"
- [ ] 새 원칙 추가 검토:
  - "7. source 파이프라인은 결정론적 추출만 담당, 추론 개입 없음" (책임 분리 원칙 명시)
  - "8. 빈 source/ 에서 `/arc42-source` 는 엄격 거부, conception 모드는 `/arc42-update` 직접 호출로 라우팅"

### 6. "## 참조" 섹션 (현재 README L46~49)

- [ ] arc42 공식 사이트 링크 유지
- [ ] SKILL.md 링크 유지
- [ ] 새 커맨드 파일(`commands/arc42-source.md`) 직접 링크 추가 검토 (또는 SKILL.md 만 진입점으로 두고 이중 게재 회피)

## 검증 항목 (갱신 후 자체 점검)

- [ ] README 에 명시된 모든 슬래시 커맨드가 `commands/` 하위에 실제 존재
- [ ] README 트리거 예시가 SKILL.md / 커맨드 frontmatter 와 일치
- [ ] README 가 plan 파일을 참조하지 않음 (plan 은 삭제 예정 자원이므로)
- [ ] 표준 경로 트리가 실제 `/arc42-create` + `/arc42-source` 실행 결과와 일치

## 본 파일 삭제 시점

위 체크리스트 모두 완료 + 검증 통과 후 즉시 본 파일 삭제. 삭제 후 `plugins/project-docs/` 하위에는 README.md 만 남는다 (plan 3종 + plugin-restructure-plan 모두 정리 완료 상태).
