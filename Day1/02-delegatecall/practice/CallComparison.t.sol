// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Library, Caller} from "./CallComparison.sol";

contract CallComparisonTest is Test {
    Library public lib;
    Caller public caller;
    
    function setUp() public {
        lib = new Library();
        caller = new Caller(address(lib));
    }
    
    function test_CallDoesNotModifyCallerStorage() public {
        // call 사용
        caller.useCall(100);
        
        // Library의 value는 변경됨
        assertEq(lib.value(), 100);
        
        // Caller의 value는 변경되지 않음
        assertEq(caller.value(), 0);
    }
    
    function test_DelegatecallModifiesCallerStorage() public {
        // delegatecall 사용
        caller.useDelegatecall(200);
        
        // Library의 value는 변경되지 않음
        assertEq(lib.value(), 0);
        
        // Caller의 value가 변경됨! ⚠️
        assertEq(caller.value(), 200);
        
        console.log("Library value:", lib.value());
        console.log("Caller value:", caller.value());
    }
    
    function test_BothMethods() public {
        // call 먼저 실행
        caller.useCall(100);
        assertEq(lib.value(), 100);
        assertEq(caller.value(), 0);
        
        // delegatecall 실행
        caller.useDelegatecall(200);
        assertEq(lib.value(), 100); // 변경 없음
        assertEq(caller.value(), 200); // 변경됨!
    }
}


