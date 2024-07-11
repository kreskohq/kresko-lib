// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {split} from "./Bytes.s.sol";

library Utils {
    using Utils for *;

    function toDec(
        uint256 _val,
        uint8 _from,
        uint8 _to
    ) internal pure returns (uint256) {
        if (_val == 0 || _from == _to) return _val;

        if (_from < _to) {
            return _val * (10 ** (_to - _from));
        }
        return _val / (10 ** (_from - _to));
    }

    function toWad(int256 _a, uint8 _dec) internal pure returns (uint256) {
        if (_a < 0) revert("-");
        return toWad(uint256(_a), _dec);
    }

    function toWad(uint256 _a, uint8 _dec) internal pure returns (uint256) {
        return toDec(_a, _dec, 18);
    }

    function fromWad(uint256 _wad, uint8 _dec) internal pure returns (uint256) {
        return toDec(_wad, 18, _dec);
    }

    struct FindResult {
        uint256 index;
        bool exists;
    }

    error ELEMENT_NOT_FOUND(uint256 idx, uint256 length);

    function find(
        address[] storage _els,
        address _el
    ) internal pure returns (FindResult memory result) {
        address[] memory elements = _els;
        for (uint256 i; i < elements.length; ) {
            if (elements[i] == _el) {
                return FindResult(i, true);
            }
            unchecked {
                ++i;
            }
        }
    }

    function find(
        bytes32[] storage _els,
        bytes32 _el
    ) internal pure returns (FindResult memory result) {
        bytes32[] memory elements = _els;
        for (uint256 i; i < elements.length; ) {
            if (elements[i] == _el) {
                return FindResult(i, true);
            }
            unchecked {
                ++i;
            }
        }
    }

    function find(
        string[] storage _els,
        string memory _el
    ) internal pure returns (FindResult memory result) {
        string[] memory elements = _els;
        for (uint256 i; i < elements.length; ) {
            if (elements[i].equals(_el)) {
                return FindResult(i, true);
            }
            unchecked {
                ++i;
            }
        }
    }

    function pushUnique(address[] storage _arr, address _val) internal {
        if (!_arr.find(_val).exists) {
            _arr.push(_val);
        }
    }

    function pushUnique(bytes32[] storage _arr, bytes32 _val) internal {
        if (!_arr.find(_val).exists) {
            _arr.push(_val);
        }
    }

    function pushUnique(string[] storage _arr, string memory _val) internal {
        if (!_arr.find(_val).exists) {
            _arr.push(_val);
        }
    }

    function removeExisting(address[] storage _arr, address _val) internal {
        FindResult memory result = _arr.find(_val);
        if (result.exists) {
            _arr.removeAddress(_val, result.index);
        }
    }

    function removeAddress(
        address[] storage _arr,
        address _val,
        uint256 _idx
    ) internal {
        if (_arr[_idx] != _val) revert ELEMENT_NOT_FOUND(_idx, _arr.length);

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

    function str(bytes32 _val) internal pure returns (string memory) {
        return str(bytes.concat(_val));
    }

    function str(bytes memory _val) internal pure returns (string memory res) {
        for (uint256 i; i < _val.length; i++) {
            if (_val[i] == 0x00) continue;
            res = string.concat(res, string(abi.encodePacked(_val[i])));
        }
    }
    function strDec(
        uint256 _val,
        uint256 _dec
    ) internal pure returns (string memory) {
        return
            string.concat(
                (_val / (10 ** _dec)).str(),
                ".",
                (_val % (10 ** _dec)).str()
            );
    }

    function str(uint256 _val) internal pure returns (string memory s) {
        unchecked {
            if (_val == 0) return "0";
            else {
                uint256 c1 = itoa32(_val % 1e32);
                _val /= 1e32;
                if (_val == 0) s = string(abi.encode(c1));
                else {
                    uint256 c2 = itoa32(_val % 1e32);
                    _val /= 1e32;
                    if (_val == 0) {
                        s = string(abi.encode(c2, c1));
                        c1 = c2;
                    } else {
                        uint256 c3 = itoa32(_val);
                        s = string(abi.encode(c3, c2, c1));
                        c1 = c3;
                    }
                }
                uint256 z = 0;
                if (c1 >> 128 == 0x30303030303030303030303030303030) {
                    c1 <<= 128;
                    z += 16;
                }
                if (c1 >> 192 == 0x3030303030303030) {
                    c1 <<= 64;
                    z += 8;
                }
                if (c1 >> 224 == 0x30303030) {
                    c1 <<= 32;
                    z += 4;
                }
                if (c1 >> 240 == 0x3030) {
                    c1 <<= 16;
                    z += 2;
                }
                if (c1 >> 248 == 0x30) {
                    z += 1;
                }
                assembly {
                    let l := mload(s)
                    s := add(s, z)
                    mstore(s, sub(l, z))
                }
            }
        }
    }

    function itoa32(uint256 x) private pure returns (uint256 y) {
        unchecked {
            require(x < 1e32);
            y = 0x3030303030303030303030303030303030303030303030303030303030303030;
            y += x % 10;
            x /= 10;
            y += x % 10 << 8;
            x /= 10;
            y += x % 10 << 16;
            x /= 10;
            y += x % 10 << 24;
            x /= 10;
            y += x % 10 << 32;
            x /= 10;
            y += x % 10 << 40;
            x /= 10;
            y += x % 10 << 48;
            x /= 10;
            y += x % 10 << 56;
            x /= 10;
            y += x % 10 << 64;
            x /= 10;
            y += x % 10 << 72;
            x /= 10;
            y += x % 10 << 80;
            x /= 10;
            y += x % 10 << 88;
            x /= 10;
            y += x % 10 << 96;
            x /= 10;
            y += x % 10 << 104;
            x /= 10;
            y += x % 10 << 112;
            x /= 10;
            y += x % 10 << 120;
            x /= 10;
            y += x % 10 << 128;
            x /= 10;
            y += x % 10 << 136;
            x /= 10;
            y += x % 10 << 144;
            x /= 10;
            y += x % 10 << 152;
            x /= 10;
            y += x % 10 << 160;
            x /= 10;
            y += x % 10 << 168;
            x /= 10;
            y += x % 10 << 176;
            x /= 10;
            y += x % 10 << 184;
            x /= 10;
            y += x % 10 << 192;
            x /= 10;
            y += x % 10 << 200;
            x /= 10;
            y += x % 10 << 208;
            x /= 10;
            y += x % 10 << 216;
            x /= 10;
            y += x % 10 << 224;
            x /= 10;
            y += x % 10 << 232;
            x /= 10;
            y += x % 10 << 240;
            x /= 10;
            y += x % 10 << 248;
        }
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
}
