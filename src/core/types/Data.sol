// SPDX-License-Identifier: MIT
// solhint-disable no-inline-assembly, one-contract-per-file
pragma solidity ^0.8.0;

import {IERC20} from "../../token/IERC20.sol";
import {IAggregatorV3} from "../../vendor/IAggregatorV3.sol";
import {Enums} from "./Const.sol";

// solhint-disable avoid-low-level-calls, var-name-mixedcase

// solhint-disable state-visibility

struct MinterAccountState {
    uint256 totalDebtValue;
    uint256 totalCollateralValue;
    uint256 collateralRatio;
}

/* ========================================================================== */
/*                                   Structs                                  */
/* ========================================================================== */

/// @notice Oracle configuration mapped to `Asset.ticker`.
struct Oracle {
    address feed;
    bytes32 pythId;
    uint256 staleTime;
    bool invertPyth;
}

/**
 * @title Protocol Asset Configuration
 * @author Kresko
 * @notice All assets in the protocol share this configuration.
 * @notice ticker is not unique, eg. krETH and WETH both would use bytes32('ETH')
 * @dev Percentages use 2 decimals: 1e4 (10000) == 100.00%. See {PercentageMath.sol}.
 * @dev Note that the percentage value for uint16 caps at 655.36%.
 */
struct Asset {
    /// @notice Reference asset ticker (matching what Redstone uses, eg. bytes32('ETH')).
    /// @notice NOT unique per asset.
    bytes32 ticker;
    /// @notice Kresko Asset Anchor address.
    address anchor;
    /// @notice Oracle provider priority for this asset.
    /// @notice Provider at index 0 is the primary price source.
    /// @notice Provider at index 1 is the reference price for deviation check and also the fallback price.
    Enums.OracleType[2] oracles;
    /// @notice Percentage multiplier which decreases collateral asset valuation (if < 100%), mitigating price risk.
    /// @notice Always <= 100% or 1e4.
    uint16 factor;
    /// @notice Percentage multiplier which increases debt asset valution (if > 100%), mitigating price risk.
    /// @notice Always >= 100% or 1e4.
    uint16 kFactor;
    /// @notice Minter fee percent for opening a debt position.
    /// @notice Fee is deducted from collaterals.
    uint16 openFee;
    /// @notice Minter fee percent for closing a debt position.
    /// @notice Fee is deducted from collaterals.
    uint16 closeFee;
    /// @notice Minter liquidation incentive when asset is the seized collateral in a liquidation.
    uint16 liqIncentive;
    /// @notice Supply limit for Kresko Assets.
    uint256 maxDebtMinter;
    /// @notice Supply limit for Kresko Assets mints in SCDP.
    uint256 maxDebtSCDP;
    /// @notice SCDP deposit limit for the asset.
    uint256 depositLimitSCDP;
    /// @notice SCDP fee percent when swapped as "asset in".
    uint16 swapInFeeSCDP;
    /// @notice SCDP fee percent when swapped as "asset out".
    uint16 swapOutFeeSCDP;
    /// @notice SCDP protocol cut of the swap fees. Cap 50% == a.feeShare + b.feeShare <= 100%.
    uint16 protocolFeeShareSCDP;
    /// @notice SCDP liquidation incentive, defined for Kresko Assets.
    /// @notice Applied as discount for seized collateral when the KrAsset is repaid in a liquidation.
    uint16 liqIncentiveSCDP;
    /// @notice ERC20 decimals of the asset, queried and saved once during setup.
    /// @notice Kresko Assets have 18 decimals.
    uint8 decimals;
    /// @notice Asset can be deposited as collateral in the Minter.
    bool isMinterCollateral;
    /// @notice Asset can be minted as debt from the Minter.
    bool isMinterMintable;
    /// @notice Asset can be deposited by users as collateral in the SCDP.
    bool isSharedCollateral;
    /// @notice Asset can be minted through swaps in the SCDP.
    bool isSwapMintable;
    /// @notice Asset is included in the total collateral value calculation for the SCDP.
    /// @notice KrAssets will be true by default - since they are indirectly deposited through swaps.
    bool isSharedOrSwappedCollateral;
    /// @notice Asset can be used to cover SCDP debt.
    bool isCoverAsset;
}

/// @notice The access control role data.
struct RoleData {
    mapping(address => bool) members;
    bytes32 adminRole;
}

/// @notice Variables used for calculating the max liquidation value.
struct MaxLiqVars {
    Asset collateral;
    uint256 accountCollateralValue;
    uint256 minCollateralValue;
    uint256 seizeCollateralAccountValue;
    uint192 minDebtValue;
    uint32 gainFactor;
    uint32 maxLiquidationRatio;
    uint32 debtFactor;
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

/// @notice Convenience struct for checking configurations
struct RawPrice {
    int256 answer;
    uint256 timestamp;
    uint256 staleTime;
    bool isStale;
    bool isZero;
    Enums.OracleType oracle;
    address feed;
}

/// @notice Configuration for pausing `Action`
struct Pause {
    bool enabled;
    uint256 timestamp0;
    uint256 timestamp1;
}

/// @notice Safety configuration for assets
struct SafetyState {
    Pause pause;
}

/**
 * @notice Asset struct for deposit assets in contract
 * @param token The ERC20 token
 * @param feed IAggregatorV3 feed for the asset
 * @param staleTime Time in seconds for the feed to be considered stale
 * @param maxDeposits Max deposits allowed for the asset
 * @param depositFee Deposit fee of the asset
 * @param withdrawFee Withdraw fee of the asset
 * @param enabled Enabled status of the asset
 */
struct VaultAsset {
    IERC20 token;
    IAggregatorV3 feed;
    uint24 staleTime;
    uint8 decimals;
    uint32 depositFee;
    uint32 withdrawFee;
    uint248 maxDeposits;
    bool enabled;
}

struct SCDPAssetData {
    uint256 debt;
    uint128 totalDeposits;
    uint128 swapDeposits;
}

/**
 * @notice SCDP initializer configuration.
 * @param feeAsset Asset that all fees from swaps are collected in.
 * @param minCollateralRatio The minimum collateralization ratio.
 * @param liquidationThreshold The liquidation threshold.
 * @param maxLiquidationRatio The maximum CR resulting from liquidations.
 * @param coverThreshold Threshold after which cover can be performed.
 * @param coverIncentive Incentive for covering debt instead of performing a liquidation.
 */
struct SCDPParameters {
    address feeAsset;
    uint32 minCollateralRatio;
    uint32 liquidationThreshold;
    uint32 maxLiquidationRatio;
    uint128 coverThreshold;
    uint128 coverIncentive;
}

/**
 * @notice SCDP asset fee and liquidation index data
 * @param currFeeIndex The ever increasing fee index, used to calculate fees.
 * @param currLiqIndex The ever increasing liquidation index, used to calculate liquidated amounts from principal.
 */
struct SCDPAssetIndexes {
    uint128 currFeeIndex;
    uint128 currLiqIndex;
}

/**
 * @notice SCDP seize data
 * @param prevLiqIndex Link to previous value in the liquidation index history.
 * @param feeIndex The fee index at the time of the seize.
 * @param liqIndex The liquidation index after the seize.
 */
struct SCDPSeizeData {
    uint256 prevLiqIndex;
    uint128 feeIndex;
    uint128 liqIndex;
}

/**
 * @notice SCDP account indexes
 * @param lastFeeIndex Fee index at the time of the action.
 * @param lastLiqIndex Liquidation index at the time of the action.
 * @param timestamp Timestamp of the last update.
 */
struct SCDPAccountIndexes {
    uint128 lastFeeIndex;
    uint128 lastLiqIndex;
    uint256 timestamp;
}
