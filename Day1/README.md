# Day 1: Solidity Deep Dive & EVM

## 📋 학습 목표

면접에서 가장 많이 나오는 기술 질문을 방어하고, 코딩 테스트를 통과하기 위한 실력을 만듭니다.

## ⏰ 시간표

| 시간 | 내용 | 학습 자료 |
|------|------|----------|
| 09:00 - 11:00 | EVM Storage Layout 마스터 | [Storage Layout](./01-storage-layout/README.md) |
| 11:00 - 13:00 | delegatecall vs call 실습 | [Delegatecall](./02-delegatecall/README.md) |
| 14:00 - 16:00 | Gas Optimization 챌린지 | [Gas Optimization](./03-gas-optimization/README.md) |
| 16:00 - 18:00 | Bytecode & ABI 분석 | [Bytecode & ABI](./04-bytecode-abi/README.md) |
| 19:00 - 21:00 | 학습 내용 정리 | GitHub 커밋 및 블로그 작성 |

---

## 📖 섹션별 상세 가이드

### 1. EVM Storage Layout 마스터 (09:00 - 11:00)

**핵심 개념:**
- EVM의 32바이트 슬롯 구조
- 변수 패킹(Variable Packing)
- 동적 배열과 매핑의 저장 방식

**학습 자료:** [01-storage-layout/README.md](./01-storage-layout/README.md)

**실습 과제:**
- Storage Layout 시각화 도구 사용
- 변수 패킹 최적화 연습

---

### 2. delegatecall vs call (11:00 - 13:00)

**핵심 개념:**
- `call` vs `delegatecall`의 차이점
- Proxy 패턴의 기초
- 컨텍스트 보존 메커니즘

**학습 자료:** [02-delegatecall/README.md](./02-delegatecall/README.md)

**실습 과제:**
- delegatecall을 사용한 상태 변수 덮어쓰기 구현
- 간단한 Proxy 컨트랙트 작성

---

### 3. Gas Optimization 챌린지 (14:00 - 16:00)

**핵심 개념:**
- `unchecked` 블록 활용
- `calldata` vs `memory` vs `storage`
- 비트맵을 활용한 가스 절약

**학습 자료:** [03-gas-optimization/README.md](./03-gas-optimization/README.md)

**실습 과제:**
- 투표 컨트랙트 작성 및 가스비 30% 줄이기 도전

---

### 4. Bytecode & ABI 분석 (16:00 - 18:00)

**핵심 개념:**
- Function Selector (4 bytes)
- ABI 인코딩/디코딩
- 바이트코드 구조 이해

**학습 자료:** [04-bytecode-abi/README.md](./04-bytecode-abi/README.md)

**실습 과제:**
- 컴파일된 바이트코드 분석
- Function Selector 직접 계산

---

## ✅ 일일 체크리스트

- [ ] EVM Storage Layout을 손으로 그려볼 수 있다
- [ ] delegatecall과 call의 차이를 코드로 설명할 수 있다
- [ ] 가스 최적화 기법 3가지를 적용해봤다
- [ ] Function Selector를 직접 계산해봤다
- [ ] GitHub에 오늘 학습 내용을 커밋했다

---

## 🎯 면접 대비 질문

각 섹션을 마친 후 다음 질문에 답할 수 있어야 합니다:

1. **Storage Layout**: "Solidity에서 `uint128` 두 개를 선언하면 몇 개의 슬롯을 사용하나요?"
2. **Delegatecall**: "Proxy 패턴에서 delegatecall을 사용하는 이유는?"
3. **Gas Optimization**: "가스비를 줄이기 위해 어떤 기법을 사용하나요?"
4. **Bytecode**: "Function Selector는 어떻게 생성되나요?"

---

## 📚 참고 자료

- [EVM Storage Layout 공식 문서](https://docs.soliditylang.org/en/latest/internals/layout_in_storage.html)
- [Foundry 공식 문서](https://book.getfoundry.sh/)
- [Ethernaut Challenges](https://ethernaut.openzeppelin.com/)


