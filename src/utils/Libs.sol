// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

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

    function toWad(int256 _val, uint8 _dec) internal pure returns (uint256) {
        if (_val < 0) revert("-");
        return toWad(uint256(_val), _dec);
    }

    function toWad(uint256 _val, uint8 _dec) internal pure returns (uint256) {
        return toDec(_val, _dec, 18);
    }

    function fromWad(uint256 _val, uint8 _dec) internal pure returns (uint256) {
        return toDec(_val, 18, _dec);
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
        address[] memory els = _els;
        for (uint256 i; i < els.length; ) {
            if (els[i] == _el) return FindResult(i, true);
            unchecked {
                ++i;
            }
        }
    }

    function find(
        bytes32[] storage _els,
        bytes32 _el
    ) internal pure returns (FindResult memory result) {
        bytes32[] memory els = _els;
        for (uint256 i; i < els.length; ) {
            if (els[i] == _el) return FindResult(i, true);
            unchecked {
                ++i;
            }
        }
    }

    function find(
        string[] storage _els,
        string memory _el
    ) internal pure returns (FindResult memory result) {
        string[] memory els = _els;
        for (uint256 i; i < els.length; ) {
            if (els[i].equals(_el)) return FindResult(i, true);
            unchecked {
                ++i;
            }
        }
    }

    function pushUnique(address[] storage _arr, address _val) internal {
        if (!_arr.find(_val).exists) _arr.push(_val);
    }

    function pushUnique(bytes32[] storage _arr, bytes32 _val) internal {
        if (!_arr.find(_val).exists) _arr.push(_val);
    }

    function pushUnique(string[] storage _arr, string memory _val) internal {
        if (!_arr.find(_val).exists) _arr.push(_val);
    }

    function removeExisting(address[] storage _arr, address _val) internal {
        FindResult memory r = _arr.find(_val);
        if (r.exists) _arr.removeAddress(_val, r.index);
    }

    function removeAddress(
        address[] storage _arr,
        address _val,
        uint256 _idx
    ) internal {
        if (_arr[_idx] != _val) revert ELEMENT_NOT_FOUND(_idx, _arr.length);

        uint256 last = _arr.length - 1;
        if (_idx != last) _arr[_idx] = _arr[last];
        _arr.pop();
    }

    function zero(address[2] memory _arr) internal pure returns (bool) {
        return _arr[0] == address(0) && _arr[1] == address(0);
    }

    function zero(string memory _val) internal pure returns (bool) {
        return bytes(_val).length == 0;
    }

    function equals(
        string memory _a,
        string memory _b
    ) internal pure returns (bool) {
        return equals(bytes(_a), bytes(_b));
    }

    function equals(
        bytes memory _a,
        bytes memory _b
    ) internal pure returns (bool) {
        return keccak256(_a) == keccak256(_b);
    }

    function str(bytes32 _val) internal pure returns (string memory) {
        return str(bytes.concat(_val));
    }

    function str(bytes memory _val) internal pure returns (string memory res) {
        for (uint256 i; i < _val.length; i++) {
            if (_val[i] != 0)
                res = string.concat(res, string(bytes.concat(_val[i])));
        }
    }

    function dstr(uint256 _val) internal pure returns (string memory) {
        return dstr(_val, 18);
    }

    function dstr(
        uint256 _val,
        uint256 _dec
    ) internal pure returns (string memory) {
        uint256 ds = 10 ** _dec;

        bytes memory d = bytes(str(_val % ds));
        (d = bytes.concat(bytes(str(10 ** (_dec - d.length))), d))[0] = 0;

        for (uint256 i = d.length; --i > 2; d[i] = 0) if (d[i] != "0") break;

        return string.concat(str(_val / ds), ".", str(d));
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

    function pmul(
        uint256 _val,
        uint256 _pct
    ) internal pure returns (uint256 result) {
        assembly {
            if iszero(
                or(
                    iszero(_pct),
                    iszero(gt(_val, div(sub(not(0), HALF_PCT_F), _pct)))
                )
            ) {
                revert(0, 0)
            }

            result := div(add(mul(_val, _pct), HALF_PCT_F), PCT_F)
        }
    }

    function pdiv(
        uint256 _val,
        uint256 _pct
    ) internal pure returns (uint256 result) {
        assembly {
            if or(
                iszero(_pct),
                iszero(iszero(gt(_val, div(sub(not(0), div(_pct, 2)), PCT_F))))
            ) {
                revert(0, 0)
            }

            result := div(add(mul(_val, PCT_F), div(_pct, 2)), _pct)
        }
    }

    uint256 internal constant WAD = 1e18;
    uint256 internal constant HALF_WAD = 0.5e18;

    function wmul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        assembly {
            if iszero(
                or(iszero(b), iszero(gt(a, div(sub(not(0), HALF_WAD), b))))
            ) {
                revert(0, 0)
            }

            c := div(add(mul(a, b), HALF_WAD), WAD)
        }
    }

    function wdiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
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

    function cc(
        string memory _a,
        string memory _b
    ) internal pure returns (string memory) {
        return string.concat(_a, _b);
    }
    function cc(
        string memory _a,
        string memory _b,
        string memory _c
    ) internal pure returns (string memory) {
        return string.concat(_a, _b, _c);
    }
    function cc(
        string memory _a,
        string memory _b,
        string memory _c,
        string memory _d
    ) internal pure returns (string memory) {
        return string.concat(_a, _b, _c, _d);
    }

    function toAddress(bytes32 b) internal pure returns (address) {
        return address(uint160(uint256(b)));
    }

    function toBytes32(address a) internal pure returns (bytes32) {
        return bytes32(bytes20(uint160(a)));
    }

    function toAddr(bytes memory b) internal pure returns (address) {
        return abi.decode(b, (address));
    }

    function toArray(
        bytes memory value
    ) internal pure returns (bytes[] memory result) {
        result = new bytes[](1);
        result[0] = value;
    }

    function add(bytes32 a, uint256 b) internal pure returns (bytes32) {
        return bytes32(uint256(a) + b);
    }

    function sub(bytes32 a, uint256 b) internal pure returns (bytes32) {
        return bytes32(uint256(a) - b);
    }
}

library Meta {
    using Utils for string;
    struct KrAssetMetadata {
        string name;
        string symbol;
        string anchorName;
        string anchorSymbol;
        bytes32 krAssetSalt;
        bytes32 anchorSalt;
    }

    struct KrAssetSalts {
        bytes32 krSalt;
        bytes32 akrSalt;
    }

    struct KrAssetAddr {
        address proxy;
        address impl;
        address aProxy;
        address aImpl;
    }

    bytes32 constant SALT_VERSION = bytes32("_1");
    bytes32 constant KISS_SALT = bytes32("KISS_1");
    bytes32 constant VAULT_SALT = bytes32("vKISS_1");

    string constant KRASSET_NAME_PREFIX = "Kresko: ";
    string constant KISS_PREFIX = "Kresko: ";

    string constant ANCHOR_NAME_PREFIX = "Kresko Asset Anchor: ";
    string constant ANCHOR_SYMBOL_PREFIX = "a";

    string constant VAULT_NAME_PREFIX = "Kresko Vault: ";
    string constant VAULT_SYMBOL_PREFIX = "v";

    function krAssetMeta(
        string memory _n,
        string memory _s
    ) internal pure returns (string memory, string memory) {
        return (KRASSET_NAME_PREFIX.cc(_n), _s);
    }

    function anchorMeta(
        string memory _krName,
        string memory _krSymbol
    ) internal pure returns (string memory, string memory) {
        return (
            ANCHOR_NAME_PREFIX.cc(_krName),
            ANCHOR_SYMBOL_PREFIX.cc(_krSymbol)
        );
    }

    function krAssetSalts(
        string memory _s
    ) internal pure returns (KrAssetSalts memory) {
        return krAssetSalts(_s, ANCHOR_SYMBOL_PREFIX.cc(_s));
    }

    function pathV3(
        address _a,
        uint24 _f,
        address _b
    ) internal pure returns (bytes memory) {
        return bytes.concat(bytes20(_a), bytes3(_f), bytes20(_b));
    }

    function concatv3(
        bytes memory _p,
        uint24 _f,
        address _out
    ) internal pure returns (bytes memory) {
        return bytes.concat(_p, bytes3(_f), bytes20(_out));
    }

    function krAssetAddr(
        address _factory,
        string memory _s
    ) internal view returns (KrAssetAddr memory res_) {
        KrAssetSalts memory _metas = krAssetSalts(_s);

        bytes4 sig = 0xc6bdc35b;

        bytes memory _data;
        (, _data) = _factory.staticcall(bytes.concat(sig, _metas.krSalt));
        (res_.proxy, res_.impl) = abi.decode(_data, (address, address));

        (, _data) = _factory.staticcall(bytes.concat(sig, _metas.akrSalt));
        (res_.aProxy, res_.aImpl) = abi.decode(_data, (address, address));
    }

    function krAssetSalts(
        string memory _krs,
        string memory _akrs
    ) internal pure returns (KrAssetSalts memory res_) {
        res_.krSalt = bytes32(
            bytes.concat(bytes(_krs), bytes(_akrs), SALT_VERSION)
        );
        res_.akrSalt = bytes32(
            bytes.concat(bytes(_akrs), bytes(_krs), SALT_VERSION)
        );
    }
}
