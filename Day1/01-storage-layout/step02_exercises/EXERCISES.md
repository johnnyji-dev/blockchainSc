# Storage Layout 연습문제

## 📝 문제 1: 슬롯 계산 (기본)

다음 컨트랙트에서 각 변수가 어느 슬롯에 저장되는지 계산하고, 실제로 확인해보세요.

```solidity
contract Exercise1 {
    uint8 a;
    uint16 b;
    uint256 c;
    uint64 d;
    uint64 e;
    uint128 f;
}
```

**과제:**
1. 각 변수의 슬롯 위치를 손으로 계산하세요
2. `StorageLayout.sol`에 이 변수들을 추가하고 테스트하세요
3. `forge inspect`로 실제 슬롯 배치를 확인하세요

---

## 📝 문제 2: 동적 배열 슬롯 계산

다음 컨트랙트에서 `arr[0]`과 `arr[1]`이 저장되는 슬롯을 계산하세요.

```solidity
contract Exercise2 {
    uint256[] public arr;  // Slot 0
}
```

**과제:**
1. `keccak256(0)`을 계산하세요 (JavaScript 또는 Solidity 사용)
2. `arr[1]`의 슬롯을 계산하세요
3. 실제로 값을 설정하고 `readSlot`으로 확인하세요

**힌트:**
```javascript
// JavaScript
const { keccak256, toUtf8Bytes } = require("ethers");
const slot = 0;
const index0Slot = keccak256(new Uint8Array(32).fill(0));
```

---

## 📝 문제 3: 매핑 슬롯 계산

다음 컨트랙트에서 `balances[0x123...]`이 저장되는 슬롯을 계산하세요.

```solidity
contract Exercise3 {
    mapping(address => uint256) public balances;  // Slot 1
    uint256 public totalSupply;  // Slot 0
}
```

**과제:**
1. `keccak256(abi.encode(addr, 1))`을 계산하세요
2. 실제로 값을 설정하고 해당 슬롯에서 읽어보세요
3. `readMappingSlot` 함수로 검증하세요

---

## 📝 문제 4: 변수 패킹 최적화

다음 컨트랙트의 가스를 최적화하기 위해 변수 순서를 재배치하세요.

```solidity
contract Inefficient {
    uint256 a;  // 32 bytes - Slot 0
    uint8 b;    // 1 byte - Slot 1 (패킹 실패!)
    uint256 c;  // 32 bytes - Slot 2
    uint8 d;    // 1 byte - Slot 3 (패킹 실패!)
}
```

**목표:** 같은 기능을 유지하면서 슬롯 사용을 최소화하세요.

**정답:**
```solidity
contract Optimized {
    uint8 b;    // 1 byte
    uint8 d;    // 1 byte
    uint256 a;  // 32 bytes
    uint256 c;  // 32 bytes
    // 총 3개 슬롯 사용 (기존 4개에서 1개 절약!)
}
```

---

## 📝 문제 5: 중첩 구조체

다음 구조체의 스토리지 레이아웃을 분석하세요.

```solidity
struct User {
    address addr;
    uint64 balance;
    uint64 timestamp;
    bool active;
}

contract Exercise5 {
    mapping(address => User) public users;
}
```

**과제:**
1. `User` 구조체가 몇 개의 슬롯을 사용하는지 계산하세요
2. `users[addr]`의 각 필드가 어느 슬롯에 저장되는지 계산하세요
3. 실제로 값을 설정하고 확인하세요

---

## ✅ 체크리스트

각 문제를 완료한 후 체크하세요:

- [ ] 문제 1: 기본 슬롯 계산 완료
- [ ] 문제 2: 동적 배열 슬롯 계산 완료
- [ ] 문제 3: 매핑 슬롯 계산 완료
- [ ] 문제 4: 변수 패킹 최적화 완료
- [ ] 문제 5: 중첩 구조체 분석 완료

---

## 🎯 추가 도전 과제

### 도전 1: Storage Collision 찾기

다음 컨트랙트에서 Storage Collision이 발생하는지 확인하세요.

```solidity
contract Parent {
    uint256 a;
}

contract Child is Parent {
    uint256 b;
    uint256[] arr;
}
```

### 도전 2: 복잡한 구조 분석

ERC20 컨트랙트의 스토리지 레이아웃을 분석하세요:
- `_balances` 매핑
- `_allowances` 매핑
- `_totalSupply` 변수

각각이 어느 슬롯에 저장되는지 계산해보세요.


