// SPDX-License-Identifier: MIT
// solhint-disable

pragma solidity ^0.8.0;

library Meta {
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
        return (string.concat(KRASSET_NAME_PREFIX, _n), _s);
    }

    function anchorMeta(
        string memory _krName,
        string memory _krSymbol
    ) internal pure returns (string memory, string memory) {
        return (
            string.concat(ANCHOR_NAME_PREFIX, _krName),
            string.concat(ANCHOR_SYMBOL_PREFIX, _krSymbol)
        );
    }

    function krAssetSalts(
        string memory _s
    ) internal pure returns (KrAssetSalts memory) {
        return krAssetSalts(_s, string.concat(ANCHOR_SYMBOL_PREFIX, _s));
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

        bytes memory retData;

        (, retData) = _factory.staticcall(
            abi.encodeWithSelector(0xc6bdc35b, _metas.krSalt)
        );
        (res_.proxy, res_.impl) = abi.decode(retData, (address, address));
        (, retData) = _factory.staticcall(
            abi.encodeWithSelector(0xc6bdc35b, _metas.akrSalt)
        );
        (res_.aProxy, res_.aImpl) = abi.decode(retData, (address, address));
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
