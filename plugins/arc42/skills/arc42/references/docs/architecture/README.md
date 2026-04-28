---
file: architecture/README.md
purpose: arc42 12 챕터 인덱스 — CFRS 아키텍처 문서 진입점
template: arc42 (https://arc42.org)
last_updated: 2026-04-28
---

# CFRS Architecture (arc42)

본 디렉토리는 **arc42 v8** 템플릿의 12 챕터 구조를 따른다.
각 챕터는 정적·동적·배포·횡단·결정·품질·위험·용어 순으로 시스템을 다층 기술한다.

> **arc42**는 Gernot Starke·Peter Hruschka가 2005년 공개한 아키텍처 문서화 템플릿(CC 라이선스)으로, ISO/IEC/IEEE 42010의 실용 구현 중 하나이다. 학습 목적상 챕터를 빠뜨리지 않고 빈 구조라도 만들어 두며, 내용은 추출(`docs/0_plan.md` 등 원본)을 통해 점진적으로 채운다.

---

## 12 챕터 인덱스

| # | 디렉토리 | 한국어 명칭 | 역할 (Why this chapter exists) |
|---|---------|------------|-------------------------------|
| 1 | [1_introduction_and_goals/](./1_introduction_and_goals/) | 소개와 목표 | 시스템의 존재 이유·핵심 목표·이해관계자. 학습 목적과 미션크리티컬 정의 |
| 2 | [2_architecture_constraints/](./2_architecture_constraints/) | 아키텍처 제약사항 | 자유롭게 바꿀 수 없는 것 — 스택·인프라·법·조직·환경 제약 *(평탄)* |
| 3 | [3_system_scope_and_context/](./3_system_scope_and_context/) | 시스템 범위와 컨텍스트 | 시스템 경계·외부 인터페이스·사용자·**제공 기능 카탈로그(73 화면)** |
| 4 | [4_solution_strategy/](./4_solution_strategy/) | 솔루션 전략 | 큰 결정의 짧은 요약 — 기술·구조·품질·조직 4축 *(평탄)* |
| 5 | [5_building_block_view/](./5_building_block_view/) | 빌딩 블록 뷰 | 정적 분해 — 모노레포·FSD 레이어·MS 6개 |
| 6 | [6_runtime_view/](./6_runtime_view/) | 런타임 뷰 | 동적 시나리오 — 통신 그래프·인증 흐름·데이터 흐름 시나리오 *(시나리오는 사용자 정의, 평탄)* |
| 7 | [7_deployment_view/](./7_deployment_view/) | 배포 뷰 | 인프라 매핑 — K8s 클러스터·노드 배치·저장소·이미지 레지스트리 |
| 8 | [8_crosscutting_concepts/](./8_crosscutting_concepts/) | 횡단 관심사 | 모든 모듈에 공통 적용 — 보안·관측성·**좌표계(★ 한국 GIS 특이)** |
| 9 | [9_architecture_decisions/](./9_architecture_decisions/) | 아키텍처 결정사항 | ADR 기록 — Next.js 풀스택·PostGIS 단일·Python 배치 분리·Tibero 폐기 등 *(개별 ADR은 사용자 정의, 평탄)* |
| 10 | [10_quality_requirements/](./10_quality_requirements/) | 품질 요구사항 | 비기능 요건 — 가용성·성능·보안·관측성 학습 목표 |
| 11 | [11_risks_and_technical_debt/](./11_risks_and_technical_debt/) | 위험과 기술 부채 | SPOF·평문 Secret 허용·결정 보류 사항 *(평탄)* |
| 12 | [12_glossary/](./12_glossary/) | 용어집 | MS1~MS6, FSD 레이어, EPSG 번호, 도메인 용어 *(평탄)* |

---

## arc42 권장 서브섹션 구조

각 챕터 내부에 arc42 v8가 권장하는 절을 leaf md로 미리 배치했다. 서브섹션이 없는 평탄 챕터는 챕터명과 동일한 단일 md 하나만 둔다.

| 챕터 | 서브섹션(leaf md) |
|------|------------------|
| 1 | `1-1_requirements_overview.md`, `1-2_quality_goals.md`, `1-3_stakeholders.md` |
| 2 | `2_architecture_constraints.md` |
| 3 | `3-1_business_context.md`, `3-2_technical_context.md` |
| 4 | `4_solution_strategy.md` |
| 5 | `5-1_whitebox_overall_system.md`, `5-2_level_2.md`, `5-3_level_3.md` |
| 6 | `6_runtime_view.md` |
| 7 | `7-1_infrastructure_level_1.md`, `7-2_infrastructure_level_2.md` |
| 8 | `8-1_domain_concepts.md`, `8-2_user_experience_concepts.md`, `8-3_safety_and_security_concepts.md`, `8-4_architecture_and_design_patterns.md`, `8-5_under_the_hood.md`, `8-6_development_concepts.md`, `8-7_operational_concepts.md` |
| 9 | `9_architecture_decisions.md` |
| 10 | `10-1_quality_tree.md`, `10-2_quality_scenarios.md` |
| 11 | `11_risks_and_technical_debt.md` |
| 12 | `12_glossary.md` |

---

## 원본 문서 → arc42 챕터 매핑

추출 진행 시점 가이드. 각 챕터 README나 본문에서 "출처: `docs/0a#1-13`" 식으로 anchor를 명시한다.

| 원본(`docs/`) | 매핑 챕터 |
|--------------|----------|
| `0_plan.md` 학습 목적·정의 | #1 |
| `0_plan.md#0-2` 핵심 변경점 | #4, #9 |
| `0a#1-1` 코드 구성/런타임 토폴로지 | #5(정적), #7(런타임) |
| `0a#1-2` 통신 그래프·포트 | #6 |
| `0a#1-3` 네임스페이스 / `0a#1-4` 노드 배치 | #7 |
| `0a#1-5` 데이터 흐름 시나리오 | #6 |
| `0a#1-6` 저장소 토폴로지 | #7 |
| `0a#1-7` 스케일링·HA / `0a#1-8` 장애 도메인 | #10 |
| `0a#1-9` 보안 경계 | #8 |
| `0a#1-10` 외부 경계/폐쇄망 | #3 |
| `0a#1-11` 관측성 | #8 |
| `0a#1-12` 이미지 레지스트리 | #7 |
| `0a#1-13` 좌표계 정책 | **#8 (별도 파일 강력 유지)** |
| `0a#1-14` MSA 절충 | #4(요지), #9(상세) |
| `0b_stack.md` | #2 |
| `0c_directory.md` | #5 |
| `0d_microservices.md` 설계 절(스키마·data_dir·SLD 등) | #5 |
| `0d_microservices.md` 구체 yml/REST/명령 | **`workflow/`로 이동** (architecture 비포함) |
| `0e_migration.md` | `workflow/runbook/` (해당 Phase에 산개 흡수, 결정 보류는 #11) |
| `0e#5-2` 결정 보류 | #11 |
| `0f_bootstrap.md` | `workflow/installation/0_infra_bootstrap/` |
| `0f#6-6` 부트스트랩 결정 보류 | #11 |

---

## 명명 규칙

- 디렉토리명: arc42 공식 영어 챕터명을 lowercase snake_case로 직역. `1_introduction_and_goals`처럼 챕터 번호 prefix 부여.
- 깊이별 번호: `n`(챕터) → `n-n`(절) → `n-n-n`(소절). 본문 헤딩에 적용.
- 파일명: 챕터 내 절을 별도 파일로 분리할 경우 `1_xxx.md`, `2_xxx.md` 등 절 번호로 시작.
- frontmatter: `source:` 필드에 원본 anchor(`docs/0a#1-13`) 명시 — 추적성 확보.

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

> 상태 전이는 사용자 요청·승인에 의해서만 변경. LLM 자율 변경 금지. 작성 또는 수정 시 본 표만 갱신하며 frontmatter에는 status 필드를 두지 않는다.

---

## 작업 정책

- **architecture/는 "이론·설계·정책"만**. 구체 yml·shell 명령·DDL은 `workflow/`로 분기.
- 추출은 점진적. arc42 권장 서브섹션은 빈 leaf md로 선배치되어 있으며, 평탄 챕터는 챕터명과 동일한 단일 md를 둔다.
- 원본 `docs/0*.md`는 추출 완료 후 archive/ 이동 또는 삭제 결정 (현재는 진실 백업으로 보존).
- 각 챕터에 자체 README.md를 두어 챕터 내부 구조와 추출 진척을 명시한다(권장, 선택).
