// SPDX-License-Identifier: MIT
// solhint-disable
pragma solidity ^0.8.0;

import {Asset, Enums, Oracle, RoleData, SafetyState, SCDPAccountIndexes, SCDPAssetData, SCDPAssetIndexes, SCDPSeizeData} from "./types/Data.sol";
import {EnumerableSet} from "@oz/utils/structs/EnumerableSet.sol";
import {IERC1155} from "../vendor/IERC1155.sol";

interface IGatingManager {
    function transferOwnership(address) external;

    function phase() external view returns (uint8);

    function qfkNFTs() external view returns (uint256[] memory);

    function kreskian() external view returns (IERC1155);

    function questForKresk() external view returns (IERC1155);

    function isWhiteListed(address) external view returns (bool);

    function whitelist(address, bool _whitelisted) external;

    function setPhase(uint8) external;

    function isEligible(address) external view returns (bool);

    function check(address) external view;
}

struct CommonState {
    /* -------------------------------------------------------------------------- */
    /*                                    Core                                    */
    /* -------------------------------------------------------------------------- */
    /// @notice asset address -> asset data
    mapping(address => Asset) assets;
    /// @notice asset -> oracle type -> oracle
    mapping(bytes32 => mapping(Enums.OracleType => Oracle)) oracles;
    /// @notice asset -> action -> state
    mapping(address => mapping(Enums.Action => SafetyState)) safetyState;
    /// @notice The recipient of protocol fees.
    address feeRecipient;
    /* -------------------------------------------------------------------------- */
    /*                             Oracle & Sequencer                             */
    /* -------------------------------------------------------------------------- */
    /// @notice Pyth endpoint
    address pythEp;
    /// @notice L2 sequencer feed address
    address sequencerUptimeFeed;
    /// @notice grace period of sequencer in seconds
    uint32 sequencerGracePeriodTime;
    /// @notice The max deviation percentage between primary and secondary price.
    uint16 maxPriceDeviationPct;
    /// @notice Offchain oracle decimals
    uint8 oracleDecimals;
    /// @notice Flag tells if there is a need to perform safety checks on user actions
    bool safetyStateSet;
    /* -------------------------------------------------------------------------- */
    /*                                 Reentrancy                                 */
    /* -------------------------------------------------------------------------- */
    uint256 entered;
    /* -------------------------------------------------------------------------- */
    /*                               Access Control                               */
    /* -------------------------------------------------------------------------- */
    mapping(bytes32 role => RoleData data) _roles;
    mapping(bytes32 role => EnumerableSet.AddressSet member) _roleMembers;
}

/* -------------------------------------------------------------------------- */
/*                                   Getter                                   */
/* -------------------------------------------------------------------------- */

// Storage position
bytes32 constant COMMON_STORAGE_POSITION = keccak256("kresko.common.storage");

// Gating
bytes32 constant GATING_MANAGER_POSITION = keccak256("kresko.gating.storage");
struct GatingState {
    IGatingManager manager;
}

function gm() pure returns (GatingState storage state) {
    bytes32 position = GATING_MANAGER_POSITION;
    assembly {
        state.slot := position
    }
}

function cs() pure returns (CommonState storage state) {
    bytes32 position = bytes32(COMMON_STORAGE_POSITION);
    assembly {
        state.slot := position
    }
}

/**
 * @title Storage layout for the minter state
 * @author Kresko
 */
struct MinterState {
    /* -------------------------------------------------------------------------- */
    /*                              Collateral Assets                             */
    /* -------------------------------------------------------------------------- */
    /// @notice Mapping of account -> collateral asset addresses deposited
    mapping(address => address[]) depositedCollateralAssets;
    /// @notice Mapping of account -> asset -> deposit amount
    mapping(address => mapping(address => uint256)) collateralDeposits;
    /* -------------------------------------------------------------------------- */
    /*                                Kresko Assets                               */
    /* -------------------------------------------------------------------------- */
    /// @notice Mapping of account -> krAsset -> debt amount owed to the protocol
    mapping(address => mapping(address => uint256)) kreskoAssetDebt;
    /// @notice Mapping of account -> addresses of borrowed krAssets
    mapping(address => address[]) mintedKreskoAssets;
    /* --------------------------------- Assets --------------------------------- */
    address[] krAssets;
    address[] collaterals;
    /* -------------------------------------------------------------------------- */
    /*                           Configurable Parameters                          */
    /* -------------------------------------------------------------------------- */

    /// @notice The recipient of protocol fees.
    address feeRecipient;
    /// @notice Max liquidation ratio, this is the max collateral ratio liquidations can liquidate to.
    uint32 maxLiquidationRatio;
    /// @notice The minimum ratio of collateral to debt that can be taken by direct action.
    uint32 minCollateralRatio;
    /// @notice The collateralization ratio at which positions may be liquidated.
    uint32 liquidationThreshold;
    /// @notice The minimum USD value of an individual synthetic asset debt position.
    uint256 minDebtValue;
}

/* -------------------------------------------------------------------------- */
/*                                   Getter                                   */
/* -------------------------------------------------------------------------- */

// Storage position
bytes32 constant MINTER_STORAGE_POSITION = keccak256("kresko.minter.storage");

function ms() pure returns (MinterState storage state) {
    bytes32 position = MINTER_STORAGE_POSITION;
    assembly {
        state.slot := position
    }
}

/* -------------------------------------------------------------------------- */
/*                                    State                                   */
/* -------------------------------------------------------------------------- */

/**
 * @title Storage layout for the shared cdp state
 * @author Kresko
 */
struct SCDPState {
    /// @notice Array of assets that are deposit assets and can be swapped
    address[] collaterals;
    /// @notice Array of kresko assets that can be minted and swapped.
    address[] krAssets;
    /// @notice Mapping of asset -> asset -> swap enabled
    mapping(address => mapping(address => bool)) isRoute;
    /// @notice Mapping of asset -> enabled
    mapping(address => bool) isEnabled;
    /// @notice Mapping of asset -> deposit/debt data
    mapping(address => SCDPAssetData) assetData;
    /// @notice Mapping of account -> depositAsset -> deposit amount.
    mapping(address => mapping(address => uint256)) deposits;
    /// @notice Mapping of account -> depositAsset -> principal deposit amount.
    mapping(address => mapping(address => uint256)) depositsPrincipal;
    /// @notice Mapping of depositAsset -> indexes.
    mapping(address => SCDPAssetIndexes) assetIndexes;
    /// @notice Mapping of account -> depositAsset -> indices.
    mapping(address => mapping(address => SCDPAccountIndexes)) accountIndexes;
    /// @notice Mapping of account -> liquidationIndex -> Seize data.
    mapping(address => mapping(uint256 => SCDPSeizeData)) seizeEvents;
    /// @notice The asset to convert fees into
    address feeAsset;
    /// @notice The minimum ratio of collateral to debt that can be taken by direct action.
    uint32 minCollateralRatio;
    /// @notice The collateralization ratio at which positions may be liquidated.
    uint32 liquidationThreshold;
    /// @notice Liquidation Overflow Multiplier, multiplies max liquidatable value.
    uint32 maxLiquidationRatio;
}

struct SDIState {
    uint256 totalDebt;
    uint256 totalCover;
    address coverRecipient;
    /// @notice Threshold after cover can be performed.
    uint48 coverThreshold;
    /// @notice Incentive for covering debt
    uint48 coverIncentive;
    address[] coverAssets;
}

/* -------------------------------------------------------------------------- */
/*                                   Getters                                  */
/* -------------------------------------------------------------------------- */

// Storage position
bytes32 constant SCDP_STORAGE_POSITION = keccak256("kresko.scdp.storage");
bytes32 constant SDI_STORAGE_POSITION = keccak256("kresko.scdp.sdi.storage");

// solhint-disable func-visibility
function scdp() pure returns (SCDPState storage state) {
    bytes32 position = SCDP_STORAGE_POSITION;
    assembly {
        state.slot := position
    }
}

function sdi() pure returns (SDIState storage state) {
    bytes32 position = SDI_STORAGE_POSITION;
    assembly {
        state.slot := position
    }
}
