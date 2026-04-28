---
file: workflow/installation/README.md
purpose: 1회성 플랫폼 설치 절차 — OS·K8s·기반 인프라·모노레포 스캐폴드
last_updated: 2026-04-28
---

# Installation

신규 환경(노드 2대)을 0에서 CFRS 운영 가능 상태까지 끌어올리는 **1회성** 절차. 환경이 정착된 후에는 거의 실행하지 않으며, 신규 환경 셋업·재해 복구 시 다시 사용한다.

> 본 디렉토리는 **명령행·yml·shell 스크립트**가 주가 된다. 결정 근거·정책은 `../../architecture/`를 참조.

---

## 단계 (의존 순서)

| Phase | 디렉토리 | 산출물 |
|-------|---------|--------|
| **0** | [0_infra_bootstrap/](./0_infra_bootstrap/) | OS(Rocky 9.x) → containerd → kubeadm/kubelet → 클러스터 init → CNI(Flannel) → DB PC join → MetalLB + ingress-nginx → 로컬 레지스트리 → GitHub Actions Runner |
| **1** | [1_data_geoserver/](./1_data_geoserver/) | PostGIS StatefulSet · Redis · db-bootstrap Job(Drizzle) · pg-backup CronJob · GeoServer Deployment · geoserver-bootstrap Job(REST 자동등록) |
| **2** | [2_monorepo_skeleton/](./2_monorepo_skeleton/) | pnpm workspace · Turborepo · biome · `packages/db`(Drizzle 119 테이블) · `packages/shared`(Zod) · `apps/web` 스캐폴드 · `apps/weather-batch` 스캐폴드 · Auth.js v5 진입 |

각 Phase는 **이전 Phase 완료 후 진입**. 각 디렉토리 내부 세부 단계는 절 번호 파일(`0-1_os_install.md`, `0-2_containerd.md` ...)로 점진 추가.

---

## 완료 기준 (Definition of Done)

- Phase 0: `kubectl get nodes`에 2개 노드 Ready, ingress LoadBalancer VIP 응답, `localhost:5000` 레지스트리 응답.
- Phase 1: PostGIS·Redis·GeoServer 모두 Ready. GeoServer Web UI 접근 가능. Drizzle 마이그레이션 성공.
- Phase 2: `pnpm install` + `pnpm build` 무오류. `apps/web` 로컬 dev 서버 기동. `apps/weather-batch`가 단일 호출 성공.

---

## 참조

- 토폴로지·정책: `../../architecture/7_deployment_view/`
- 스택 결정 근거: `../../architecture/2_architecture_constraints/`
- MS 설계: `../../architecture/5_building_block_view/`
- 원본 문서: `docs/0f_bootstrap.md`, `docs/0d_microservices.md` 구체 절
