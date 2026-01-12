// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title SelectorCalculator
 * @dev Function Selector 계산 및 ABI 디코딩 실습
 */

contract SelectorCalculator {
    /**
     * @dev 함수 시그니처로부터 Function Selector 계산
     * @param funcSig 함수 시그니처 (예: "transfer(address,uint256)")
     * @return selector 4바이트 Function Selector
     */
    function getSelector(string memory funcSig) external pure returns (bytes4 selector) {
        selector = bytes4(keccak256(bytes(funcSig)));
    }
    
    /**
     * @dev 여러 함수 시그니처의 Selector를 한 번에 계산
     */
    function getSelectors(string[] memory funcSigs) 
        external 
        pure 
        returns (bytes4[] memory selectors) 
    {
        selectors = new bytes4[](funcSigs.length);
        for (uint256 i = 0; i < funcSigs.length; ) {
            selectors[i] = bytes4(keccak256(bytes(funcSigs[i])));
            unchecked {
                ++i;
            }
        }
    }
}

contract ABIDecoder {
    /**
     * @dev ABI 인코딩된 데이터에서 Function Selector 추출
     * @param data ABI 인코딩된 함수 호출 데이터
     * @return selector Function Selector (첫 4바이트)
     */
    function extractSelector(bytes memory data) 
        external 
        pure 
        returns (bytes4 selector) 
    {
        require(data.length >= 4, "Data too short");
        assembly {
            selector := mload(add(data, 0x20))
        }
    }
    
    /**
     * @dev transfer 함수의 ABI 디코딩
     * @param data transfer(address,uint256) 호출 데이터
     * @return to 받는 주소
     * @return amount 전송할 양
     */
    function decodeTransfer(bytes memory data) 
        external 
        pure 
        returns (address to, uint256 amount) 
    {
        require(data.length >= 68, "Invalid data length"); // 4 (selector) + 32 + 32
        
        // Selector 제거 (첫 4바이트)
        bytes memory params = new bytes(data.length - 4);
        for (uint256 i = 0; i < params.length; ) {
            params[i] = data[i + 4];
            unchecked {
                ++i;
            }
        }
        
        // 디코딩
        (to, amount) = abi.decode(params, (address, uint256));
    }
    
    /**
     * @dev 일반적인 ABI 디코딩 (타입 지정)
     */
    function decode(bytes memory data, string memory types) 
        external 
        pure 
        returns (bytes memory) 
    {
        // TODO: 동적 타입 디코딩 구현
        // 실제로는 abi.decode를 직접 사용하는 것이 더 안전합니다
        revert("Not implemented");
    }
}

contract BytecodeAnalyzer {
    /**
     * @dev 컨트랙트의 바이트코드 크기 확인
     */
    function getBytecodeSize() external pure returns (uint256 size) {
        assembly {
            size := codesize()
        }
    }
    
    /**
     * @dev 특정 주소의 컨트랙트 바이트코드 크기 확인
     */
    function getContractSize(address addr) external view returns (uint256 size) {
        assembly {
            size := extcodesize(addr)
        }
    }
    
    /**
     * @dev 바이트코드에서 특정 패턴 찾기 (예: Function Selector)
     */
    function findPattern(bytes4 pattern) external view returns (bool found) {
        uint256 codeSize;
        assembly {
            codeSize := codesize()
        }
        
        // 간단한 검색 (실제로는 더 복잡한 로직 필요)
        // 바이트코드에서 직접 패턴을 찾기는 어렵습니다
        // 이는 학습 목적으로만 사용하세요
        return false;
    }
}


