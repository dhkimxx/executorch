# Samsung Exynos Self-Hosted Runner Setup (Docker)

이 디렉토리는 삼성 Exynos 빌드 및 테스트를 위한 GitHub Self-hosted Runner를 Docker로 쉽게 띄울 수 있도록 구성되어 있습니다.

## 필수 준비 사항

1.  **Runner Token 발급**:
    - 리포지토리의 _Settings -> Actions -> Runners -> New self-hosted runner_ 클릭.
    - `Run` 섹션이 아닌, `Configure` 단계에서 보여주는 **token** 문자열을 복사합니다. (예: `A1B2C3D4...`)

## 실행 방법

### 1. Docker 이미지 빌드 및 실행 (Docker Compose)

`GITHUB_TOKEN` 환경 변수에 토큰을 설정하고 실행합니다.

```bash
# 토큰 설정 (실제 토큰으로 교체)
export GITHUB_TOKEN="YOUR_RUNNER_TOKEN_HERE"

# 실행
docker compose up -d --build
```

### 2. 로그 확인

```bash
docker compose logs -f
```

`Listening for Jobs` 메시지가 뜨면 성공적으로 연결된 것입니다.

## 포함된 도구

- **Ubuntu 22.04**
- **Android NDK**: `/opt/ndk`에 설치 가능하도록 디렉토리 생성 및 권한 설정됨.
- **Python 3.10**: Build에 필요한 Python 환경.
- **Conda**: Executorch 의존성 관리를 위한 Miniconda.
- **Sudo**: `setup-samsung-linux-deps.sh` 실행을 위해 `runner` 사용자에 sudo 권한 부여.

## 주의 사항

- `setup-samsung-linux-deps.sh` 스크립트는 실행 시 필요한 NDK 등을 `/opt/ndk`에 다운로드하려 시도할 수 있습니다.
- Runner는 `runner`라는 사용자로 실행되며, 비밀번호 없이 `sudo`를 사용할 수 있습니다.
