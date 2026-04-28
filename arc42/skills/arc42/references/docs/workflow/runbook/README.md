---
file: workflow/runbook/README.md
purpose: 기능 구현 cookbook + 일상 운영 절차 (상시 갱신)
status: 디렉토리 구조 잠정 — architecture 5-3 확정 후 일괄 생성
last_updated: 2026-04-28
---

# Runbook

`installation/` 완료 후 **상시 사용**하는 절차. 기능 추가, 데이터 적재, 장애 대응, 모니터링 점검 등 반복적·발전적 작업의 단계별 cookbook.

> 본 디렉토리도 명령·yml·shell이 주. 결정 근거는 `../../architecture/`.

---

## 현재 상태

본 디렉토리는 README만 존재하고 하위 디렉토리는 비어 있다. 이는 의도된 상태이며, 다음 architecture 산출물 확정 후 일괄 생성한다:

1. `architecture/5_building_block_view/5-3_level_3.md` — `apps/web/pages/` 8 도메인 슬러그 + 메인 페이지 + 서브폴더/팝업/공용 위젯 매핑
2. `architecture/9_architecture_decisions/` ADR — 도메인 슬러그 채택(step-fps-view 패턴) 사유 + 공용 위젯 분리 기준
3. `architecture/8_crosscutting_concepts/2_user_experience_concepts.md` — 모달/팝업 결합 정책

이유: runbook 디렉토리는 architecture Building Block View(Level 3)의 **파생물**이며, 슬러그·도메인 그룹·공용 위젯 결정 없이 미리 만들면 architecture 확정 후 대대적 rename·이동이 발생한다.

---

## 잠정 디렉토리 골격 (architecture 확정 후 채택 예정)

step-fps-view `src/pages/common/`의 8 도메인 슬러그를 채택. 의존 순서를 prefix로 부여.

```
runbook/
├─ README.md                       # 본 파일
├─ 0_login/                        # 00-M00
├─ 1_dashboard/                    # 01-M01 (+ 12 팝업은 본 디렉토리 내 파일)
├─ 2_bbs/                          # 02-M01~M04
│   ├─ report/                     # 02-M03 보고서 서브플로우 (등록/조회/정형 R01~R04)
│   └─ hooks/                      # 게시판 도메인 공용 훅
├─ 3_data/                         # 03-M01~M05
│   ├─ observatory/                # 03-M02 서브플로우
│   ├─ observingPoint/             # 03-M03 서브플로우
│   └─ workHistory/                # 03-M05 좌표등록 서브플로우
├─ 4_inundation/                   # 04-M01~M05 (+ 04-M00-P* 공용 위젯)
│   └─ _shared/                    # FloodGisMap, RainfallGisMap, LongitudinalGraph, 시나리오 그래프 5종
├─ 5_event/                        # 05-M01~M03
├─ 6_performance/                  # 06-M01-T01~T03, R01
│   └─ components/                 # 타일·차트 컴포넌트
├─ 7_settings/                     # 08-M01~M12 (+ 모달 6종)
└─ 8_operations/                   # 운영 (Prometheus/Grafana, Alertmanager, 백업 검증, DR)
```

도메인 그룹핑·슬러그 사유:
- step-fps-view 학습 연속성 확보 (기존 자산을 재사용·참조 가능)
- 도메인 8개가 카탈로그 메뉴 트리와 1:1 일치
- 메인 페이지 단위 디렉토리 → 화면 단위 진척 추적 직관적
- 팝업·장표는 부모 메인의 자식 파일로 결합 — 컨텍스트 단절 방지
- 공용 위젯(예: 04 도시침수의 그래프 5종)은 도메인 내 `_shared/` 또는 별도 서브폴더로 추출

---

## 의존 순서 (전역 — 화면 ID 기준)

```
installation/0~2 완료 후 진입
    └─► 0_login                       (00-M00)
            └─► 7_settings/cross-cutting 우선부분  (08-M03 사용자, 08-M04 권한, 08-M10 코드, 08-M11 테이블, 08-M12 환경, 08-M09 로그)
                    └─► 7_settings/master_data    (08-M07 좌표, 08-M05 지점, 08-M06 API)
                            └─► 7_settings/ingest (08-M01 원천, 08-M02 필터링) + weather-batch
                                    └─► 4_inundation/_shared (지도 위젯)
                                            └─► 1_dashboard/sub-popups (01-M01-P01~P05)
                                                    └─► 3_data                (03-M01~M05)
                                                            └─► 1_dashboard/main + remaining popups (P06~P12)
                                                                    └─► 4_inundation                 (04-M01~M05)
                                                                            └─► 5_event              (05-M01~M03)
                                                                                    └─► 2_bbs        (02-M01~M04)
                                                                                            └─► 6_performance (06-*)
                                                                                                    └─► 8_operations
```

cross-cutting 화면(08-M03/M04/M10/M11/M12/M09)은 `7_settings/` 도메인에 속하지만 **모든 다른 화면의 선행**. 도메인 그룹은 settings로 두되, 의존 순서상 가장 먼저 진입한다.

---

## 사용 패턴 (확정 후)

- **기능 추가**: 해당 도메인 디렉토리에 메인 페이지 슬러그 폴더가 있는지 확인 → 없으면 생성 → 본문 절 번호 파일(`1-구현.md`, `2-테스트.md` ...) 추가.
- **장애 대응**: `8_operations/` 또는 해당 도메인 디렉토리의 트러블슈팅 절 우선.
- **데이터 변경**: `7_settings/ingest`(08-M01/M02) + Drizzle 마이그레이션 절 동시 갱신.

---

## 완료 기준 (각 디렉토리 공통)

1. 대상 화면이 dev 환경에서 접근·동작.
2. Auth/권한이 매트릭스대로 적용 (`08-M04` 구현 후 검증 가능).
3. 단위·통합 테스트(가능 범위)에서 그린.
4. `architecture/`의 해당 챕터에 결정/정책이 반영 또는 변경 사유 기록.

---

## 참조

- 화면 카탈로그(단일 진실 소스): `../../source/screens.md`
- FSD pages 슬라이스 정식 정의: `../../architecture/5_building_block_view/5-3_level_3.md` *(작성 예정)*
- MS 설계: `../../architecture/5_building_block_view/`
- 횡단 정책(보안·관측·좌표계): `../../architecture/8_crosscutting_concepts/`
- 결정 기록: `../../architecture/9_architecture_decisions/`
- 슬러그 명명 사유 ADR: `../../architecture/9_architecture_decisions/` *(작성 예정)*
- 원본 문서: `../../source/0d_microservices.md` 구체 절, `../../source/0e_migration.md`
