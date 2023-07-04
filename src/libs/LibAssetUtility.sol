// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.8.14;

import {CollateralAsset, KrAsset} from "../types/MinterTypes.sol";
import {LibDecimals} from "../libs/LibDecimals.sol";
import {WadRay} from "../libs/WadRay.sol";
import {IKreskoAssetAnchor} from "../interfaces/IKreskoAssetAnchor.sol";
import {LibDecimals} from "../libs/LibDecimals.sol";
import {Error} from "../libs/Errors.sol";

/**
 * @title LibAssetUtility
 * @author Kresko
 * @notice Utility functions for KrAsset and CollateralAsset structs
 */
library LibAssetUtility {
    using WadRay for uint256;
    using LibDecimals for uint256;

    /**
     * @notice Amount of non rebasing tokens -> amount of rebasing tokens
     * @param self the kresko asset struct
     * @param _nonRebasedAmount the amount to convert
     */
    function toRebasingAmount(
        KrAsset memory self,
        uint256 _nonRebasedAmount
    ) internal view returns (uint256) {
        return
            IKreskoAssetAnchor(self.anchor).convertToAssets(_nonRebasedAmount);
    }

    /**
     * @notice Amount of non rebasing tokens -> amount of rebasing tokens
     * @dev if collateral is not a kresko asset, returns the input
     * @param self the collateral asset struct
     * @param _nonRebasedAmount the amount to convert
     */
    function toRebasingAmount(
        CollateralAsset memory self,
        uint256 _nonRebasedAmount
    ) internal view returns (uint256) {
        if (self.anchor == address(0)) return _nonRebasedAmount;
        return
            IKreskoAssetAnchor(self.anchor).convertToAssets(_nonRebasedAmount);
    }

    /**
     * @notice Amount of rebasing tokens -> amount of non rebasing tokens
     * @param self the kresko asset struct
     * @param _maybeRebasedAmount the amount to convert
     */
    function toNonRebasingAmount(
        KrAsset memory self,
        uint256 _maybeRebasedAmount
    ) internal view returns (uint256) {
        return
            IKreskoAssetAnchor(self.anchor).convertToShares(
                _maybeRebasedAmount
            );
    }

    /**
     * @notice Amount of rebasing tokens -> amount of non rebasing tokens
     * @dev if collateral is not a kresko asset, returns the input
     * @param self the collateral asset struct
     * @param _maybeRebasedAmount the amount to convert
     */
    function toNonRebasingAmount(
        CollateralAsset memory self,
        uint256 _maybeRebasedAmount
    ) internal view returns (uint256) {
        if (self.anchor == address(0)) return _maybeRebasedAmount;
        return
            IKreskoAssetAnchor(self.anchor).convertToShares(
                _maybeRebasedAmount
            );
    }

    /**
     * @notice Get the oracle price of a collateral asset in uint256 with extOracleDecimals
     */
    function uintPrice(
        CollateralAsset memory self
    ) internal view returns (uint256) {
        (, int256 answer, , , ) = self.oracle.latestRoundData();
        require(answer >= 0, Error.NEGATIVE_ORACLE_PRICE);
        return uint256(answer);
    }

    /**
     * @notice Get the oracle price of a kresko asset in uint256 with extOracleDecimals
     */
    function uintPrice(KrAsset memory self) internal view returns (uint256) {
        (, int256 answer, , , ) = self.oracle.latestRoundData();
        require(answer >= 0, Error.NEGATIVE_ORACLE_PRICE);
        return uint256(answer);
    }

    /**
     * @notice check the price and return it
     * @notice reverts if the price deviates more than `_oracleDeviationPct`
     * @param _chainlinkPrice chainlink price
     * @param _redstonePrice redstone price
     * @param _oracleDeviationPct the deviation percentage to use for the oracle
     */
    function _getPrice(
        uint256 _chainlinkPrice,
        uint256 _redstonePrice,
        uint256 _oracleDeviationPct
    ) internal pure returns (uint256) {
        if (_chainlinkPrice == 0) return _redstonePrice;
        if (_redstonePrice == 0) return _chainlinkPrice;
        if (
            (_redstonePrice.wadMul(1 ether - _oracleDeviationPct) <=
                _chainlinkPrice) &&
            (_redstonePrice.wadMul(1 ether + _oracleDeviationPct) >=
                _chainlinkPrice)
        ) return _chainlinkPrice;

        // Revert if price deviates more than `_oracleDeviationPct`
        revert(Error.ORACLE_PRICE_UNSTABLE);
    }
}
