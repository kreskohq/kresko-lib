// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MockSequencerUptimeFeed {
    uint256 internal __startedAt;
    uint256 internal __updatedAt;
    int256 internal answer;

    constructor() {
        __startedAt = block.timestamp;
        __updatedAt = block.timestamp;
    }

    /// @notice 0 = up, 1 = down
    function setAnswer(int256 _answer) external {
        if (answer != _answer) {
            __startedAt = block.timestamp;
            answer = _answer;
        }
        __updatedAt = block.timestamp;
    }

    function latestRoundData()
        public
        view
        virtual
        returns (
            uint80 roundId,
            int256,
            uint256 startedAt,
            uint256 updatedAt,
            uint80
        )
    {
        return (0, answer, __startedAt, updatedAt, 0);
    }
}
