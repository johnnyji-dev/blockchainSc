# 1. EVM Storage Layout 마스터

## 📚 학습 목표

- EVM의 32바이트 슬롯 구조를 완벽히 이해한다
- 변수 패킹(Variable Packing) 원리를 손으로 계산할 수 있다
- 동적 배열과 매핑의 슬롯 계산법을 마스터한다

---

## 🎓 이론 학습

### EVM Storage 기본 구조

EVM의 스토리지는 **2^256개의 슬롯**으로 구성되어 있으며, 각 슬롯은 **32바이트(256비트)**, 한 덩어리(word)입니다.

```
Slot 0: [32 bytes]
Slot 1: [32 bytes]
Slot 2: [32 bytes]
...
Slot 2^256-1: [32 bytes]
```

### 변수 패킹 (Variable Packing)

Solidity는 **같은 슬롯에 여러 변수를 저장**하여 가스를 절약합니다.

#### 규칙:
1. 각 변수는 선언 순서대로 저장됩니다
2. **같은 슬롯에 들어갈 수 있는 경우**에만 패킹됩니다
3. 다음 슬롯으로 넘어가는 조건:
   - 현재 슬롯의 남은 공간이 부족할 때
   - 다음 변수가 32바이트보다 클 때

uint256, bytes32 같은 32바이트 타입은 보통 슬롯 1개를 통째로 사용합니다.
uint8, bool, address(20B)처럼 32바이트보다 작은 값들은 같은 슬롯에 차곡차곡 packing(끼워넣기)될 수 있습니다.

#### 예제 1: 기본 패킹

```solidity
contract PackingExample {
    uint128 a;  // Slot 0 (0-15 bytes)
    uint128 b;  // Slot 0 (16-31 bytes) ✅ 패킹됨!
    uint256 c;  // Slot 1 (전체 슬롯 사용)
}
```

**슬롯 배치:**
- Slot 0: `a` (16 bytes) + `b` (16 bytes) = 32 bytes ✅
- Slot 1: `c` (32 bytes)

Storage Slot (32 bytes = 256 bits)
┌──────────────────────────────────────────────────────────────┐
│ byte[0] ...                                      ... byte[31]│
└──────────────────────────────────────────────────────────────┘

(많이 쓰는 관점: 0~31 바이트가 한 슬롯)
slot[n] = 0x????????????????????????????????????????????????????????????????  (총 64 hex)

slot[0]  ──┐ 32바이트
slot[1]  ──┤ 32바이트
slot[2]  ──┤ 32바이트
...        ┘

// 예시 (개념)
uint128 a; // 16B
uint64  b; // 8B
uint32  c; // 4B
uint32  d; // 4B
// 합계: 16 + 8 + 4 + 4 = 32B → 슬롯 1개에 딱 맞게 packing 가능

slot[k] (32B)
┌──────────────────────────────────────────────────────────────┐
│ a(16B) │ b(8B) │ c(4B) │ d(4B)                               │
└──────────────────────────────────────────────────────────────┘

#### 예제 2: 패킹 실패

```solidity
contract NoPacking {
    uint128 a;  // Slot 0 (0-15 bytes)
    uint256 b;  // Slot 1 (전체 슬롯 사용) - a와 패킹 불가!
    uint128 c;  // Slot 2 (0-15 bytes)
}
```

**이유:** `uint256`은 32바이트를 모두 사용하므로, Slot 0에 `a`와 함께 들어갈 수 없습니다.

### 동적 배열 (Dynamic Array)

동적 타입은 "슬롯 1개에 값이 바로 들어가는 것"이 아니라, 슬롯을 주소(포인터/기준점)처럼 사용하고 실제 데이터는 다른 슬롯들에 흩어져 저장됩니다.

동적 배열은 **2개의 슬롯**을 사용합니다:
1. **길이 슬롯**: 배열의 길이를 저장 (keccak256(slot) 위치)
2. **데이터 슬롯들**: 실제 데이터 (keccak256(slot)부터 시작)

```solidity
contract DynamicArray {
    uint256[] public arr;  // Slot 0: 길이 저장
    // arr[0] -> keccak256(0)
    // arr[1] -> keccak256(0) + 1
    // arr[2] -> keccak256(0) + 2
}
```

### 매핑 (Mapping)

매핑은 **항상 1개의 슬롯**만 사용합니다 (길이 정보 없음).

```solidity
contract MappingExample {
    mapping(address => uint256) public balances;  // Slot 0
    // balances[addr] -> keccak256(addr, 0)
}
```

**계산 공식:**
```
keccak256(abi.encode(key, slot))
```

---

## 📝 연습문제

### 문제 1: 슬롯 계산

다음 컨트랙트에서 각 변수가 어느 슬롯에 저장되는지 계산하세요:

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

<details>
<summary>정답 보기</summary>

- Slot 0: `a` (1 byte) + `b` (2 bytes) + 빈 공간 (13 bytes) + `d` (8 bytes) + `e` (8 bytes) = 32 bytes
- Slot 1: `c` (32 bytes)
- Slot 2: `f` (16 bytes)

**이유:** `uint256 c`는 32바이트를 모두 사용하므로 Slot 0에 들어갈 수 없습니다.
</details>

### 문제 2: 동적 배열 슬롯

다음 컨트랙트에서 `arr[0]`과 `arr[1]`이 저장되는 슬롯을 계산하세요:

```solidity
contract Exercise2 {
    uint256[] public arr;  // Slot 0
}
```

<details>
<summary>정답 보기</summary>

- `arr.length` → Slot 0
- `arr[0]` → `keccak256(0)`
- `arr[1]` → `keccak256(0) + 1`

**계산:**
```javascript
// JavaScript/Node.js 예시
const { keccak256 } = require('ethers');
const slot = 0;
const index0 = keccak256(Buffer.from([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]));
```
</details>

### 문제 3: 매핑 슬롯

다음 컨트랙트에서 `balances[0x123...]`이 저장되는 슬롯을 계산하세요:

```solidity
contract Exercise3 {
    mapping(address => uint256) public balances;  // Slot 1
    uint256 public totalSupply;  // Slot 0
}
```

<details>
<summary>정답 보기</summary>

- `totalSupply` → Slot 0
- `balances[addr]` → `keccak256(abi.encode(addr, 1))`

**계산:**
```solidity
// Solidity에서
bytes32 slot = keccak256(abi.encode(addr, uint256(1)));
```
</details>

---

## 🛠️ 실습과제

### 과제 1: Storage Layout 시각화

1. `practice/StorageLayout.sol` 파일을 생성하세요
2. 다양한 변수 타입을 선언하고 `forge inspect` 명령어로 실제 슬롯 배치를 확인하세요

```bash
forge inspect StorageLayout storage-layout
```

### 과제 2: 변수 패킹 최적화

다음 컨트랙트의 가스를 최적화하기 위해 변수 순서를 재배치하세요:

```solidity
contract Inefficient {
    uint256 a;  // 32 bytes
    uint8 b;    // 1 byte
    uint256 c;  // 32 bytes
    uint8 d;    // 1 byte
}
```

**목표:** 같은 기능을 유지하면서 슬롯 사용을 최소화하세요.

### 과제 3: Storage Reader 작성

다음 기능을 가진 컨트랙트를 작성하세요:

```solidity
contract StorageReader {
    // 특정 슬롯의 값을 읽는 함수
    function readSlot(uint256 slot) external view returns (bytes32);
    
    // 동적 배열의 특정 인덱스 값을 읽는 함수
    function readArraySlot(uint256 arraySlot, uint256 index) 
        external 
        pure 
        returns (uint256 calculatedSlot);
    
    // 매핑의 특정 키 값을 읽는 함수
    function readMappingSlot(uint256 mappingSlot, address key) 
        external 
        pure 
        returns (uint256 calculatedSlot);
}
```

---

## ✅ 체크리스트

- [ ] EVM 스토리지가 2^256개의 32바이트 슬롯으로 구성됨을 이해했다
- [ ] 변수 패킹 규칙을 설명할 수 있다
- [ ] 동적 배열의 슬롯 계산 공식을 외웠다
- [ ] 매핑의 슬롯 계산 공식을 외웠다
- [ ] `forge inspect`로 실제 슬롯 배치를 확인해봤다
- [ ] 변수 패킹 최적화를 직접 해봤다

---

## 🎯 면접 대비 질문

1. **Q: `uint128` 두 개를 선언하면 몇 개의 슬롯을 사용하나요?**
   - A: 1개의 슬롯을 사용합니다. 각각 16바이트이므로 32바이트 슬롯에 함께 들어갈 수 있습니다.

2. **Q: 동적 배열과 매핑의 차이점은?**
   - A: 동적 배열은 길이 정보를 저장하는 슬롯이 필요하지만, 매핑은 길이 정보가 없습니다. 매핑은 키-값 쌍만 저장합니다.

3. **Q: 변수 패킹이 실패하는 경우는?**
   - A: 다음 변수가 32바이트보다 크거나, 현재 슬롯의 남은 공간보다 클 때 실패합니다.

---

## 💻 Assembly를 사용한 Storage 직접 접근

설명드린 `slot[p]`, `T`, `p`, `keccak256(p)` 같은 표현은 **개발자가 이해하기 쉽게 만든 "추상적인 공식"**이며, 일반적인 Solidity 코드(`Counter.sol` 등)에서는 그대로 사용할 수 없습니다.

하지만, **"Assembly(어셈블리)"**라고 불리는 특수한 코드를 사용하면 이 공식대로 **실제 슬롯에 직접 접근**하여 값을 읽거나 쓸 수 있습니다.

### 1. 일반 Solidity 코드에서는? (사용 불가)

우리가 평소에 쓰는 코드(`Counter.sol`)에서는 이런 표현을 쓰지 않습니다.
Solidity가 알아서 이 공식을 내부적으로 처리해주기 때문에, 우리는 그냥 **변수 이름**만 쓰면 됩니다.

```solidity
// 일반적인 Solidity 사용법
uint256[] public arr;

function example() public {
    arr.push(100);      // 그냥 push하면 알아서 슬롯 계산해서 넣음
    uint256 x = arr[0]; // 그냥 인덱스로 접근하면 알아서 가져옴
}
```

### 2. "Assembly"를 쓰면? (사용 가능)

`slot`, `p` 같은 개념을 실제로 코드에서 쓰고 싶다면 `assembly { ... }` 블록을 사용해야 합니다. 이때는 `T`, `p` 대신 실제 변수의 슬롯 위치를 나타내는 문법(`.slot`)을 사용합니다.

예를 들어, `arr`의 길이를 직접 슬롯에서 읽어오는 코드는 다음과 같습니다.

```solidity
uint256[] public arr;

function getLengthFromSlot() public view returns (uint256 length) {
    assembly {
        // arr.slot : arr 변수가 시작되는 슬롯 번호 (공식에서의 'p')
        // sload(p) : p번 슬롯의 값을 읽어와라 (공식에서의 'slot[p]')
        length := sload(arr.slot)
    }
}
```

- `arr.slot`: 여기서 `p`에 해당하는 실제 슬롯 번호를 가져옵니다.
- `sload()`: 특정 슬롯의 데이터를 읽는 명령어입니다.

### 3. 실제 데이터 위치 계산해보기 (심화)

공식에서 본 `keccak256(p)` 위치에 있는 실제 데이터를 가져오는 코드입니다.

```solidity
function getFirstElementFromSlot() public view returns (uint256 element) {
    assembly {
        // 1. p (슬롯 번호) 가져오기
        let p := arr.slot
        
        // 2. keccak256(p) 계산하기
        // 메모리 0번지에 p값을 저장하고 해시를 돌림 (복잡한 과정 필요)
        mstore(0, p)
        let dataSlot := keccak256(0, 32) 
        
        // 3. 계산된 위치에서 데이터 읽기
        element := sload(dataSlot)
    }
}
```

### 요약

1. **설명에 쓴 표현(`slot[p]`, `T` 등):** 이해를 돕기 위한 **수학 공식** 같은 것입니다. 코드에 그대로 복사하면 에러가 납니다.
2. **일반 코딩:** 그냥 `arr.length`, `arr[0]`처럼 편하게 쓰시면 됩니다. Solidity가 알아서 공식을 적용해 줍니다.
3. **고급 코딩(Assembly):** `.slot`, `sload` 같은 특수 명령어를 쓰면 공식과 똑같이 작동하도록 **직접 조작**할 수 있습니다.

질문하신 내용의 핵심은 **"이건 Solidity가 내부적으로 이렇게 작동한다는 설계도"**이며, 실제 코딩할 때는 **자동으로 처리된다**는 점입니다.

---

## 🔐 keccak256 해시 함수

`keccak256`은 이더리움 블록체인에서 가장 기본이 되는 **암호화 해시 함수**입니다.

쉽게 비유하면 **"마법의 분쇄기"**와 같습니다. 어떤 재료(데이터)를 넣든지 간에, 항상 **일정한 크기(32바이트)**의 **알아볼 수 없는 가루(해시값)**로 갈아버립니다.

### 핵심 기능과 특징

1. **고유한 지문 생성 (Deterministic)**
   - 같은 데이터를 넣으면 항상 **똑같은 결과**가 나옵니다.
   - 입력 데이터가 글자 하나만 달라져도 결과는 **완전히 다르게** 바뀝니다(눈사태 효과).
   - *예: `keccak256("apple")`과 `keccak256("apple!")`의 결과는 천지 차이입니다.*

2. **되돌리기 불가능 (One-way)**
   - 갈아버린 가루(해시값)만 보고 원래 재료(입력값)가 무엇이었는지 추측하는 것은 **불가능**합니다.
   - 이 특성 덕분에 비밀번호 검증이나 데이터 무조작 증명에 쓰입니다.

3. **데이터 위치 계산 (주소 생성기)**
   - 아까 설명드린 `mapping`이나 `동적 배열`에서 **데이터가 저장될 슬롯 위치를 정할 때** 이 함수를 씁니다.
   - 마치 "철수의 데이터는 어디에 둘까요?"라고 물으면, `keccak256("철수")`를 돌려서 "38492번 사물함에 넣어!"라고 무작위처럼 보이는(하지만 정해진) 위치를 알려주는 역할을 합니다.

### 원본을 잃어버리면?

`keccak256`으로 데이터를 암호화(정확히는 **해싱**)한 뒤 원본을 잃어버리면, 그 데이터는 **영원히 사용할 수 없게 되어 "디지털 쓰레기"**가 됩니다.

원본을 모를 때 발생하는 구체적인 상황 3가지:

#### 1. 자산 영구 동결 (가장 흔한 사고)
만약 **개인키(Private Key)**를 잃어버리고 해시값(지갑 주소)만 알고 있다면?
- **상황:** 내 지갑에 100억 원어치 비트코인이 들어있는 것은 블록체인 상에서 뻔히 보입니다.
- **문제:** 그 돈을 꺼내려면 "내가 이 주소(해시값)의 주인(원본 키 소유자)이다!"라는 것을 증명해야 하는데, 증명할 원본 키가 없습니다.
- **결과:** 그 돈은 **누구도 꺼낼 수 없는 상태**로 영원히 블록체인에 갇힙니다.

#### 2. 로그인 불가 및 데이터 접근 차단
비밀번호를 해시값으로 저장해둔 시스템에서 원본 비밀번호를 잊어버렸다면?
- **상황:** 서버에는 `keccak256("내비밀번호123")`의 결과인 `0xab12...`만 저장되어 있습니다.
- **문제:** 사용자가 로그인을 시도할 때 입력한 비밀번호를 똑같이 해싱해서 비교해야 하는데, 사용자가 원본을 모릅니다.
- **결과:** 서버 관리자조차 원본 비밀번호를 모르기 때문에, **비밀번호 찾기가 불가능**하고 오직 **비밀번호 재설정**만 가능합니다. (만약 재설정 기능이 없다면 계정은 영구 봉인됩니다.)

#### 3. 검증 실패 (무결성 깨짐)
중요한 문서(계약서 등)의 원본을 잃어버리고 해시값(지문)만 가지고 있다면?
- **상황:** "이 문서의 해시값은 `0x1234...`입니다"라는 기록은 남아있습니다.
- **문제:** 나중에 누군가 위조된 문서를 들고 와도, "이게 원본이 맞다/아니다"를 판별할 **비교 대상(진짜 원본)**이 없습니다.
- **결과:** 법적 효력이나 증명 능력을 잃게 됩니다.

### 요약: 언제 쓰이나요?

1. **서명 만들기:** "이 거래는 내가 보낸 게 확실해!"라고 증명할 때.
2. **ID 만들기:** 유니크한 ID가 필요할 때 (예: NFT ID 생성).
3. **위치 찾기:** 블록체인 저장소(Storage)의 몇 번째 칸에 데이터를 저장할지 결정할 때.

즉, 이더리움 세계에서 **"무언가를 유일하게 식별하거나, 보안이 필요한 곳에 숨겨두고 싶을 때"** 사용하는 필수 도구입니다.

---

## 💼 keccak256 실제 사용 사례

스마트 컨트랙트에서 `keccak256`이 실제로 쓰이는 대표적인 3가지 사례(권한 관리, 고유 ID 생성, 서명 검증)를 코드로 보여드릴게요.

### 1. 역할 기반 권한 관리 (Role-Based Access Control)

가장 흔하게 쓰이는 방식입니다. "관리자", "민터(발행자)" 같은 역할 이름을 `keccak256`으로 해시화하여 고유한 ID(bytes32)로 만듭니다. 문자열을 그대로 비교하는 것보다 가스비가 훨씬 절약됩니다.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RoleManager {
    // "ADMIN_ROLE"이라는 글자를 해시값으로 변환하여 저장 (고유 ID 역할)
    // 예: 0xdf8b4c520ffe197c5343c6f5...
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    mapping(bytes32 => mapping(address => bool)) public roles;

    constructor() {
        // 배포한 사람에게 ADMIN 권한 부여
        roles[ADMIN_ROLE][msg.sender] = true;
    }

    function grantMinter(address _user) external {
        // 호출자가 ADMIN 권한이 있는지 확인
        require(roles[ADMIN_ROLE][msg.sender], "Not Admin");
        roles[MINTER_ROLE][_user] = true;
    }
}
```

**비유:** 이 코드는 **"놀이공원 자유이용권 검사"**와 비슷합니다.
- **`ADMIN_ROLE` (관리자 배지):** "ADMIN_ROLE"이라는 글자를 암호화해서 아무도 위조할 수 없는 **특별한 도장(bytes32)**을 만듭니다. 이 도장은 관리자만 가질 수 있습니다.
- **`constructor` (개장 준비):** 놀이공원을 처음 만든 사람(배포자, `msg.sender`) 손등에 이 **관리자 도장**을 꽝 찍어줍니다 (`roles[ADMIN][나] = true`).
- **`grantMinter` (알바생 채용):**
  1. 누군가 "저 알바 시켜주세요(`grantMinter` 호출)" 하고 찾아옵니다.
  2. 먼저 "너 손등 보여봐. 관리자 도장 있어?" 하고 확인합니다 (`require`).
  3. 도장이 있으면, 그 사람에게 **민터(발행자) 도장**을 새로 찍어줍니다. 도장이 없으면 "넌 관리자가 아니잖아!" 하고 쫓아냅니다.

**핵심:** 긴 이름("ADMIN_ROLE") 대신 **암호화된 도장(해시값)**을 써서 빠르고 정확하게 신분을 확인합니다.

### 2. 고유 ID 생성 (Unique Identifier)

여러 정보(예: 사용자 주소 + 현재 시간 + ID)를 섞어서, 절대 겹치지 않는 유니크한 ID를 만들 때 사용합니다.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract UniqueIDGenerator {
    struct Item {
        bytes32 id;
        string name;
    }
    
    Item[] public items;

    function createItem(string memory _name) public returns (bytes32) {
        // 이름 + 생성자 주소 + 현재 시간(block.timestamp)을 섞어서 해시 생성
        // abi.encodePacked는 여러 인자를 하나로 뭉쳐주는 함수
        bytes32 uniqueId = keccak256(abi.encodePacked(_name, msg.sender, block.timestamp));
        
        items.push(Item(uniqueId, _name));
        return uniqueId;
    }
}
```

**비유:** 이 코드는 **"절대 겹치지 않는 주민등록번호 만들기"**입니다.
- **재료 준비:** 주민번호를 만들 때 다음 세 가지를 섞습니다.
  1. **이름:** "철수" (`_name`)
  2. **만든 사람:** "동사무소 직원 A" (`msg.sender`)
  3. **만든 시간:** "2026년 1월 5일 4시 1분 1초" (`block.timestamp`)
- **`abi.encodePacked` (믹서기 통에 넣기):** 이 세 가지 재료를 믹서기에 넣기 좋게 한 덩어리로 꽉꽉 뭉칩니다.
- **`keccak256` (믹서기 돌리기):** 윙~ 갈아서 **알아볼 수 없는 가루(해시값)**로 만듭니다.
- **결과:** 세상에 단 하나뿐인 ID가 완성됩니다.
  - 같은 "철수"라도 **만든 사람**이 다르거나 **만든 시간**이 0.1초라도 다르면, 완전히 다른 ID가 나옵니다. 그래서 절대 겹칠 일이 없습니다.

### 3. 서명 검증 (Signature Verification)

사용자가 "내가 이 거래를 승인했어"라고 서명(Signature)을 보내면, 컨트랙트가 그 서명이 진짜인지 확인할 때 사용합니다. 이때 서명된 메시지의 원본을 해시화해서 비교합니다.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VerifySignature {
    /* 
    서명 검증 과정:
    1. 메시지(문자열)를 해시화한다.
    2. 이더리움 서명 표준(Prefix 추가)에 맞춰 다시 해시화한다.
    3. ecrecover 함수로 서명에서 주소를 복원하여, 보낸 사람과 일치하는지 확인한다.
    */
    function verify(
        address _signer,
        string memory _message,
        bytes memory _signature
    ) public pure returns (bool) {
        // 1. 메시지 해시 생성
        bytes32 messageHash = keccak256(abi.encodePacked(_message));
        
        // 2. 이더리움 서명된 메시지 해시로 변환
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        
        // 3. 서명 복원 (recover 함수는 별도 구현 필요, 여기선 개념만 설명)
        return recoverSigner(ethSignedMessageHash, _signature) == _signer;
    }

    function getEthSignedMessageHash(bytes32 _messageHash) public pure returns (bytes32) {
        return keccak256(
            abi.encodePacked("\x19Ethereum Signed Message:\n32", _messageHash)
        );
    }
    
    // (참고) recoverSigner는 ecrecover를 사용하여 구현합니다.
    function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) public pure returns (address) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }
    
    function splitSignature(bytes memory sig) public pure returns (bytes32 r, bytes32 s, uint8 v) {
        require(sig.length == 65, "invalid signature length");
        assembly {
            r := mload(add(sig, 32))
            s := mload(add(sig, 64))
            v := byte(0, mload(add(sig, 96)))
        }
    }
}
```

**비유:** 이 코드는 **"비밀 편지와 봉인 확인"**입니다. 옛날 왕이 보낸 밀서가 진짜인지 확인하는 과정과 같습니다.

- **1단계: 편지 내용 확인 (`messageHash`)**
  - "공격하라!"라는 편지(`_message`)를 받았습니다. 이 내용을 믹서기(`keccak256`)에 갈아서 **편지의 지문**을 뜹니다.

- **2단계: 왕실 봉인 확인 (`getEthSignedMessageHash`)**
  - 이 편지가 진짜 왕이 보낸 것이라면, 편지 앞에 **"이더리움 왕국(Ethereum Signed Message)"**이라는 공식 문구가 붙어 있어야 합니다.
  - 이 문구까지 합쳐서 다시 한번 지문을 뜹니다. 이것이 **최종 봉인(해시값)**입니다.

- **3단계: 서명자 확인 (`recoverSigner`)**
  - 편지 봉투에 붙어 있는 **서명(Signature)**을 떼어내서 특수 기계(`ecrecover`)에 넣습니다.
  - 기계는 서명을 분석해서 **"이 서명을 한 사람은 0x1234... 주소를 가진 사람입니다"**라고 알려줍니다.
  - **비교:** 기계가 알려준 사람(`recoverSigner` 결과)이 진짜 왕(`_signer`)과 똑같은 사람이면 **"진짜(true)"**, 아니면 **"가짜(false)"**라고 판별합니다.

### 요약

- **권한:** 긴 문자열("ADMIN_ROLE") 대신 짧고 고유한 `bytes32` ID로 바꿔서 관리 (비용 절감)
- **ID 생성:** 여러 데이터를 섞어서 절대 중복되지 않는 번호표 생성
- **보안:** 서명 위조를 막기 위해 원본 데이터의 '지문'을 떠서 검증

---

## 🔍 서명 검증의 원리: recoverSigner와 keccak256의 차이

`recoverSigner`와 `keccak256`은 둘 다 암호학을 쓰지만, 그 성질은 정반대입니다.

### 결론

1. **recoverSigner(서명 복구)는 one-way와 무관합니다.** 오히려 그 반대로, 서명을 통해 **공개키(Public Key)를 역산(복구)**해내는 과정입니다.
2. **원리:** 타원곡선 암호학(ECDSA)의 수학적 특성을 이용하여, 서명값(v, r, s)과 원본 메시지로부터 **"이 서명을 만들 수 있는 유일한 공개키"**를 계산해냅니다.

### 1. One-way와 무관한 이유 (비유)

- **Keccak256 (One-way):** 믹서기에 사과를 넣고 갈아버린 주스입니다. 주스만 보고 사과 모양을 되돌릴 수 없습니다.
- **RecoverSigner (복구 가능):** 이것은 **"도장 감식"**과 같습니다.
  - 문서(메시지)에 찍힌 도장(서명)을 현미경으로 자세히 들여다보면, **"이 도장은 철수의 도장이다"**라는 사실을 알아낼 수 있습니다.
  - 즉, 도장을 훼손(해시)한 게 아니라, 도장의 무늬(수학적 패턴)를 분석해서 주인을 찾아내는 것입니다.

### 2. recoverSigner의 작동 원리 (초등학생 비유)

기계가 어떻게 "진짜 왕"을 알아보는지 단계별로 설명해 드릴게요.

#### 준비물

- **왕의 비밀 도장 (개인키):** 왕만 가지고 있습니다. 절대 공개 안 함.
- **왕의 공개된 인장 (공개키/주소):** 성벽에 붙어 있어서 누구나 압니다. (예: `0xKing...`)
- **편지 (메시지):** "공격하라"
- **서명 (v, r, s):** 왕이 비밀 도장으로 편지에 찍은 자국입니다.

#### 기계(recoverSigner)의 분석 과정

이 기계는 수학 공식을 사용하는 **역추적 탐정**입니다.

1. **단서 수집:** 탐정에게 "편지 내용"과 "찍힌 도장 자국(서명)"을 줍니다.
2. **수학적 역추적 (ECDSA):**
   - 도장 자국(서명)은 왕의 비밀 도장(개인키)과 편지 내용이 수학적으로 결합된 결과물입니다.
   - 탐정은 이 자국의 곡선 모양과 각도를 분석해서 수학 공식을 거꾸로 풉니다.
   - **공식:** `공개키 = (서명값 s * 랜덤포인트 X - 메시지해시 * 기준점 G) / 서명값 r`
3. **범인 지목 (주소 복구):**
   - 계산을 끝낸 탐정이 외칩니다. **"이런 모양의 도장 자국을 남길 수 있는 도장은 세상에 딱 하나, 바로 `0xKing...`의 도장뿐입니다!"**
4. **최종 확인:**
   - 탐정이 찾아낸 주소(`0xKing...`)가 우리가 알고 있는 진짜 왕의 주소와 **똑같다면**, 이 편지는 진짜 왕이 쓴 게 맞습니다.
   - 다르다면 누군가 위조한 것입니다.

### 3. 누구나 검증 가능하지만 위조는 불가능

서명 검증(`recoverSigner`/`ecrecover`)은 "왕의 편지(서명)가 진짜인지"를 **누구나** 공개 정보만으로 확인할 수 있게 설계된 방식입니다.

#### 왜 누구나 검증할 수 있나

- 검증에 필요한 것은 (1) 메시지(또는 메시지 해시), (2) 서명값(v, r, s), (3) 서명자 주소(왕 주소)처럼 **공개 가능한 정보**뿐입니다.
- `ecrecover`는 서명과 메시지 해시로부터 "이 서명을 만든 공개키(=주소)가 누구인지"를 복구해 주고, 그 결과를 왕의 주소와 비교해서 참/거짓을 판단합니다.

#### 그래도 위조가 어려운 이유

- 공격자는 왕의 **개인키 없이** 왕과 같은 서명을 만들어낼 수 없고, 검증 과정에서 복구된 주소가 왕 주소와 일치하지 않게 됩니다.

### 요약

- `keccak256`은 데이터를 **파괴(단방향)**해서 지문을 만드는 것이고,
- `recoverSigner`는 서명에 남아있는 수학적 흔적을 **역추적(복구)**해서 도장 주인을 찾아내는 기술입니다.
