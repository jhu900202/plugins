---
file: workflow/README.md
purpose: 구현·설치·운영 절차 — arc42 범위 외(out-of-scope)
last_updated: 2026-04-28
---

# CFRS Workflow

본 디렉토리는 **arc42 범위 외**의 산출물을 담는다. arc42(`../architecture/`)는 "왜·무엇·어디에" 까지 다루며, **"어떻게(구체 명령·yml·DDL·단계 절차)"** 는 본 디렉토리가 담당한다.

> 명령행(`kubectl`, `helm`, `psql`, `curl`, `systemctl`)·yml 전문·shell 스크립트가 등장하면 **workflow의 영역**.
> 다이어그램·정책 표·결정 근거가 등장하면 **architecture의 영역**.

---

## 디렉토리 구조

```
workflow/
├─ README.md                  ← 본 파일
├─ installation/              ← 1회성 플랫폼 설치 (OS·K8s·기반 인프라·모노레포 스캐폴드)
└─ runbook/                   ← 기능 구현 절차 + 일상 운영 절차
```

---

## 두 디렉토리의 경계

| 구분 | `installation/` | `runbook/` |
|------|----------------|-----------|
| **시점** | 프로젝트 최초 1회 (또는 신규 환경 셋업) | 상시 — 기능 추가/장애 대응 |
| **대상 독자** | 환경을 셋업하는 사람 | 기능을 구현하거나 운영하는 사람 |
| **변경 빈도** | 낮음 (인프라 정착 후 거의 정지) | 높음 (기능 추가마다 갱신) |
| **재실행 가정** | 환경 폐기 후 재구축 시점 | 매 기능·매 사고마다 |
| **포함 예시** | OS·containerd·kubeadm·MetalLB 설치, PostGIS/Redis/GeoServer 최초 배포, pnpm/turbo 모노레포 골격 | 기능 구현 단계, 데이터 적재 절차, Auth.js 설정, 화면 추가 cookbook, 백업·모니터링·알림 운영 |

---

## 의존 순서 (전역)

```
installation/0_infra_bootstrap
    └─► installation/1_data_geoserver
            └─► installation/2_monorepo_skeleton
                    └─► runbook/0_cross_cutting
                            └─► runbook/1_master_data
                                    └─► runbook/2_ingest_clean
                                            └─► runbook/3_gis_widgets
                                                    └─► runbook/4_data_views
                                                            └─► runbook/5_situation_dashboard
                                                                    └─► runbook/6_urban_flood
                                                                            └─► runbook/7_event_alert
                                                                                    └─► runbook/8_board_report
                                                                                            └─► runbook/9_kpi_verification
                                                                                                    └─► runbook/10_operations
```

각 단계는 **이전 단계 완료를 전제**한다. 단계 내부 세부 절차는 해당 디렉토리 README 또는 본문 파일 참조.

---

## 작업 정책

- 각 디렉토리에 `.gitkeep` 유지. 추출은 점진적 — 한 파일씩 추가.
- 본문 절 번호는 **n / n-n / n-n-n** 깊이 규칙(예: `## 1.`, `### 1-1.`).
- `architecture/` 챕터를 인용할 때는 `../architecture/8_crosscutting_concepts/3_crs_policy.md#1-2` 식 상대경로로 명시.
- 명령행은 가능한 한 **shell 코드 블록**으로 그대로 복사 가능하게 작성. 환경 변수는 placeholder(`<NODE_IP>`, `<DB_PASSWORD>`) 명시.
