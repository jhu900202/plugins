# arc42-source 커맨드 생성 계획

본 문서는 신규 `commands/arc42-source.md` 와 `plugins/arc42/skills/arc42/scripts/` 의 내용을 어떻게 작성할지에 대한 작업 계획이다. 최종적으로 본 문서의 내용은 해당 커맨드/스크립트 안으로 인라인 이전된 뒤 본 파일은 삭제될 예정이다.

leaf 작성 절차(챕터·leaf 구조·검증·위임)는 `arc42-update-plan.md` 가 담당하며, 본 문서는 source 추출 도메인에 한정된다.

## source 처리 파이프라인 커맨드 설계

source/ 처리는 **단일 커맨드 `arc42-source`** 로 노출하고, 내부적으로 파이썬 스크립트가 4단계를 제어한다. 추론 개입 없이 상태 파일 문자열 파싱으로 단계가 결정된다.

### 단일 커맨드 + 내부 파이프라인 구조

- 사용자 진입점: `/arc42-source` (커맨드는 스크립트 호출 wrapper)
- 컨트롤러: 파이썬 스크립트 (공식 저장소 컨벤션 — `skill-creator`, `hookify` 등)
- 상태 파일: `source/_pipeline-state.md` — 파싱 친화 평문 형식

### 스크립트 배치 (공식 저장소 컨벤션 준수)

```
plugins/project-docs/skills/arc42/scripts/
├── source_pipeline.py    # 메인 컨트롤러 (상태 파싱 → 단계 디스패치)
├── stage_list.py         # 단계 1: _file-list.md 생성
├── stage_convert.py      # 단계 2: 변환
├── stage_fragment.py     # 단계 3: 파편화
├── stage_verify.py       # 단계 4: 검증
└── state_parser.py       # 상태 md 문자열 파싱 유틸 (추론 차단 핵심)
```

source 작업 공간(런타임): `${CLAUDE_PROJECT_DIR}/.claude/docs/architecture/source/` (사용자 프로젝트 시점). 템플릿 시점은 `plugins/project-docs/skills/arc42/templates/architecture/source/`.

스크립트는 arc42 스킬 전용 (결정 4 — runbook 은 architecture/ 직접 Read 로 입력 소비).

### 상태 파일 포맷 (`source/_pipeline-state.md`)

```
# arc42-source pipeline state

stage: convert
last-completed: list
last-run: 2026-04-29T16:30:00
list: done
convert: pending
fragment: pending
verify: pending
```

`state_parser.py` 가 `^stage:\s*(\w+)$`, `^(list|convert|fragment|verify):\s*(\w+)$` 정규식으로 파싱.

### 커맨드 동작 알고리즘

1. `source/_pipeline-state.md` 존재 확인
2. 없으면: 신규 생성(`stage: list`, 모든 단계 `pending`) → `list` 단계부터 실행
3. 있으면: `stage:` 라인 파싱 → 해당 단계부터 실행
4. 각 단계 완료 시 스크립트가 상태 파일 갱신 (`<stage>: done`, `stage:` 다음 단계로)
5. 모든 단계 `done` → "파이프라인 완료" 보고 후 종료. 재실행은 `--from <stage>` 강제 옵션 필요

### 단계별 산출물

| 단계 | 역할 | 산출물 |
|---|---|---|
| `list` | source/ 파일 목록 리스트업 | `_file-list.md` |
| `convert` | 스크립트 기반 md 변환 | `_converted/*.converted.md`, `_file-list.md` 상태 갱신 |
| `fragment` | 조건/요구사항 문장 단위 파편화 | `_fragments/**/*.md`, `_fragment-list.md` |
| `verify` | 파편화 완전성 검증 | `_verify/*.verify.md`, `_verify-report.md`, `_fragment-list.md` 검증 상태 갱신 |

### `list` 단계 — 빈 source/ 엄격 거부 정책

`arc42-source` 는 결정론적 추출 도구이며, 입력이 0개일 때의 출력은 정의되지 않는다. 따라서 list 단계 진입 시 source/ 에 산출물이 0개면 **즉시 중단** 한다.

- 상태 파일(`_pipeline-state.md`) 미생성 — 다음 호출 시 깨끗한 상태로 재시작 가능
- 종료 코드 비-0
- 진단 메시지:

  ```
  source/ 에 처리할 산출물이 없습니다.
  - 산출물 배치 누락이면: 파일을 추가한 뒤 /arc42-source 재실행
  - 구상 단계라면: /arc42-source 를 거치지 않고 /arc42-update 직접 호출 (백지 작성 모드)
  ```

구상 단계(산출물 없이 아키텍처 생성)는 `arc42-update` 의 백지 작성 fallback 이 처리한다(arc42-update.md L12). arc42-source 는 conception 모드 플래그·상태 필드를 보유하지 않는다 — 책임 분리.

### `convert` 단계 — 처리 가능 확장자

**convert 가 자동 처리 (구현 우선순위 순)**
| 확장자 | 사용 맥락 | 라이브러리 | 구현 난이도 |
|--------|----------|-----------|------------|
| `.pdf` | 공문·계약서·보고서 | pdfplumber | 낮음 |
| `.xlsx` | 기획서·데이터·양식 | openpyxl / pandas | 낮음 |
| `.docx` | 제안서·매뉴얼 | python-docx | 낮음 |
| `.pptx` | 발표자료 | python-pptx | 낮음 |
| `.csv` `.json` `.yaml` `.xml` | 데이터·설정·API 명세 | 내장 모듈 | 매우 낮음 |
| `.txt` `.md` `.html` | 텍스트 직접 처리 (변환 불필요) | Read 도구 | 없음 |

**convert 가 사용자에게 위임 (자동 처리 불가)**
| 확장자 | 사유 |
|--------|------|
| `.hwp` `.hwpx` | pyhwp 구버전만 지원·hwpx 미지원 → 사용자가 PDF/docx로 사전 변환 요청 |
| `.png` `.jpg` | OCR 정확도 불보장 → 수동 기술 |
| `.psd` `.ai` `.fig` | 디자인 원본 파일 |

### `fragment` 단계 — 파편화 단위

**조건/요구사항 문장 1개 = 파편 1개**. 예시 수준: "OO 기능 입력 텍스트는 400자로 제한한다". 파편이 50줄을 초과하면 강제 분할한다. 맥락 없이 단독으로 이해 불가능한 파편은 상위 문맥을 포함한 뒤 `context-merged: true` 로 표기한다.

### `verify` 단계 — 검증 보고서 형식

`_verify-report.md` 는 정형화된 표가 아닌 **비정형 보고서**다. 누락·미처리된 원문 문장을 그대로 나열하는 방식으로 작성하며, 별도 집계 컬럼이나 통계 테이블을 두지 않는다.

## arc42-update 의 source 진입 (소비자 인터페이스)

`/arc42-update` 가 본 파이프라인 산출물을 소비할 때 따르는 절차. 본 사양이 단일 진실 소스이며, `arc42-update.md` 는 본 절을 inline 참조한다.

1. `.claude/docs/source/` 디렉토리 존재 확인.
2. 파이프라인 산출물 진입점 확인:
   - `_file-list.md` 존재 → 파이프라인이 1단계 이상 실행됨. 산출물을 우선 Read.
   - `_fragments/` + `_fragment-list.md` 존재 → 파편 단위 선택적 Read.
   - `_verify-report.md` 존재 → 검증 누락 항목을 update 보고에 포함.
3. `_pipeline-state.md` 의 `stage:` 라인을 문자열 파싱으로 읽어 어느 단계까지 완료되었는지 확인.
4. 산출물 부재 시: 디렉토리 내 모든 .md 파일을 Read 도구로 전체 스캔(구버전 동작 호환) 후, 파이프라인 미실행 사실을 사용자에게 안내.
5. 각 파일에서 헤딩 줄(`^## `, `^### `, `^#### `)을 추출하여 "파일명 → 헤딩 목록" 형식의 anchor 인덱스 생성.
6. 인덱스를 표 형태로 사용자에게 보고.

발견 실패 시:
- 디렉토리 없음 → `create` 미실행 가능성. 사용자에게 보고.
- 디렉토리 비어 있음 → 사용자에게 자료 복사 또는 백지 작성 여부 확인.
- 비-md 파일이 산출물 없이 존재 → 사용자에게 `/arc42-source` 실행을 안내.

## 함께 적용할 변경

- `commands/arc42-source.md` 신규 생성 — 내부에서 `plugins/arc42/skills/arc42/scripts/source_pipeline.py` 호출.
- arc42-update-plan.md 다른 절들(§2 보고 형식, §5 위임 매핑 등)에 "파이프라인 산출물 진입 시" 분기 보강 검토.

## 미결정 사항

- `.xlsx` 다중 시트 처리 전략 — 시트별 분리 파편화 vs. 시트 목록만 리스트업 후 사용자 판단 위임.
- pandoc 미설치 환경 폴백 — `convert` 단계가 pandoc 없을 때 취할 대안 행동(오류 보고 후 중단 vs. 텍스트 직접 추출 시도).
- 파편 헤더 포맷 — YAML frontmatter(`---`) vs. HTML 주석(`<!-- -->`) 중 어느 방식으로 파편 메타데이터를 표기할지.
- `context-merged` 파편의 중복 포함 범위 기준 — 상위 섹션 전체 vs. 직전 N줄 vs. 최상위 헤딩까지 소급하는 규칙 미정.
- 상태 파일 포맷 — 현재 `.md` 평문 형식. `.toml`/`.json` 으로 갈지, 그대로 둘지.
- `--from <stage>` 강제 재실행 옵션의 인자 검증 방식 (잘못된 단계명 입력 시 에러 메시지 정형화).
- 파이썬 의존성 관리 — `requirements.txt` 또는 `pyproject.toml` 위치(`plugins/arc42/` vs. `plugins/arc42/skills/arc42/scripts/`).