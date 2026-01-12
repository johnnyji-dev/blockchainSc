// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CallComparison
 * @dev call vs delegatecall 비교 실습
 */

contract Library {
    uint256 public value;
    
    function setValue(uint256 _value) external {
        value = _value;
    }
    
    function getValue() external view returns (uint256) {
        return value;
    }
}

contract Caller {
    uint256 public value;
    Library public lib;
    
    constructor(address _lib) {
        lib = Library(_lib);
    }
    
    // call을 사용한 호출
    function useCall(uint256 _value) external returns (bool) {
        (bool success, ) = address(lib).call(
            abi.encodeWithSignature("setValue(uint256)", _value)
        );
        return success;
    }
    
    // delegatecall을 사용한 호출
    function useDelegatecall(uint256 _value) external returns (bool) {
        (bool success, ) = address(lib).delegatecall(
            abi.encodeWithSignature("setValue(uint256)", _value)
        );
        return success;
    }
    
    function getLibValue() external view returns (uint256) {
        return lib.value();
    }
}


