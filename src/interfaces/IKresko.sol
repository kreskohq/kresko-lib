// SPDX-License-Identifier: MIT
pragma solidity >=0.8.14;

import {MinterInitArgs, KrAsset, CollateralAsset, MinterParams, Action, SafetyState} from "../types/MinterTypes.sol";
import {FixedPoint} from "../libs/FixedPoint.sol";
import {StabilityRateParams, StabilityRateConfig} from "../types/StabilityRateTypes.sol";

interface IKresko {
    function initialize(MinterInitArgs calldata args) external;

    function toggleAssetsPaused(
        address[] memory _assets,
        Action _action,
        bool _withDuration,
        uint256 _duration
    ) external;

    function safetyStateSet() external view returns (bool);

    function safetyStateFor(
        address _asset,
        Action _action
    ) external view returns (SafetyState memory);

    function burnKreskoAsset(
        address _account,
        address _kreskoAsset,
        uint256 _amount,
        uint256 _mintedKreskoAssetIndex
    ) external;

    function batchCloseKrAssetDebtPositions(address _account) external;

    function closeKrAssetDebtPosition(
        address _account,
        address _kreskoAsset
    ) external;

    function domainSeparator() external view returns (bytes32);

    function minterInitializations() external view returns (uint256);

    function mintKreskoAsset(
        address _account,
        address _kreskoAsset,
        uint256 _mintAmount
    ) external;

    function feeRecipient() external view returns (address);

    function ammOracle() external view returns (address);

    function extOracleDecimals() external view returns (uint8);

    function liquidationThreshold()
        external
        view
        returns (FixedPoint.Unsigned memory);

    function liquidationIncentiveMultiplier()
        external
        view
        returns (FixedPoint.Unsigned memory);

    function minimumCollateralizationRatio()
        external
        view
        returns (FixedPoint.Unsigned memory);

    function minimumDebtValue()
        external
        view
        returns (FixedPoint.Unsigned memory);

    function krAssetExists(address _krAsset) external view returns (bool);

    function kreskoAsset(address _asset) external view returns (KrAsset memory);

    function collateralDeposits(
        address _account,
        address _asset
    ) external view returns (uint256);

    /**
     * @notice Get `_account` interest amount for `_asset`
     * @param _account The account to query amount for
     * @return kissAmount the interest denominated in KISS, ignores K-factor
     */
    function kreskoAssetDebtInterestTotal(
        address _account
    ) external view returns (uint256 kissAmount);

    function getAccountSingleCollateralValueAndRealValue(
        address _account,
        address _asset
    )
        external
        view
        returns (
            FixedPoint.Unsigned memory value,
            FixedPoint.Unsigned memory realValue
        );

    /**
     * @notice Gets an index for the Kresko asset the account has minted.
     * @param _account The account to get the minted Kresko assets for.
     * @param _kreskoAsset The asset lookup address.
     * @return index of the minted Kresko asset.
     */
    function getMintedKreskoAssetsIndex(
        address _account,
        address _kreskoAsset
    ) external view returns (uint256);

    /**
     * @notice Gets an array of Kresko assets the account has minted.
     * @param _account The account to get the minted Kresko assets for.
     * @return An array of addresses of Kresko assets the account has minted.
     */
    function getMintedKreskoAssets(
        address _account
    ) external view returns (address[] memory);

    /**
     * @notice Gets the Kresko asset value in USD of a particular account.
     * @param _account The account to calculate the Kresko asset value for.
     * @return The Kresko asset value of a particular account.
     */
    function getAccountKrAssetValue(
        address _account
    ) external view returns (FixedPoint.Unsigned memory);

    function getDepositedCollateralAssets(
        address _account
    ) external view returns (address[] memory);

    function getAccountMinimumCollateralValueAtRatio(
        address _account,
        FixedPoint.Unsigned memory _ratio
    ) external view returns (FixedPoint.Unsigned memory);

    /**
     * @notice Get `_account` debt amount for `_asset`
     * @param _asset The asset address
     * @param _account The account to query amount for
     * @return Amount of debt for `_asset`
     */
    function kreskoAssetDebt(
        address _account,
        address _asset
    ) external view returns (uint256);

    /**
     * @notice Get `_account` interest amount for `_asset`
     * @param _asset The asset address
     * @param _account The account to query amount for
     * @return assetAmount the interest denominated in _asset
     * @return kissAmount the interest denominated in KISS, ignores K-factor
     */
    function kreskoAssetDebtInterest(
        address _account,
        address _asset
    ) external view returns (uint256 assetAmount, uint256 kissAmount);

    /**
     * @notice Calculates the expected fee to be taken from a user's deposited collateral assets,
     *         by imitating calcFee without modifying state.
     * @param _account The account to charge the open fee from.
     * @param _kreskoAsset The address of the kresko asset being burned.
     * @param _kreskoAssetAmount The amount of the kresko asset being minted.
     * @param _feeType The fee type (open, close, etc).
     * @return assets The collateral types as an array of addresses.
     * @return amounts The collateral amounts as an array of uint256.
     */
    function calcExpectedFee(
        address _account,
        address _kreskoAsset,
        uint256 _kreskoAssetAmount,
        uint256 _feeType
    ) external view returns (address[] memory, uint256[] memory);

    function getDepositedCollateralAssetIndex(
        address _account,
        address _collateralAsset
    ) external view returns (uint256 i);

    function getAccountCollateralRatio(
        address _account
    ) external view returns (FixedPoint.Unsigned memory ratio);

    function getAccountCollateralValue(
        address _account
    ) external view returns (FixedPoint.Unsigned memory);

    function collateralAsset(
        address _asset
    ) external view returns (CollateralAsset memory);

    function collateralExists(
        address _collateralAsset
    ) external view returns (bool);

    function getAllParams() external view returns (MinterParams memory);

    /**
     * @notice Get `_account` principal debt amount for `_asset`
     * @param _asset The asset address
     * @param _account The account to query amount for
     * @return Amount of principal debt for `_asset`
     */
    function kreskoAssetDebtPrincipal(
        address _account,
        address _asset
    ) external view returns (uint256);

    function getCollateralValueAndOraclePrice(
        address _collateralAsset,
        uint256 _amount,
        bool _ignoreCollateralFactor
    )
        external
        view
        returns (FixedPoint.Unsigned memory, FixedPoint.Unsigned memory);

    function getKrAssetValue(
        address _kreskoAsset,
        uint256 _amount,
        bool _ignoreKFactor
    ) external view returns (FixedPoint.Unsigned memory);

    function updateLiquidationIncentiveMultiplier(
        uint256 _liquidationIncentiveMultiplier
    ) external;

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

    function setupStabilityRateParams(
        address _asset,
        StabilityRateParams memory _setup
    ) external;

    function updateStabilityRateParams(
        address _asset,
        StabilityRateParams memory _setup
    ) external;

    function updateStabilityRateAndIndexForAsset(address _asset) external;

    function updateKiss(address _kiss) external;

    function repayStabilityRateInterestPartial(
        address _account,
        address _kreskoAsset,
        uint256 _kissRepayAmount
    ) external;

    function repayFullStabilityRateInterest(
        address _account,
        address _kreskoAsset
    ) external returns (uint256 kissRepayAmount);

    function batchRepayFullStabilityRateInterest(
        address _account
    ) external returns (uint256 kissRepayAmount);

    function getStabilityRateForAsset(
        address _asset
    ) external view returns (uint256 stabilityRate);

    function getPriceRateForAsset(
        address _asset
    ) external view returns (uint256 priceRate);

    function getDebtIndexForAsset(
        address _asset
    ) external view returns (uint256 debtIndex);

    function getStabilityRateConfigurationForAsset(
        address _asset
    ) external view returns (StabilityRateConfig memory);

    function kiss() external view returns (address);

    function getLastDebtIndexForAccount(
        address _account,
        address _asset
    ) external view returns (uint128 lastDebtIndex);

    /**
     * @notice Adds a collateral asset to the protocol.
     * @dev Only callable by the owner and cannot be called more than once for an asset.
     * @param _collateralAsset The address of the collateral asset.
     * @param _config The configuration for the collateral asset.
     */
    function addCollateralAsset(
        address _collateralAsset,
        CollateralAsset memory _config
    ) external;

    /**
     * @notice Adds a KreskoAsset to the protocol.
     * @dev Only callable by the owner.
     * @param _krAsset The address of the wrapped KreskoAsset, needs to support IKreskoAsset.
     * @param _config Configuration for the KreskoAsset.
     */
    function addKreskoAsset(address _krAsset, KrAsset memory _config) external;

    /**
     * @notice Updates a previously added collateral asset.
     * @dev Only callable by the owner.
     * @param _collateralAsset The address of the collateral asset.
     * @param _config The configuration for the collateral asset.
     */
    function updateCollateralAsset(
        address _collateralAsset,
        CollateralAsset memory _config
    ) external;

    /**
     * @notice Updates a previously added kresko asset.
     * @dev Only callable by the owner.
     * @param _krAsset The address of the KreskoAsset.
     * @param _config Configuration for the KreskoAsset.
     */
    function updateKreskoAsset(
        address _krAsset,
        KrAsset memory _config
    ) external;

    /**
     * @notice Updates the fee recipient.
     * @param _feeRecipient The new fee recipient.
     */
    function updateFeeRecipient(address _feeRecipient) external;

    /**
     * @notice  Updates the cFactor of a KreskoAsset.
     * @param _collateralAsset The collateral asset.
     * @param _cFactor The new cFactor.
     */
    function updateCFactor(address _collateralAsset, uint256 _cFactor) external;

    /**
     * @notice Updates the kFactor of a KreskoAsset.
     * @param _kreskoAsset The KreskoAsset.
     * @param _kFactor The new kFactor.
     */
    function updateKFactor(address _kreskoAsset, uint256 _kFactor) external;

    /**
     * @notice Updates the liquidation incentive multiplier.
     * @param _collateralAsset The collateral asset to update it for.
     * @param _liquidationIncentiveMultiplier The new liquidation incentive multiplie.
     */
    function updateLiquidationIncentiveMultiplier(
        address _collateralAsset,
        uint256 _liquidationIncentiveMultiplier
    ) external;

    /**
     * @notice Updates the max liquidation usd overflow multiplier value.
     * @param _maxLiquidationMultiplier Overflow value in percent, 18 decimals.
     */
    function updateMaxLiquidationMultiplier(
        uint256 _maxLiquidationMultiplier
    ) external;

    /**
     * @dev Updates the contract's collateralization ratio.
     * @param _minimumCollateralizationRatio The new minimum collateralization ratio as wad.
     */
    function updateMinimumCollateralizationRatio(
        uint256 _minimumCollateralizationRatio
    ) external;

    /**
     * @dev Updates the contract's minimum debt value.
     * @param _minimumDebtValue The new minimum debt value as a wad.
     */
    function updateMinimumDebtValue(uint256 _minimumDebtValue) external;

    /**
     * @dev Updates the contract's liquidation threshold value
     * @param _liquidationThreshold The new liquidation threshold value
     */
    function updateLiquidationThreshold(uint256 _liquidationThreshold) external;

    /**
     * @notice Sets the protocol AMM oracle address
     * @param _ammOracle  The address of the oracle
     */
    function updateAMMOracle(address _ammOracle) external;

    /**
     * @notice Sets the decimal precision of external oracle
     * @param _decimals Amount of decimals
     */
    function updateExtOracleDecimals(uint8 _decimals) external;

    /**
     * @notice Sets the decimal precision of external oracle
     * @param _oracleDeviationPct Amount of decimals
     */
    function updateOracleDeviationPct(uint256 _oracleDeviationPct) external;
}
