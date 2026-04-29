# arc42

프로젝트 아키텍처 문서를 **arc42 v8**으로 빠르게 깔고, 점진적으로 채워 가는 Claude Code 플러그인.

## 모드

| 슬래시 커맨드 | 동작 |
|------|------|
| `/arc42-create` | 골격 템플릿을 `.claude/docs/`로 복사 (`.claude/docs` 존재 시 차단) |
| `/arc42-list` | 진척 표 출력 |
| `/arc42-update <chapter-id>` | `.claude/docs/source/` 자료를 기반으로 챕터 본문 작성 |
| `/arc42-confirm <chapter-id>` | 챕터 진척 상태를 `confirm` 으로 확정 (사용자 명시 호출에서만) |

자연어 트리거(예: "1-1 챕터 작성해줘", "1-1 확정")로도 동일 동작에 진입할 수 있습니다 — 스킬이 자동 활성화됩니다.

## 진척 상태 (3단계)

- `draft` — 골격 생성 직후
- `review` — `update` 완료 후 자동
- `confirm` — 사용자 검토 후 명시 호출

## 표준 경로 (생성물)

```
.claude/docs/
├── architecture/      arc42 12 챕터 본문
├── workflow/          설치·운영 절차 (arc42 외 확장)
└── source/            사용자 분석 자료 작업 폴더
```

## 트리거 예시

- `/arc42-create` 또는 "arc42 골격 만들어줘"
- `/arc42-update 1-1` 또는 "1-1 챕터 작성해줘"
- `/arc42-confirm 1-1` 또는 "1-1 확정"

## 원칙

1. arc42 표준 외 항목은 README에 명시
2. frontmatter 통일 표준 1종만 사용
3. 상태는 진척 표 1곳에서만 관리 (이중 진실 금지)
4. `confirm` 부여는 사용자 명시 명령에서만
5. `update`는 항상 source 전체 우선 스캔
6. 파괴적 변경은 사용자 확인 후

## 참조

- [arc42 공식 사이트](https://arc42.org)