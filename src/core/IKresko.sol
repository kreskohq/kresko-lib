// SPDX-License-Identifier: MIT
// solhint-disable one-contract-per-file, max-line-length
pragma solidity ^0.8.0;

import {IErrorsEvents} from "./IErrorsEvents.sol";
import {SwapArgs, BurnArgs, UncheckedWithdrawArgs, LiquidationArgs, SCDPLiquidationArgs, MintArgs, SCDPWithdrawArgs, SCDPRepayArgs, WithdrawArgs} from "./types/Args.sol";
import {FeedConfiguration, MinterParams, SwapRouteSetter, SCDPInitArgs} from "./types/Setup.sol";
import {RawPrice, Asset, SafetyState, Enums, MaxLiqInfo, MinterAccountState, SCDPAssetIndexes, SCDPParameters, Oracle} from "./types/Data.sol";
import {View} from "./IData.sol";
import {PythView} from "../vendor/IPyth.sol";

interface ISCDPConfigFacet {
    /**
     * @notice Initialize SCDP.
     * Callable by diamond owner only.
     * @param _init The initial configuration.
     */
    function initializeSCDP(SCDPInitArgs memory _init) external;

    /// @notice Get the pool configuration.
    function getParametersSCDP() external view returns (SCDPParameters memory);

    /**
     * @notice Set the asset to cumulate swap fees into.
     * Only callable by admin.
     * @param _assetAddr Asset that is validated to be a deposit asset.
     */
    function setFeeAssetSCDP(address _assetAddr) external;

    /// @notice Set the minimum collateralization ratio for SCDP.
    function setMinCollateralRatioSCDP(uint32 _newMCR) external;

    /// @notice Set the liquidation threshold for SCDP while updating MLR to one percent above it.
    function setLiquidationThresholdSCDP(uint32 _newLT) external;

    /// @notice Set the max liquidation ratio for SCDP.
    /// @notice MLR is also updated automatically when setLiquidationThresholdSCDP is used.
    function setMaxLiquidationRatioSCDP(uint32 _newMLR) external;

    /// @notice Set the new liquidation incentive for a swappable asset.
    /// @param _assetAddr Asset address
    /// @param _newLiqIncentiveSCDP New liquidation incentive. Bounded to 1e4 <-> 1.25e4.
    function setKrAssetLiqIncentiveSCDP(
        address _assetAddr,
        uint16 _newLiqIncentiveSCDP
    ) external;

    /**
     * @notice Update the deposit asset limit configuration.
     * Only callable by admin.
     * emits PoolCollateralUpdated
     * @param _assetAddr The Collateral asset to update
     * @param _newDepositLimitSCDP The new deposit limit for the collateral
     */
    function setDepositLimitSCDP(
        address _assetAddr,
        uint256 _newDepositLimitSCDP
    ) external;

    /**
     * @notice Disable or enable a deposit asset. Reverts if invalid asset.
     * Only callable by admin.
     * @param _assetAddr Asset to set.
     * @param _enabled Whether to enable or disable the asset.
     */
    function setAssetIsSharedCollateralSCDP(
        address _assetAddr,
        bool _enabled
    ) external;

    /**
     * @notice Disable or enable asset from shared collateral value calculations.
     * Reverts if invalid asset and if disabling asset that has user deposits.
     * Only callable by admin.
     * @param _assetAddr Asset to set.
     * @param _enabled Whether to enable or disable the asset.
     */
    function setAssetIsSharedOrSwappedCollateralSCDP(
        address _assetAddr,
        bool _enabled
    ) external;

    /**
     * @notice Disable or enable a kresko asset to be used in swaps.
     * Reverts if invalid asset. Enabling will also add it to collateral value calculations.
     * Only callable by admin.
     * @param _assetAddr Asset to set.
     * @param _enabled Whether to enable or disable the asset.
     */
    function setAssetIsSwapMintableSCDP(
        address _assetAddr,
        bool _enabled
    ) external;

    /**
     * @notice Sets the fees for a kresko asset
     * @dev Only callable by admin.
     * @param _assetAddr The kresko asset to set fees for.
     * @param _openFee The new open fee.
     * @param _closeFee The new close fee.
     * @param _protocolFee The protocol fee share.
     */
    function setAssetSwapFeesSCDP(
        address _assetAddr,
        uint16 _openFee,
        uint16 _closeFee,
        uint16 _protocolFee
    ) external;

    /**
     * @notice Set whether swap routes for pairs are enabled or not. Both ways.
     * Only callable by admin.
     * @param _setters The configurations to set.
     */
    function setSwapRoutesSCDP(SwapRouteSetter[] calldata _setters) external;

    /**
     * @notice Set whether a swap route for a pair is enabled or not.
     * Only callable by admin.
     * @param _setter The configuration to set
     */
    function setSingleSwapRouteSCDP(SwapRouteSetter calldata _setter) external;
}

interface ISCDPStateFacet {
    /**
     * @notice Get the total collateral principal deposits for `_account`
     * @param _account The account.
     * @param _depositAsset The deposit asset
     */
    function getAccountDepositSCDP(
        address _account,
        address _depositAsset
    ) external view returns (uint256);

    /**
     * @notice Get the fees of `depositAsset` for `_account`
     * @param _account The account.
     * @param _depositAsset The deposit asset
     */
    function getAccountFeesSCDP(
        address _account,
        address _depositAsset
    ) external view returns (uint256);

    /**
     * @notice Get the value of fees for `_account`
     * @param _account The account.
     */
    function getAccountTotalFeesValueSCDP(
        address _account
    ) external view returns (uint256);

    /**
     * @notice Get the (principal) deposit value for `_account`
     * @param _account The account.
     * @param _depositAsset The deposit asset
     */
    function getAccountDepositValueSCDP(
        address _account,
        address _depositAsset
    ) external view returns (uint256);

    function getAssetIndexesSCDP(
        address _assetAddr
    ) external view returns (SCDPAssetIndexes memory);

    /**
     * @notice Get the total collateral deposit value for `_account`
     * @param _account The account.
     */
    function getAccountTotalDepositsValueSCDP(
        address _account
    ) external view returns (uint256);

    /**
     * @notice Get the total collateral deposits for `_collateralAsset`
     * @param _collateralAsset The collateral asset
     */
    function getDepositsSCDP(
        address _collateralAsset
    ) external view returns (uint256);

    /**
     * @notice Get the total collateral swap deposits for `_collateralAsset`
     * @param _collateralAsset The collateral asset
     */
    function getSwapDepositsSCDP(
        address _collateralAsset
    ) external view returns (uint256);

    /**
     * @notice Get the total collateral deposit value for `_collateralAsset`
     * @param _depositAsset The collateral asset
     * @param _ignoreFactors Ignore factors when calculating collateral and debt value.
     */
    function getCollateralValueSCDP(
        address _depositAsset,
        bool _ignoreFactors
    ) external view returns (uint256);

    /**
     * @notice Get the total collateral value, oracle precision
     * @param _ignoreFactors Ignore factors when calculating collateral value.
     */
    function getTotalCollateralValueSCDP(
        bool _ignoreFactors
    ) external view returns (uint256);

    /**
     * @notice Get all pool KreskoAssets
     */
    function getKreskoAssetsSCDP() external view returns (address[] memory);

    /**
     * @notice Get the collateral debt amount for `_krAsset`
     * @param _krAsset The KreskoAsset
     */
    function getDebtSCDP(address _krAsset) external view returns (uint256);

    /**
     * @notice Get the debt value for `_krAsset`
     * @param _krAsset The KreskoAsset
     * @param _ignoreFactors Ignore factors when calculating collateral and debt value.
     */
    function getDebtValueSCDP(
        address _krAsset,
        bool _ignoreFactors
    ) external view returns (uint256);

    /**
     * @notice Get the total debt value of krAssets in oracle precision
     * @param _ignoreFactors Ignore factors when calculating debt value.
     */
    function getTotalDebtValueSCDP(
        bool _ignoreFactors
    ) external view returns (uint256);

    /**
     * @notice Get enabled state of asset
     */
    function getAssetEnabledSCDP(
        address _assetAddr
    ) external view returns (bool);

    /**
     * @notice Get whether swap is enabled from `_assetIn` to `_assetOut`
     * @param _assetIn The asset to swap from
     * @param _assetOut The asset to swap to
     */
    function getSwapEnabledSCDP(
        address _assetIn,
        address _assetOut
    ) external view returns (bool);

    function getCollateralRatioSCDP() external view returns (uint256);
}

/* -------------------------------------------------------------------------- */
/*                               Access Control                                    */
/* -------------------------------------------------------------------------- */

interface IViewDataFacet {
    function viewProtocolData(
        PythView calldata prices
    ) external view returns (View.Protocol memory);

    function viewAccountData(
        PythView calldata prices,
        address account
    ) external view returns (View.Account memory);

    function viewMinterAccounts(
        PythView calldata prices,
        address[] memory accounts
    ) external view returns (View.MAccount[] memory);

    function viewSCDPAccount(
        PythView calldata prices,
        address account
    ) external view returns (View.SAccount memory);

    function viewSCDPDepositAssets() external view returns (address[] memory);

    function viewTokenBalances(
        PythView calldata prices,
        address account,
        address[] memory tokens
    ) external view returns (View.Balance[] memory result);

    function viewAccountGatingPhase(
        address account
    ) external view returns (uint8 phase, bool eligibleForCurrentPhase);

    function viewSCDPAccounts(
        PythView calldata prices,
        address[] memory accounts,
        address[] memory assets
    ) external view returns (View.SAccount[] memory);

    function viewSCDPAssets(
        PythView calldata prices,
        address[] memory assets
    ) external view returns (View.AssetData[] memory);
}

interface IMinterDepositWithdrawFacet {
    /**
     * @notice Deposits collateral into the protocol.
     * @param _account The user to deposit collateral for.
     * @param _collateralAsset The address of the collateral asset.
     * @param _depositAmount The amount of the collateral asset to deposit.
     */
    function depositCollateral(
        address _account,
        address _collateralAsset,
        uint256 _depositAmount
    ) external payable;

    /**
     * @notice Withdraws sender's collateral from the protocol.
     * @dev Requires that the post-withdrawal collateral value does not violate minimum collateral requirement.
     * @param _args WithdrawArgs
     * @param _updateData Price update data
     * assets array. Only needed if withdrawing the entire deposit of a particular collateral asset.
     */
    function withdrawCollateral(
        WithdrawArgs memory _args,
        bytes[] calldata _updateData
    ) external payable;

    /**
     * @notice Withdraws sender's collateral from the protocol before checking minimum collateral ratio.
     * @dev Executes post-withdraw-callback triggering onUncheckedCollateralWithdraw on the caller
     * @dev Requires that the post-withdraw-callback collateral value does not violate minimum collateral requirement.
     * @param _args UncheckedWithdrawArgs
     * @param _updateData Price update data
     * assets array. Only needed if withdrawing the entire deposit of a particular collateral asset.
     */
    function withdrawCollateralUnchecked(
        UncheckedWithdrawArgs memory _args,
        bytes[] calldata _updateData
    ) external payable;
}

interface IMinterBurnFacet {
    /**
     * @notice Burns existing Kresko assets.
     * @notice Manager role is required if the caller is not the account being repaid to or the account repaying.
     * @param args Burn arguments
     * @param _updateData Price update data
     */
    function burnKreskoAsset(
        BurnArgs memory args,
        bytes[] calldata _updateData
    ) external payable;
}

interface IMinterMintFacet {
    /**
     * @notice Mints new Kresko assets.
     * @param _args MintArgs struct containing the arguments necessary to perform a mint.
     */
    function mintKreskoAsset(
        MintArgs memory _args,
        bytes[] calldata _updateData
    ) external payable;
}

interface ISCDPSwapFacet {
    /**
     * @notice Preview the amount out received.
     * @param _assetIn The asset to pay with.
     * @param _assetOut The asset to receive.
     * @param _amountIn The amount of _assetIn to pay
     * @return amountOut The amount of `_assetOut` to receive according to `_amountIn`.
     */
    function previewSwapSCDP(
        address _assetIn,
        address _assetOut,
        uint256 _amountIn
    )
        external
        view
        returns (uint256 amountOut, uint256 feeAmount, uint256 protocolFee);

    /**
     * @notice Swap kresko assets with KISS using the shared collateral pool.
     * Uses oracle pricing of _amountIn to determine how much _assetOut to send.
     * @param _args SwapArgs struct containing swap data.
     */
    function swapSCDP(SwapArgs calldata _args) external payable;

    /**
     * @notice Accumulates fees to deposits as a fixed, instantaneous income.
     * @param _depositAssetAddr Deposit asset to give income for
     * @param _incomeAmount Amount to accumulate
     * @return nextLiquidityIndex Next liquidity index for the asset.
     */
    function cumulateIncomeSCDP(
        address _depositAssetAddr,
        uint256 _incomeAmount
    ) external payable returns (uint256 nextLiquidityIndex);
}

interface ISCDPFacet {
    /**
     * @notice Deposit collateral for account to the collateral pool.
     * @param _account The account to deposit for.
     * @param _collateralAsset The collateral asset to deposit.
     * @param _amount The amount to deposit.
     */
    function depositSCDP(
        address _account,
        address _collateralAsset,
        uint256 _amount
    ) external payable;

    /**
     * @notice Withdraw collateral for account from the collateral pool.
     * @param _args WithdrawArgs struct containing withdraw data.
     */
    function withdrawSCDP(
        SCDPWithdrawArgs memory _args,
        bytes[] calldata _updateData
    ) external payable;

    /**
     * @notice Withdraw collateral without caring about fees.
     * @param _args WithdrawArgs struct containing withdraw data.
     */
    function emergencyWithdrawSCDP(
        SCDPWithdrawArgs memory _args,
        bytes[] calldata _updateData
    ) external payable;

    /**
     * @notice Withdraws any pending fees for an account.
     * @param _account The account to withdraw fees for.
     * @param _collateralAsset The collateral asset to withdraw fees for.
     * @param _receiver Receiver of fees withdrawn, if 0 then the receiver is the account.
     * @return feeAmount The amount of fees withdrawn.
     */
    function claimFeesSCDP(
        address _account,
        address _collateralAsset,
        address _receiver
    ) external payable returns (uint256 feeAmount);

    /**
     * @notice Repay debt for no fees or slippage.
     * @notice Only uses swap deposits, if none available, reverts.
     * @param _args RepayArgs struct containing repay data.
     */
    function repaySCDP(SCDPRepayArgs calldata _args) external payable;

    /**
     * @notice Liquidate the collateral pool.
     * @notice Adjusts everyones deposits if swap deposits do not cover the seized amount.
     * @param _args LiquidationArgs struct containing liquidation data.
     */
    function liquidateSCDP(
        SCDPLiquidationArgs memory _args,
        bytes[] calldata _updateData
    ) external payable;

    /**
     * @dev Calculates the total value that is allowed to be liquidated from SCDP (if it is liquidatable)
     * @param _repayAssetAddr Address of Kresko Asset to repay
     * @param _seizeAssetAddr Address of Collateral to seize
     * @return MaxLiqInfo Calculated information about the maximum liquidation.
     */
    function getMaxLiqValueSCDP(
        address _repayAssetAddr,
        address _seizeAssetAddr
    ) external view returns (MaxLiqInfo memory);

    function getLiquidatableSCDP() external view returns (bool);
}

interface ISDIFacet {
    /// @notice Get the total debt of the SCDP.
    function getTotalSDIDebt() external view returns (uint256);

    /// @notice Get the effective debt value of the SCDP.
    function getEffectiveSDIDebtUSD() external view returns (uint256);

    /// @notice Get the effective debt amount of the SCDP.
    function getEffectiveSDIDebt() external view returns (uint256);

    /// @notice Get the total normalized amount of cover.
    function getSDICoverAmount() external view returns (uint256);

    function previewSCDPBurn(
        address _assetAddr,
        uint256 _burnAmount,
        bool _ignoreFactors
    ) external view returns (uint256 shares);

    function previewSCDPMint(
        address _assetAddr,
        uint256 _mintAmount,
        bool _ignoreFactors
    ) external view returns (uint256 shares);

    /// @notice Simply returns the total supply of SDI.
    function totalSDI() external view returns (uint256);

    /// @notice Get the price of SDI in USD, oracle precision.
    function getSDIPrice() external view returns (uint256);

    /// @notice Cover debt by providing collateral without getting anything in return.
    function coverSCDP(
        address _assetAddr,
        uint256 _coverAmount,
        bytes[] calldata _updateData
    ) external payable returns (uint256 value);

    /// @notice Cover debt by providing collateral, receiving small incentive in return.
    function coverWithIncentiveSCDP(
        address _assetAddr,
        uint256 _coverAmount,
        address _seizeAssetAddr,
        bytes[] calldata _updateData
    ) external payable returns (uint256 value, uint256 seizedAmount);

    /// @notice Enable a cover asset to be used.
    function enableCoverAssetSDI(address _assetAddr) external;

    /// @notice Disable a cover asset to be used.
    function disableCoverAssetSDI(address _assetAddr) external;

    /// @notice Set the contract holding cover assets.
    function setCoverRecipientSDI(address _coverRecipient) external;

    /// @notice Get all accepted cover assets.
    function getCoverAssetsSDI() external view returns (address[] memory);
}

interface IMinterConfigFacet {
    /**
     * @dev Updates the contract's minimum debt value.
     * @param _newMinDebtValue The new minimum debt value as a wad.
     */
    function setMinDebtValueMinter(uint256 _newMinDebtValue) external;

    /**
     * @notice Updates the liquidation incentive multiplier.
     * @param _collateralAsset The collateral asset to update.
     * @param _newLiquidationIncentive The new liquidation incentive multiplier for the asset.
     */
    function setCollateralLiquidationIncentiveMinter(
        address _collateralAsset,
        uint16 _newLiquidationIncentive
    ) external;

    /**
     * @dev Updates the contract's collateralization ratio.
     * @param _newMinCollateralRatio The new minimum collateralization ratio as wad.
     */
    function setMinCollateralRatioMinter(
        uint32 _newMinCollateralRatio
    ) external;

    /**
     * @dev Updates the contract's liquidation threshold value
     * @param _newThreshold The new liquidation threshold value
     */
    function setLiquidationThresholdMinter(uint32 _newThreshold) external;

    /**
     * @notice Updates the max liquidation ratior value.
     * @notice This is the maximum collateral ratio that liquidations can liquidate to.
     * @param _newMaxLiquidationRatio Percent value in wad precision.
     */
    function setMaxLiquidationRatioMinter(
        uint32 _newMaxLiquidationRatio
    ) external;
}

interface IMinterStateFacet {
    /// @notice The collateralization ratio at which positions may be liquidated.
    function getLiquidationThresholdMinter() external view returns (uint32);

    /// @notice Multiplies max liquidation multiplier, if a full liquidation happens this is the resulting CR.
    function getMaxLiquidationRatioMinter() external view returns (uint32);

    /// @notice The minimum USD value of an individual synthetic asset debt position.
    function getMinDebtValueMinter() external view returns (uint256);

    /// @notice The minimum ratio of collateral to debt that can be taken by direct action.
    function getMinCollateralRatioMinter() external view returns (uint32);

    /// @notice simple check if kresko asset exists
    function getKrAssetExists(address _krAsset) external view returns (bool);

    /// @notice simple check if collateral asset exists
    function getCollateralExists(
        address _collateralAsset
    ) external view returns (bool);

    /// @notice get all meaningful protocol parameters
    function getParametersMinter() external view returns (MinterParams memory);

    /**
     * @notice Gets the USD value for a single collateral asset and amount.
     * @param _collateralAsset The address of the collateral asset.
     * @param _amount The amount of the collateral asset to calculate the value for.
     * @return value The unadjusted value for the provided amount of the collateral asset.
     * @return adjustedValue The (cFactor) adjusted value for the provided amount of the collateral asset.
     * @return price The price of the collateral asset.
     */
    function getCollateralValueWithPrice(
        address _collateralAsset,
        uint256 _amount
    )
        external
        view
        returns (uint256 value, uint256 adjustedValue, uint256 price);

    /**
     * @notice Gets the USD value for a single Kresko asset and amount.
     * @param _krAsset The address of the Kresko asset.
     * @param _amount The amount of the Kresko asset to calculate the value for.
     * @return value The unadjusted value for the provided amount of the debt asset.
     * @return adjustedValue The (kFactor) adjusted value for the provided amount of the debt asset.
     * @return price The price of the debt asset.
     */
    function getDebtValueWithPrice(
        address _krAsset,
        uint256 _amount
    )
        external
        view
        returns (uint256 value, uint256 adjustedValue, uint256 price);
}

interface IMinterLiquidationFacet {
    /**
     * @notice Attempts to liquidate an account by repaying the portion of the account's Kresko asset
     * debt, receiving in return a portion of the account's collateral at a discounted rate.
     * @param _args LiquidationArgs struct containing the arguments necessary to perform a liquidation.
     */
    function liquidate(LiquidationArgs calldata _args) external payable;

    /**
     * @dev Calculates the total value that is allowed to be liquidated from an account (if it is liquidatable)
     * @param _account Address of the account to liquidate
     * @param _repayAssetAddr Address of Kresko Asset to repay
     * @param _seizeAssetAddr Address of Collateral to seize
     * @return MaxLiqInfo Calculated information about the maximum liquidation.
     */
    function getMaxLiqValue(
        address _account,
        address _repayAssetAddr,
        address _seizeAssetAddr
    ) external view returns (MaxLiqInfo memory);
}

interface IMinterAccountStateFacet {
    // ExpectedFeeRuntimeInfo is used for stack size optimization
    struct ExpectedFeeRuntimeInfo {
        address[] assets;
        uint256[] amounts;
        uint256 collateralTypeCount;
    }

    /**
     * @notice Calculates if an account's current collateral value is under its minimum collateral value
     * @param _account The account to check.
     * @return bool Indicates if the account can be liquidated.
     */
    function getAccountLiquidatable(
        address _account
    ) external view returns (bool);

    /**
     * @notice Get accounts state in the Minter.
     * @param _account Account address to get the state for.
     * @return MinterAccountState Total debt value, total collateral value and collateral ratio.
     */
    function getAccountState(
        address _account
    ) external view returns (MinterAccountState memory);

    /**
     * @notice Gets an array of Kresko assets the account has minted.
     * @param _account The account to get the minted Kresko assets for.
     * @return address[] Array of Kresko Asset addresses the account has minted.
     */
    function getAccountMintedAssets(
        address _account
    ) external view returns (address[] memory);

    /**
     * @notice Gets an index for the Kresko asset the account has minted.
     * @param _account The account to get the minted Kresko assets for.
     * @param _krAsset The asset lookup address.
     * @return index The index of asset in the minted assets array.
     */
    function getAccountMintIndex(
        address _account,
        address _krAsset
    ) external view returns (uint256);

    /**
     * @notice Gets the total Kresko asset debt value in USD for an account.
     * @notice Adjusted value means it is multiplied by kFactor.
     * @param _account Account to calculate the Kresko asset value for.
     * @return value The unadjusted value of debt.
     * @return valueAdjusted The kFactor adjusted value of debt.
     */
    function getAccountTotalDebtValues(
        address _account
    ) external view returns (uint256 value, uint256 valueAdjusted);

    /**
     * @notice Gets the total Kresko asset debt value in USD for an account.
     * @param _account The account to calculate the Kresko asset value for.
     * @return uint256 Total debt value of `_account`.
     */
    function getAccountTotalDebtValue(
        address _account
    ) external view returns (uint256);

    /**
     * @notice Get `_account` debt amount for `_asset`
     * @param _assetAddr The asset address
     * @param _account The account to query amount for
     * @return uint256 Amount of debt for `_assetAddr`
     */
    function getAccountDebtAmount(
        address _account,
        address _assetAddr
    ) external view returns (uint256);

    /**
     * @notice Get the unadjusted and the adjusted value of collateral deposits of `_assetAddr` for `_account`.
     * @notice Adjusted value means it is multiplied by cFactor.
     * @param _account Account to get the collateral values for.
     * @param _assetAddr Asset to get the collateral values for.
     * @return value Unadjusted value of the collateral deposits.
     * @return valueAdjusted cFactor adjusted value of the collateral deposits.
     * @return price Price for the collateral asset
     */
    function getAccountCollateralValues(
        address _account,
        address _assetAddr
    )
        external
        view
        returns (uint256 value, uint256 valueAdjusted, uint256 price);

    /**
     * @notice Gets the adjusted collateral value of a particular account.
     * @param _account Account to calculate the collateral value for.
     * @return valueAdjusted Collateral value of a particular account.
     */
    function getAccountTotalCollateralValue(
        address _account
    ) external view returns (uint256 valueAdjusted);

    /**
     * @notice Gets the adjusted and unadjusted collateral value of `_account`.
     * @notice Adjusted value means it is multiplied by cFactor.
     * @param _account Account to get the values for
     * @return value Unadjusted total value of the collateral deposits.
     * @return valueAdjusted cFactor adjusted total value of the collateral deposits.
     */
    function getAccountTotalCollateralValues(
        address _account
    ) external view returns (uint256 value, uint256 valueAdjusted);

    /**
     * @notice Get an account's minimum collateral value required
     * to back a Kresko asset amount at a given collateralization ratio.
     * @dev Accounts that have their collateral value under the minimum collateral value are considered unhealthy,
     *      accounts with their collateral value under the liquidation threshold are considered liquidatable.
     * @param _account Account to calculate the minimum collateral value for.
     * @param _ratio Collateralization ratio required: higher ratio = more collateral required
     * @return uint256 Minimum collateral value of a particular account.
     */
    function getAccountMinCollateralAtRatio(
        address _account,
        uint32 _ratio
    ) external view returns (uint256);

    /**
     * @notice Get a list of accounts and their collateral ratios
     * @return ratio The collateral ratio of `_account`
     */
    function getAccountCollateralRatio(
        address _account
    ) external view returns (uint256 ratio);

    /**
     * @notice Get a list of account collateral ratios
     * @return ratios Collateral ratios of the `_accounts`
     */
    function getAccountCollateralRatios(
        address[] memory _accounts
    ) external view returns (uint256[] memory);

    /**
     * @notice Gets an index for the collateral asset the account has deposited.
     * @param _account Account to get the index for.
     * @param _collateralAsset Asset address.
     * @return i Index of the minted collateral asset.
     */
    function getAccountDepositIndex(
        address _account,
        address _collateralAsset
    ) external view returns (uint256 i);

    /**
     * @notice Gets an array of collateral assets the account has deposited.
     * @param _account The account to get the deposited collateral assets for.
     * @return address[] Array of collateral asset addresses the account has deposited.
     */
    function getAccountCollateralAssets(
        address _account
    ) external view returns (address[] memory);

    /**
     * @notice Get `_account` collateral deposit amount for `_assetAddr`
     * @param _assetAddr The asset address
     * @param _account The account to query amount for
     * @return uint256 Amount of collateral deposited for `_assetAddr`
     */
    function getAccountCollateralAmount(
        address _account,
        address _assetAddr
    ) external view returns (uint256);

    /**
     * @notice Calculates the expected fee to be taken from a user's deposited collateral assets,
     *         by imitating calcFee without modifying state.
     * @param _account Account to charge the open fee from.
     * @param _krAsset Address of the kresko asset being burned.
     * @param _kreskoAssetAmount Amount of the kresko asset being minted.
     * @param _feeType Fee type (open or close).
     * @return assets Collateral types as an array of addresses.
     * @return amounts Collateral amounts as an array of uint256.
     */
    function previewFee(
        address _account,
        address _krAsset,
        uint256 _kreskoAssetAmount,
        Enums.MinterFee _feeType
    ) external view returns (address[] memory assets, uint256[] memory amounts);
}

interface IAuthorizationFacet {
    /**
     * @dev OpenZeppelin
     * Returns one of the accounts that have `role`. `index` must be a
     * value between 0 and {getRoleMemberCount}, non-inclusive.
     *
     * Role bearers are not sorted in any particular way, and their ordering may
     * change at any point.
     *
     * @notice WARNING:
     * When using {getRoleMember} and {getRoleMemberCount}, make sure
     * you perform all queries on the same block.
     *
     * See the following forum post for more information:
     * - https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296
     *
     * @dev Kresko
     *
     * TL;DR above:
     *
     * - If you iterate the EnumSet outside a single block scope you might get different results.
     * - Since when EnumSet member is deleted it is replaced with the highest index.
     * @return address with the `role`
     */
    function getRoleMember(
        bytes32 role,
        uint256 index
    ) external view returns (address);

    /**
     * @dev Returns the number of accounts that have `role`. Can be used
     * together with {getRoleMember} to enumerate all bearers of a role.
     * @notice See warning in {getRoleMember} if combining these two
     */
    function getRoleMemberCount(bytes32 role) external view returns (uint256);

    /**
     * @dev Grants `role` to `account`.
     *
     * If `account` had not been already granted `role`, emits a {RoleGranted}
     * event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function grantRole(bytes32 role, address account) external;

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * @notice To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) external view returns (bytes32);

    /**
     * @dev Returns true if `account` has been granted `role`.
     */
    function hasRole(
        bytes32 role,
        address account
    ) external view returns (bool);

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been revoked `role`, emits a {RoleRevoked}
     * event.
     *
     * @notice Requirements
     *
     * - the caller must be `account`.
     */
    function renounceRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from `account`.
     *
     * @notice Requirements
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) external;
}

interface ISafetyCouncilFacet {
    /**
     * @dev Toggle paused-state of assets in a per-action basis
     *
     * @notice These functions are only callable by a multisig quorum.
     * @param _assets list of addresses of krAssets and/or collateral assets
     * @param _action One of possible user actions:
     *  Deposit = 0
     *  Withdraw = 1,
     *  Repay = 2,
     *  Borrow = 3,
     *  Liquidate = 4
     * @param _withDuration Set a duration for this pause - @todo: implement it if required
     * @param _duration Duration for the pause if `_withDuration` is true
     */
    function toggleAssetsPaused(
        address[] memory _assets,
        Enums.Action _action,
        bool _withDuration,
        uint256 _duration
    ) external;

    /**
     * @notice set the safetyStateSet flag
     */
    function setSafetyStateSet(bool val) external;

    /**
     * @notice For external checks if a safety state has been set for any asset
     */
    function safetyStateSet() external view returns (bool);

    /**
     * @notice View the state of safety measures for an asset on a per-action basis
     * @param _assetAddr krAsset / collateral asset
     * @param _action One of possible user actions:
     *
     *  Deposit = 0
     *  Withdraw = 1,
     *  Repay = 2,
     *  Borrow = 3,
     *  Liquidate = 4
     */
    function safetyStateFor(
        address _assetAddr,
        Enums.Action _action
    ) external view returns (SafetyState memory);

    /**
     * @notice Check if `_assetAddr` has a pause enabled for `_action`
     * @param _action enum `Action`
     *  Deposit = 0
     *  Withdraw = 1,
     *  Repay = 2,
     *  Borrow = 3,
     *  Liquidate = 4
     * @return true if `_action` is paused
     */
    function assetActionPaused(
        Enums.Action _action,
        address _assetAddr
    ) external view returns (bool);
}

interface ICommonConfigFacet {
    struct PythConfig {
        bytes32[] pythIds;
        uint256[] staleTimes;
        bool[] invertPyth;
    }

    /**
     * @notice Updates the fee recipient.
     * @param _newFeeRecipient The new fee recipient.
     */
    function setFeeRecipient(address _newFeeRecipient) external;

    function setPythEndpoint(address _pythEp) external;

    /**
     * @notice Sets the decimal precision of external oracle
     * @param _decimals Amount of decimals
     */
    function setDefaultOraclePrecision(uint8 _decimals) external;

    /**
     * @notice Sets the decimal precision of external oracle
     * @param _oracleDeviationPct Amount of decimals
     */
    function setMaxPriceDeviationPct(uint16 _oracleDeviationPct) external;

    /**
     * @notice Sets L2 sequencer uptime feed address
     * @param _sequencerUptimeFeed sequencer uptime feed address
     */
    function setSequencerUptimeFeed(address _sequencerUptimeFeed) external;

    /**
     * @notice Sets sequencer grace period time
     * @param _sequencerGracePeriodTime grace period time
     */
    function setSequencerGracePeriod(uint32 _sequencerGracePeriodTime) external;

    /**
     * @notice Set feeds for a ticker.
     * @param _ticker Ticker in bytes32 eg. bytes32("ETH")
     * @param _feedConfig List oracle configuration containing oracle identifiers and feed addresses.
     */
    function setFeedsForTicker(
        bytes32 _ticker,
        FeedConfiguration memory _feedConfig
    ) external;

    /**
     * @notice Set chainlink feeds for tickers.
     * @dev Has modifiers: onlyRole.
     * @param _tickers Bytes32 list of tickers
     * @param _feeds List of feed addresses.
     */
    function setChainlinkFeeds(
        bytes32[] calldata _tickers,
        address[] calldata _feeds,
        uint256[] memory _staleTimes
    ) external;

    /**
     * @notice Set api3 feeds for tickers.
     * @dev Has modifiers: onlyRole.
     * @param _tickers Bytes32 list of tickers
     * @param _feeds List of feed addresses.
     */
    function setAPI3Feeds(
        bytes32[] calldata _tickers,
        address[] calldata _feeds,
        uint256[] memory _staleTimes
    ) external;

    /**
     * @notice Set a vault feed for ticker.
     * @dev Has modifiers: onlyRole.
     * @param _ticker Ticker in bytes32 eg. bytes32("ETH")
     * @param _vaultAddr Vault address
     * @custom:signature setVaultFeed(bytes32,address)
     * @custom:selector 0xc3f9c901
     */
    function setVaultFeed(bytes32 _ticker, address _vaultAddr) external;

    /**
     * @notice Set a pyth feeds for tickers.
     * @dev Has modifiers: onlyRole.
     * @param _tickers Bytes32 list of tickers
     * @param pythConfig Pyth configuration
     */
    function setPythFeeds(
        bytes32[] calldata _tickers,
        PythConfig calldata pythConfig
    ) external;

    function setPythFeed(
        bytes32 _ticker,
        bytes32 _pythId,
        bool _invert,
        uint256 _staleTime
    ) external;

    /**
     * @notice Set ChainLink feed address for ticker.
     * @param _ticker Ticker in bytes32 eg. bytes32("ETH")
     * @param _feedAddr The feed address.
     * @custom:signature setChainLinkFeed(bytes32,address)
     * @custom:selector 0xe091f77a
     */
    function setChainLinkFeed(
        bytes32 _ticker,
        address _feedAddr,
        uint256 _staleTime
    ) external;

    /**
     * @notice Set API3 feed address for an asset.
     * @param _ticker Ticker in bytes32 eg. bytes32("ETH")
     * @param _feedAddr The feed address.
     * @custom:signature setApi3Feed(bytes32,address)
     * @custom:selector 0x7e9f9837
     */
    function setAPI3Feed(
        bytes32 _ticker,
        address _feedAddr,
        uint256 _staleTime
    ) external;

    /**
     * @notice Sets gating manager
     * @param _newManager _newManager address
     */
    function setGatingManager(address _newManager) external;
}

interface ICommonStateFacet {
    /// @notice The recipient of protocol fees.
    function getFeeRecipient() external view returns (address);

    /// @notice The pyth endpoint.
    function getPythEndpoint() external view returns (address);

    /// @notice Offchain oracle decimals
    function getDefaultOraclePrecision() external view returns (uint8);

    /// @notice max deviation between main oracle and fallback oracle
    function getOracleDeviationPct() external view returns (uint16);

    /// @notice gating manager contract address
    function getGatingManager() external view returns (address);

    /// @notice Get the L2 sequencer uptime feed address.
    function getSequencerUptimeFeed() external view returns (address);

    /// @notice Get the L2 sequencer uptime feed grace period
    function getSequencerGracePeriod() external view returns (uint32);

    /**
     * @notice Get configured feed of the ticker
     * @param _ticker Ticker in bytes32, eg. bytes32("ETH").
     * @param _oracleType The oracle type.
     * @return feedAddr Feed address matching the oracle type given.
     */
    function getOracleOfTicker(
        bytes32 _ticker,
        Enums.OracleType _oracleType
    ) external view returns (Oracle memory);

    function getChainlinkPrice(bytes32 _ticker) external view returns (uint256);

    function getVaultPrice(bytes32 _ticker) external view returns (uint256);

    function getRedstonePrice(bytes32 _ticker) external view returns (uint256);

    function getAPI3Price(bytes32 _ticker) external view returns (uint256);

    function getPythPrice(bytes32 _ticker) external view returns (uint256);
}

interface IAssetStateFacet {
    /**
     * @notice Get the state of a specific asset
     * @param _assetAddr Address of the asset.
     * @return Asset State of asset
     * @custom:signature getAsset(address)
     * @custom:selector 0x30b8b2c6
     */

    function getAsset(address _assetAddr) external view returns (Asset memory);

    /**
     * @notice Get price for an asset from address.
     * @param _assetAddr Asset address.
     * @return uint256 Current price for the asset.
     * @custom:signature getPrice(address)
     * @custom:selector 0x41976e09
     */
    function getPrice(address _assetAddr) external view returns (uint256);

    /**
     * @notice Get push price for an asset from address.
     * @param _assetAddr Asset address.
     * @return RawPrice Current raw price for the asset.
     * @custom:signature getPushPrice(address)
     * @custom:selector 0xc72f3dd7
     */
    function getPushPrice(
        address _assetAddr
    ) external view returns (RawPrice memory);

    /**
     * @notice Get value for an asset amount using the current price.
     * @param _assetAddr Asset address.
     * @param _amount The amount (uint256).
     * @return uint256 Current value for `_amount` of `_assetAddr`.
     * @custom:signature getValue(address,uint256)
     * @custom:selector 0xc7bf8cf5
     */
    function getValue(
        address _assetAddr,
        uint256 _amount
    ) external view returns (uint256);

    /**
     * @notice Gets corresponding feed address for the oracle type and asset address.
     * @param _assetAddr The asset address.
     * @param _oracleType The oracle type.
     * @return feedAddr Feed address that the asset uses with the oracle type.
     */
    function getFeedForAddress(
        address _assetAddr,
        Enums.OracleType _oracleType
    ) external view returns (address feedAddr);
}

interface IAssetConfigFacet {
    /**
     * @notice Adds a new asset to the common state.
     * @notice Performs validations according to the `_config` provided.
     * @dev Use validateAssetConfig / static call this for validation.
     * @param _assetAddr Asset address.
     * @param _config Configuration struct to save for the asset.
     * @param _feedConfig Configuration struct for the asset's oracles
     * @return Asset Result of addAsset.
     */
    function addAsset(
        address _assetAddr,
        Asset memory _config,
        FeedConfiguration memory _feedConfig
    ) external returns (Asset memory);

    /**
     * @notice Update asset config.
     * @notice Performs validations according to the `_config` set.
     * @dev Use validateAssetConfig / static call this for validation.
     * @param _assetAddr The asset address.
     * @param _config Configuration struct to apply for the asset.
     */
    function updateAsset(
        address _assetAddr,
        Asset memory _config
    ) external returns (Asset memory);

    /**
     * @notice  Updates the cFactor of a KreskoAsset. Convenience.
     * @param _assetAddr The collateral asset.
     * @param _newFactor The new collateral factor.
     */
    function setAssetCFactor(address _assetAddr, uint16 _newFactor) external;

    /**
     * @notice Updates the kFactor of a KreskoAsset.
     * @param _assetAddr The KreskoAsset.
     * @param _newKFactor The new kFactor.
     */
    function setAssetKFactor(address _assetAddr, uint16 _newKFactor) external;

    /**
     * @notice Validate supplied asset config. Reverts with information if invalid.
     * @param _assetAddr The asset address.
     * @param _config Configuration for the asset.
     * @return bool True for convenience.
     */
    function validateAssetConfig(
        address _assetAddr,
        Asset memory _config
    ) external view returns (bool);

    /**
     * @notice Update oracle order for an asset.
     * @param _assetAddr The asset address.
     * @param _newOracleOrder List of 2 OracleTypes. 0 is primary and 1 is the reference.
     */
    function setAssetOracleOrder(
        address _assetAddr,
        Enums.OracleType[2] memory _newOracleOrder
    ) external;
}

/// @title IDiamondStateFacet
/// @notice Functions for the diamond state itself.
interface IDiamondStateFacet {
    /// @notice Whether the diamond is initialized.
    function initialized() external view returns (bool);

    /// @notice The EIP-712 typehash for the contract's domain.
    function domainSeparator() external view returns (bytes32);

    /// @notice Get the storage version (amount of times the storage has been upgraded)
    /// @return uint256 The storage version.
    function getStorageVersion() external view returns (uint256);

    /**
     * @notice Get the address of the owner
     * @return owner_ The address of the owner.
     */
    function owner() external view returns (address owner_);

    /**
     * @notice Get the address of pending owner
     * @return pendingOwner_ The address of the pending owner.
     **/
    function pendingOwner() external view returns (address pendingOwner_);

    /**
     * @notice Initiate ownership transfer to a new address
     * @notice caller must be the current contract owner
     * @notice the new owner cannot be address(0)
     * @notice emits a {PendingOwnershipTransfer} event
     * @param _newOwner address that is set as the pending new owner
     */
    function transferOwnership(address _newOwner) external;

    /**
     * @notice Transfer the ownership to the new pending owner
     * @notice caller must be the pending owner
     * @notice emits a {OwnershipTransferred} event
     */
    function acceptOwnership() external;
}

interface IBatchFacet {
    /**
     * @notice Performs batched calls to the protocol with a single price update.
     * @param _calls Calls to perform.
     * @param _updateData Pyth price data to use for the calls.
     */
    function batchCall(
        bytes[] calldata _calls,
        bytes[] calldata _updateData
    ) external payable;

    /**
     * @notice Performs "static calls" with the update prices through `batchCallToError`, using a try-catch.
     * Refunds the msg.value sent for price update fee.
     * @param _staticCalls Calls to perform.
     * @param _updateData Pyth price update preview with the static calls.
     * @return timestamp Timestamp of the data.
     * @return results Static call results as bytes[]
     */
    function batchStaticCall(
        bytes[] calldata _staticCalls,
        bytes[] calldata _updateData
    ) external payable returns (uint256 timestamp, bytes[] memory results);

    /**
     * @notice Performs supplied calls and reverts a `Errors.BatchResult` containing returned results as bytes[].
     * @param _calls Calls to perform.
     * @param _updateData Pyth price update data to use for the static calls.
     * @return `Errors.BatchResult` which needs to be caught and decoded on-chain (according to the result signature).
     * Use `batchStaticCall` for a direct return.
     */
    function batchCallToError(
        bytes[] calldata _calls,
        bytes[] calldata _updateData
    ) external payable returns (uint256, bytes[] memory);

    /**
     * @notice Used to transform bytes memory -> calldata by external call, then calldata slices the error selector away.
     * @param _errorData Error data to decode.
     * @return timestamp Timestamp of the data.
     * @return results Static call results as bytes[]
     */
    function decodeErrorData(
        bytes calldata _errorData
    ) external pure returns (uint256 timestamp, bytes[] memory results);
}

// solhint-disable-next-line no-empty-blocks
interface IKresko is
    IErrorsEvents,
    IDiamondStateFacet,
    IAuthorizationFacet,
    ICommonConfigFacet,
    ICommonStateFacet,
    IAssetConfigFacet,
    IAssetStateFacet,
    ISCDPSwapFacet,
    ISCDPFacet,
    ISCDPConfigFacet,
    ISCDPStateFacet,
    ISDIFacet,
    IMinterBurnFacet,
    ISafetyCouncilFacet,
    IMinterConfigFacet,
    IMinterMintFacet,
    IMinterStateFacet,
    IMinterDepositWithdrawFacet,
    IMinterAccountStateFacet,
    IMinterLiquidationFacet,
    IViewDataFacet,
    IBatchFacet
{

}
