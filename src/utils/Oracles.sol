// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAggregatorV3} from "../vendor/IAggregatorV3.sol";
import {IAPI3} from "../vendor/IAPI3.sol";
import {toWad} from "./Math.sol";

library CL {
    function price(address _feed) internal view returns (uint256) {
        (, int256 answer, , , ) = IAggregatorV3(_feed).latestRoundData();
        return uint256(answer);
    }

    function price18(address _feed) internal view returns (uint256) {
        (, int256 answer, , , ) = IAggregatorV3(_feed).latestRoundData();
        return toWad(uint256(answer), IAggregatorV3(_feed).decimals());
    }

    function stale(address _feed) internal view returns (bool) {
        (, , , uint256 updatedAt, ) = IAggregatorV3(_feed).latestRoundData();
        return block.timestamp - updatedAt > 1 days;
    }
}

library API3 {
    function price(address _proxy) internal view returns (uint256) {
        (int224 value, ) = IAPI3(_proxy).read();
        return uint256(int256(value));
    }

    function price8(address _proxy) internal view returns (uint256) {
        (int224 value, ) = IAPI3(_proxy).read();
        return uint256(int256(value)) / 1e10;
    }

    function stale(address _proxy) internal view returns (bool) {
        (, uint32 timestamp) = IAPI3(_proxy).read();
        return block.timestamp - timestamp > 1 days;
    }
}
