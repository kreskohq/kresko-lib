// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {FFIVm, hasVM, vmAddr} from "./Base.s.sol";
import {Purify} from "../Purify.sol";

interface IMinVM is FFIVm {
    enum CallerMode {
        // No caller modification is currently active.
        None,
        // A one time broadcast triggered by a `vm.broadcast()` call is currently active.
        Broadcast,
        // A recurrent broadcast triggered by a `vm.startBroadcast()` call is currently active.
        RecurrentBroadcast,
        // A one time prank triggered by a `vm.prank()` call is currently active.
        Prank,
        // A recurrent prank triggered by a `vm.startPrank()` call is currently active.
        RecurrentPrank
    }

    function broadcast(address signer) external;

    function getNonce(address) external returns (uint256);

    function readCallers() external returns (CallerMode, address, address);

    function readFile(string memory) external returns (string memory);

    function writeFile(string calldata, string calldata) external;

    function exists(string calldata) external returns (bool);

    function assertTrue(bool) external pure;

    function assertTrue(bool, string calldata) external pure;

    function copyFile(
        string calldata from,
        string calldata to
    ) external returns (uint64 copied);

    function createDir(string calldata path, bool recursive) external;

    function replace(
        string calldata input,
        string calldata from,
        string calldata to
    ) external pure returns (string memory output);

    function split(
        string calldata input,
        string calldata delimiter
    ) external pure returns (string[] memory outputs);

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

    function startBroadcast(address) external;

    function stopBroadcast() external;

    function startPrank(address) external;

    function startPrank(address, address) external;

    function stopPrank() external;

    function prank(address, address) external;

    function prank(address) external;

    function rememberKey(uint256) external returns (address);

    function deriveKey(string calldata, uint32) external pure returns (uint256);

    function envOr(
        string calldata n,
        string calldata d
    ) external returns (string memory);

    function envOr(string calldata n, uint256 d) external returns (uint256);

    function envOr(string calldata n, address d) external returns (address);

    function envString(string calldata n) external returns (string memory);

    function envUint(string calldata n) external returns (uint256);

    function envAddress(string calldata n) external returns (address);

    function createFork(string calldata urlOrAlias) external returns (uint256);

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

    function toString(address value) external pure returns (string memory r);

    function toString(
        bytes calldata value
    ) external pure returns (string memory r);

    function toString(bytes32 value) external pure returns (string memory r);

    function toString(bool value) external pure returns (string memory r);

    function toString(uint256 value) external pure returns (string memory r);

    function toString(int256 value) external pure returns (string memory r);

    // Convert values from a string
    function parseBytes(
        string calldata str
    ) external pure returns (bytes memory r);

    function parseAddress(
        string calldata str
    ) external pure returns (address r);

    function parseUint(string calldata str) external pure returns (uint256 r);

    function parseInt(string calldata str) external pure returns (int256 r);

    function parseBytes32(
        string calldata str
    ) external pure returns (bytes32 r);

    function parseBool(string calldata str) external pure returns (bool r);

    function rpc(string calldata method, string calldata params) external;

    function createSelectFork(
        string calldata network
    ) external returns (uint256);

    function createSelectFork(
        string calldata network,
        uint256 blockNr
    ) external returns (uint256);

    function allowCheatcodes(address to) external;

    function unixTime() external returns (uint256);

    function activeFork() external view returns (uint256);

    function selectFork(uint256 forkId) external;

    function rollFork(uint256 blockNumber) external;

    function rollFork(uint256 forkId, uint256 blockNumber) external;

    /// See `serializeJson`.
    function serializeAddress(
        string calldata objk,
        string calldata valk,
        address value
    ) external returns (string memory json);

    /// See `serializeJson`.
    function serializeAddress(
        string calldata objk,
        string calldata valk,
        address[] calldata values
    ) external returns (string memory json);

    /// See `serializeJson`.
    function serializeBool(
        string calldata objk,
        string calldata valk,
        bool value
    ) external returns (string memory json);

    /// See `serializeJson`.
    function serializeBool(
        string calldata objk,
        string calldata valk,
        bool[] calldata values
    ) external returns (string memory json);

    /// See `serializeJson`.
    function serializeBytes32(
        string calldata objk,
        string calldata valk,
        bytes32 value
    ) external returns (string memory json);

    /// See `serializeJson`.
    function serializeBytes32(
        string calldata objk,
        string calldata valk,
        bytes32[] calldata values
    ) external returns (string memory json);

    /// See `serializeJson`.
    function serializeBytes(
        string calldata objk,
        string calldata valk,
        bytes calldata value
    ) external returns (string memory json);

    /// See `serializeJson`.
    function serializeBytes(
        string calldata objk,
        string calldata valk,
        bytes[] calldata values
    ) external returns (string memory json);

    /// See `serializeJson`.
    function serializeInt(
        string calldata objk,
        string calldata valueKey,
        int256 value
    ) external returns (string memory json);

    /// See `serializeJson`.
    function serializeInt(
        string calldata objk,
        string calldata valk,
        int256[] calldata values
    ) external returns (string memory json);

    /// Serializes a key and value to a JSON object stored in-memory that can be later written to a file.
    /// Returns the stringified version of the specific JSON file up to that moment.
    function serializeJson(
        string calldata objk,
        string calldata value
    ) external returns (string memory json);

    /// See `serializeJson`.
    function serializeString(
        string calldata objk,
        string calldata valk,
        string calldata value
    ) external returns (string memory json);

    /// See `serializeJson`.
    function serializeString(
        string calldata objk,
        string calldata valk,
        string[] calldata values
    ) external returns (string memory json);

    /// See `serializeJson`.
    function serializeUint(
        string calldata objk,
        string calldata valk,
        uint256 value
    ) external returns (string memory json);

    /// See `serializeJson`.
    function serializeUint(
        string calldata objk,
        string calldata valk,
        uint256[] calldata values
    ) external returns (string memory json);

    /// Write a serialized JSON object to a file. If the file exists, it will be overwritten.
    function writeJson(string calldata json, string calldata path) external;
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

library LibVm {
    struct Callers {
        address msgSender;
        address txOrigin;
        string mode;
    }

    function callmode() internal returns (string memory) {
        (IMinVM.CallerMode _m, , ) = mvm.readCallers();
        return callModeStr(_m);
    }

    function clearCallers()
        internal
        returns (IMinVM.CallerMode m_, address s_, address o_)
    {
        (m_, s_, o_) = unbroadcast();

        if (
            m_ == IMinVM.CallerMode.Prank ||
            m_ == IMinVM.CallerMode.RecurrentPrank
        ) {
            mvm.stopPrank();
        }
    }

    function getTime() internal returns (uint256) {
        return uint256(mvm.unixTime() / 1000);
    }

    function restore(IMinVM.CallerMode _m, address _ss, address _so) internal {
        if (_m == IMinVM.CallerMode.Broadcast) mvm.broadcast(_ss);
        if (_m == IMinVM.CallerMode.RecurrentBroadcast) mvm.startBroadcast(_ss);
        if (_m == IMinVM.CallerMode.Prank) {
            _ss == _so ? mvm.prank(_ss, _so) : mvm.prank(_ss);
        }
        if (_m == IMinVM.CallerMode.RecurrentPrank) {
            _ss == _so ? mvm.startPrank(_ss, _so) : mvm.startPrank(_ss);
        }
    }

    function unbroadcast()
        internal
        returns (IMinVM.CallerMode m_, address s_, address o_)
    {
        (m_, s_, o_) = mvm.readCallers();
        if (
            m_ == IMinVM.CallerMode.Broadcast ||
            m_ == IMinVM.CallerMode.RecurrentBroadcast
        ) {
            mvm.stopBroadcast();
        }
    }

    function unprank()
        internal
        returns (IMinVM.CallerMode m_, address s_, address o_)
    {
        (m_, s_, o_) = mvm.readCallers();
        if (
            m_ == IMinVM.CallerMode.Prank ||
            m_ == IMinVM.CallerMode.RecurrentPrank
        ) {
            mvm.stopPrank();
        }
    }

    function callers() internal returns (Callers memory) {
        (IMinVM.CallerMode m_, address s_, address o_) = mvm.readCallers();
        return Callers(s_, o_, callModeStr(m_));
    }

    function sender() internal returns (address s_) {
        (, s_, ) = mvm.readCallers();
    }

    function callModeStr(
        IMinVM.CallerMode _mode
    ) internal pure returns (string memory) {
        if (_mode == IMinVM.CallerMode.Broadcast) return "broadcast";
        if (_mode == IMinVM.CallerMode.RecurrentBroadcast)
            return "persistent broadcast";
        if (_mode == IMinVM.CallerMode.Prank) return "prank";
        if (_mode == IMinVM.CallerMode.RecurrentPrank)
            return "persistent prank";
        if (_mode == IMinVM.CallerMode.None) return "none";
        return "unknown";
    }

    function getAddr(
        string memory _mEnv,
        uint32 _idx
    ) internal returns (address) {
        return mAddr(_mEnv, _idx);
    }

    function getPk(
        string memory _mEnv,
        uint32 _idx
    ) internal returns (uint256) {
        return mPk(_mEnv, _idx);
    }
}
