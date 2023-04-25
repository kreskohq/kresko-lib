// SPDX-License-Identifier: MIT
pragma solidity >=0.8.14;

import {MinterInitArgs} from "../MinterTypes.sol";

interface IConfigurationFacet {
    function initialize(MinterInitArgs calldata args) external;

    function addCollateralAsset(
        address _collateralAsset,
        address _anchor,
        uint256 _factor,
        address _oracle,
        address _marketStatusOracle
    ) external;

    function addKreskoAsset(
        address _krAsset,
        address _anchor,
        uint256 _kFactor,
        address _oracle,
        address _marketStatusOracle,
        uint256 _supplyLimit,
        uint256 _closeFee,
        uint256 _openFee
    ) external;

    function updateCollateralAsset(
        address _collateralAsset,
        address _anchor,
        uint256 _factor,
        address _oracle,
        address _marketStatusOracle
    ) external;

    function updateFeeRecipient(address _feeRecipient) external;

    function updateKreskoAsset(
        address _krAsset,
        address _anchor,
        uint256 _kFactor,
        address _oracle,
        address _marketStatusOracle,
        uint256 _supplyLimit,
        uint256 _closeFee,
        uint256 _openFee
    ) external;

    function updateLiquidationIncentiveMultiplier(
        uint256 _liquidationIncentiveMultiplier
    ) external;

    function updateMinimumCollateralizationRatio(
        uint256 _minimumCollateralizationRatio
    ) external;

    function updateMinimumDebtValue(uint256 _minimumDebtValue) external;

    function updateLiquidationThreshold(uint256 _minimumDebtValue) external;

    function updateAMMOracle(address _ammOracle) external;

    function updateExtOracleDecimals(uint8 _decimals) external;

    function depositCollateral(
        address _account,
        address _collateralAsset,
        uint256 _amount
    ) external;

    function withdrawCollateral(
        address _account,
        address _collateralAsset,
        uint256 _amount,
        uint256 _depositedCollateralAssetIndex
    ) external;

    function batchLiquidateInterest(
        address _account,
        address _collateralAssetToSeize
    ) external;

    function liquidateInterest(
        address _account,
        address _repayKreskoAsset,
        address _collateralAssetToSeize
    ) external;

    function calculateMaxLiquidatableValueForAssets(
        address _account,
        address _repayKreskoAsset,
        address _collateralAssetToSeize
    ) external view returns (FixedPoint.Unsigned memory maxLiquidatableUSD);

    function isAccountLiquidatable(
        address _account
    ) external view returns (bool);

    function liquidate(
        address _account,
        address _repayKreskoAsset,
        uint256 _repayAmount,
        address _collateralAssetToSeize,
        uint256 _mintedKreskoAssetIndex,
        uint256 _depositedCollateralAssetIndex
    ) external;
}
