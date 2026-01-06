# 4. Bytecode & ABI 분석

## 📚 학습 목표

- 컴파일된 바이트코드의 구조를 이해한다
- Function Selector (4 bytes)가 어떻게 작동하는지 이해한다
- ABI 인코딩/디코딩을 직접 수행할 수 있다
- 바이트코드를 분석하여 함수를 식별할 수 있다

---

## 🎓 이론 학습

### Function Selector

함수 시그니처의 첫 4바이트를 Function Selector라고 합니다.

#### 계산 방법:

1. **함수 시그니처 작성**
   ```solidity
   function transfer(address to, uint256 amount) external
   ```
   → 시그니처: `"transfer(address,uint256)"`

2. **Keccak256 해시**
   ```javascript
   keccak256("transfer(address,uint256)")
   // 결과: 0xa9059cbb2ab09eb219583f4a59a5d0623ade346d962bcd4e46b11da047c9049b
   ```

3. **첫 4바이트 추출**
   ```
   0xa9059cbb
   ```

### ABI 인코딩

#### 기본 타입 인코딩

```solidity
// 함수 호출 데이터 생성
abi.encodeWithSignature("transfer(address,uint256)", to, amount)
// 또는
abi.encodeWithSelector(0xa9059cbb, to, amount)
```

**구조:**
```
[4 bytes selector][32 bytes param1][32 bytes param2]...
```

#### 예제:

```solidity
function transfer(address to, uint256 amount) external
```

호출 데이터:
```
0xa9059cbb                                    // Function Selector (4 bytes)
000000000000000000000000742d35cc6634c0532925a3b844bc454e4438f44e  // to (32 bytes)
0000000000000000000000000000000000000000000000000000000000000064  // amount (32 bytes)
```

### 바이트코드 구조

컴파일된 컨트랙트 바이트코드는 다음으로 구성됩니다:

1. **생성자 바이트코드**: 컨트랙트 초기화 로직
2. **런타임 바이트코드**: 실제 컨트랙트 로직
3. **메타데이터**: 컴파일러 버전, 소스 코드 해시 등

---

## 📝 연습문제

### 문제 1: Function Selector 계산

다음 함수들의 Function Selector를 계산하세요:

```solidity
function approve(address spender, uint256 amount) external;
function transferFrom(address from, address to, uint256 amount) external;
function balanceOf(address account) external view returns (uint256);
```

<details>
<summary>정답 보기</summary>

```javascript
// JavaScript/Node.js
const { keccak256, toUtf8Bytes } = require("ethers");

function getSelector(funcSig) {
    return keccak256(toUtf8Bytes(funcSig)).slice(0, 10); // 0x + 4 bytes
}

console.log(getSelector("approve(address,uint256)"));
// 0x095ea7b3

console.log(getSelector("transferFrom(address,address,uint256)"));
// 0x23b872dd

console.log(getSelector("balanceOf(address)"));
// 0x70a08231
```

**Solidity에서:**
```solidity
bytes4 selector = bytes4(keccak256("approve(address,uint256)"));
```
</details>

### 문제 2: ABI 인코딩

다음 함수 호출을 ABI 인코딩하세요:

```solidity
transfer(address(0x742d35Cc6634C0532925a3b844Bc454e4438f44e), 100)
```

<details>
<summary>정답 보기</summary>

```solidity
bytes memory data = abi.encodeWithSignature(
    "transfer(address,uint256)",
    0x742d35Cc6634C0532925a3b844Bc454e4438f44e,
    100
);

// 결과:
// 0xa9059cbb
// 000000000000000000000000742d35cc6634c0532925a3b844bc454e4438f44e
// 0000000000000000000000000000000000000000000000000000000000000064
```
</details>

### 문제 3: 바이트코드에서 Function Selector 찾기

컴파일된 바이트코드에서 특정 함수의 위치를 찾는 방법은?

<details>
<summary>정답 보기</summary>

바이트코드에서 Function Selector는 직접적으로 저장되지 않습니다. 대신:

1. **호출 시**: 트랜잭션의 `data` 필드에 Function Selector가 포함됨
2. **런타임**: EVM이 `data`의 첫 4바이트를 읽어 해당 함수로 분기
3. **분석**: 디컴파일러나 바이트코드 분석 도구 사용

**Foundry에서 확인:**
```bash
forge inspect ContractName bytecode
forge inspect ContractName abi
```
</details>

---

## 🛠️ 실습과제

### 과제 1: Function Selector 계산기

다음 기능을 가진 컨트랙트를 작성하세요:

```solidity
contract SelectorCalculator {
    // 함수 시그니처로부터 Selector 계산
    function getSelector(string memory funcSig) external pure returns (bytes4);
    
    // Selector로부터 가능한 함수 시그니처 찾기 (역추적은 불가능하지만 테스트용)
    function callWithSelector(bytes4 selector, bytes memory data) external;
}
```

### 과제 2: ABI 디코더

다음 기능을 가진 컨트랙트를 작성하세요:

```solidity
contract ABIDecoder {
    // ABI 인코딩된 데이터 디코딩
    function decodeTransfer(bytes memory data) 
        external 
        pure 
        returns (address to, uint256 amount);
    
    // Function Selector 추출
    function extractSelector(bytes memory data) 
        external 
        pure 
        returns (bytes4 selector);
}
```

### 과제 3: 바이트코드 분석

Foundry를 사용하여 다음을 수행하세요:

1. 간단한 컨트랙트 컴파일
2. 바이트코드 추출 및 분석
3. Function Selector가 호출 시 어떻게 사용되는지 추적

```bash
# 바이트코드 추출
forge inspect ContractName bytecode

# ABI 추출
forge inspect ContractName abi

# 특정 함수의 바이트코드 위치 찾기 (고급)
```

---

## ✅ 체크리스트

- [ ] Function Selector를 직접 계산해봤다
- [ ] ABI 인코딩/디코딩을 수행해봤다
- [ ] `forge inspect`로 바이트코드를 확인해봤다
- [ ] 트랜잭션의 `data` 필드 구조를 이해했다
- [ ] Function Selector가 EVM에서 어떻게 사용되는지 설명할 수 있다

---

## 🎯 면접 대비 질문

1. **Q: Function Selector는 어떻게 생성되나요?**
   - A: 함수 시그니처(함수명과 파라미터 타입)를 Keccak256으로 해시한 후, 첫 4바이트를 추출합니다.

2. **Q: Function Selector 충돌 가능성은?**
   - A: 이론적으로는 가능하지만 매우 낮습니다. 4바이트 = 2^32 가지 경우의 수. 실제로는 거의 발생하지 않습니다.

3. **Q: ABI 인코딩에서 동적 타입은 어떻게 처리되나요?**
   - A: 고정 크기 타입은 직접 인코딩되지만, 동적 타입(array, bytes, string)은 오프셋과 길이 정보가 포함됩니다.

4. **Q: 바이트코드에서 함수를 찾는 방법은?**
   - A: 바이트코드 자체에는 함수가 직접 저장되지 않습니다. EVM은 트랜잭션의 Function Selector를 읽어 JUMP 테이블을 통해 해당 함수로 분기합니다.

---

## 🔧 유용한 도구

- **Foundry**: `forge inspect` 명령어
- **Ethers.js**: `ethers.utils.Interface`, `ethers.utils.id()`
- **Online Tools**: 
  - [4byte.directory](https://www.4byte.directory/) - Function Selector 데이터베이스
  - [abi.hashex.org](https://abi.hashex.org/) - ABI 인코더/디코더


