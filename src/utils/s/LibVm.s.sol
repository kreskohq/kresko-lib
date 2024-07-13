// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {hasVM, mAddr, store, mvm, LibVm} from "./MinVm.s.sol";
import {PLog} from "./PLog.s.sol";
import {Purify} from "../Purify.sol";
import {Utils} from "../Libs.sol";

library Help {
    function txt(address _val) internal pure returns (string memory) {
        return mvm.toString(_val);
    }

    function txt(uint256 _val) internal pure returns (string memory) {
        return mvm.toString(_val);
    }

    function txt(bytes32 _val) internal pure returns (string memory) {
        return mvm.toString(_val);
    }

    function txt(bytes memory _val) internal pure returns (string memory) {
        return mvm.toString(_val);
    }

    function toAddr(string memory _val) internal pure returns (address) {
        return mvm.parseAddress(_val);
    }

    function toUint(string memory _val) internal pure returns (uint256) {
        return mvm.parseUint(_val);
    }

    function toB32(string memory _val) internal pure returns (bytes32) {
        return mvm.parseBytes32(_val);
    }

    function toBytes(string memory _val) internal pure returns (bytes memory) {
        return mvm.parseBytes(_val);
    }
}

library Log {
    event log(string);
    event logs(bytes);

    event log_address(address);
    event log_bytes32(bytes32);
    event log_int(int256);
    event log_uint(uint256);
    event log_bytes(bytes);
    event log_string(string);

    event log_named_address(string key, address val);
    event log_named_bytes32(string key, bytes32 val);
    event log_named_int(string key, int256 val);
    event log_named_uint(string key, uint256 val);
    event log_named_bytes(string key, bytes val);
    event log_named_string(string key, string val);

    event log_array(uint256[] val);
    event log_array(int256[] val);
    event log_array(address[] val);
    event log_named_array(string key, uint256[] val);
    event log_named_array(string key, int256[] val);
    event log_named_array(string key, address[] val);
    using Help for bytes32;
    using Help for string;
    using Help for address;
    using Help for bytes;
    using Utils for *;

    function prefix(string memory _prefix) internal {
        store().logPrefix = _prefix;
    }

    function _hp() private view returns (bool) {
        return !store().logPrefix.isEmpty();
    }

    function __pre(string memory _str) private view returns (string memory) {
        if (_hasPrefix()) {
            return string.concat(store().logPrefix, _str);
        } else {
            return _str;
        }
    }

    function _pre(string memory _str) internal pure returns (string memory) {
        return Purify.StrInStrOut(__pre)(_str);
    }

    function _hasPrefix() private pure returns (bool) {
        return Purify.BoolOut(_hp)();
    }

    function hr() internal pure {
        PLog.clg("--------------------------------------------------");
    }

    function br() internal pure {
        PLog.clg("\n");
    }

    function n() internal pure {
        PLog.clg("\n");
    }

    function sr() internal pure {
        PLog.clg("**************************************************");
    }

    function clg(bool _val) internal pure {
        PLog.clg(_pre(_val ? "true" : "false"));
    }

    function clg(string memory _str, bool _val) internal pure {
        PLog.clg(_pre(_str), _val ? "true" : "false");
    }

    function clg(address _val) internal pure {
        if (!_hasPrefix()) {
            PLog.clg(_val);
        } else {
            PLog.clg(_val, _pre(""));
        }
    }

    function blg(bytes32 _val) internal pure {
        if (!_hasPrefix()) {
            PLog.blg(_val);
        } else {
            PLog.blg(_val, _pre(""));
        }
    }

    function clg(int256 _val) internal pure {
        if (!_hasPrefix()) {
            PLog.clg(_val);
        } else {
            PLog.clg(_val, _pre(""));
        }
    }

    function clg(uint256 _val) internal pure {
        if (!_hasPrefix()) {
            PLog.clg(_val);
        } else {
            PLog.clg(_val, _pre(""));
        }
    }

    function blg(bytes memory _val) internal pure {
        if (!_hasPrefix()) {
            PLog.blg(_val);
        } else {
            PLog.blg(_val, _pre(""));
        }
    }

    function plg(uint256 _val, string memory _str) internal pure {
        PLog.dlg(_val, _str, 2);
    }

    function plg(string memory _str, uint256 _val) internal pure {
        PLog.dlg(_val, _str, 2);
    }

    function dlg(int256 _val, string memory _str) internal pure {
        dlg(_val, _pre(_str), 18);
    }

    function dlg(int256 _val, string memory _str, uint256 dec) internal pure {
        PLog.dlg(_val, _pre(_str), dec);
    }

    function dlg(string memory _str, int256 _val) internal pure {
        dlg(_val, _str);
    }

    function dlg(string memory _str, uint256 _val) internal pure {
        dlg(_val, _str, 18);
    }

    function dlg(string memory _str, int256 _val, uint256 dec) internal pure {
        PLog.dlg(_val, _str, dec);
    }

    function dlg(string memory _str, uint256 _val, uint256 dec) internal pure {
        PLog.dlg(_val, _str, dec);
    }

    function dlg(uint256 _val, string memory _str) internal pure {
        PLog.dlg(_val, _str, 18);
    }

    function dlg(uint256 _val, string memory _str, uint256 dec) internal pure {
        PLog.dlg(_val, _str, dec);
    }

    function clg(string memory _str, uint256 _val) internal pure {
        PLog.clg(_val, _pre(_str));
    }

    function clg(uint256 _val, string memory _str) internal pure {
        PLog.clg(_val, _pre(_str));
    }

    function clg(string memory _str, int256 _val) internal pure {
        PLog.clg(_val, _pre(_str));
    }

    function clg(int256 _val, string memory _str) internal pure {
        PLog.clg(_val, _pre(_str));
    }

    function clg(string memory _val) internal pure {
        PLog.clg(_pre(_val));
    }

    function clg(string memory _val, string memory _lbl) internal pure {
        PLog.clg(_pre(_lbl), _val);
    }

    function clg(string memory _lbl, address _val) internal pure {
        PLog.clg(_val, _pre(_lbl));
    }

    function clg(string memory _lbl, uint256[] memory _val) internal {
        emit log_named_array(_pre(_lbl), _val);
    }

    function clg(string memory _lbl, int256[] memory _val) internal {
        emit log_named_array(_pre(_lbl), _val);
    }

    function blg(string memory _lbl, bytes memory _val) internal pure {
        PLog.blg(_val, _pre(_lbl));
    }

    function blg(string memory _lbl, bytes32 _val) internal pure {
        PLog.blg(_val, _pre(_lbl));
    }

    function clg(address[] memory _val, string memory _str) internal {
        emit log_named_array(_pre(_str), _val);
    }

    function clg(address _val, string memory _str) internal pure {
        PLog.clg(_val, _pre(_str));
    }

    function clg(bool _val, string memory _str) internal pure {
        clg(_pre(_str), _val);
    }

    function clg(address[] memory _val) internal {
        emit log_array(_val);
    }

    function clg(uint256[] memory _val) internal {
        if (!_hasPrefix()) {
            emit log_array(_val);
        } else {
            emit log_named_array(_pre(""), _val);
        }
    }

    function clg(uint256[] memory _val, string memory _str) internal {
        emit log_named_array(_pre(_str), _val);
    }

    function blg(bytes32 _val, string memory _str) internal pure {
        PLog.blg(_val, _pre(_str));
    }

    function blg(bytes memory _val, string memory _str) internal pure {
        PLog.blg(_val, _pre(_str));
    }

    function logCallers() internal {
        LibVm.Callers memory current = LibVm.callers();

        emit log_named_string("isHEVM", hasVM() ? "true" : "false");
        emit log_named_address("msg.sender", current.msgSender);
        emit log_named_address("tx.origin", current.txOrigin);
        emit log_named_string("mode", current.mode);
    }
}
