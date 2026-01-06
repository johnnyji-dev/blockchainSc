# 3. Gas Optimization 챌린지

## 📚 학습 목표

- 가스 최적화 기법을 실제 코드에 적용할 수 있다
- `unchecked` 블록을 안전하게 사용할 수 있다
- `calldata`, `memory`, `storage`의 차이를 이해하고 적절히 선택할 수 있다
- 비트맵을 활용한 가스 절약 기법을 익힌다

---

## 🎓 이론 학습

### 가스 비용 비교

| 연산 | 가스 비용 | 비고 |
|------|-----------|------|
| SLOAD (스토리지 읽기) | 2,100 | 첫 읽기 |
| SSTORE (스토리지 쓰기) | 20,000 | 0 → non-zero |
| MLOAD (메모리 읽기) | 3 | |
| MSTORE (메모리 쓰기) | 3 | |
| CALLDATALOAD | 3 | |
| ADD/SUB | 3 | |
| MUL/DIV | 5 | |

### 주요 최적화 기법

#### 1. unchecked 블록

오버플로우 체크를 건너뛰어 가스를 절약합니다.

```solidity
// ❌ 비효율적
function increment(uint256 x) external pure returns (uint256) {
    require(x + 1 > x, "Overflow");  // 가스 소모
    return x + 1;
}

// ✅ 최적화
function increment(uint256 x) external pure returns (uint256) {
    unchecked {
        return x + 1;  // 오버플로우 체크 없음
    }
}
```

**주의:** 오버플로우가 발생하지 않음을 확신할 때만 사용!

#### 2. calldata vs memory vs storage

```solidity
// ❌ 비효율적: memory 사용
function process(uint256[] memory data) external {
    // memory는 복사 비용 발생
}

// ✅ 최적화: calldata 사용 (읽기만 할 때)
function process(uint256[] calldata data) external {
    // calldata는 복사 없이 직접 읽기
}

// ✅ 최적화: storage 직접 사용 (수정할 때)
function process() external {
    uint256[] storage data = myArray;  // 포인터만 사용
}
```

#### 3. 비트맵 (Bitmap)

여러 boolean을 하나의 uint256에 패킹합니다.

```solidity
// ❌ 비효율적
mapping(uint256 => bool) public isActive;  // 각각 1 슬롯 사용

// ✅ 최적화: 비트맵
mapping(uint256 => uint256) public bitmap;  // 256개 boolean을 1 슬롯에

function setActive(uint256 index, bool active) external {
    uint256 slot = index / 256;
    uint256 bit = index % 256;
    
    if (active) {
        bitmap[slot] |= (1 << bit);
    } else {
        bitmap[slot] &= ~(1 << bit);
    }
}

function isActive(uint256 index) external view returns (bool) {
    uint256 slot = index / 256;
    uint256 bit = index % 256;
    return (bitmap[slot] & (1 << bit)) != 0;
}
```

#### 4. 변수 패킹

이미 Day 1에서 학습한 내용입니다. 스토리지 슬롯을 최소화합니다.

#### 5. 루프 최적화

```solidity
// ❌ 비효율적
for (uint256 i = 0; i < array.length; i++) {
    // array.length를 매번 SLOAD
}

// ✅ 최적화
uint256 length = array.length;  // 한 번만 읽기
for (uint256 i = 0; i < length; ) {
    // ...
    unchecked {
        ++i;  // 가스 절약
    }
}
```

---

## 📝 연습문제

### 문제 1: unchecked 사용

다음 함수를 `unchecked`를 사용하여 최적화하세요:

```solidity
function sum(uint256 a, uint256 b) external pure returns (uint256) {
    require(a + b >= a, "Overflow");
    return a + b;
}
```

<details>
<summary>정답 보기</summary>

```solidity
function sum(uint256 a, uint256 b) external pure returns (uint256) {
    unchecked {
        return a + b;
    }
}
```

**주의:** Solidity 0.8.0+ 에서는 기본적으로 오버플로우 체크가 있지만, `unchecked`로 비활성화하면 가스를 절약할 수 있습니다.
</details>

### 문제 2: calldata 최적화

다음 함수를 최적화하세요:

```solidity
function processData(uint256[] memory data) external pure returns (uint256) {
    uint256 sum = 0;
    for (uint256 i = 0; i < data.length; i++) {
        sum += data[i];
    }
    return sum;
}
```

<details>
<summary>정답 보기</summary>

```solidity
function processData(uint256[] calldata data) external pure returns (uint256) {
    uint256 sum = 0;
    uint256 length = data.length;
    for (uint256 i = 0; i < length; ) {
        sum += data[i];
        unchecked {
            ++i;
        }
    }
    return sum;
}
```

**개선 사항:**
1. `memory` → `calldata` (복사 비용 제거)
2. `data.length`를 변수에 저장 (반복 읽기 제거)
3. `unchecked`로 증가 연산 최적화
</details>

---

## 🛠️ 실습과제

### 과제: 투표 컨트랙트 가스 최적화

다음 기본 투표 컨트랙트를 작성하고, **가스비를 30% 이상 줄이세요**.

#### 기본 요구사항:
1. 투표자 등록 기능
2. 투표 기능 (중복 투표 방지)
3. 투표 결과 조회 기능

#### 최적화 목표:
- `unchecked` 블록 활용
- `calldata` 사용
- 비트맵으로 boolean 최적화
- 변수 패킹
- 루프 최적화

#### 측정 방법:
```bash
forge test --gas-report
```

---

## ✅ 체크리스트

- [ ] `unchecked` 블록을 안전하게 사용할 수 있다
- [ ] `calldata`, `memory`, `storage`의 차이를 설명할 수 있다
- [ ] 비트맵을 사용하여 boolean을 최적화할 수 있다
- [ ] 투표 컨트랙트의 가스비를 30% 이상 줄였다
- [ ] `forge test --gas-report`로 가스 사용량을 측정해봤다

---

## 🎯 면접 대비 질문

1. **Q: 가스 최적화 기법 3가지를 설명해주세요.**
   - A: 
     1. `unchecked` 블록: 오버플로우 체크 제거
     2. `calldata` 사용: 메모리 복사 비용 제거
     3. 비트맵: 여러 boolean을 하나의 슬롯에 패킹

2. **Q: 언제 `unchecked`를 사용해야 하나요?**
   - A: 오버플로우가 발생하지 않음을 수학적으로 보장할 수 있을 때. 예: 루프 카운터, 이미 검증된 값의 연산.

3. **Q: `calldata`와 `memory`의 차이는?**
   - A: `calldata`는 읽기 전용으로 복사 비용이 없고, `memory`는 복사 비용이 발생합니다. 읽기만 할 때는 `calldata`를 사용하는 것이 효율적입니다.


