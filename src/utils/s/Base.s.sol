// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Purify} from "../Purify.sol";

address constant clgAddr = 0x000000000000000000636F6e736F6c652e6c6f67;
address constant fSender = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
address constant vmAddr = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;

string constant BASE_FFI_DIR = "./lib/kresko-lib/utils/";

function getFFIPath(string memory _path) pure returns (string memory) {
    return string.concat(BASE_FFI_DIR, _path);
}

function logp(bytes memory _p) pure {
    Purify.BytesIn(logv)(_p);
}

function logv(bytes memory _b) view {
    uint256 len = _b.length;
    address _a = clgAddr;
    /// @solidity memory-safe-assembly
    assembly {
        let start := add(_b, 32)
        let r := staticcall(gas(), _a, start, len, 0, 0)
    }
}

struct FFIResult {
    int32 exitCode;
    bytes stdout;
    bytes stderr;
}

interface FFIVm {
    function ffi(string[] memory) external returns (bytes memory);

    function tryFfi(string[] memory) external returns (FFIResult memory);

    function toString(bytes32) external view returns (string memory);

    function toString(address) external view returns (string memory);

    function toString(uint256) external view returns (string memory);
    function toString(
        bytes calldata value
    ) external pure returns (string memory r);
}

FFIVm constant vmFFI = FFIVm(vmAddr);

function hasVM() view returns (bool) {
    uint256 len = 0;
    assembly {
        len := extcodesize(vmAddr)
    }
    return len > 0;
}

function execFFI(string[] memory args) returns (bytes memory) {
    FFIResult memory res = vmFFI.tryFfi(args);
    if (res.exitCode == 1) {
        revert(abi.decode(res.stdout, (string)));
    }
    return res.stdout;
}
