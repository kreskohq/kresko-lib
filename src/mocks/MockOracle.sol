// SPDX-License-Identifier: BUSL-1.1

pragma solidity ^0.8.0;
import {IAggregatorV3} from "../vendor/IAggregatorV3.sol";

contract MockOracle is IAggregatorV3 {
    uint8 public decimals = 8;
    string public override description;
    uint256 public override version = 1;
    int256 public answer;

    constructor(string memory _desc, uint256 _answr, uint8 _dec) {
        description = _desc;
        answer = int256(_answr);
        decimals = _dec;
    }

    function setPrice(uint256 _answr) external {
        answer = int256(_answr);
    }

    function price() external view returns (uint256) {
        return uint256(answer);
    }

    function getRoundData(
        uint80
    )
        external
        view
        override
        returns (
            uint80 roundId,
            int256,
            uint256 startedAt,
            uint256 updatedAt,
            uint80
        )
    {
        return (1, answer, block.timestamp, block.timestamp, roundId);
    }

    function latestRoundData()
        external
        view
        override
        returns (
            uint80 roundId,
            int256,
            uint256 startedAt,
            uint256 updatedAt,
            uint80
        )
    {
        return (1, answer, block.timestamp, block.timestamp, roundId);
    }
}
