# 골프 예약 프로젝트 디브리핑

- 작성 일시: 2026-05-21 22:05:13 (Asia/Seoul)
- 작업 디렉터리: `C:\Users\USER\Desktop\레슨 예약 및 아케이드\골프_예약`
- 기준 파일: `index.html`

## 오늘 확인한 내용

- 실제 작업 기준은 `index.html`이며, `골프_예약_시스템.html`, `레슨가격.html`은 과거 작업본/참고 파일로 확인됨.
- 초기에 파일 간 내용 차이 때문에 가격표와 계좌번호가 바뀐 것처럼 보였으나, 실제 배포 기준 파일에는 정상 정보가 들어 있었음.
- 예약 폼은 Google Forms로 연결하기로 확정.

## 오늘 처리한 작업

### 1. Google Form 연결

- Google Form 자동 생성 완료.
- 고객용 폼 URL 확보:
  - `https://docs.google.com/forms/d/e/1FAIpQLScjus1bW9ISCwXwvv5Td8MWjp7u3Qed5fi6lA_9TTPyKAgZRg/viewform`
- `희망 지점` 필드 ID 확인 완료:
  - `entry.757779451`
- `index.html`에 예약 폼 URL과 지점 필드 ID 반영 완료.
- Apps Script 트리거 설정 완료:
  - `onFormSubmit`
  - 양식 제출 시

### 2. 노출 정보 관련 판단

- 전화번호는 이미 난독화 완료 상태로 유지.
- 계좌번호는 모달 진입 직후 바로 노출되지 않도록 변경.
- 버튼 클릭 후에만 계좌번호가 표시되도록 수정.
- 계좌번호 표시 후에는 기존처럼 클릭 복사 가능하도록 유지.

### 3. 계좌 영역 UI 변경

- 기존:
  - 모달을 열면 계좌번호가 즉시 노출됨
- 변경 후:
  - `계좌번호 확인하기` 버튼만 먼저 표시
  - 클릭 시 계좌번호와 예금주 정보가 표시됨
  - 계좌번호 클릭 시 복사 기능 동작

### 4. 배포 구조 정리

- 초기에 `wrangler deploy`로 잘못 Workers 쪽으로 한 번 배포됨.
- 이후 배포 방식을 Pages 기준으로 정리함.
- `wrangler.toml`을 Pages 설정으로 변경:
  - `pages_build_output_dir = "./public"`
- 배포용 스크립트 `deploy-pages.ps1` 추가:
  - 루트 `index.html`을 `public/index.html`로 동기화
  - 이후 `wrangler pages deploy public --project-name golf-reservation-lesson` 실행
- 예전 Workers 배포본은 삭제 완료.

## 현재 파일 상태

- 수정됨: `index.html`
- 수정됨: `wrangler.toml`
- 추가됨: `deploy-pages.ps1`
- 추가됨: `public/index.html`

## 현재 배포 상태

- Cloudflare Pages 배포 완료.
- 확인된 배포 URL:
  - `https://3d5f8118.golf-reservation-lesson.pages.dev`

## 앞으로 작업 기준

- 내용 수정은 항상 루트 `index.html`에서 진행.
- 배포는 아래 명령만 사용:

```powershell
.\deploy-pages.ps1
```

## 참고 메모

- 현재 프로젝트는 Pages 기준으로 운영하는 것이 가장 단순함.
- `wrangler deploy`는 앞으로 사용하지 않는 것이 안전함.
- 이유:
  - Pages 프로젝트와 Workers 배포가 다시 혼동될 수 있음.
  - 현재 사이트 구조는 정적 랜딩 페이지에 가깝기 때문.

## Workers vs Pages 핵심 차이

- Pages:
  - HTML, CSS, JS, 이미지 같은 정적 사이트를 올리는 데 더 직관적인 서비스
  - 지금 프로젝트처럼 랜딩 페이지 1장 운영에 적합
  - 대시보드에서도 Pages 프로젝트로 관리됨
  - 현재 이 프로젝트는 이 방식으로 운영 중

- Workers:
  - 요청이 들어올 때 서버 로직을 실행하는 서비스
  - API, 로그인 처리, 동적 응답, 데이터 가공 같은 기능을 붙일 때 적합
  - 정적 파일도 붙일 수 있지만 본질은 "코드 실행" 쪽에 가까움

## 이번 프로젝트에서 Pages를 선택한 이유

- 현재 사이트는 예약 랜딩 페이지 + 외부 Google Form 연결 구조임
- 서버에서 계산하거나 DB를 조회하는 기능이 없음
- 따라서 굳이 Workers로 갈 이유가 없고, Pages가 더 단순하고 관리도 쉬움
- 실제로 `wrangler deploy`를 쓰면 Workers 쪽으로 가서 대시보드 위치가 달라져 혼선이 생겼음
- 그래서 앞으로는 Pages로만 관리하도록 정리함

## 한 줄 기준

- 홈페이지/랜딩페이지 올리기: Pages
- 서버 기능/API 만들기: Workers
