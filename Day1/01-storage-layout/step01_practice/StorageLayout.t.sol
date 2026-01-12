// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {StorageLayout} from "./StorageLayout.sol";

contract StorageLayoutTest is Test {
    StorageLayout public storageLayout;

    function setUp() public {
        storageLayout = new StorageLayout();
    }

    function test_VariablePacking() public {
        // TODO: 변수 패킹이 제대로 작동하는지 테스트
        // 각 변수의 슬롯 위치를 확인하고 검증하세요
        storageLayout.setA(1);
        storageLayout.setB(2);
        storageLayout.setC(3);
        
        // 슬롯 읽기 테스트
        bytes32 slot0 = storageLayout.readSlot(0);
        bytes32 slot1 = storageLayout.readSlot(1);
        
        console.log("Slot 0:", uint256(slot0));
        console.log("Slot 1:", uint256(slot1));
    }

    function test_DynamicArraySlot() public {
        // TODO: 동적 배열 슬롯 계산 테스트
        uint256[] memory values = new uint256[](3);
        values[0] = 100;
        values[1] = 200;
        values[2] = 300;
        
        storageLayout.setDynamicArray(values);
        
        // 배열 슬롯 계산
        // dynamicArray는 Slot 3에 저장됨 (forge inspect로 확인)
        uint256 arraySlot = 3; // dynamicArray의 슬롯 위치
        uint256 index0Slot = storageLayout.readArraySlot(arraySlot, 0);
        uint256 index1Slot = storageLayout.readArraySlot(arraySlot, 1);
        
        console.log("Array[0] slot:", index0Slot);
        console.log("Array[1] slot:", index1Slot);
    }

    function test_MappingSlot() public {
        // TODO: 매핑 슬롯 계산 테스트
        address testAddr = address(0x123);
        uint256 amount = 1000;
        
        storageLayout.setBalance(testAddr, amount);
        
        // 매핑 슬롯 계산
        // balances는 Slot 4에 저장됨 (forge inspect로 확인)
        uint256 mappingSlot = 4; // balances의 슬롯 위치
        uint256 calculatedSlot = storageLayout.readMappingSlot(mappingSlot, testAddr);
        
        console.log("Mapping slot:", calculatedSlot);
        
        // 실제 슬롯에서 값 읽기
        bytes32 value = storageLayout.readSlot(calculatedSlot);
        assertEq(uint256(value), amount);
    }
}


