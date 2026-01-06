# Gas Optimization 연습문제

## 📝 문제 1: unchecked 사용

다음 함수들을 `unchecked`를 사용하여 최적화하세요.

```solidity
// 문제 1-1
function increment(uint256 x) external pure returns (uint256) {
    require(x + 1 > x, "Overflow");
    return x + 1;
}

// 문제 1-2
function sumArray(uint256[] memory arr) external pure returns (uint256) {
    uint256 sum = 0;
    for (uint256 i = 0; i < arr.length; i++) {
        require(sum + arr[i] >= sum, "Overflow");
        sum += arr[i];
    }
    return sum;
}
```

**과제:**
1. 각 함수를 `unchecked`로 최적화하세요
2. 안전성을 유지하면서 가스를 절약하세요
3. 테스트 코드로 검증하세요

---

## 📝 문제 2: calldata 최적화

다음 함수들을 `calldata`를 사용하여 최적화하세요.

```solidity
// 문제 2-1
function processData(uint256[] memory data) external pure returns (uint256) {
    uint256 sum = 0;
    for (uint256 i = 0; i < data.length; i++) {
        sum += data[i];
    }
    return sum;
}

// 문제 2-2
function validateAddresses(address[] memory addresses) external pure returns (bool) {
    for (uint256 i = 0; i < addresses.length; i++) {
        require(addresses[i] != address(0), "Invalid address");
    }
    return true;
}
```

**과제:**
1. `memory`를 `calldata`로 변경하세요
2. 루프 최적화도 함께 적용하세요
3. 가스 사용량을 비교하세요

---

## 📝 문제 3: 비트맵 구현

다음 요구사항을 만족하는 비트맵 컨트랙트를 작성하세요:

**요구사항:**
1. 여러 boolean 값을 하나의 uint256에 저장
2. `setBit(uint256 index, bool value)` 함수
3. `getBit(uint256 index)` 함수
4. 가스 최적화 적용

**과제:**
1. 비트맵 컨트랙트 작성
2. 일반 `mapping(uint256 => bool)`과 가스 비교
3. 최소 50% 가스 절약 목표

---

## 📝 문제 4: 변수 패킹 최적화

다음 컨트랙트의 변수 순서를 최적화하세요.

```solidity
contract Inefficient {
    uint256 public totalSupply;      // Slot 0
    address public owner;            // Slot 1
    bool public paused;              // Slot 2
    uint256 public maxSupply;        // Slot 3
    address public treasury;         // Slot 4
    uint8 public decimals;           // Slot 5
}
```

**과제:**
1. 변수 순서를 재배치하여 슬롯 사용 최소화
2. 최소 2개 슬롯 절약 목표
3. 기능은 동일하게 유지

---

## 📝 문제 5: 투표 컨트랙트 최적화 (종합)

기본 `Voting.sol` 컨트랙트를 최적화하여 **가스비를 30% 이상 줄이세요**.

**최적화 기법 적용:**
- [ ] `unchecked` 블록
- [ ] `calldata` 사용
- [ ] 비트맵 (boolean 최적화)
- [ ] 변수 패킹
- [ ] 루프 최적화
- [ ] 불필요한 체크 제거

**측정 방법:**
```bash
forge test --gas-report
```

**과제:**
1. `OptimizedVoting.sol` 완성
2. 가스 리포트 생성 및 비교
3. 30% 이상 절약 확인

---

## 📝 문제 6: 문자열 처리 최적화

다음 함수를 최적화하세요.

```solidity
function concatenate(string memory a, string memory b) 
    external 
    pure 
    returns (string memory) 
{
    bytes memory aBytes = bytes(a);
    bytes memory bBytes = bytes(b);
    bytes memory result = new bytes(aBytes.length + bBytes.length);
    
    for (uint256 i = 0; i < aBytes.length; i++) {
        result[i] = aBytes[i];
    }
    
    for (uint256 i = 0; i < bBytes.length; i++) {
        result[aBytes.length + i] = bBytes[i];
    }
    
    return string(result);
}
```

**과제:**
1. 루프 최적화 (`unchecked` 사용)
2. 불필요한 연산 제거
3. 가스 사용량 측정

---

## ✅ 체크리스트

각 문제를 완료한 후 체크하세요:

- [ ] 문제 1: unchecked 최적화 완료
- [ ] 문제 2: calldata 최적화 완료
- [ ] 문제 3: 비트맵 구현 완료
- [ ] 문제 4: 변수 패킹 최적화 완료
- [ ] 문제 5: 투표 컨트랙트 30% 이상 최적화 완료
- [ ] 문제 6: 문자열 처리 최적화 완료

---

## 🎯 추가 도전 과제

### 도전 1: 가스 최적화 마스터

다음 컨트랙트를 **50% 이상** 가스 절약하세요:

```solidity
contract Challenge {
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowances;
    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    
    function transfer(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }
    
    function approve(address spender, uint256 amount) external {
        allowances[msg.sender][spender] = amount;
    }
}
```

### 도전 2: 가스 최적화 도구 사용

다음 도구들을 사용하여 가스 최적화를 수행하세요:
- [Hardhat Gas Reporter](https://github.com/cgewecke/hardhat-gas-reporter)
- [Foundry Gas Snapshots](https://book.getfoundry.sh/reference/forge/forge-snapshot)
- [Tenderly Gas Profiler](https://tenderly.co/)

### 도전 3: 실제 프로젝트 분석

오픈소스 프로젝트(예: Uniswap, Aave)의 가스 최적화 기법을 분석하고 보고서를 작성하세요.


