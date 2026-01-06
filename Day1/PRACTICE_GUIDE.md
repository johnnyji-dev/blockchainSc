# Day 1 실습 가이드

## 🚀 시작하기

### 1. Foundry 설치 확인

```bash
forge --version
cast --version
anvil --version
```

설치되어 있지 않다면:
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### 2. 프로젝트 구조 확인

```
Day1/
├── 01-storage-layout/
│   ├── README.md
│   ├── exercises/
│   └── practice/
├── 02-delegatecall/
│   ├── README.md
│   ├── exercises/
│   └── practice/
├── 03-gas-optimization/
│   ├── README.md
│   ├── exercises/
│   └── practice/
└── 04-bytecode-abi/
    ├── README.md
    ├── exercises/
    └── practice/
```

---

## 📅 시간별 실습 순서

### 09:00 - 11:00: EVM Storage Layout

```bash
cd Day1/01-storage-layout/practice

# Foundry 프로젝트 초기화 (이미 되어있다면 생략)
forge init . --force

# 컴파일
forge build

# 테스트 실행
forge test -vvv

# Storage Layout 확인
forge inspect StorageLayout storage-layout
```

**실습 과제:**
1. `StorageLayout.sol`의 TODO 부분 완성
2. `StorageLayout.t.sol`의 테스트 작성
3. `exercises/EXERCISES.md`의 문제 풀이

---

### 11:00 - 13:00: delegatecall vs call

```bash
cd Day1/02-delegatecall/practice

# 컴파일 및 테스트
forge build
forge test -vvv
```

**실습 과제:**
1. `CallComparison.sol`로 call vs delegatecall 차이 확인
2. `SimpleProxy.sol`의 TODO 완성
3. Proxy 컨트랙트 테스트 작성

---

### 14:00 - 16:00: Gas Optimization

```bash
cd Day1/03-gas-optimization/practice

# 컴파일 및 테스트
forge build
forge test --gas-report
```

**실습 과제:**
1. `Voting.sol`의 `OptimizedVoting` 컨트랙트 완성
2. 가스 리포트로 비교
3. **목표: 30% 이상 가스 절약**

---

### 16:00 - 18:00: Bytecode & ABI

```bash
cd Day1/04-bytecode-abi/practice

# 컴파일 및 테스트
forge build
forge test -vvv

# 바이트코드 확인
forge inspect SelectorCalculator bytecode

# ABI 확인
forge inspect SelectorCalculator abi
```

**실습 과제:**
1. `SelectorCalculator.sol`의 함수들 테스트
2. 실제 Function Selector 계산
3. ABI 인코딩/디코딩 연습

---

## 🛠️ 유용한 명령어

### Foundry 기본 명령어

```bash
# 프로젝트 초기화
forge init <project-name>

# 컴파일
forge build

# 테스트 실행
forge test

# 상세한 출력으로 테스트
forge test -vvv

# 특정 테스트만 실행
forge test --match-test testFunctionName

# 가스 리포트
forge test --gas-report

# 컨트랙트 배포 (로컬)
forge script script/Deploy.s.sol --rpc-url http://localhost:8545 --broadcast
```

### 디버깅

```bash
# 트레이스 출력
forge test -vvvv

# 특정 테스트 디버깅
forge test --debug <testFunctionName>
```

### 바이트코드 분석

```bash
# Storage Layout 확인
forge inspect <ContractName> storage-layout

# 바이트코드 추출
forge inspect <ContractName> bytecode

# ABI 추출
forge inspect <ContractName> abi

# 메타데이터 확인
forge inspect <ContractName> metadata
```

---

## 📝 학습 체크리스트

각 섹션을 마친 후 확인하세요:

### 1. EVM Storage Layout
- [ ] 변수 패킹 원리 이해
- [ ] 동적 배열 슬롯 계산 가능
- [ ] 매핑 슬롯 계산 가능
- [ ] `forge inspect`로 실제 슬롯 확인

### 2. delegatecall
- [ ] call vs delegatecall 차이 설명 가능
- [ ] Storage Collision 이해
- [ ] 간단한 Proxy 구현 완료

### 3. Gas Optimization
- [ ] unchecked 사용법 이해
- [ ] calldata vs memory 차이 이해
- [ ] 비트맵 구현 완료
- [ ] 투표 컨트랙트 30% 이상 최적화

### 4. Bytecode & ABI
- [ ] Function Selector 계산 가능
- [ ] ABI 인코딩/디코딩 가능
- [ ] 바이트코드 분석 도구 사용 가능

---

## 🐛 문제 해결

### 컴파일 에러

```bash
# Solidity 버전 확인
forge --version

# 캐시 삭제 후 재컴파일
forge clean
forge build
```

### 테스트 실패

```bash
# 상세한 출력으로 확인
forge test -vvvv

# 특정 테스트만 실행
forge test --match-test <testName>
```

### 가스 측정이 안 될 때

```bash
# 가스 리포트 옵션 확인
forge test --help | grep gas

# Foundry 최신 버전으로 업데이트
foundryup
```

---

## 📚 추가 학습 자료

### 공식 문서
- [Foundry Book](https://book.getfoundry.sh/)
- [Solidity 문서](https://docs.soliditylang.org/)
- [EVM 스펙](https://ethereum.org/en/developers/docs/evm/)

### 도구
- [4byte.directory](https://www.4byte.directory/) - Function Selector 데이터베이스
- [Ethervm](https://ethervm.io/) - 바이트코드 디컴파일러
- [Tenderly](https://tenderly.co/) - 가스 프로파일러

---

## 💡 학습 팁

1. **코드를 직접 타이핑하세요**: 복사-붙여넣기보다 직접 작성하면 더 잘 기억합니다.

2. **테스트를 먼저 작성하세요**: TDD 방식으로 학습하면 이해가 빠릅니다.

3. **가스 리포트를 확인하세요**: 최적화의 효과를 수치로 확인할 수 있습니다.

4. **GitHub에 커밋하세요**: 매 섹션마다 커밋하여 학습 기록을 남기세요.

5. **면접 질문을 미리 준비하세요**: 각 섹션의 "면접 대비 질문"을 스스로 답변해보세요.

---

## 🎯 오늘의 목표

- [ ] 4개 섹션 모두 완료
- [ ] 모든 실습 코드 작성 및 테스트 통과
- [ ] 연습문제 최소 3개 이상 풀이
- [ ] GitHub에 커밋 및 푸시
- [ ] 학습 내용 블로그/노트 정리

**화이팅! 💪**


