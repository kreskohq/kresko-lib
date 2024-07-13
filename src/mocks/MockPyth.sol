// SPDX-License-Identifier: MIT
// solhint-disable
pragma solidity ^0.8.0;

import {IPyth, PythView, Price} from "../vendor/Pyth.sol";

contract MockPyth is IPyth {
    mapping(bytes32 => Price) internal prices;

    constructor(bytes[] memory _updateData) {
        updatePriceFeeds(_updateData);
    }

    function getPriceNoOlderThan(
        bytes32 _id,
        uint256 _maxAge
    ) external view override returns (Price memory) {
        if (prices[_id].publishTime >= block.timestamp - _maxAge) {
            return prices[_id];
        }
        revert("Pyth: price too old");
    }

    function getPriceUnsafe(
        bytes32 _id
    ) external view override returns (Price memory) {
        return prices[_id];
    }

    function getUpdateFee(
        bytes[] memory _updateData
    ) external pure override returns (uint256) {
        return abi.decode(_updateData[0], (PythView)).ids.length;
    }

    function updatePriceFeeds(bytes[] memory _updateData) public payable {
        PythView memory _viewData = abi.decode(_updateData[0], (PythView));
        for (uint256 i; i < _viewData.ids.length; i++) {
            _set(_viewData.ids[i], _viewData.prices[i]);
        }
    }

    function updatePriceFeedsIfNecessary(
        bytes[] memory _updateData,
        bytes32[] memory _ids,
        uint64[] memory _publishTimes
    ) external payable override {
        PythView memory _viewData = abi.decode(_updateData[0], (PythView));
        for (uint256 i; i < _ids.length; i++) {
            if (prices[_ids[i]].publishTime < _publishTimes[i]) {
                _set(_viewData.ids[i], _viewData.prices[i]);
            }
        }
    }

    function _set(bytes32 _id, Price memory _price) internal {
        prices[_id] = _price;
    }
}

function createMockPyth(PythView memory _viewData) returns (MockPyth) {
    bytes[] memory _updateData = new bytes[](1);
    _updateData[0] = abi.encode(_viewData);

    return new MockPyth(_updateData);
}
