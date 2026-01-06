// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}

/*
 * 테스트 실행 결과 설명
 * 
 * 1. 테스트 실행
 *    - forge test 명령어로 테스트를 실행합니다
 *    - 총 2개의 테스트가 실행됩니다:
 *      * test_Increment(): 숫자가 1씩 증가하는지 확인
 *      * testFuzz_SetNumber(uint256): 무작위 숫자로 값을 설정하는 퍼즈 테스트 (256번 실행)
 * 
 * 2. 가스비(Gas) 설명
 *    - μ (뮤): 평균 가스 소모량
 *    - ~ (물결): 중간값 가스 소모량
 *    - 블록체인에 값을 처음 기록할 때(0 → 1)는 많은 가스가 필요하지만,
 *      이미 있는 값을 수정할 때(1 → 2)는 상대적으로 적은 가스가 소요됩니다
 * 
 * 3. 왜 counter.number()를 사용하나요?
 * 
 *    Solidity에서 public 변수는 자동으로 Getter 함수가 생성됩니다.
 *    다른 컨트랙트에서 변수에 접근할 때는 직접 접근이 불가능하며,
 *    반드시 Getter 함수를 호출해야 합니다.
 * 
 *    - counter.number (X): 직접 접근은 불가능
 *    - counter.number() (O): Getter 함수 호출로 접근
 * 
 *    같은 컨트랙트 내부에서는 변수 이름만으로 접근 가능하지만,
 *    외부 컨트랙트에서는 함수 호출 형태인 ()를 반드시 붙여야 합니다.
 */