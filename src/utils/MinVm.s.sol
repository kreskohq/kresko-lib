// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {FFIVm, hasVM, vmAddr} from "./Base.sol";

interface IMinVM is FFIVm {
    function readFile(string memory) external returns (string memory);

    function writeFile(string calldata, string calldata) external;

    function writeJson(string calldata json, string calldata path) external;

    function exists(string calldata) external returns (bool);

    function writeJson(
        string calldata json,
        string calldata path,
        string calldata valueKey
    ) external;

    function parseJson(
        string calldata
    ) external pure returns (bytes memory encoded);

    function parseJson(
        string calldata json,
        string calldata key
    ) external pure returns (bytes memory encoded);

    function isFile(string calldata) external view returns (bool);

    function snapshot() external returns (uint256);

    function revertTo(uint256) external returns (bool);

    function warp(uint256 newTime) external;

    function projectRoot() external view returns (string memory);

    function unixTime() external returns (uint256 ms);

    function startBroadcast(address) external;

    function stopBroadcast() external;

    function startPrank(address) external;

    function stopPrank() external;

    function rememberKey(uint256) external returns (address);

    function deriveKey(string calldata, uint32) external pure returns (uint256);

    function envOr(
        string calldata n,
        string calldata d
    ) external returns (string memory);

    function envOr(string calldata n, uint256 d) external returns (uint256);

    function envOr(string calldata n, address d) external returns (address);

    function rpc(
        string calldata m,
        string calldata p
    ) external returns (string memory);

    function activeFork() external returns (uint256);

    function selectFork(uint256) external;

    function createFork(string calldata urlOrAlias) external returns (uint256);

    function createSelectFork(
        string memory urlOrAlias
    ) external returns (uint256);

    function load(address t, bytes32 s) external view returns (bytes32);

    // Signs data
    function sign(
        uint256 pk,
        bytes32 d
    ) external pure returns (uint8 v, bytes32 r, bytes32 s);

    function record() external;

    function accesses(
        address t
    ) external returns (bytes32[] memory reads, bytes32[] memory wries);

    function getCode(string calldata a) external view returns (bytes memory cc);

    function setEnv(string calldata k, string calldata v) external;

    function allowCheatcodes(address addr) external;
}

IMinVM constant mvm = IMinVM(vmAddr);

function mPk(string memory _mEnv, uint32 _idx) returns (uint256) {
    return mvm.deriveKey(mvm.envOr(_mEnv, "error burger code"), _idx);
}

function mAddr(string memory _mEnv, uint32 _idx) returns (address) {
    return
        mvm.rememberKey(
            mvm.deriveKey(mvm.envOr(_mEnv, "error burger code"), _idx)
        );
}

struct Store {
    bool _failed;
    bool logDisabled;
    string logPrefix;
}

function store() view returns (Store storage s) {
    if (!hasVM()) revert("no hevm");
    assembly {
        s.slot := 0x35b9089429a720996a27ffd842a4c293f759fc6856f1c672c8e2b5040a1eddfe
    }
}
