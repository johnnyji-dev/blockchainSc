# delegatecall 연습문제

## 📝 문제 1: call vs delegatecall 결과 예측

다음 코드를 실행했을 때 각 컨트랙트의 `value` 값을 예측하고, 실제로 테스트해보세요.

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

**과제:**
1. `caller.useCall(100)` 실행 후 각 컨트랙트의 `value` 확인
2. `caller.useDelegatecall(200)` 실행 후 각 컨트랙트의 `value` 확인
3. 결과를 설명하세요

---

## 📝 문제 2: Storage Collision 발견

다음 코드에서 어떤 문제가 발생하는지 찾아보세요.

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

**과제:**
1. Storage Collision이 발생하는 이유를 설명하세요
2. 해결 방법을 제시하세요
3. 수정된 코드를 작성하세요

**힌트:** EIP-1967 표준을 사용하거나, Storage Slot을 명시적으로 지정하세요.

---

## 📝 문제 3: 간단한 Proxy 구현

다음 요구사항을 만족하는 Proxy 컨트랙트를 작성하세요:

**요구사항:**
1. 구현 컨트랙트 업그레이드 기능
2. 모든 호출을 구현 컨트랙트로 위임
3. Storage Collision 방지
4. 초기화 함수 지원

**과제:**
1. `SimpleProxy.sol`을 완성하세요
2. 테스트 코드를 작성하세요
3. 업그레이드가 제대로 작동하는지 확인하세요

---

## 📝 문제 4: 라이브러리 패턴

`delegatecall`을 사용하여 라이브러리 패턴을 구현하세요.

```solidity
library MathLibrary {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }
    
    function multiply(uint256 a, uint256 b) internal pure returns (uint256) {
        return a * b;
    }
}

contract Calculator {
    // TODO: MathLibrary를 사용하여 계산 함수 구현
    // delegatecall을 직접 사용하지 않고, library를 import하여 사용
}
```

**과제:**
1. 라이브러리 함수를 사용하는 컨트랙트 작성
2. 내부적으로 `delegatecall`이 어떻게 사용되는지 이해
3. 테스트 코드 작성

---

## 📝 문제 5: 다중 상속과 delegatecall

다음 컨트랙트에서 `delegatecall` 사용 시 주의사항을 분석하세요.

```solidity
contract Base {
    uint256 public baseValue;
}

contract Middle is Base {
    uint256 public middleValue;
}

contract Top is Middle {
    uint256 public topValue;
    
    function delegatecallTo(address target, bytes memory data) external {
        (bool success, ) = target.delegatecall(data);
        require(success, "Delegatecall failed");
    }
}
```

**과제:**
1. 각 컨트랙트의 스토리지 레이아웃을 분석하세요
2. `delegatecall` 사용 시 Storage Collision 가능성을 확인하세요
3. 안전한 사용 방법을 제시하세요

---

## ✅ 체크리스트

각 문제를 완료한 후 체크하세요:

- [ ] 문제 1: call vs delegatecall 차이 이해
- [ ] 문제 2: Storage Collision 발견 및 해결
- [ ] 문제 3: 간단한 Proxy 구현 완료
- [ ] 문제 4: 라이브러리 패턴 이해
- [ ] 문제 5: 다중 상속과 delegatecall 분석 완료

---

## 🎯 추가 도전 과제

### 도전 1: UUPS Proxy 구현

EIP-1822 표준을 따르는 UUPS (Universal Upgradeable Proxy Standard) Proxy를 구현해보세요.

### 도전 2: Diamond Pattern 이해

EIP-2535 Diamond Pattern에서 `delegatecall`이 어떻게 사용되는지 연구하고, 간단한 예제를 작성해보세요.

### 도전 3: Storage Collision 방지 패턴

여러 라이브러리를 사용하는 컨트랙트에서 Storage Collision을 방지하는 패턴을 설계하세요.


