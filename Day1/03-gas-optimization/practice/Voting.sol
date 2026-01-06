// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title Voting
 * @dev 가스 최적화 챌린지: 투표 컨트랙트
 * 
 * 목표: 가스비를 30% 이상 줄이기
 * 
 * 최적화 기법 적용:
 * 1. unchecked 블록
 * 2. calldata 사용
 * 3. 비트맵 (여러 boolean을 하나의 uint256에)
 * 4. 변수 패킹
 * 5. 루프 최적화
 */

contract Voting {
    // ============ 기본 버전 (비최적화) ============
    
    struct Voter {
        bool registered;
        bool voted;
        uint256 vote;
    }
    
    mapping(address => Voter) public voters;
    uint256[] public voteCounts;
    address public chairperson;
    
    constructor(address[] memory _voters) {
        chairperson = msg.sender;
        voteCounts = new uint256[](3); // 후보자 3명
        
        // 등록
        for (uint256 i = 0; i < _voters.length; i++) {
            voters[_voters[i]].registered = true;
        }
    }
    
    function vote(uint256 candidate) external {
        require(voters[msg.sender].registered, "Not registered");
        require(!voters[msg.sender].voted, "Already voted");
        require(candidate < voteCounts.length, "Invalid candidate");
        
        voters[msg.sender].voted = true;
        voters[msg.sender].vote = candidate;
        voteCounts[candidate]++;
    }
    
    function getVoteCount(uint256 candidate) external view returns (uint256) {
        return voteCounts[candidate];
    }
}

// ============ 최적화 버전 (과제) ============

contract OptimizedVoting {
    // TODO: 가스 최적화를 적용하세요
    
    // 힌트 1: 비트맵 사용
    // mapping(address => uint256) private voterBitmap;
    // 비트 0: registered, 비트 1: voted
    
    // 힌트 2: 변수 패킹
    // struct를 최소화하거나 제거
    
    // 힌트 3: calldata 사용
    // constructor(address[] calldata _voters)
    
    // 힌트 4: unchecked 사용
    // 루프 카운터, 배열 인덱스 등
    
    // TODO: 여기에 최적화된 코드 작성
}


