// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SimpleProxy
 * @dev 간단한 Proxy 컨트랙트 구현
 * 
 * ⚠️ 주의: 이는 학습용 예제입니다. 프로덕션에서는 OpenZeppelin의
 * UpgradeableProxy를 사용하는 것을 권장합니다.
 */

contract Implementation {
    address public owner;
    uint256 public value;
    
    function initialize() external {
        require(owner == address(0), "Already initialized");
        owner = msg.sender;
    }
    
    function setValue(uint256 _value) external {
        require(msg.sender == owner, "Not owner");
        value = _value;
    }
    
    function getValue() external view returns (uint256) {
        return value;
    }
}

contract SimpleProxy {
    // ⚠️ Storage Collision 방지: implementation을 마지막 슬롯에 배치
    // 또는 EIP-1967 표준 사용
    address public implementation;
    
    constructor(address _implementation) {
        implementation = _implementation;
    }
    
    function upgrade(address newImplementation) external {
        // TODO: 권한 체크 추가 필요
        implementation = newImplementation;
    }
    
    // 모든 호출을 구현 컨트랙트로 위임
    fallback() external payable {
        address impl = implementation;
        require(impl != address(0), "Implementation not set");
        
        assembly {
            // delegatecall 실행
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())
            
            let result := delegatecall(gas(), impl, ptr, calldatasize(), 0, 0)
            
            let size := returndatasize()
            returndatacopy(ptr, 0, size)
            
            switch result
            case 0 { revert(ptr, size) }
            default { return(ptr, size) }
        }
    }
    
    // receive 함수: 이더를 받을 수 있도록
    receive() external payable {}
}


