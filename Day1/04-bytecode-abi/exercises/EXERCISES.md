# Bytecode & ABI 연습문제

## 📝 문제 1: Function Selector 계산

다음 함수들의 Function Selector를 직접 계산하세요.

```solidity
function transfer(address to, uint256 amount) external;
function approve(address spender, uint256 amount) external;
function transferFrom(address from, address to, uint256 amount) external;
function balanceOf(address account) external view returns (uint256);
function totalSupply() external view returns (uint256);
```

**과제:**
1. 각 함수의 시그니처를 작성하세요
2. `SelectorCalculator.sol`을 사용하여 Selector를 계산하세요
3. JavaScript/Node.js로도 계산해보세요
4. [4byte.directory](https://www.4byte.directory/)에서 검증하세요

**힌트:**
```javascript
const { keccak256, toUtf8Bytes } = require("ethers");
const selector = keccak256(toUtf8Bytes("transfer(address,uint256)")).slice(0, 10);
```

---

## 📝 문제 2: ABI 인코딩/디코딩

다음 함수 호출을 ABI 인코딩하고, 다시 디코딩하세요.

```solidity
// 인코딩할 함수 호출
transfer(address(0x742d35Cc6634C0532925a3b844Bc454e4438f44e), 100)

// 인코딩할 함수 호출 2
approve(address(0x1234567890123456789012345678901234567890), 1000)
```

**과제:**
1. `abi.encodeWithSignature`로 인코딩하세요
2. `ABIDecoder.sol`로 디코딩하세요
3. 원본 값과 비교하여 검증하세요

---

## 📝 문제 3: 바이트코드 분석

다음 단계를 수행하여 바이트코드를 분석하세요:

1. 간단한 컨트랙트 작성 및 컴파일
2. 바이트코드 추출
3. Function Selector 찾기
4. 바이트코드 크기 확인

**과제:**
```bash
# 1. 컨트랙트 컴파일
forge build

# 2. 바이트코드 추출
forge inspect ContractName bytecode

# 3. ABI 추출
forge inspect ContractName abi

# 4. 바이트코드 크기 확인
forge inspect ContractName bytecode | wc -c
```

---

## 📝 문제 4: 동적 타입 ABI 인코딩

다음 동적 타입을 포함한 함수 호출을 인코딩하세요.

```solidity
function batchTransfer(address[] memory recipients, uint256[] memory amounts) external;
```

**과제:**
1. 동적 배열을 포함한 ABI 인코딩 이해
2. 오프셋과 길이 정보가 어떻게 포함되는지 분석
3. 실제로 인코딩하고 검증하세요

**힌트:** 동적 타입은 오프셋과 길이 정보가 포함됩니다.

---

## 📝 문제 5: Function Selector 역추적

주어진 Function Selector로부터 가능한 함수 시그니처를 찾아보세요.

```solidity
bytes4 selector1 = 0xa9059cbb;
bytes4 selector2 = 0x095ea7b3;
bytes4 selector3 = 0x23b872dd;
```

**과제:**
1. [4byte.directory](https://www.4byte.directory/)에서 검색
2. 가능한 함수 시그니처 목록 확인
3. 실제 ERC20 표준과 비교

---

## 📝 문제 6: 트랜잭션 데이터 분석

실제 메인넷 트랜잭션의 `data` 필드를 분석하세요.

**과제:**
1. Etherscan에서 ERC20 transfer 트랜잭션 찾기
2. 트랜잭션의 `input data` 복사
3. Function Selector 추출
4. 파라미터 디코딩

**예시 트랜잭션:**
- USDT Transfer: [Etherscan 예시](https://etherscan.io/tx/0x...)

---

## 📝 문제 7: 커스텀 ABI 인코더/디코더

다음 기능을 가진 컨트랙트를 작성하세요:

```solidity
contract CustomABI {
    // 여러 타입을 포함한 복잡한 함수 시그니처 인코딩
    function encodeComplex(
        address addr,
        uint256[] memory numbers,
        string memory text
    ) external pure returns (bytes memory);
    
    // 인코딩된 데이터 디코딩
    function decodeComplex(bytes memory data)
        external
        pure
        returns (
            address addr,
            uint256[] memory numbers,
            string memory text
        );
}
```

**과제:**
1. 복잡한 타입을 포함한 ABI 인코딩 구현
2. 디코딩 함수 구현
3. 테스트 코드 작성

---

## ✅ 체크리스트

각 문제를 완료한 후 체크하세요:

- [ ] 문제 1: Function Selector 계산 완료
- [ ] 문제 2: ABI 인코딩/디코딩 완료
- [ ] 문제 3: 바이트코드 분석 완료
- [ ] 문제 4: 동적 타입 ABI 인코딩 이해
- [ ] 문제 5: Function Selector 역추적 완료
- [ ] 문제 6: 실제 트랜잭션 데이터 분석 완료
- [ ] 문제 7: 커스텀 ABI 인코더/디코더 구현 완료

---

## 🎯 추가 도전 과제

### 도전 1: 바이트코드 디컴파일러 이해

다음 도구들을 사용하여 바이트코드를 분석해보세요:
- [Ethervm](https://ethervm.io/decompile)
- [Dedaub](https://library.dedaub.com/decompile)
- [Panoramix](https://github.com/palkeo/panoramix)

### 도전 2: Function Selector 충돌 찾기

같은 Function Selector를 가진 서로 다른 함수 시그니처를 찾아보세요. (매우 드물지만 존재합니다)

### 도전 3: ABI 인코딩 최적화

가스 최적화를 위해 ABI 인코딩을 최소화하는 방법을 연구하세요. (예: 함수 파라미터 순서 최적화)


