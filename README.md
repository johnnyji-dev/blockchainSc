# 블록체인 스마트 컨트랙트 개발자

## 📚 학습 구조

각 일차별로 다음 구조로 학습합니다:
- `Day{N}/` - 해당 일차 학습 자료
  - `README.md` - 학습 가이드 및 이론 정리
  - `exercises/` - 연습문제
  - `practice/` - 실습과제 코드

## 🛠️ 환경 설정

### Foundry 설치
```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### 프로젝트 초기화
```bash
forge init Day1/practice
  // 지정된 경우에 기본적인 Foundry 프로젝트 구조를 생성하고 필수 라이브러리를 설치하는 명령어
cd Day1/practice
forge build
  // 경고 메시지들은 오류가 아니라, 최신 버전의 Solidity 컴파일러와 forge-std 라이브러리 간의 문법 호환성 문제로 인해 발생한 경고 | "forge build" 는 프로젝트 내 src, test, script 폴더에 있는 모든 .sol 파일을 컴파일한다. | 컴파일된 결과물(ABI, 바이트코드 등)은 out 디렉토리에 저장됩니다. | 이 명령어가 오류 없이 종료되었다면, 프로젝트는 정상적으로 빌드된 것입니다.
Warning (2424): Natspec memory-safe-assembly special comment for inline assembly is deprecated and scheduled for removal. Use the memory-safe block annotation instead.
    --> lib/forge-std/src/safeconsole.sol:4271:9:
     |
4271 |         assembly {
     |         ^ (Relevant source part starts here and spans across multiple lines).
  // 최신 Solidity 컴파일러(v0.8.20 이상)에서는 어셈블리 블록의 메모리 안전성을 표시하는 방식이 변경되었습니다.
  // 
forge test
```

## 📅 학습 일정

- [Day 1: Solidity Deep Dive & EVM](./Day1/README.md) ⬅️ 현재 학습 중
- Day 2: Foundry Mastery
- Day 3: Security & Hacking
- Day 4: Backend Integration
- Day 5: End-to-End System & Docker
- Day 6-7: Project Refactoring & Coding Test
- Day 8: Account Abstraction (ERC-4337)
- Day 9: L2 & Scalability
- Day 10: System Design
- Day 11: ZKP & Trend
- Day 12: Interview Simulation
- Day 13: Final Polish
- Day 14: Rest & Mind Control

## 💡 학습 원칙

1. **Hands-on**: 반드시 코드를 직접 작성하고 실행해보세요
2. **GitHub 잔디**: 매일 커밋하여 학습 기록을 남기세요
3. **이해 중심**: 암기보다는 "왜?"를 계속 물어보세요
4. **면접 대비**: 각 개념을 면접에서 설명할 수 있도록 준비하세요

