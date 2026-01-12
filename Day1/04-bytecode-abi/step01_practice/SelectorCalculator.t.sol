// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {SelectorCalculator, ABIDecoder, BytecodeAnalyzer} from "./SelectorCalculator.sol";

contract SelectorCalculatorTest is Test {
    SelectorCalculator public calculator;
    ABIDecoder public decoder;
    BytecodeAnalyzer public analyzer;
    
    function setUp() public {
        calculator = new SelectorCalculator();
        decoder = new ABIDecoder();
        analyzer = new BytecodeAnalyzer();
    }
    
    function test_GetSelector() public {
        bytes4 selector = calculator.getSelector("transfer(address,uint256)");
        assertEq(selector, 0xa9059cbb);
        
        console.log("Transfer selector:", uint32(selector));
    }
    
    function test_GetMultipleSelectors() public {
        string[] memory funcSigs = new string[](3);
        funcSigs[0] = "transfer(address,uint256)";
        funcSigs[1] = "approve(address,uint256)";
        funcSigs[2] = "balanceOf(address)";
        
        bytes4[] memory selectors = calculator.getSelectors(funcSigs);
        
        assertEq(selectors[0], 0xa9059cbb);
        assertEq(selectors[1], 0x095ea7b3);
        assertEq(selectors[2], 0x70a08231);
        
        console.log("Transfer:", uint32(selectors[0]));
        console.log("Approve:", uint32(selectors[1]));
        console.log("BalanceOf:", uint32(selectors[2]));
    }
    
    function test_ExtractSelector() public {
        address to = address(0x742d35Cc6634C0532925a3b844Bc454e4438f44e);
        uint256 amount = 100;
        
        bytes memory data = abi.encodeWithSignature(
            "transfer(address,uint256)",
            to,
            amount
        );
        
        bytes4 selector = decoder.extractSelector(data);
        assertEq(selector, 0xa9059cbb);
        
        console.log("Extracted selector:", uint32(selector));
    }
    
    function test_DecodeTransfer() public {
        address to = address(0x742d35Cc6634C0532925a3b844Bc454e4438f44e);
        uint256 amount = 100;
        
        bytes memory data = abi.encodeWithSignature(
            "transfer(address,uint256)",
            to,
            amount
        );
        
        (address decodedTo, uint256 decodedAmount) = decoder.decodeTransfer(data);
        
        assertEq(decodedTo, to);
        assertEq(decodedAmount, amount);
        
        console.log("Decoded to:", decodedTo);
        console.log("Decoded amount:", decodedAmount);
    }
    
    function test_BytecodeSize() public {
        uint256 size = analyzer.getBytecodeSize();
        console.log("Contract bytecode size:", size);
        
        // 컨트랙트가 배포되었으므로 크기가 0보다 커야 함
        assertGt(size, 0);
    }
    
    function test_ContractSize() public {
        address testContract = address(calculator);
        uint256 size = analyzer.getContractSize(testContract);
        console.log("Calculator contract size:", size);
        assertGt(size, 0);
    }
    
    function test_RealWorldExample() public {
        // 실제 ERC20 transfer 호출 시뮬레이션
        address token = address(0xdAC17F958D2ee523a2206206994597C13D831ec7); // USDT
        address to = address(0x742d35Cc6634C0532925a3b844Bc454e4438f44e);
        uint256 amount = 100 * 10**6; // 100 USDT (6 decimals)
        
        bytes memory callData = abi.encodeWithSignature(
            "transfer(address,uint256)",
            to,
            amount
        );
        
        bytes4 selector = decoder.extractSelector(callData);
        console.log("USDT transfer selector:", uint32(selector));
        
        // 실제로는 이렇게 호출:
        // (bool success, ) = token.call(callData);
    }
}


