// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Voting, OptimizedVoting} from "./Voting.sol";

contract VotingTest is Test {
    address[] public voters;
    
    function setUp() public {
        voters.push(address(0x1));
        voters.push(address(0x2));
        voters.push(address(0x3));
        voters.push(address(0x4));
        voters.push(address(0x5));
    }
    
    function test_BasicVoting() public {
        Voting voting = new Voting(voters);
        
        // 투표
        vm.prank(voters[0]);
        voting.vote(0);
        
        vm.prank(voters[1]);
        voting.vote(1);
        
        assertEq(voting.getVoteCount(0), 1);
        assertEq(voting.getVoteCount(1), 1);
    }
    
    function testFuzz_Voting(uint256 candidate) public {
        Voting voting = new Voting(voters);
        candidate = bound(candidate, 0, 2);
        
        vm.prank(voters[0]);
        voting.vote(candidate);
        
        assertEq(voting.getVoteCount(candidate), 1);
    }
    
    // TODO: 가스 비교 테스트
    function test_GasComparison() public {
        // 기본 버전 가스 측정
        uint256 gasBefore1 = gasleft();
        Voting voting1 = new Voting(voters);
        uint256 gasUsed1 = gasBefore1 - gasleft();
        
        // 최적화 버전 가스 측정
        uint256 gasBefore2 = gasleft();
        OptimizedVoting voting2 = new OptimizedVoting(voters);
        uint256 gasUsed2 = gasBefore2 - gasleft();
        
        console.log("Basic Voting Gas:", gasUsed1);
        console.log("Optimized Voting Gas:", gasUsed2);
        console.log("Gas Saved:", gasUsed1 - gasUsed2);
        console.log("Gas Saved %:", ((gasUsed1 - gasUsed2) * 100) / gasUsed1);
        
        // 30% 이상 절약 확인
        assertGe(gasUsed1 - gasUsed2, (gasUsed1 * 30) / 100);
    }
}


