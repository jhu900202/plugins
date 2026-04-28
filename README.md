# Claude Code 플러그인 마켓플레이스

jhu900202 의 개인용 Claude Code 플러그인 컬렉션입니다.

## 구조

- **`/plugins`** — 본 저장소에서 직접 개발·유지하는 내부 플러그인
- **외부 repo 참조** —외부 플러그인은 본 저장소에 코드를 두지 않고 `marketplace.json` 에서 URL/`git-subdir`/`github` 형태로 참조합니다.

## 설치

플러그인은 Claude Code 의 플러그인 시스템을 통해 본 마켓플레이스에서 직접 설치할 수 있습니다.

먼저 마켓플레이스를 등록하세요:

```
/plugin marketplace add jhu900202/plugins
```

그 후 다음 명령으로 설치합니다:

```
/plugin install {plugin-name}@plugins
```

또는 `/plugin > Discover` 에서 플러그인을 찾아 설치할 수 있습니다.

## 등록된 플러그인

| 이름 | 설명 | 카테고리 | 출처 |
|---|---|---|---|
| `arc42` | 프로젝트 아키텍처 문서를 arc42 v8 로 빠르게 깔고 점진적으로 채워 가는 스캐폴더 | documentation | 내부 (`./plugins/arc42`) |
| `galmuri` | 흩어진 맥락을 갈무리한다 — 요약·정리·퇴고·문서화·의사결정 덱 | productivity | 외부 ([jazz1x/galmuri](https://github.com/jazz1x/galmuri)) |
| `harnish` | 자율 구현 엔진 — PRD 생성(drafti) → 자율 구현(harnish) → 점검(ralphi) | development | 외부 ([jazz1x/harnish](https://github.com/jazz1x/harnish)) |
| `honne` | LLM 과 나눈 흔적에서 당신 자신의 패턴을 끌어냅니다 — tatemae 아래의 honne | productivity | 외부 ([jazz1x/honne](https://github.com/jazz1x/honne)) |

## 플러그인 구조

각 플러그인은 다음 표준 구조를 따릅니다:

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json      # 플러그인 메타데이터 (필수)
├── .mcp.json            # MCP 서버 설정 (선택)
├── commands/            # 슬래시 명령 (선택)
├── agents/              # 에이전트 정의 (선택)
├── skills/              # 스킬 정의 (선택)
└── README.md            # 문서
```