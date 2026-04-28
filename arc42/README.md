# arc42

프로젝트 아키텍처 문서를 **arc42 v8**으로 빠르게 깔고, 점진적으로 채워 가는 Claude Code 플러그인.

## 모드

| 명령 | 동작 |
|------|------|
| `/arc42 create` | 골격 템플릿을 `.claude/docs/`로 복사 (`.claude/docs` 존재 시 차단) |
| `/arc42 list` | 진척 표 출력 |
| `/arc42 update <chapter-id>` | `.claude/docs/source/` 자료를 기반으로 챕터 본문 작성 |
| `/arc42 confirm <chapter-id>` | 챕터 진척 상태를 `confirm`으로 확정 (사용자 명시 호출에서만) |

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

- "arc42 골격 만들어줘"
- "/arc42 create"
- "1-1 챕터 작성해줘"
- "1-1 확정"

## 원칙

1. arc42 표준 외 항목은 README에 명시
2. frontmatter 통일 표준 1종만 사용
3. 상태는 진척 표 1곳에서만 관리 (이중 진실 금지)
4. `confirm` 부여는 사용자 명시 명령에서만
5. `update`는 항상 source 전체 우선 스캔
6. 파괴적 변경은 사용자 확인 후

## 참조

- [arc42 공식 사이트](https://arc42.org)
- 스킬 본문: [`skills/arc42/SKILL.md`](skills/arc42/SKILL.md)
- 프론트매터 표준: [`skills/arc42/references/frontmatter.md`](skills/arc42/references/frontmatter.md)
- 디렉토리 구조: [`skills/arc42/references/structure.md`](skills/arc42/references/structure.md)
- leaf 작성 가이드: [`skills/arc42/references/leaf-spec.md`](skills/arc42/references/leaf-spec.md)
