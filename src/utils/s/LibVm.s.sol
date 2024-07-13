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

    event log_array(uint256[] val);
    event log_array(int256[] val);
    event log_array(address[] val);
    using Utils for *;

    function prefix(string memory _prefix) internal {
        store().logPrefix = _prefix;
    }

    function _hp() private view returns (bool) {
        return !store().logPrefix.isEmpty();
    }

    function __pre(string memory _str) private view returns (string memory) {
        if (_hasPrefix()) {
            return ("[").cc(store().logPrefix, "] ", _str);
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
        n();
    }

    function n() internal pure {
        PLog.clg("\n");
    }

    function sr() internal pure {
        PLog.clg("**************************************************");
    }

    function h1(string memory _h1) internal pure {
        sr();
        PLog.clg(_h1);
        hr();
    }
    function h2(string memory _h2) internal pure {
        PLog.clg(("------ ").cc(_h2, " ------"));
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
        PLog.plg(_val, _pre(_str));
    }

    function plg(string memory _str, uint256 _val) internal pure {
        PLog.plg(_val, _pre(_str));
    }

    function dlg(int256 _val, string memory _str) internal pure {
        dlg(_val, _str, 18);
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
        PLog.dlg(_val, _pre(_str), dec);
    }

    function dlg(string memory _str, uint256 _val, uint256 dec) internal pure {
        PLog.dlg(_val, _pre(_str), dec);
    }

    function dlg(uint256 _val, string memory _str) internal pure {
        PLog.dlg(_val, _pre(_str), 18);
    }

    function dlg(uint256 _val, string memory _str, uint256 dec) internal pure {
        PLog.dlg(_val, _pre(_str), dec);
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

    function blg(string memory _lbl, bytes memory _val) internal pure {
        PLog.blg(_val, _pre(_lbl));
    }

    function blg(string memory _lbl, bytes32 _val) internal pure {
        PLog.blg(_val, _pre(_lbl));
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

    function blg(bytes32 _val, string memory _str) internal pure {
        PLog.blg(_val, _pre(_str));
    }
    function blgstr(bytes32 _val, string memory _str) internal pure {
        PLog.blgstr(_val, _pre(_str));
    }

    function blg(bytes memory _val, string memory _str) internal pure {
        PLog.blg(_val, _pre(_str));
    }
    function blgstr(bytes memory _val, string memory _str) internal pure {
        PLog.blgstr(_val, _pre(_str));
    }

    function logCallers() internal {
        LibVm.Callers memory current = LibVm.callers();

        clg(hasVM() ? "true" : "false", "isHEVM:");
        clg(current.msgSender, "msg.sender:");
        clg(current.txOrigin, "tx.origin:");
        clg(current.mode, "mode:");
    }
}
