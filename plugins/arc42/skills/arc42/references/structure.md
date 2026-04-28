# 디렉토리 구조 사양

`create` 모드가 생성하는 디렉토리·파일 표준. arc42 v8 12 챕터 골격에 더해 arc42 외 영역인 workflow 분기와 사용자 작업용 source 폴더를 함께 만든다.

## 1. arc42 12 챕터 (기본 산출물)

```
.claude/docs/architecture/
├── README.md                              # 12 챕터 인덱스 + 진척 표 + 명명 규칙
├── 1_introduction_and_goals/
│   ├── 1-1_requirements_overview.md
│   ├── 1-2_quality_goals.md
│   └── 1-3_stakeholders.md
├── 2_architecture_constraints/
│   └── 2_architecture_constraints.md
├── 3_system_scope_and_context/
│   ├── 3-1_business_context.md
│   └── 3-2_technical_context.md
├── 4_solution_strategy/
│   └── 4_solution_strategy.md
├── 5_building_block_view/
│   ├── 5-1_whitebox_overall_system.md
│   ├── 5-2_level_2.md
│   └── 5-3_level_3.md
├── 6_runtime_view/
│   └── 6_runtime_view.md
├── 7_deployment_view/
│   ├── 7-1_infrastructure_level_1.md
│   └── 7-2_infrastructure_level_2.md
├── 8_crosscutting_concepts/
│   ├── 8-1_domain_concepts.md
│   ├── 8-2_user_experience_concepts.md
│   ├── 8-3_safety_and_security_concepts.md
│   ├── 8-4_architecture_and_design_patterns.md
│   ├── 8-5_under_the_hood.md
│   ├── 8-6_development_concepts.md
│   └── 8-7_operational_concepts.md
├── 9_architecture_decisions/
│   └── 9_architecture_decisions.md
├── 10_quality_requirements/
│   ├── 10-1_quality_tree.md
│   └── 10-2_quality_scenarios.md
├── 11_risks_and_technical_debt/
│   └── 11_risks_and_technical_debt.md
└── 12_glossary/
    └── 12_glossary.md
```

### 챕터·서브섹션 표 (arc42 v8 표준 매핑)

| 챕터 | 디렉토리 슬러그 | 서브섹션(leaf) |
|------|---------------|--------------|
| 1 | `1_introduction_and_goals` | `1-1_requirements_overview`, `1-2_quality_goals`, `1-3_stakeholders` |
| 2 | `2_architecture_constraints` | `2_architecture_constraints` *(평탄)* |
| 3 | `3_system_scope_and_context` | `3-1_business_context`, `3-2_technical_context` |
| 4 | `4_solution_strategy` | `4_solution_strategy` *(평탄)* |
| 5 | `5_building_block_view` | `5-1_whitebox_overall_system`, `5-2_level_2`, `5-3_level_3` |
| 6 | `6_runtime_view` | `6_runtime_view` *(평탄, 시나리오는 사용자 정의)* |
| 7 | `7_deployment_view` | `7-1_infrastructure_level_1`, `7-2_infrastructure_level_2` |
| 8 | `8_crosscutting_concepts` | `8-1_domain_concepts`, `8-2_user_experience_concepts`, `8-3_safety_and_security_concepts`, `8-4_architecture_and_design_patterns`, `8-5_under_the_hood`, `8-6_development_concepts`, `8-7_operational_concepts` |
| 9 | `9_architecture_decisions` | `9_architecture_decisions` *(평탄, 개별 ADR은 사용자 정의)* |
| 10 | `10_quality_requirements` | `10-1_quality_tree`, `10-2_quality_scenarios` |
| 11 | `11_risks_and_technical_debt` | `11_risks_and_technical_debt` *(평탄)* |
| 12 | `12_glossary` | `12_glossary` *(평탄)* |

## 2. workflow (arc42 외 확장)

기본 산출물에 함께 생성된다.

```
.claude/docs/workflow/
├── README.md                              # 분할 의도·경계·전역 의존 순서
├── installation/
│   └── README.md                          # 1회성 플랫폼 설치 영역
└── runbook/
    └── README.md                          # 기능 cookbook + 일상 운영 영역
```

각 README는 명령행·yml·shell이 주가 됨을 명시하고 architecture 챕터를 cross-reference한다.

> 주의: workflow 분기·installation/runbook 명명·세부 디렉토리 구조는 **arc42 표준 외**. 운영 매뉴얼·플레이북 영역의 보편 관행이며, 본 스킬은 빈 골격만 제공하고 세부 구조는 사용자가 프로젝트 맥락에 맞게 정의한다.

## 3. source 폴더 (사용자 자료 작업 공간)

```
.claude/docs/source/
├── README.md                              # 사용 안내
└── .gitkeep
```

- 사용자가 **분석 자료(.md, .pdf 텍스트, 회의록, 기획서 등)를 직접 복사**해 두는 폴더.
- `update <chapter-id>` 실행 시 본 폴더 내 모든 .md 파일이 출처 후보로 스캔된다.
- 자료 파일 형식·이름·구조는 자유. 단 .md가 아닌 형식은 사전에 .md로 변환해야 함.
- 챕터 추출 완료 후 본 폴더는 사용자 결정에 따라 보존·archive·삭제.

README.md 내용 예시:
```
# Source — 분석 자료 작업 폴더

본 폴더는 arc42 챕터 추출 시 참조되는 원본 자료 보관소다.
- `update <chapter-id>` 실행 시 이 폴더의 모든 .md 파일이 스캔된다.
- 자료를 자유롭게 추가·수정·삭제하라.
- 챕터별 추출이 완료되면 본 폴더는 정리 또는 archive 결정.
```

## 4. 인덱스 표 (`docs/INDEX.md` 내부)

`docs/INDEX.md` 본문에 다음 형식의 표를 포함한다. 상태는 텍스트(`draft`/`review`/`confirm`)만 사용하며 이모지를 쓰지 않는다.

| # | leaf 경로 | 상태 |
|---|----------|:----:|
| 1-1 | `1_introduction_and_goals/1-1_requirements_overview.md` | draft |
| 1-2 | `1_introduction_and_goals/1-2_quality_goals.md` | draft |
| ... | ... | ... |

상태 의미:
- `draft` — 골격 생성 직후 (`create`).
- `review` — 본문이 작성됨 (`update <id>` 후 자동).
- `confirm` — 사용자가 검토·승인 (`confirm <id>` 명령에서만).

LLM은 `confirm` 상태를 자율 부여하지 않는다.

## 5. .gitkeep 정책

- 빈 디렉토리에는 `.gitkeep` 부착 (git이 빈 디렉토리를 추적하지 않으므로 협업 안전성 확보).
- 디렉토리에 leaf .md가 있으면 `.gitkeep` 생략.
- workflow/installation, workflow/runbook은 README만 있으면 `.gitkeep` 생략.

## 6. 디렉토리·파일 명명 규칙

- 챕터 디렉토리: `{n}_{snake_case_name}/` (arc42 공식 영문명 lowercase snake_case 직역, 챕터 번호 prefix)
- leaf 파일: `{n-n}_{snake_case_name}.md` (서브섹션 번호 + 영문명)
- 평탄 챕터: `{n}_{snake_case_name}.md` (챕터명과 동일)
- 깊이별 번호 규칙: 본문 헤딩 `## n.`, `### n-n.`, `#### n-n-n.`

## 7. 표지 언어

- README와 leaf의 표지(제목·요약)는 한국어. 영문명은 괄호 병기.
- 디렉토리·파일명은 항상 영문 snake_case (한국어 path 사용 금지 — 인코딩 안전성).

## 8. 기존 파일 충돌 처리

`create` 실행 시 다음 규칙으로 안전 처리:

- 같은 경로에 이미 디렉토리가 있으면 그 자리에서 추가 생성만 (덮어쓰기 안 함).
- 같은 경로에 이미 .md가 있으면 **건너뛰기** + 경고 로그.
- 덮어쓰기는 사용자가 명시적으로 요청 시에만.
- 모든 신규 생성·건너뛰기를 결과 요약 표로 출력.
