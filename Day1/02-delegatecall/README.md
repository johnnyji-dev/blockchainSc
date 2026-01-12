# 2. delegatecall vs call

## 📚 학습 목표

- `call`과 `delegatecall`의 차이점을 완벽히 이해한다
- Proxy 패턴의 기초 원리를 코드로 구현할 수 있다
- 컨텍스트 보존 메커니즘을 이해한다

---

## 🎓 이론 학습

### call vs delegatecall

#### `call` (일반 호출)

```solidity
(bool success, bytes memory data) = target.call(abi.encodeWithSignature("function()"));
```

**특징:**
- **컨텍스트 변경**: 호출된 컨트랙트의 스토리지를 사용
- **msg.sender**: 원래 호출자 유지
- **msg.value**: 전달된 이더 유지
- **스토리지**: 호출된 컨트랙트의 스토리지에 접근

#### `delegatecall` (위임 호출)

```solidity
(bool success, bytes memory data) = target.delegatecall(abi.encodeWithSignature("function()"));
```

**특징:**
- **컨텍스트 보존**: 호출한 컨트랙트의 스토리지를 사용 ⚠️
- **msg.sender**: 원래 호출자 유지
- **msg.value**: 전달된 이더 유지
- **스토리지**: 호출한 컨트랙트의 스토리지에 접근 ⚠️

### 핵심 차이점

| 항목 | call | delegatecall |
|------|------|--------------|
| 스토리지 | 타겟 컨트랙트 | 호출한 컨트랙트 |
| 코드 실행 | 타겟 컨트랙트 | 타겟 컨트랙트 |
| 상태 변경 | 타겟 컨트랙트 | 호출한 컨트랙트 |

### 시각적 비교

```
[Contract A] --call--> [Contract B]
                        ↓
                   B의 스토리지 변경

[Contract A] --delegatecall--> [Contract B]
                        ↓
                   A의 스토리지 변경! ⚠️
```

---

## 📝 연습문제

### 문제 1: call vs delegatecall 결과 예측

다음 코드를 실행했을 때 각 컨트랙트의 `value` 값은?

```solidity
contract Library {
    uint256 public value;
    
    function setValue(uint256 _value) external {
        value = _value;
    }
}

contract Caller {
    uint256 public value;
    Library public lib;
    
    constructor(address _lib) {
        lib = Library(_lib);
    }
    
    function useCall(uint256 _value) external {
        (bool success, ) = address(lib).call(
            abi.encodeWithSignature("setValue(uint256)", _value)
        );
    }
    
    function useDelegatecall(uint256 _value) external {
        (bool success, ) = address(lib).delegatecall(
            abi.encodeWithSignature("setValue(uint256)", _value)
        );
    }
}
```

**시나리오:**
1. `caller.useCall(100)` 실행 후
2. `caller.useDelegatecall(200)` 실행 후

<details>
<summary>정답 보기</summary>

1. `useCall(100)` 실행 후:
   - `lib.value` = 100 ✅
   - `caller.value` = 0 (변경 없음)

2. `useDelegatecall(200)` 실행 후:
   - `lib.value` = 100 (변경 없음)
   - `caller.value` = 200 ✅ (Caller의 스토리지가 변경됨!)

**이유:** `delegatecall`은 호출한 컨트랙트(Caller)의 스토리지를 사용합니다.
</details>

### 문제 2: Storage Collision

다음 코드에서 어떤 문제가 발생할까요?

```solidity
contract Library {
    uint256 public storedData;  // Slot 0
}

contract Proxy {
    address public implementation;  // Slot 0 ⚠️
    uint256 public storedData;     // Slot 1
    
    function upgrade(address newImpl) external {
        implementation = newImpl;
    }
    
    function setData(uint256 data) external {
        (bool success, ) = implementation.delegatecall(
            abi.encodeWithSignature("setData(uint256)", data)
        );
    }
}
```

<details>
<summary>정답 보기</summary>

**Storage Collision 발생!**

- `Library.storedData`는 Slot 0을 사용
- `Proxy.implementation`도 Slot 0을 사용
- `delegatecall`로 `Library.setData()`를 호출하면
- `Library`의 Slot 0(`storedData`)에 쓰려고 하지만
- 실제로는 `Proxy`의 Slot 0(`implementation`)이 덮어써짐! 💥

**해결책:** Storage Layout을 일치시켜야 합니다.
</details>

---

## 🛠️ 실습과제

### 과제 1: call vs delegatecall 비교 실습

`step01_practice/CallComparison.sol` 파일을 작성하여 다음을 구현하세요:

1. `Library` 컨트랙트: `setValue(uint256)` 함수
2. `Caller` 컨트랙트:
   - `useCall()`: call을 사용하여 Library 호출
   - `useDelegatecall()`: delegatecall을 사용하여 Library 호출
3. 테스트로 두 방식의 차이를 확인

### 과제 2: 간단한 Proxy 컨트랙트

다음 요구사항을 만족하는 Proxy 컨트랙트를 작성하세요:

```solidity
contract SimpleProxy {
    address public implementation;
    
    // 구현 컨트랙트 업그레이드
    function upgrade(address newImpl) external;
    
    // 모든 호출을 구현 컨트랙트로 위임
    fallback() external;
}
```

**요구사항:**
- Storage Collision을 피하기 위해 올바른 슬롯 배치 사용
- `delegatecall`을 사용하여 구현 컨트랙트의 함수 호출
- 테스트 코드 작성

### 과제 3: Storage Collision 방지

과제 2의 Proxy를 개선하여 Storage Collision을 방지하세요.

**힌트:**
- EIP-1967 표준 사용
- 또는 Storage Slot을 명시적으로 지정

---

## ✅ 체크리스트

- [ ] `call`과 `delegatecall`의 차이를 코드로 설명할 수 있다
- [ ] Storage Collision이 무엇인지 이해했다
- [ ] 간단한 Proxy 컨트랙트를 직접 작성해봤다
- [ ] `delegatecall`로 상태 변수가 덮어써지는 현상을 직접 구현해봤다
- [ ] 테스트 코드로 두 방식의 차이를 검증해봤다

---

## 🎯 면접 대비 질문

1. **Q: Proxy 패턴에서 delegatecall을 사용하는 이유는?**
   - A: 구현 컨트랙트의 로직을 실행하면서 Proxy의 스토리지를 사용하기 위해. 이를 통해 업그레이드 가능한 컨트랙트를 만들 수 있습니다.

2. **Q: delegatecall의 위험성은?**
   - A: Storage Collision. 구현 컨트랙트와 Proxy의 스토리지 레이아웃이 일치하지 않으면 예상치 못한 변수가 덮어써질 수 있습니다.

3. **Q: call과 delegatecall 중 어떤 경우에 어떤 것을 사용하나요?**
   - A: 
     - `call`: 독립적인 컨트랙트 간 상호작용
     - `delegatecall`: Proxy 패턴, 라이브러리 패턴에서 컨텍스트 보존이 필요할 때


