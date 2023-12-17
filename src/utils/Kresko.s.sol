// solhint-disable s-visibility, max-ss-count, no-empty-blocks, no-console, no-inline-assembly, state-visibility, avoid-low-level-calls,one-contract-per-file
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {__revert, getPayloadRs} from "./Base.s.sol";

type Kresko is address;

interface IMINKISS {
    function vKISS() external view returns (address);

    function kresko() external view returns (address);
}

library LibKresko {
    bytes32 constant STORAGE_LOCATION =
        keccak256("LIB_KRESKO_STORAGE_LOCATION");

    struct State {
        bytes rsPayload;
        address kiss;
        address vault;
    }

    function getPrice(
        Kresko _kresko,
        address _asset
    ) internal view returns (uint256) {
        return
            abi.decode(
                _kresko.rsStatic(abi.encodeWithSelector(0x41976e09, _asset)),
                (uint256)
            );
    }

    function getValue(
        Kresko _kresko,
        address _asset,
        uint256 _amount
    ) internal view returns (uint256) {
        return
            abi.decode(
                _kresko.rsStatic(
                    abi.encodeWithSelector(0xc7bf8cf5, _asset, _amount)
                ),
                (uint256)
            );
    }

    function depositCollateral(
        Kresko _kresko,
        address _account,
        address _asset,
        uint256 _amount
    ) internal {
        _kresko.call(
            abi.encodeWithSelector(0xf970c3b7, _account, _asset, _amount)
        );
    }

    function withdrawCollateral(
        Kresko _kresko,
        address _account,
        address _collateralAsset,
        uint256 _withdrawAmount,
        uint256 _collateralIndex,
        address _receiver
    ) internal {
        _kresko.rsCall(
            abi.encodeWithSelector(
                0x152911c6,
                _account,
                _collateralAsset,
                _withdrawAmount,
                _collateralIndex,
                _receiver
            )
        );
    }

    function mintKreskoAsset(
        Kresko _kresko,
        address _account,
        address _asset,
        uint256 _amount,
        address _receiver
    ) internal {
        _kresko.rsCall(
            abi.encodeWithSelector(
                0x6933bffa,
                _account,
                _asset,
                _amount,
                _receiver
            )
        );
    }

    function burnKreskoAsset(
        Kresko _kresko,
        address _account,
        address _krAsset,
        uint256 _burnAmount,
        uint256 _mintIndex,
        address _repayee
    ) internal {
        _kresko.rsCall(
            abi.encodeWithSelector(
                0xc255c9f6,
                _account,
                _krAsset,
                _burnAmount,
                _mintIndex,
                _repayee
            )
        );
    }

    function depositSCDP(
        Kresko _kresko,
        address _account,
        address _asset,
        uint256 _amount
    ) internal {
        _kresko.rsCall(
            abi.encodeWithSelector(0xd42f4c91, _account, _asset, _amount)
        );
    }

    function withdrawSCDP(
        Kresko _kresko,
        address _account,
        address _asset,
        uint256 _amount,
        address _receiver
    ) internal {
        _kresko.rsCall(
            abi.encodeWithSelector(
                0x254d4996,
                _account,
                _asset,
                _amount,
                _receiver
            )
        );
    }

    function claimFeesSCDP(
        Kresko _kresko,
        address _account,
        address _asset,
        address _receiver
    ) internal returns (uint256 feeAmount) {
        return
            abi.decode(
                _kresko.call(
                    abi.encodeWithSelector(
                        0xf78453f0,
                        _account,
                        _asset,
                        _receiver
                    )
                ),
                (uint256)
            );
    }

    function swapSCDP(
        Kresko _kresko,
        address _receiver,
        address _assetInAddr,
        address _assetOutAddr,
        uint256 _amountIn,
        uint256 _amountOutMin
    ) internal {
        _kresko.rsCall(
            abi.encodeWithSelector(
                0xce1d9ede,
                _receiver,
                _assetInAddr,
                _assetOutAddr,
                _amountIn,
                _amountOutMin
            )
        );
    }

    function getAccountCollateralRatio(
        Kresko _kresko,
        address _account
    ) internal view returns (uint256 ratio) {
        return
            abi.decode(
                _kresko.rsStatic(abi.encodeWithSelector(0xd0d78140, _account)),
                (uint256)
            );
    }

    function getAccountCollateralRatios(
        Kresko _kresko,
        address[] calldata _accounts
    ) internal view returns (uint256[] memory) {
        return
            abi.decode(
                _kresko.rsStatic(abi.encodeWithSelector(0x361e559c, _accounts)),
                (uint256[])
            );
    }

    function getAccountDebtAmount(
        Kresko _kresko,
        address _account,
        address _assetAddr
    ) internal view returns (uint256) {
        return
            abi.decode(
                _kresko.staticcall(
                    abi.encodeWithSelector(0xa121217c, _account, _assetAddr)
                ),
                (uint256)
            );
    }

    function getAccountCollateralAmount(
        Kresko _kresko,
        address _account,
        address _assetAddr
    ) internal view returns (uint256) {
        return
            abi.decode(
                _kresko.staticcall(
                    abi.encodeWithSelector(0x5ff7e7c0, _account, _assetAddr)
                ),
                (uint256)
            );
    }

    function getAccountState(
        Kresko _kresko,
        address _account
    ) internal view returns (MinterAccountState memory) {
        return
            abi.decode(
                _kresko.rsStatic(abi.encodeWithSelector(0x9ee2735b, _account)),
                (MinterAccountState)
            );
    }

    function getDebtValueSCDP(
        Kresko _kresko,
        address _krAsset,
        bool _ignoreFactors
    ) internal view returns (uint256) {
        return
            abi.decode(
                _kresko.rsStatic(
                    abi.encodeWithSelector(0xbc71971c, _krAsset, _ignoreFactors)
                ),
                (uint256)
            );
    }

    function getCollateralValueSCDP(
        Kresko _kresko,
        address _depositAsset,
        bool _ignoreFactors
    ) internal view returns (uint256) {
        return
            abi.decode(
                _kresko.rsStatic(
                    abi.encodeWithSelector(
                        0xfd390447,
                        _depositAsset,
                        _ignoreFactors
                    )
                ),
                (uint256)
            );
    }

    function getDepositsSCDP(
        Kresko _kresko,
        address _depositAsset
    ) internal view returns (uint256) {
        return
            abi.decode(
                _kresko.staticcall(
                    abi.encodeWithSelector(0xbf4f2eed, _depositAsset)
                ),
                (uint256)
            );
    }

    function getDebtSCDP(
        Kresko _kresko,
        address _krAsset
    ) external view returns (uint256) {
        return
            abi.decode(
                _kresko.staticcall(
                    abi.encodeWithSelector(0x4044ba83, _krAsset)
                ),
                (uint256)
            );
    }

    function liquidateSCDP(
        Kresko _kresko,
        address _repayAssetAddr,
        uint256 _repayAmount,
        address _seizeAssetAddr
    ) internal {
        _kresko.rsCall(
            abi.encodeWithSelector(
                0xdd04fb2b,
                _repayAssetAddr,
                _repayAmount,
                _seizeAssetAddr
            )
        );
    }

    function coverSCDP(
        Kresko _kresko,
        address _assetAddr,
        uint256 _coverAmount
    ) internal returns (uint256 value) {
        return
            abi.decode(
                _kresko.rsCall(
                    abi.encodeWithSelector(0xb4a2dfc3, _assetAddr, _coverAmount)
                ),
                (uint256)
            );
    }

    function coverWithIncentiveSCDP(
        Kresko _kresko,
        address _assetAddr,
        uint256 _coverAmount,
        address _seizeAssetAddr
    ) internal returns (uint256 value, uint256 seizedAmount) {
        return
            abi.decode(
                _kresko.rsCall(
                    abi.encodeWithSelector(
                        0xfcddbb8c,
                        _assetAddr,
                        _coverAmount,
                        _seizeAssetAddr
                    )
                ),
                (uint256, uint256)
            );
    }

    function repaySCDP(
        Kresko _kresko,
        address _repayAssetAddr,
        uint256 _repayAmount,
        address _seizeAssetAddr
    ) internal {
        _kresko.rsCall(
            abi.encodeWithSelector(
                0xc844569f,
                _repayAssetAddr,
                _repayAmount,
                _seizeAssetAddr
            )
        );
    }

    function getLiquidatableSCDP(Kresko _kresko) internal view returns (bool) {
        return
            abi.decode(
                _kresko.rsStatic(abi.encodeWithSelector(0x19961082)),
                (bool)
            );
    }

    function getMaxLiqValueSCDP(
        Kresko _kresko,
        address _repayAssetAddr,
        address _seizeAssetAddr
    ) internal view returns (MaxLiqInfo memory) {
        return
            abi.decode(
                _kresko.rsStatic(
                    abi.encodeWithSelector(
                        0x30d528a5,
                        _repayAssetAddr,
                        _seizeAssetAddr
                    )
                ),
                (MaxLiqInfo)
            );
    }

    function previewSwapSCDP(
        Kresko _kresko,
        address _assetInAddr,
        address _assetOutAddr,
        uint256 _amountIn
    ) internal view returns (uint256, uint256, uint256) {
        return
            abi.decode(
                _kresko.rsStatic(
                    abi.encodeWithSelector(
                        0x1e7207e1,
                        _assetInAddr,
                        _assetOutAddr,
                        _amountIn
                    )
                ),
                (uint256, uint256, uint256)
            );
    }

    function getCollateralsSCDP(
        Kresko _kresko
    ) internal view returns (address[] memory result) {
        return
            abi.decode(
                _kresko.staticcall(abi.encodeWithSelector(0x0ab887a4)),
                (address[])
            );
    }

    function getKreskoAssetsSCDP(
        Kresko _kresko
    ) internal view returns (address[] memory) {
        return
            abi.decode(
                _kresko.staticcall(abi.encodeWithSelector(0x01838e7e)),
                (address[])
            );
    }

    function getAccountMintedAssets(
        Kresko _kresko,
        address _account
    ) internal view returns (address[] memory) {
        return
            abi.decode(
                _kresko.staticcall(
                    abi.encodeWithSelector(0x5a65c59f, _account)
                ),
                (address[])
            );
    }

    function getAccountCollateralAssets(
        Kresko _kresko,
        address _account
    ) internal view returns (address[] memory) {
        return
            abi.decode(
                _kresko.staticcall(
                    abi.encodeWithSelector(0xc9573fbc, _account)
                ),
                (address[])
            );
    }

    function liquidateMinter(
        Kresko _kresko,
        LiquidationArgs memory _args
    ) internal {
        _kresko.rsCall(abi.encodeWithSelector(0xac7a969e, _args));
    }

    function getAccountLiquidatable(
        Kresko _kresko,
        address _account
    ) internal view returns (bool) {
        return
            abi.decode(
                _kresko.rsStatic(abi.encodeWithSelector(0x6ea382b4, _account)),
                (bool)
            );
    }

    function getAccountMintIndex(
        Kresko _kresko,
        address _account,
        address _krAsset
    ) internal view returns (uint256) {
        return
            abi.decode(
                _kresko.staticcall(
                    abi.encodeWithSelector(0xd96b7aea, _account, _krAsset)
                ),
                (uint256)
            );
    }

    function getAccountDepositIndex(
        Kresko _kresko,
        address _account,
        address _collateralAsset
    ) internal view returns (uint256 i) {
        return
            abi.decode(
                _kresko.staticcall(
                    abi.encodeWithSelector(
                        0xf0ad0603,
                        _account,
                        _collateralAsset
                    )
                ),
                (uint256)
            );
    }

    function getMaxLiqValue(
        Kresko _kresko,
        address _account,
        address _repayAssetAddr,
        address _seizeAssetAddr
    ) internal view returns (MaxLiqInfo memory) {
        return
            abi.decode(
                _kresko.rsStatic(
                    abi.encodeWithSelector(
                        0x9d5cb88e,
                        _account,
                        _repayAssetAddr,
                        _seizeAssetAddr
                    )
                ),
                (MaxLiqInfo)
            );
    }

    function wrapKrAsset(
        Kresko,
        address _krAsset,
        uint256 _amount,
        address _receiver
    ) internal {
        (bool success, bytes memory retdata) = _krAsset.call(
            abi.encodeWithSelector(0xbf376c7a, _receiver, _amount)
        );
        if (!success) {
            __revert(retdata);
        }
    }

    function nativeWrapKrAsset(
        Kresko,
        address _krAsset,
        uint256 _amount
    ) internal {
        (bool success, bytes memory retdata) = _krAsset.call{value: _amount}(
            ""
        );
        if (!success) {
            __revert(retdata);
        }
    }

    function unwrapKrAsset(
        Kresko,
        address _krAsset,
        uint256 _amount,
        address _receiver,
        bool _receiveNative
    ) internal {
        (bool success, bytes memory retdata) = _krAsset.call(
            abi.encodeWithSelector(
                0x41086fdc,
                _receiver,
                _amount,
                _receiveNative
            )
        );
        if (!success) {
            __revert(retdata);
        }
    }

    function previewBuyKISS(
        Kresko,
        address _asset,
        uint256 _amount
    ) internal returns (uint256, uint256) {
        (bool success, bytes memory retdata) = s().vault.call(
            abi.encodeWithSelector(0xd1f810a5, _asset, _amount)
        );
        if (!success) {
            __revert(retdata);
        }
        return abi.decode(retdata, (uint256, uint256));
    }

    function previewSellKISS(
        Kresko,
        address _asset,
        uint256 _amount
    ) internal returns (uint256, uint256) {
        (bool success, bytes memory retdata) = s().vault.call(
            abi.encodeWithSelector(0xcbe52ae3, _asset, _amount)
        );
        if (!success) {
            __revert(retdata);
        }
        return abi.decode(retdata, (uint256, uint256));
    }

    function buyKISS(
        Kresko,
        address _assetAddr,
        uint256 _amount,
        address _receiver
    ) internal returns (uint256 assetsIn, uint256 assetFee) {
        (bool success, bytes memory retdata) = s().kiss.call(
            abi.encodeWithSelector(0x0c8daea9, _assetAddr, _amount, _receiver)
        );
        if (!success) {
            __revert(retdata);
        }
        return abi.decode(retdata, (uint256, uint256));
    }

    function sellKISS(
        Kresko,
        address _assetAddr,
        uint256 _amount,
        address _receiver,
        address _owner
    ) internal returns (uint256 assetsIn, uint256 assetFee) {
        (bool success, bytes memory retdata) = s().kiss.call(
            abi.encodeWithSelector(
                0x00acf447,
                _assetAddr,
                _amount,
                _receiver,
                _owner
            )
        );
        if (!success) {
            __revert(retdata);
        }
        return abi.decode(retdata, (uint256, uint256));
    }

    function from(address _kresko) internal pure returns (Kresko) {
        return Kresko.wrap(_kresko);
    }

    function from(Kresko, address _kresko) internal pure returns (Kresko) {
        return Kresko.wrap(_kresko);
    }

    function from(
        address _kresko,
        bytes memory _rsPayload
    ) internal returns (Kresko) {
        s().rsPayload = _rsPayload;
        return Kresko.wrap(_kresko);
    }

    function from(
        Kresko,
        address _kresko,
        bytes memory _rsPayload
    ) internal returns (Kresko) {
        s().rsPayload = _rsPayload;
        return Kresko.wrap(_kresko);
    }

    function fromFFI(
        Kresko,
        address _kresko,
        string memory _rsPrices
    ) internal returns (Kresko) {
        s().rsPayload = getPayloadRs(_rsPrices);
        return Kresko.wrap(_kresko);
    }

    function fromKISS(address _kiss) internal returns (Kresko result) {
        return result.fromKISS(_kiss);
    }

    function fromKISS(
        Kresko,
        address _kiss,
        bytes memory _rsPayload
    ) internal returns (Kresko result) {
        s().rsPayload = _rsPayload;
        return result.fromKISS(_kiss);
    }

    function fromKISS(Kresko, address _kiss) internal returns (Kresko) {
        s().kiss = _kiss;
        s().vault = IMINKISS(_kiss).vKISS();
        return Kresko.wrap(IMINKISS(_kiss).kresko());
    }

    function fromKISSFFI(
        Kresko,
        address _kiss,
        string memory _rsPrices
    ) internal returns (Kresko result) {
        s().rsPayload = getPayloadRs(_rsPrices);
        return result.fromKISS(_kiss);
    }

    function setPricesFFI(Kresko, string memory _rsPrices) internal {
        s().rsPayload = getPayloadRs(_rsPrices);
    }

    function setPayload(Kresko, bytes memory _rsPayload) internal {
        s().rsPayload = _rsPayload;
    }

    function s() internal pure returns (State storage s_) {
        bytes32 position = STORAGE_LOCATION;
        assembly {
            s_.slot := position
        }
    }

    function call(
        Kresko _kresko,
        bytes memory _data
    ) internal returns (bytes memory) {
        (bool success, bytes memory retdata) = Kresko.unwrap(_kresko).call(
            _data
        );
        if (!success) {
            __revert(retdata);
        }
        return retdata;
    }

    function rsCall(
        Kresko _kresko,
        bytes memory _data
    ) internal returns (bytes memory) {
        (bool success, bytes memory retdata) = Kresko.unwrap(_kresko).call(
            abi.encodePacked(_data, s().rsPayload)
        );
        if (!success) {
            __revert(retdata);
        }
        return retdata;
    }

    function staticcall(
        Kresko _kresko,
        bytes memory _data
    ) internal view returns (bytes memory) {
        (bool success, bytes memory retdata) = Kresko
            .unwrap(_kresko)
            .staticcall(_data);
        if (!success) {
            __revert(retdata);
        }
        return retdata;
    }

    function rsStatic(
        Kresko _kresko,
        bytes memory _data
    ) internal view returns (bytes memory) {
        (bool success, bytes memory retdata) = Kresko
            .unwrap(_kresko)
            .staticcall(abi.encodePacked(_data, s().rsPayload));
        if (!success) {
            __revert(retdata);
        }
        return retdata;
    }
}

using LibKresko for Kresko global;

struct MinterAccountState {
    uint256 totalDebtValue;
    uint256 totalCollateralValue;
    uint256 collateralRatio;
}

struct LiquidationArgs {
    address account;
    address repayAssetAddr;
    uint256 repayAmount;
    address seizeAssetAddr;
    uint256 repayAssetIndex;
    uint256 seizeAssetIndex;
}

struct MaxLiqInfo {
    address account;
    address seizeAssetAddr;
    address repayAssetAddr;
    uint256 repayValue;
    uint256 repayAmount;
    uint256 seizeAmount;
    uint256 seizeValue;
    uint256 repayAssetPrice;
    uint256 repayAssetIndex;
    uint256 seizeAssetPrice;
    uint256 seizeAssetIndex;
}
