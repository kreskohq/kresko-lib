// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

function toWad(uint256 _a, uint8 _dec) pure returns (uint256) {
    if (_dec == 18 || _a == 0) return _a;
    if (_dec < 18) {
        return _a * (10 ** (18 - _dec));
    }
    return _a / (10 ** (_dec - 18));
}

function toWad(int256 _a, uint8 _dec) pure returns (uint256) {
    if (_a < 0) {
        revert("-");
    }
    return toWad(uint256(_a), _dec);
}

function fromWad(uint256 _wad, uint8 _dec) pure returns (uint256) {
    if (_dec == 18 || _wad == 0) return _wad;
    if (_dec < 18) {
        return _wad / (10 ** (18 - _dec));
    }
    return _wad * (10 ** (_dec - 18));
}
