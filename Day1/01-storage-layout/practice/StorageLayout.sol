// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title StorageLayout
 * @dev EVM Storage Layout 학습을 위한 실습 컨트랙트
 * 
 * 학습 목표:
 * 1. 변수 패킹 이해
 * 2. 동적 배열 슬롯 계산
 * 3. 매핑 슬롯 계산
 */
contract StorageLayout {
    // 연습문제 1: 이 변수들이 어느 슬롯에 저장되는지 계산해보세요
    uint8 public a;
    uint16 public b;
    uint256 public c;
    uint64 public d;
    uint64 public e;
    uint128 public f;

    // 연습문제 2: 동적 배열
    uint256[] public dynamicArray;

    // 연습문제 3: 매핑
    mapping(address => uint256) public balances;
    uint256 public totalSupply;

    // 실습과제: Storage Reader 함수들
    function readSlot(uint256 slot) external view returns (bytes32 value) {
        assembly {
            value := sload(slot)
        }
    }

    function readArraySlot(uint256 arraySlot, uint256 index) 
        external 
        pure 
        returns (uint256 calculatedSlot) 
    {
        // TODO: 동적 배열의 인덱스 슬롯 계산
        // 힌트: keccak256(arraySlot) + index
        calculatedSlot = uint256(keccak256(abi.encode(arraySlot))) + index;
    }

    function readMappingSlot(uint256 mappingSlot, address key) 
        external 
        pure 
        returns (uint256 calculatedSlot) 
    {
        // TODO: 매핑의 키 슬롯 계산
        // 힌트: keccak256(abi.encode(key, mappingSlot))
        calculatedSlot = uint256(keccak256(abi.encode(key, mappingSlot)));
    }

    // 테스트용 setter 함수들
    function set_a(uint8 _a) external {
        a = _a;
    }
    
    function set_b(uint16 _b) external {
        b = _b;
    }
    
    function set_c(uint256 _c) external {
        c = _c;
    }
    
    function setDynamicArray(uint256[] memory values) external {
        dynamicArray = values;
    }

    function setBalance(address account, uint256 amount) external {
        balances[account] = amount;
        totalSupply += amount;
    }
}

