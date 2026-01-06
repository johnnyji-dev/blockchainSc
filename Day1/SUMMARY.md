# Day 1 학습 요약

## 📚 오늘 배운 내용

### 1. EVM Storage Layout (09:00 - 11:00)

**핵심 개념:**
- EVM 스토리지는 2^256개의 32바이트 슬롯으로 구성
- 변수 패킹: 같은 슬롯에 여러 변수 저장 가능
- 동적 배열: `keccak256(slot) + index`로 저장 위치 계산
- 매핑: `keccak256(abi.encode(key, slot))`로 저장 위치 계산

**면접 대비 답변:**
- "`uint128` 두 개는 1개 슬롯 사용 (각 16바이트)"
- "동적 배열은 길이 정보를 저장하는 슬롯이 필요"
- "매핑은 길이 정보 없이 키-값 쌍만 저장"

---

### 2. delegatecall vs call (11:00 - 13:00)

**핵심 개념:**
- `call`: 타겟 컨트랙트의 스토리지 사용
- `delegatecall`: 호출한 컨트랙트의 스토리지 사용 ⚠️
- Proxy 패턴의 기초
- Storage Collision 위험성

**면접 대비 답변:**
- "Proxy 패턴에서 delegatecall을 사용하는 이유: 구현 컨트랙트의 로직을 실행하면서 Proxy의 스토리지를 사용하기 위해"
- "Storage Collision: 구현 컨트랙트와 Proxy의 스토리지 레이아웃이 일치하지 않으면 예상치 못한 변수가 덮어써질 수 있음"

---

### 3. Gas Optimization (14:00 - 16:00)

**핵심 기법:**
- `unchecked` 블록: 오버플로우 체크 제거
- `calldata` vs `memory`: 복사 비용 절약
- 비트맵: 여러 boolean을 하나의 슬롯에 패킹
- 변수 패킹: 슬롯 사용 최소화
- 루프 최적화: 길이를 변수에 저장, `unchecked` 사용

**면접 대비 답변:**
- "가스 최적화 기법 3가지: unchecked 블록, calldata 사용, 비트맵 활용"
- "unchecked는 오버플로우가 발생하지 않음을 수학적으로 보장할 수 있을 때 사용"

---

### 4. Bytecode & ABI (16:00 - 18:00)

**핵심 개념:**
- Function Selector: 함수 시그니처의 Keccak256 해시 첫 4바이트
- ABI 인코딩: `[4 bytes selector][32 bytes param1][32 bytes param2]...`
- 바이트코드 구조: 생성자 코드 + 런타임 코드 + 메타데이터

**면접 대비 답변:**
- "Function Selector는 함수 시그니처를 Keccak256으로 해시한 후 첫 4바이트를 추출"
- "Function Selector 충돌 가능성은 이론적으로 존재하지만 매우 낮음 (2^32 경우의 수)"

---

## ✅ 완료 체크리스트

### 학습 자료
- [x] 각 섹션별 README.md 작성
- [x] 실습 코드 작성
- [x] 테스트 코드 작성
- [x] 연습문제 작성

### 실습 완료
- [ ] Storage Layout 실습 완료
- [ ] delegatecall 실습 완료
- [ ] Gas Optimization 실습 완료 (30% 이상 절약)
- [ ] Bytecode & ABI 실습 완료

### 연습문제
- [ ] 각 섹션별 연습문제 최소 3개 이상 풀이

---

## 🎯 면접 대비 핵심 질문

### 1. EVM Storage Layout
**Q: Solidity에서 `uint128` 두 개를 선언하면 몇 개의 슬롯을 사용하나요?**
- A: 1개의 슬롯을 사용합니다. 각각 16바이트이므로 32바이트 슬롯에 함께 들어갈 수 있습니다.

### 2. delegatecall
**Q: Proxy 패턴에서 delegatecall을 사용하는 이유는?**
- A: 구현 컨트랙트의 로직을 실행하면서 Proxy의 스토리지를 사용하기 위해. 이를 통해 업그레이드 가능한 컨트랙트를 만들 수 있습니다.

### 3. Gas Optimization
**Q: 가스비를 줄이기 위해 어떤 기법을 사용하나요?**
- A: 
  1. `unchecked` 블록으로 오버플로우 체크 제거
  2. `calldata` 사용으로 메모리 복사 비용 제거
  3. 비트맵으로 여러 boolean을 하나의 슬롯에 패킹
  4. 변수 패킹으로 슬롯 사용 최소화

### 4. Bytecode & ABI
**Q: Function Selector는 어떻게 생성되나요?**
- A: 함수 시그니처(함수명과 파라미터 타입)를 Keccak256으로 해시한 후, 첫 4바이트를 추출합니다.

---

## 📝 다음 단계 (Day 2)

Day 2에서는 다음을 학습합니다:
- Foundry Mastery
- Fuzzing Test
- Mainnet Forking
- Invariant Test

**준비물:**
- Foundry 설치 완료
- GitHub 계정
- 집중할 수 있는 환경

---

## 💡 학습 팁

1. **코드를 직접 타이핑하세요**: 복사-붙여넣기보다 직접 작성하면 더 잘 기억합니다.

2. **테스트를 먼저 작성하세요**: TDD 방식으로 학습하면 이해가 빠릅니다.

3. **가스 리포트를 확인하세요**: 최적화의 효과를 수치로 확인할 수 있습니다.

4. **GitHub에 커밋하세요**: 매 섹션마다 커밋하여 학습 기록을 남기세요.

5. **면접 질문을 미리 준비하세요**: 각 섹션의 "면접 대비 질문"을 스스로 답변해보세요.

---

## 🎉 축하합니다!

Day 1을 완료하셨습니다! 이제 블록체인 스마트 컨트랙트 개발의 핵심 개념을 이해하셨습니다.

**오늘의 성과:**
- ✅ EVM Storage Layout 마스터
- ✅ delegatecall vs call 이해
- ✅ Gas Optimization 기법 습득
- ✅ Bytecode & ABI 분석 능력

**내일도 화이팅! 💪**


