---
file: docs/INDEX.md
title: 문서 인덱스
last_updated: {{TODAY}}
---

# 문서 인덱스

프로젝트 문서의 진척 상태를 단일 진실 소스로 관리하는 인덱스. 현재 `architecture/` (arc42 v8 12 챕터) 를 추적하며, `workflow/` 영역의 산출물도 동일 표에 통합 가능하다.

---

## 작업 정책

- **architecture/는 "이론·설계·정책"만**. 구체 yml·shell 명령·DDL 은 `workflow/` 로 분기.
- 추출은 점진적. 빈 leaf md 가 선배치(평탄 챕터는 챕터명과 동일한 단일 md)되어 있으며, 사용자가 `.claude/docs/source/` 에 둔 원본 자료에서 본문을 점진적으로 채운다. 추출 완료 후 source/ 보존·아카이브 결정은 사용자에게 위임.
- 각 챕터에 자체 `README.md` 를 두어 챕터 내부 구조와 추출 진척을 명시할 수 있다 (권장, 선택).
- **상태 전이는 사용자 요청·승인에 의해서만 변경.** LLM 자율 변경 금지.

---

## 인덱스

상태 표기 (3단계):

- `draft` — 골격 생성 직후 (`create`)
- `review` — 본문 작성됨 (`update <id>` 후 자동)
- `confirm` — 사용자 검토·승인 완료 (`confirm <id>` 명령에서만)

| # | 제목 | 경로 | 역할 | 상태 |
|---|------|------|------|:----:|
| 1 | 소개와 목표 | architecture/1_introduction_and_goals | 시스템의 존재 이유·핵심 목표·이해관계자 | - |
| 1-1 | 요구사항 개요 | [1-1_requirements_overview.md](./architecture/1_introduction_and_goals/1-1_requirements_overview.md) | 시스템 요구사항 컨텍스트 요약 | draft |
| 1-2 | 품질 목표 | [1-2_quality_goals.md](./architecture/1_introduction_and_goals/1-2_quality_goals.md) | 핵심 품질 속성 우선순위 | draft |
| 1-3 | 이해관계자 | [1-3_stakeholders.md](./architecture/1_introduction_and_goals/1-3_stakeholders.md) | 주요 이해관계자·기대사항·관심사 | draft |
| 2 | 아키텍처 제약사항 | [2_architecture_constraints.md](./architecture/2_architecture_constraints/2_architecture_constraints.md) | 자유롭게 바꿀 수 없는 것 — 스택·인프라·법·조직·환경 | draft |
| 3 | 시스템 범위와 컨텍스트 | architecture/3_system_scope_and_context | 시스템 경계·외부 인터페이스·사용자·기능 카탈로그 | - |
| 3-1 | 비즈니스 컨텍스트 | [3-1_business_context.md](./architecture/3_system_scope_and_context/3-1_business_context.md) | 외부 비즈니스 인터페이스·행위자 | draft |
| 3-2 | 기술 컨텍스트 | [3-2_technical_context.md](./architecture/3_system_scope_and_context/3-2_technical_context.md) | 외부 기술 인터페이스·프로토콜 | draft |
| 4 | 솔루션 전략 | [4_solution_strategy.md](./architecture/4_solution_strategy/4_solution_strategy.md) | 큰 결정의 짧은 요약 — 기술·구조·품질·조직 4축 | draft |
| 5 | 빌딩 블록 뷰 | architecture/5_building_block_view | 정적 분해 — 모듈·컴포넌트 | - |
| 5-1 | 화이트박스 전체 시스템 | [5-1_whitebox_overall_system.md](./architecture/5_building_block_view/5-1_whitebox_overall_system.md) | 시스템 최상위 분해 | draft |
| 5-2 | 레벨 2 | [5-2_level_2.md](./architecture/5_building_block_view/5-2_level_2.md) | 주요 빌딩블록 내부 구조 | draft |
| 5-3 | 레벨 3 | [5-3_level_3.md](./architecture/5_building_block_view/5-3_level_3.md) | 핵심 컴포넌트 내부 구조 | draft |
| 6 | 런타임 뷰 | [6_runtime_view.md](./architecture/6_runtime_view/6_runtime_view.md) | 동적 시나리오 — 통신·플로우 | draft |
| 7 | 배포 뷰 | architecture/7_deployment_view | 인프라 매핑 — 노드·환경·저장소 | - |
| 7-1 | 인프라 레벨 1 | [7-1_infrastructure_level_1.md](./architecture/7_deployment_view/7-1_infrastructure_level_1.md) | 최상위 인프라 토폴로지 | draft |
| 7-2 | 인프라 레벨 2 | [7-2_infrastructure_level_2.md](./architecture/7_deployment_view/7-2_infrastructure_level_2.md) | 노드별 상세 매핑 | draft |
| 8 | 횡단 관심사 | architecture/8_crosscutting_concepts | 모든 모듈에 공통 적용 — 보안·관측성·도메인 정책 | - |
| 8-1 | 도메인 개념 | [8-1_domain_concepts.md](./architecture/8_crosscutting_concepts/8-1_domain_concepts.md) | 도메인 모델·핵심 개념 | draft |
| 8-2 | 사용자 경험 개념 | [8-2_user_experience_concepts.md](./architecture/8_crosscutting_concepts/8-2_user_experience_concepts.md) | UI/UX 패턴·접근성 | draft |
| 8-3 | 안전·보안 개념 | [8-3_safety_and_security_concepts.md](./architecture/8_crosscutting_concepts/8-3_safety_and_security_concepts.md) | 안전·보안 정책·위협 모델 | draft |
| 8-4 | 아키텍처·설계 패턴 | [8-4_architecture_and_design_patterns.md](./architecture/8_crosscutting_concepts/8-4_architecture_and_design_patterns.md) | 표준 패턴·이디엄 | draft |
| 8-5 | 내부 동작 개념 | [8-5_under_the_hood.md](./architecture/8_crosscutting_concepts/8-5_under_the_hood.md) | 내부 구현 디테일 | draft |
| 8-6 | 개발 개념 | [8-6_development_concepts.md](./architecture/8_crosscutting_concepts/8-6_development_concepts.md) | 개발 프로세스·테스팅·빌드 | draft |
| 8-7 | 운영 개념 | [8-7_operational_concepts.md](./architecture/8_crosscutting_concepts/8-7_operational_concepts.md) | 배포·운영·모니터링 | draft |
| 9 | 아키텍처 결정사항 | [9_architecture_decisions.md](./architecture/9_architecture_decisions/9_architecture_decisions.md) | ADR 기록 | draft |
| 10 | 품질 요구사항 | architecture/10_quality_requirements | 비기능 요건 | - |
| 10-1 | 품질 트리 | [10-1_quality_tree.md](./architecture/10_quality_requirements/10-1_quality_tree.md) | ISO 25010 품질 속성 트리 | draft |
| 10-2 | 품질 시나리오 | [10-2_quality_scenarios.md](./architecture/10_quality_requirements/10-2_quality_scenarios.md) | 측정 가능한 품질 시나리오 | draft |
| 11 | 위험과 기술 부채 | [11_risks_and_technical_debt.md](./architecture/11_risks_and_technical_debt/11_risks_and_technical_debt.md) | SPOF·결정 보류·부채 | draft |
| 12 | 용어집 | [12_glossary.md](./architecture/12_glossary/12_glossary.md) | 도메인·기술 용어 | draft |

---
