// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {vmFFI} from "../Base.s.sol";
import {PythView, IPyth} from "../../vendor/Pyth.sol";

function getPythData(
    bytes32[] memory _ids,
    string memory _jsPath
) returns (bytes[] memory) {
    string[] memory args = new string[](3 + _ids.length);
    args[0] = "bun";
    args[1] = "--no-warnings";
    args[2] = _jsPath;
    for (uint256 i = 0; i < _ids.length; i++) {
        args[i + 3] = vmFFI.toString(_ids[i]);
    }

    (, bytes[] memory updatedata, ) = abi.decode(
        vmFFI.ffi(args),
        (bytes32[], bytes[], IPyth.Price[])
    );
    return updatedata;
}

function getPythData(
    string memory _ids,
    string memory _jsPath
) returns (bytes[] memory, PythView memory) {
    string[] memory args = new string[](4);

    args[0] = "bun";
    args[1] = "--no-warnings";
    args[2] = _jsPath;
    args[3] = _ids;

    (
        bytes32[] memory ids,
        bytes[] memory updatedata,
        IPyth.Price[] memory prices
    ) = abi.decode(vmFFI.ffi(args), (bytes32[], bytes[], IPyth.Price[]));
    return (updatedata, PythView(ids, prices));
}

function getMockPythPayload(
    bytes32[] memory _ids,
    int64[] memory _prices
) view returns (bytes[] memory) {
    bytes[] memory _updateData = new bytes[](_ids.length);
    for (uint256 i = 0; i < _ids.length; i++) {
        _updateData[i] = abi.encode(
            _ids[i],
            IPyth.Price(
                _prices[i],
                uint64(_prices[i]) / 1000,
                -8,
                block.timestamp
            )
        );
    }
    return _updateData;
}
