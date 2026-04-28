---
file: docs/architecture/README.md
title: Architecture (arc42)
last_updated: {{TODAY}}
---

# Architecture (arc42)

본 디렉토리는 arc42 v8 12 챕터 구조를 따른다.

> **arc42**는 Gernot Starke·Peter Hruschka가 2005년 공개한 아키텍처 문서화 템플릿(CC 라이선스)으로, ISO/IEC/IEEE 42010의 실용 구현 중 하나. 학습 목적상 챕터를 빠뜨리지 않고 빈 구조라도 만들어 두며, 내용은 추출(`docs/source/` 자료)을 통해 점진적으로 채운다.

---

## 12 챕터 인덱스

| # | 디렉토리 | 한국어 명칭 | 역할 |
|---|---------|------------|------|
| 1 | `1_introduction_and_goals/` | 소개와 목표 | 시스템의 존재 이유·핵심 목표·이해관계자 |
| 2 | `2_architecture_constraints/` | 아키텍처 제약사항 | 자유롭게 바꿀 수 없는 것 — 스택·인프라·법·조직·환경 |
| 3 | `3_system_scope_and_context/` | 시스템 범위와 컨텍스트 | 시스템 경계·외부 인터페이스·사용자·기능 카탈로그 |
| 4 | `4_solution_strategy/` | 솔루션 전략 | 큰 결정의 짧은 요약 — 기술·구조·품질·조직 4축 |
| 5 | `5_building_block_view/` | 빌딩 블록 뷰 | 정적 분해 — 모듈·컴포넌트 |
| 6 | `6_runtime_view/` | 런타임 뷰 | 동적 시나리오 — 통신·플로우 |
| 7 | `7_deployment_view/` | 배포 뷰 | 인프라 매핑 — 노드·환경·저장소 |
| 8 | `8_crosscutting_concepts/` | 횡단 관심사 | 모든 모듈에 공통 적용 — 보안·관측성·도메인 정책 |
| 9 | `9_architecture_decisions/` | 아키텍처 결정사항 | ADR 기록 |
| 10 | `10_quality_requirements/` | 품질 요구사항 | 비기능 요건 |
| 11 | `11_risks_and_technical_debt/` | 위험과 기술 부채 | SPOF·결정 보류·부채 |
| 12 | `12_glossary/` | 용어집 | 도메인·기술 용어 |

---

## 진척 표

추출 진행 상태 단일 진실 소스. 사용자 검토·승인 결과를 본 표에 반영. (frontmatter `status`는 사용 안 함.)

상태 표기 (3단계):
- `draft` — 골격 생성 직후 (`create`).
- `review` — 본문 작성됨 (`update <id>` 후 자동).
- `confirm` — 사용자 검토·승인 완료 (`confirm <id>` 명령에서만).

| # | leaf 경로 | 상태 |
|---|----------|:----:|
| 1-1 | `1_introduction_and_goals/1-1_requirements_overview.md` | draft |
| 1-2 | `1_introduction_and_goals/1-2_quality_goals.md` | draft |
| 1-3 | `1_introduction_and_goals/1-3_stakeholders.md` | draft |
| 2 | `2_architecture_constraints/2_architecture_constraints.md` | draft |
| 3-1 | `3_system_scope_and_context/3-1_business_context.md` | draft |
| 3-2 | `3_system_scope_and_context/3-2_technical_context.md` | draft |
| 4 | `4_solution_strategy/4_solution_strategy.md` | draft |
| 5-1 | `5_building_block_view/5-1_whitebox_overall_system.md` | draft |
| 5-2 | `5_building_block_view/5-2_level_2.md` | draft |
| 5-3 | `5_building_block_view/5-3_level_3.md` | draft |
| 6 | `6_runtime_view/6_runtime_view.md` | draft |
| 7-1 | `7_deployment_view/7-1_infrastructure_level_1.md` | draft |
| 7-2 | `7_deployment_view/7-2_infrastructure_level_2.md` | draft |
| 8-1 | `8_crosscutting_concepts/8-1_domain_concepts.md` | draft |
| 8-2 | `8_crosscutting_concepts/8-2_user_experience_concepts.md` | draft |
| 8-3 | `8_crosscutting_concepts/8-3_safety_and_security_concepts.md` | draft |
| 8-4 | `8_crosscutting_concepts/8-4_architecture_and_design_patterns.md` | draft |
| 8-5 | `8_crosscutting_concepts/8-5_under_the_hood.md` | draft |
| 8-6 | `8_crosscutting_concepts/8-6_development_concepts.md` | draft |
| 8-7 | `8_crosscutting_concepts/8-7_operational_concepts.md` | draft |
| 9 | `9_architecture_decisions/9_architecture_decisions.md` | draft |
| 10-1 | `10_quality_requirements/10-1_quality_tree.md` | draft |
| 10-2 | `10_quality_requirements/10-2_quality_scenarios.md` | draft |
| 11 | `11_risks_and_technical_debt/11_risks_and_technical_debt.md` | draft |
| 12 | `12_glossary/12_glossary.md` | draft |

> 상태 전이는 사용자 요청·승인에 의해서만 변경. LLM 자율 변경 금지. 본 표만 갱신하며 frontmatter에 status 필드를 두지 않는다.
