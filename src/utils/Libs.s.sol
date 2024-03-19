// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {mvm, LibVm} from "./LibVm.s.sol";
import {IERC20} from "../token/IERC20.sol";
import {hasVM, mAddr, store} from "./MinVm.s.sol";
import {PLog} from "./PLog.s.sol";
import {Purify} from "./Purify.sol";

library Help {
    error ELEMENT_NOT_FOUND(ID element, uint256 index, address[] elements);
    using Help for address[];
    using Help for bytes32[];
    using Help for string[];
    using Help for string;

    struct ID {
        string symbol;
        address addr;
    }

    function id(address _token) internal view returns (ID memory) {
        if (_token.code.length > 0) {
            return ID(IERC20(_token).symbol(), _token);
        }
        return ID("", _token); // not a token
    }

    struct FindResult {
        uint256 index;
        bool exists;
    }

    function find(
        address[] storage _els,
        address _search
    ) internal pure returns (FindResult memory result) {
        address[] memory elements = _els;
        for (uint256 i; i < elements.length; ) {
            if (elements[i] == _search) {
                return FindResult(i, true);
            }
            unchecked {
                ++i;
            }
        }
    }

    function find(
        bytes32[] storage _els,
        bytes32 _search
    ) internal pure returns (FindResult memory result) {
        bytes32[] memory elements = _els;
        for (uint256 i; i < elements.length; ) {
            if (elements[i] == _search) {
                return FindResult(i, true);
            }
            unchecked {
                ++i;
            }
        }
    }

    function find(
        string[] storage _els,
        string memory _search
    ) internal pure returns (FindResult memory result) {
        string[] memory elements = _els;
        for (uint256 i; i < elements.length; ) {
            if (elements[i].equals(_search)) {
                return FindResult(i, true);
            }
            unchecked {
                ++i;
            }
        }
    }

    function pushUnique(address[] storage _els, address _toAdd) internal {
        if (!_els.find(_toAdd).exists) {
            _els.push(_toAdd);
        }
    }

    function pushUnique(bytes32[] storage _els, bytes32 _toAdd) internal {
        if (!_els.find(_toAdd).exists) {
            _els.push(_toAdd);
        }
    }

    function pushUnique(string[] storage _els, string memory _toAdd) internal {
        if (!_els.find(_toAdd).exists) {
            _els.push(_toAdd);
        }
    }

    function removeExisting(address[] storage _arr, address _toR) internal {
        FindResult memory result = _arr.find(_toR);
        if (result.exists) {
            _arr.removeAddress(_toR, result.index);
        }
    }

    function removeAddress(
        address[] storage _arr,
        address _toR,
        uint256 _idx
    ) internal {
        if (_arr[_idx] != _toR) revert ELEMENT_NOT_FOUND(id(_toR), _idx, _arr);

        uint256 lastIndex = _arr.length - 1;
        if (_idx != lastIndex) {
            _arr[_idx] = _arr[lastIndex];
        }

        _arr.pop();
    }

    function isEmpty(address[2] memory _arr) internal pure returns (bool) {
        return _arr[0] == address(0) && _arr[1] == address(0);
    }

    function isEmpty(string memory _val) internal pure returns (bool) {
        return bytes(_val).length == 0;
    }

    function equals(
        string memory _a,
        string memory _b
    ) internal pure returns (bool) {
        return
            keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b));
    }

    function str(address _val) internal pure returns (string memory) {
        return mvm.toString(_val);
    }

    function str(uint256 _val) internal pure returns (string memory) {
        return mvm.toString(_val);
    }

    function str(bytes32 _val) internal pure returns (string memory) {
        return mvm.toString(_val);
    }

    function txt(bytes32 _val) internal pure returns (string memory) {
        return string(abi.encodePacked(_val));
    }

    function txt(bytes memory _val) internal pure returns (string memory) {
        return string(abi.encodePacked(_val));
    }

    function str(bytes memory _val) internal pure returns (string memory) {
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

    function and(
        string memory a,
        string memory b
    ) internal pure returns (string memory) {
        return string.concat(a, b);
    }

    uint256 internal constant PCT_F = 1e4;
    uint256 internal constant HALF_PCT_F = 0.5e4;

    function pctMul(
        uint256 value,
        uint256 _pct
    ) internal pure returns (uint256 result) {
        assembly {
            if iszero(
                or(
                    iszero(_pct),
                    iszero(gt(value, div(sub(not(0), HALF_PCT_F), _pct)))
                )
            ) {
                revert(0, 0)
            }

            result := div(add(mul(value, _pct), HALF_PCT_F), PCT_F)
        }
    }

    function pctDiv(
        uint256 value,
        uint256 _pct
    ) internal pure returns (uint256 result) {
        assembly {
            if or(
                iszero(_pct),
                iszero(iszero(gt(value, div(sub(not(0), div(_pct, 2)), PCT_F))))
            ) {
                revert(0, 0)
            }

            result := div(add(mul(value, PCT_F), div(_pct, 2)), _pct)
        }
    }

    // HALF_WAD and HALF_RAY expressed with extended notation
    // as constant with operations are not supported in Yul assembly
    uint256 constant WAD = 1e18;
    uint256 constant HALF_WAD = 0.5e18;

    uint256 constant RAY = 1e27;
    uint256 constant HALF_RAY = 0.5e27;

    uint256 constant WAD_RAY_RATIO = 1e9;

    function mulWad(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // to avoid overflow, a <= (type(uint256).max - HALF_WAD) / b
        assembly {
            if iszero(
                or(iszero(b), iszero(gt(a, div(sub(not(0), HALF_WAD), b))))
            ) {
                revert(0, 0)
            }

            c := div(add(mul(a, b), HALF_WAD), WAD)
        }
    }

    function divWad(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // to avoid overflow, a <= (type(uint256).max - halfB) / WAD
        assembly {
            if or(
                iszero(b),
                iszero(iszero(gt(a, div(sub(not(0), div(b, 2)), WAD))))
            ) {
                revert(0, 0)
            }

            c := div(add(mul(a, WAD), div(b, 2)), b)
        }
    }

    function mulRay(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // to avoid overflow, a <= (type(uint256).max - HALF_RAY) / b
        assembly {
            if iszero(
                or(iszero(b), iszero(gt(a, div(sub(not(0), HALF_RAY), b))))
            ) {
                revert(0, 0)
            }

            c := div(add(mul(a, b), HALF_RAY), RAY)
        }
    }

    function divRay(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // to avoid overflow, a <= (type(uint256).max - halfB) / RAY
        assembly {
            if or(
                iszero(b),
                iszero(iszero(gt(a, div(sub(not(0), div(b, 2)), RAY))))
            ) {
                revert(0, 0)
            }

            c := div(add(mul(a, RAY), div(b, 2)), b)
        }
    }

    function fromRayToWad(uint256 a) internal pure returns (uint256 b) {
        assembly {
            b := div(a, WAD_RAY_RATIO)
            let remainder := mod(a, WAD_RAY_RATIO)
            if iszero(lt(remainder, div(WAD_RAY_RATIO, 2))) {
                b := add(b, 1)
            }
        }
    }

    function fromWadToRay(uint256 a) internal pure returns (uint256 b) {
        // to avoid overflow, b/WAD_RAY_RATIO == a
        assembly {
            b := mul(a, WAD_RAY_RATIO)

            if iszero(eq(div(b, WAD_RAY_RATIO), a)) {
                revert(0, 0)
            }
        }
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
    event log_named_decimal_int(string key, int256 val, uint256 decimals);
    event log_named_decimal_uint(string key, uint256 val, uint256 decimals);
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
    using Help for uint256[2];
    using Help for uint8[2];
    using Help for uint32[2];
    using Help for uint16[2];

    function prefix(string memory _prefix) internal {
        store().logPrefix = _prefix;
    }

    function _hp() private view returns (bool) {
        return !store().logPrefix.isEmpty();
    }

    function __pre(string memory _str) private view returns (string memory) {
        if (_hasPrefix()) {
            return store().logPrefix.and(_str);
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

    function log_bool(bool _val) internal pure {
        PLog.clg(_pre(_val ? "true" : "false"));
    }

    function log_named_bool(string memory _str, bool _val) internal pure {
        PLog.clg(_pre(_str), _val ? "true" : "false");
    }

    function log_pct(uint256 _val) internal {
        emit log_named_decimal_uint(_pre(""), _val, 2);
    }

    function log_pct(uint256 _val, string memory _str) internal {
        emit log_named_decimal_uint(_pre(_str), _val, 2);
    }

    function log_decimal_balance(address _account, address _token) internal {
        emit log_named_decimal_uint(
            _pre(mvm.toString(_account).and(IERC20(_token).symbol())),
            IERC20(_token).balanceOf(_account),
            IERC20(_token).decimals()
        );
    }

    function log_decimal_balances(
        address _account,
        address[] memory _tokens
    ) internal {
        for (uint256 i; i < _tokens.length; i++) {
            emit log_named_decimal_uint(
                _pre(mvm.toString(_account).and(IERC20(_tokens[i]).symbol())),
                IERC20(_tokens[i]).balanceOf(_account),
                IERC20(_tokens[i]).decimals()
            );
        }
    }

    function clg(address _val) internal pure {
        if (check()) return;
        if (!_hasPrefix()) {
            PLog.clg(_val);
        } else {
            PLog.clg(_val, _pre(""));
        }
    }

    function blg(bytes32 _val) internal pure {
        if (check()) return;
        if (!_hasPrefix()) {
            PLog.blg(_val);
        } else {
            PLog.blg(_val, _pre(""));
        }
    }

    function clg(int256 _val) internal pure {
        if (check()) return;
        if (!_hasPrefix()) {
            PLog.clg(_val);
        } else {
            PLog.clg(_val, _pre(""));
        }
    }

    function clg(uint256 _val) internal pure {
        if (check()) return;
        if (!_hasPrefix()) {
            PLog.clg(_val);
        } else {
            PLog.clg(_val, _pre(""));
        }
    }

    function blg(bytes memory _val) internal pure {
        if (check()) return;
        if (!_hasPrefix()) {
            PLog.blg(_val);
        } else {
            PLog.blg(_val, _pre(""));
        }
    }

    function pct(uint256 _val, string memory _str) internal {
        if (check()) return;
        emit log_named_decimal_uint(_pre(_str), _val, 2);
    }

    function pct(string memory _str, uint256 _val) internal {
        if (check()) return;
        emit log_named_decimal_uint(_pre(_str), _val, 2);
    }

    function dlg(int256 _val, string memory _str) internal {
        if (check()) return;
        emit log_named_decimal_int(_pre(_str), _val, 18);
    }

    function dlg(int256 _val, string memory _str, uint256 dec) internal {
        if (check()) return;
        emit log_named_decimal_int(_pre(_str), _val, dec);
    }

    function dlg(string memory _str, int256 _val) internal {
        if (check()) return;
        emit log_named_decimal_int(_pre(_str), _val, 18);
    }

    function dlg(string memory _str, uint256 _val) internal {
        if (check()) return;
        emit log_named_decimal_uint(_pre(_str), _val, 18);
    }

    function dlg(string memory _str, int256 _val, uint256 dec) internal {
        if (check()) return;
        emit log_named_decimal_int(_pre(_str), _val, dec);
    }

    function dlg(string memory _str, uint256 _val, uint256 dec) internal {
        if (check()) return;
        emit log_named_decimal_uint(_pre(_str), _val, dec);
    }

    function dlg(uint256 _val, string memory _str) internal {
        if (check()) return;
        emit log_named_decimal_uint(_pre(_str), _val, 18);
    }

    function dlg(uint256 _val, string memory _str, uint256 dec) internal {
        if (check()) return;
        emit log_named_decimal_uint(_pre(_str), _val, dec);
    }

    function clg(string memory _str, uint256 _val) internal pure {
        if (check()) return;
        PLog.clg(_val, _pre(_str));
    }

    function clg(uint256 _val, string memory _str) internal pure {
        if (check()) return;
        PLog.clg(_val, _pre(_str));
    }

    function clg(string memory _str, int256 _val) internal pure {
        if (check()) return;
        PLog.clg(_val, _pre(_str));
    }

    function clg(int256 _val, string memory _str) internal pure {
        if (check()) return;
        PLog.clg(_val, _pre(_str));
    }

    function clg(string memory _val) internal pure {
        if (check()) return;
        PLog.clg(_pre(_val));
    }

    function clg(string memory _val, string memory _lbl) internal pure {
        if (check()) return;
        PLog.clg(_pre(_lbl), _val);
    }

    function clg(string memory _lbl, address _val) internal pure {
        if (check()) return;
        PLog.clg(_val, _pre(_lbl));
    }

    function clg(string memory _lbl, uint256[] memory _val) internal {
        if (check()) return;
        emit log_named_array(_pre(_lbl), _val);
    }

    function clg(string memory _lbl, int256[] memory _val) internal {
        if (check()) return;
        emit log_named_array(_pre(_lbl), _val);
    }

    function blg(string memory _lbl, bytes memory _val) internal pure {
        if (check()) return;
        PLog.blg(_val, _pre(_lbl));
    }

    function blg(string memory _lbl, bytes32 _val) internal pure {
        if (check()) return;
        PLog.blg(_val, _pre(_lbl));
    }

    function blg2txt(string memory _lbl, bytes32 _val) internal pure {
        if (check()) return;
        PLog.clg(_pre(_lbl), _val.txt());
    }

    function blg2str(string memory _lbl, bytes memory _val) internal pure {
        if (check()) return;
        PLog.clg(_pre(_lbl), _val.str());
    }

    function blg2txt(string memory _lbl, bytes memory _val) internal pure {
        if (check()) return;
        PLog.clg(_pre(_lbl), _val.txt());
    }

    function blg2str(bytes32 _val, string memory _lbl) internal pure {
        if (check()) return;
        PLog.clg(_pre(_lbl), _val.str());
    }

    function blg2txt(bytes32 _val, string memory _lbl) internal pure {
        if (check()) return;
        PLog.clg(_pre(_lbl), _val.txt());
    }

    function blg2str(bytes memory _val, string memory _lbl) internal pure {
        if (check()) return;
        PLog.clg(_pre(_lbl), _val.str());
    }

    function blg2txt(bytes memory _val, string memory _lbl) internal pure {
        if (check()) return;
        PLog.clg(_pre(_lbl), _val.txt());
    }

    function clg2bytes(string memory _val, string memory _lbl) internal pure {
        if (check()) return;
        PLog.blg(bytes(_val), _pre(_lbl));
    }

    function clg2str(address _val, string memory _lbl) internal pure {
        if (check()) return;
        PLog.clg(_pre(_lbl), _val.str());
    }

    function clg2str(string memory _lbl, address _val) internal pure {
        if (check()) return;
        PLog.clg(_pre(_lbl).and(_val.str()));
    }

    function clg(address[] memory _val, string memory _str) internal {
        if (check()) return;
        emit log_named_array(_pre(_str), _val);
    }

    function clg(address _val, string memory _str) internal pure {
        if (check()) return;
        PLog.clg(_val, _pre(_str));
    }

    function clg(bool _val, string memory _str) internal pure {
        log_named_bool(_pre(_str), _val);
    }

    function clg(bool _val) internal pure {
        log_bool(_val);
    }

    function clg(address[] memory _val) internal {
        if (check()) return;
        emit log_array(_val);
    }

    function clg(uint256[] memory _val) internal {
        if (check()) return;
        if (!_hasPrefix()) {
            emit log_array(_val);
        } else {
            emit log_named_array(_pre(""), _val);
        }
    }

    function clg(int256[] memory _val) internal {
        if (check()) return;
        if (!_hasPrefix()) {
            emit log_array(_val);
        } else {
            emit log_named_array(_pre(""), _val);
        }
    }

    function clg(uint256[] memory _val, string memory _str) internal {
        if (check()) return;
        emit log_named_array(_pre(_str), _val);
    }

    function clg(int256[] memory _val, string memory _str) internal {
        if (check()) return;
        emit log_named_array(_pre(_str), _val);
    }

    function blg(bytes32 _val, string memory _str) internal pure {
        if (check()) return;
        PLog.blg(_val, _pre(_str));
    }

    function blg(bytes memory _val, string memory _str) internal pure {
        if (check()) return;
        PLog.blg(_val, _pre(_str));
    }

    function clgBal(address _account, address[] memory _tokens) internal {
        log_decimal_balances(_account, _tokens);
    }

    function clgBal(address _account, address _token) internal {
        log_decimal_balance(_account, _token);
    }

    function logCallers() internal {
        if (check()) return;
        LibVm.Callers memory current = LibVm.callers();

        emit log_named_string("isHEVM", hasVM() ? "true" : "false");
        emit log_named_address("msg.sender", current.msgSender);
        emit log_named_address("tx.origin", current.txOrigin);
        emit log_named_string("mode", current.mode);
    }

    function disable() internal {
        store().logDisabled = true;
    }

    function enable() internal {
        store().logDisabled = false;
    }

    function _check() internal view returns (bool) {
        return store().logDisabled;
    }

    function check() internal pure returns (bool) {
        return Purify.BoolOut(_check)();
    }
}
