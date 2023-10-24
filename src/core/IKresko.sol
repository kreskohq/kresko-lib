// solhint-disable
// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;
import {IERC20} from "../token/IERC20.sol";
import {IERC20Permit} from "../token/IERC20Permit.sol";

// OpenZeppelin Contracts (last updated v5.0.0) (access/extensions/IAccessControlEnumerable.sol)

// OpenZeppelin Contracts (last updated v5.0.0) (access/IAccessControl.sol)

/**
 * @dev External interface of AccessControl declared to support ERC165 detection.
 */
interface IAccessControl {
    /**
     * @dev The `account` is missing a role.
     */
    error AccessControlUnauthorizedAccount(address account, bytes32 neededRole);

    /**
     * @dev The caller of a function is not the expected one.
     *
     * NOTE: Don't confuse with {AccessControlUnauthorizedAccount}.
     */
    error AccessControlBadConfirmation();

    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     */
    event RoleAdminChanged(
        bytes32 indexed role,
        bytes32 indexed previousAdminRole,
        bytes32 indexed newAdminRole
    );

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {AccessControl-_setupRole}.
     */
    event RoleGranted(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );

    /**
     * @dev Returns `true` if `account` has been granted `role`.
     */
    function hasRole(
        bytes32 role,
        address account
    ) external view returns (bool);

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {AccessControl-_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) external view returns (bytes32);

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
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) external;

    /**
     * @dev Revokes `role` from the calling account.
     *
     * Roles are often managed via {grantRole} and {revokeRole}: this function's
     * purpose is to provide a mechanism for accounts to lose their privileges
     * if they are compromised (such as when a trusted device is misplaced).
     *
     * If the calling account had been granted `role`, emits a {RoleRevoked}
     * event.
     *
     * Requirements:
     *
     * - the caller must be `callerConfirmation`.
     */
    function renounceRole(bytes32 role, address callerConfirmation) external;
}

/**
 * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
 */
interface IAccessControlEnumerable is IAccessControl {
    /**
     * @dev Returns one of the accounts that have `role`. `index` must be a
     * value between 0 and {getRoleMemberCount}, non-inclusive.
     *
     * Role bearers are not sorted in any particular way, and their ordering may
     * change at any point.
     *
     * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
     * you perform all queries on the same block. See the following
     * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
     * for more information.
     */
    function getRoleMember(
        bytes32 role,
        uint256 index
    ) external view returns (address);

    /**
     * @dev Returns the number of accounts that have `role`. Can be used
     * together with {getRoleMember} to enumerate all bearers of a role.
     */
    function getRoleMemberCount(bytes32 role) external view returns (uint256);
}

interface IERC165 {
    /// @notice Query if a contract implements an interface
    /// @param interfaceId The interface identifier, as specified in ERC-165
    /// @dev Interface identification is specified in ERC-165. This function
    ///  uses less than 30,000 gas.
    /// @return `true` if the contract implements `interfaceID` and
    ///  `interfaceID` is not 0xffffffff, `false` otherwise
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/* solhint-disable func-name-mixedcase */

/// @title KreskoAsset issuer interface
/// @author Kresko
/// @notice Contract that allows minting and burning through Kresko.
/// @dev All mintable assets in Kresko must implement this. (enforced through introspection)
interface IKreskoAssetIssuer {
    /**
     * @notice Mints @param _assets of krAssets for @param _to,
     * @notice Mints relative @return _shares of anchor tokens.
     */
    function issue(
        uint256 _assets,
        address _to
    ) external returns (uint256 shares);

    /**
     * @notice Burns @param _assets of krAssets from @param _from,
     * @notice Burns relative @return _shares of anchor tokens.
     */
    function destroy(
        uint256 _assets,
        address _from
    ) external returns (uint256 shares);

    /**
     * @notice Preview conversion from KrAsset amount: @param assets to matching amount of Anchor tokens: @return shares
     */
    function convertToShares(
        uint256 assets
    ) external view returns (uint256 shares);

    /**
     * @notice Preview conversion from Anchor token amount: @param shares to matching KrAsset amount: @return assets
     */
    function convertToAssets(
        uint256 shares
    ) external view returns (uint256 assets);

    /**
     * @notice Preview conversion from Anchor token amounts: @param shares to matching amounts of KrAssets: @return assets
     */
    function convertManyToAssets(
        uint256[] calldata shares
    ) external view returns (uint256[] memory assets);

    /**
     * @notice Preview conversion from KrAsset amounts: @param assets to matching amounts of Anchor tokens: @return shares
     */
    function convertManyToShares(
        uint256[] calldata assets
    ) external view returns (uint256[] memory shares);
}

interface ISyncable {
    function sync() external;
}

interface IKreskoAsset is IERC20Permit, IAccessControlEnumerable, IERC165 {
    /**
     * @notice Rebase information
     * @param positive supply increasing/reducing rebase
     * @param denominator the denominator for the operator, 1 ether = 1
     */
    struct Rebase {
        uint248 denominator;
        bool positive;
    }

    /**
     * @notice Wrapping information for the Kresko Asset
     * @param underlying If available, this is the corresponding on-chain underlying token.
     * @param underlyingDecimals Decimals of the underlying token.
     * @param openFee Possible fee when wrapping from underlying to KrAsset.
     * @param closeFee Possible fee when wrapping from KrAsset to underlying.
     * @param nativeUnderlyingEnabled Whether native underlying can be sent used for wrapping.
     * @param feeRecipient Fee recipient.
     */
    struct Wrapping {
        address underlying;
        uint8 underlyingDecimals;
        uint48 openFee;
        uint40 closeFee;
        bool nativeUnderlyingEnabled;
        address payable feeRecipient;
    }

    /**
     * @notice Initializes a KreskoAsset ERC20 token.
     * @dev Intended to be operated by the Kresko smart contract.
     * @param _name The name of the KreskoAsset.
     * @param _symbol The symbol of the KreskoAsset.
     * @param _decimals Decimals for the asset.
     * @param _admin The adminstrator of this contract.
     * @param _kresko The protocol, can perform mint and burn.
     * @param _underlyingAddr The underlying token if available.
     * @param _feeRecipient Fee recipient for synth wraps.
     * @param _openFee Synth warp open fee.
     * @param _closeFee Synth wrap close fee.
     */
    function initialize(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        address _admin,
        address _kresko,
        address _underlyingAddr,
        address _feeRecipient,
        uint48 _openFee,
        uint40 _closeFee
    ) external;

    function kresko() external view returns (address);

    function rebaseInfo() external view returns (Rebase memory);

    function wrappingInfo() external view returns (Wrapping memory);

    function isRebased() external view returns (bool);

    /**
     * @notice Perform a rebase, changing the denumerator and its operator
     * @param _denominator the denumerator for the operator, 1 ether = 1
     * @param _positive supply increasing/reducing rebase
     * @param _pools UniswapV2Pair address to sync so we wont get rekt by skim() calls.
     * @dev denumerator values 0 and 1 ether will disable the rebase
     */
    function rebase(
        uint248 _denominator,
        bool _positive,
        address[] calldata _pools
    ) external;

    /**
     * @notice Updates ERC20 metadata for the token in case eg. a ticker change
     * @param _name new name for the asset
     * @param _symbol new symbol for the asset
     * @param _version number that must be greater than latest emitted `Initialized` version
     */
    function reinitializeERC20(
        string memory _name,
        string memory _symbol,
        uint8 _version
    ) external;

    /**
     * @notice Mints tokens to an address.
     * @dev Only callable by operator.
     * @dev Internal balances are always unrebased, events emitted are not.
     * @param _to The address to mint tokens to.
     * @param _amount The amount of tokens to mint.
     */
    function mint(address _to, uint256 _amount) external;

    /**
     * @notice Burns tokens from an address.
     * @dev Only callable by operator.
     * @dev Internal balances are always unrebased, events emitted are not.
     * @param _from The address to burn tokens from.
     * @param _amount The amount of tokens to burn.
     */
    function burn(address _from, uint256 _amount) external;

    /**
     * @notice Triggers stopped state.
     *
     * Requirements:
     *
     * - The contract must not be paused.
     */
    function pause() external;

    /**
     * @notice  Returns to normal state.
     *
     * Requirements:
     *
     * - The contract must be paused.
     */
    function unpause() external;

    /**
     * @notice Deposit underlying tokens to receive equal value of krAsset (-fee).
     * @param _to The to address.
     * @param _amount The amount (uint256).
     */
    function wrap(address _to, uint256 _amount) external;

    /**
     * @notice Withdraw kreskoAsset to receive underlying tokens / native (-fee).
     * @param _amount The amount (uint256).
     * @param _receiveNative bool whether to receive underlying as native
     */
    function unwrap(uint256 _amount, bool _receiveNative) external;

    /**
     * @notice Sets anchor token address
     * @dev Has modifiers: onlyRole.
     * @param _anchor The anchor address.
     */
    function setAnchorToken(address _anchor) external;

    /**
     * @notice Enables depositing native token ETH in case of krETH
     * @dev Has modifiers: onlyRole.
     * @param _enabled The enabled (bool).
     */
    function enableNativeUnderlying(bool _enabled) external;

    /**
     * @notice Sets fee recipient address
     * @dev Has modifiers: onlyRole.
     * @param _feeRecipient The fee recipient address.
     */
    function setFeeRecipient(address _feeRecipient) external;

    /**
     * @notice Sets deposit fee
     * @dev Has modifiers: onlyRole.
     * @param _openFee The open fee (uint48).
     */
    function setOpenFee(uint48 _openFee) external;

    /**
     * @notice Sets withdraw fee
     * @dev Has modifiers: onlyRole.
     * @param _closeFee The open fee (uint48).
     */
    function setCloseFee(uint40 _closeFee) external;

    /**
     * @notice Sets underlying token address (and its decimals)
     * @notice Zero address will disable functionality provided for the underlying.
     * @dev Has modifiers: onlyRole.
     * @param _underlyingAddr The underlying address.
     */
    function setUnderlying(address _underlyingAddr) external;
}

interface IERC4626Upgradeable {
    /**
     * @notice The underlying Kresko Asset
     */
    function asset() external view returns (IKreskoAsset);

    /**
     * @notice Deposit KreskoAssets for equivalent amount of anchor tokens
     * @param assets Amount of KreskoAssets to deposit
     * @param receiver Address to send shares to
     * @return shares Amount of shares minted
     */
    function deposit(
        uint256 assets,
        address receiver
    ) external returns (uint256 shares);

    /**
     * @notice Withdraw KreskoAssets for equivalent amount of anchor tokens
     * @param assets Amount of KreskoAssets to withdraw
     * @param receiver Address to send KreskoAssets to
     * @param owner Address to burn shares from
     * @return shares Amount of shares burned
     * @dev shares are burned from owner, not msg.sender
     */
    function withdraw(
        uint256 assets,
        address receiver,
        address owner
    ) external returns (uint256 shares);

    function maxDeposit(address) external view returns (uint256);

    function maxMint(address) external view returns (uint256 assets);

    function maxRedeem(address owner) external view returns (uint256 assets);

    function maxWithdraw(address owner) external view returns (uint256 assets);

    /**
     * @notice Mint shares of anchor tokens for equivalent amount of KreskoAssets
     * @param shares Amount of shares to mint
     * @param receiver Address to send shares to
     * @return assets Amount of KreskoAssets redeemed
     */
    function mint(
        uint256 shares,
        address receiver
    ) external returns (uint256 assets);

    function previewDeposit(
        uint256 assets
    ) external view returns (uint256 shares);

    function previewMint(uint256 shares) external view returns (uint256 assets);

    function previewRedeem(
        uint256 shares
    ) external view returns (uint256 assets);

    function previewWithdraw(
        uint256 assets
    ) external view returns (uint256 shares);

    /**
     * @notice Track the underlying amount
     * @return Total supply for the underlying
     */
    function totalAssets() external view returns (uint256);

    /**
     * @notice Redeem shares of anchor for KreskoAssets
     * @param shares Amount of shares to redeem
     * @param receiver Address to send KreskoAssets to
     * @param owner Address to burn shares from
     * @return assets Amount of KreskoAssets redeemed
     */
    function redeem(
        uint256 shares,
        address receiver,
        address owner
    ) external returns (uint256 assets);
}

interface IKreskoAssetAnchor is
    IKreskoAssetIssuer,
    IERC4626Upgradeable,
    IERC20Permit,
    IAccessControlEnumerable,
    IERC165
{
    function totalAssets()
        external
        view
        override(IERC4626Upgradeable)
        returns (uint256);

    /**
     * @notice Initializes the Kresko Asset Anchor.
     *
     * @param _asset The underlying (Kresko) Asset
     * @param _name Name of the anchor token
     * @param _symbol Symbol of the anchor token
     * @param _admin The adminstrator of this contract.
     * @dev Decimals are not supplied as they are read from the underlying Kresko Asset
     */
    function initialize(
        IKreskoAsset _asset,
        string memory _name,
        string memory _symbol,
        address _admin
    ) external;

    /**
     * @notice Updates ERC20 metadata for the token in case eg. a ticker change
     * @param _name new name for the asset
     * @param _symbol new symbol for the asset
     * @param _version number that must be greater than latest emitted `Initialized` version
     */
    function reinitializeERC20(
        string memory _name,
        string memory _symbol,
        uint8 _version
    ) external;

    /**
     * @notice Mint Kresko Anchor Asset to Kresko Asset (Only KreskoAsset can call)
     * @param assets The assets (uint256).
     */
    function wrap(uint256 assets) external;

    /**
     * @notice Burn Kresko Anchor Asset to Kresko Asset (Only KreskoAsset can call)
     * @param assets The assets (uint256).
     */
    function unwrap(uint256 assets) external;
}

/**
 * @title WadRayMath library
 * @author Aave
 * @notice Provides functions to perform calculations with Wad and Ray units
 * @dev Provides mul and div function for wads (decimal numbers with 18 digits of precision) and rays (decimal numbers
 * with 27 digits of precision)
 * @dev Operations are rounded. If a value is >=.5, will be rounded up, otherwise rounded down.
 **/
library WadRay {
    // HALF_WAD and HALF_RAY expressed with extended notation
    // as constant with operations are not supported in Yul assembly
    uint256 internal constant WAD = 1e18;
    uint256 internal constant HALF_WAD = 0.5e18;

    uint256 internal constant RAY = 1e27;
    uint256 internal constant HALF_RAY = 0.5e27;

    uint256 internal constant WAD_RAY_RATIO = 1e9;

    /**
     * @dev Multiplies two wad, rounding half up to the nearest wad
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Wad
     * @param b Wad
     * @return c = a*b, in wad
     **/
    function wadMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // to avoid overflow, a <= (type(uint256).max - HALF_WAD) / b
        assembly {
            if iszero(
                or(iszero(b), iszero(gt(a, div(sub(not(0), HALF_WAD), b))))
            ) {
                revert(0, 0)
            }

            c := div(add(mul(a, b), HALF_WAD), WAD)
        }
    }

    /**
     * @dev Divides two wad, rounding half up to the nearest wad
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Wad
     * @param b Wad
     * @return c = a/b, in wad
     **/
    function wadDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // to avoid overflow, a <= (type(uint256).max - halfB) / WAD
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

    /**
     * @notice Multiplies two ray, rounding half up to the nearest ray
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Ray
     * @param b Ray
     * @return c = a raymul b
     **/
    function rayMul(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // to avoid overflow, a <= (type(uint256).max - HALF_RAY) / b
        assembly {
            if iszero(
                or(iszero(b), iszero(gt(a, div(sub(not(0), HALF_RAY), b))))
            ) {
                revert(0, 0)
            }

            c := div(add(mul(a, b), HALF_RAY), RAY)
        }
    }

    /**
     * @notice Divides two ray, rounding half up to the nearest ray
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Ray
     * @param b Ray
     * @return c = a raydiv b
     **/
    function rayDiv(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // to avoid overflow, a <= (type(uint256).max - halfB) / RAY
        assembly {
            if or(
                iszero(b),
                iszero(iszero(gt(a, div(sub(not(0), div(b, 2)), RAY))))
            ) {
                revert(0, 0)
            }

            c := div(add(mul(a, RAY), div(b, 2)), b)
        }
    }

    /**
     * @dev Casts ray down to wad
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Ray
     * @return b = a converted to wad, rounded half up to the nearest wad
     **/
    function rayToWad(uint256 a) internal pure returns (uint256 b) {
        assembly {
            b := div(a, WAD_RAY_RATIO)
            let remainder := mod(a, WAD_RAY_RATIO)
            if iszero(lt(remainder, div(WAD_RAY_RATIO, 2))) {
                b := add(b, 1)
            }
        }
    }

    /**
     * @dev Converts wad up to ray
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Wad
     * @return b = a converted in ray
     **/
    function wadToRay(uint256 a) internal pure returns (uint256 b) {
        // to avoid overflow, b/WAD_RAY_RATIO == a
        assembly {
            b := mul(a, WAD_RAY_RATIO)

            if iszero(eq(div(b, WAD_RAY_RATIO), a)) {
                revert(0, 0)
            }
        }
    }
}

interface IErrorFieldProvider {
    function symbol() external view returns (string memory);
}

/* solhint-disable max-line-length */
library Errors {
    struct ID {
        string symbol;
        address addr;
    }

    function id(address _addr) internal view returns (ID memory) {
        if (_addr.code.length > 0)
            return ID(IErrorFieldProvider(_addr).symbol(), _addr);
        return ID("", _addr); // not a token
    }

    function symbol(
        address _addr
    ) internal view returns (string memory symbol_) {
        if (_addr.code.length > 0) return IErrorFieldProvider(_addr).symbol();
    }

    error ADDRESS_HAS_NO_CODE(address);
    error NOT_INITIALIZING();
    error COMMON_ALREADY_INITIALIZED();
    error MINTER_ALREADY_INITIALIZED();
    error SCDP_ALREADY_INITIALIZED();
    error STRING_HEX_LENGTH_INSUFFICIENT();
    error SAFETY_COUNCIL_NOT_ALLOWED();
    error SAFETY_COUNCIL_SETTER_IS_NOT_ITS_OWNER(address);
    error SAFETY_COUNCIL_ALREADY_EXISTS(address given, address existing);
    error MULTISIG_NOT_ENOUGH_OWNERS(address, uint256 owners, uint256 required);
    error ACCESS_CONTROL_NOT_SELF(address who, address self);
    error MARKET_CLOSED(ID, string);
    error SCDP_ASSET_ECONOMY(
        ID,
        uint256 seizeReductionPct,
        ID,
        uint256 repayIncreasePct
    );
    error MINTER_ASSET_ECONOMY(
        ID,
        uint256 seizeReductionPct,
        ID,
        uint256 repayIncreasePct
    );
    error INVALID_TICKER(ID, string ticker);
    error ASSET_NOT_ENABLED(ID);
    error ASSET_CANNOT_BE_USED_TO_COVER(ID);
    error ASSET_PAUSED_FOR_THIS_ACTION(ID, uint8 action);
    error ASSET_NOT_MINTER_COLLATERAL(ID);
    error ASSET_NOT_MINTABLE_FROM_MINTER(ID);
    error ASSET_NOT_SWAPPABLE(ID);
    error ASSET_DOES_NOT_HAVE_DEPOSITS(ID);
    error ASSET_NOT_DEPOSITABLE(ID);
    error ASSET_ALREADY_ENABLED(ID);
    error ASSET_ALREADY_DISABLED(ID);
    error ASSET_DOES_NOT_EXIST(ID);
    error ASSET_ALREADY_EXISTS(ID);
    error ASSET_IS_VOID(ID);
    error INVALID_ASSET(ID);
    error CANNOT_REMOVE_COLLATERAL_THAT_HAS_USER_DEPOSITS(ID);
    error CANNOT_REMOVE_SWAPPABLE_ASSET_THAT_HAS_DEBT(ID);
    error INVALID_CONTRACT_KRASSET(ID krAsset);
    error INVALID_CONTRACT_KRASSET_ANCHOR(ID anchor, ID krAsset);
    error NOT_SWAPPABLE_KRASSET(ID);
    error IDENTICAL_ASSETS(ID);
    error WITHDRAW_NOT_SUPPORTED();
    error DEPOSIT_NOT_SUPPORTED();
    error REDEEM_NOT_SUPPORTED();
    error NATIVE_TOKEN_DISABLED(ID);
    error EXCEEDS_ASSET_DEPOSIT_LIMIT(ID, uint256 deposits, uint256 limit);
    error EXCEEDS_ASSET_MINTING_LIMIT(ID, uint256 deposits, uint256 limit);
    error UINT128_OVERFLOW(ID, uint256 deposits, uint256 limit);
    error INVALID_SENDER(address, address);
    error INVALID_MIN_DEBT(uint256 invalid, uint256 valid);
    error INVALID_SCDP_FEE(ID, uint256 invalid, uint256 valid);
    error INVALID_MCR(uint256 invalid, uint256 valid);
    error MLR_CANNOT_BE_LESS_THAN_LIQ_THRESHOLD(uint256 mlt, uint256 lt);
    error INVALID_LIQ_THRESHOLD(uint256 lt, uint256 min, uint256 max);
    error INVALID_PROTOCOL_FEE(ID, uint256 invalid, uint256 valid);
    error INVALID_ASSET_FEE(ID, uint256 invalid, uint256 valid);
    error INVALID_ORACLE_DEVIATION(uint256 invalid, uint256 valid);
    error INVALID_ORACLE_TYPE(uint8 invalid);
    error INVALID_FEE_RECIPIENT(address invalid);
    error INVALID_LIQ_INCENTIVE(ID, uint256 invalid, uint256 min, uint256 max);
    error INVALID_KFACTOR(ID, uint256 invalid, uint256 valid);
    error INVALID_CFACTOR(ID, uint256 invalid, uint256 valid);
    error INVALID_MINTER_FEE(ID, uint256 invalid, uint256 valid);
    error INVALID_PRICE_PRECISION(uint256 decimals, uint256 valid);
    error INVALID_DECIMALS(ID, uint256 decimals);
    error INVALID_FEE(ID, uint256 invalid, uint256 valid);
    error INVALID_FEE_TYPE(uint8 invalid, uint8 valid);
    error INVALID_VAULT_PRICE(string ticker, address);
    error INVALID_API3_PRICE(string ticker, address);
    error INVALID_CL_PRICE(string ticker, address);
    error INVALID_PRICE(ID, address oracle, int256 price);
    error INVALID_KRASSET_OPERATOR(
        ID,
        address invalidOperator,
        address validOperator
    );
    error INVALID_DENOMINATOR(ID, uint256 denominator, uint256 valid);
    error INVALID_OPERATOR(ID, address who, address valid);
    error INVALID_SUPPLY_LIMIT(ID, uint256 invalid, uint256 valid);
    error NEGATIVE_PRICE(address asset, int256 price);
    error STALE_PRICE(
        string ticker,
        uint256 price,
        uint256 timeFromUpdate,
        uint256 threshold
    );
    error RAW_PRICE_STALE(
        ID asset,
        string ticker,
        int256 price,
        uint8 oracleType,
        address feed,
        uint256 timeFromUpdate,
        uint256 threshold
    );
    error PRICE_UNSTABLE(
        uint256 primaryPrice,
        uint256 referencePrice,
        uint256 deviationPct
    );
    error ZERO_OR_STALE_VAULT_PRICE(ID, address, uint256);
    error ZERO_OR_STALE_PRICE(string ticker, uint8[2] oracles);
    error RAW_PRICE_LTE_ZERO(
        ID asset,
        string ticker,
        int256 price,
        uint8 oracleType,
        address feed
    );
    error NO_PUSH_ORACLE_SET(string ticker);
    error NOT_SUPPORTED_YET();
    error WRAP_NOT_SUPPORTED();
    error BURN_AMOUNT_OVERFLOW(ID, uint256 burnAmount, uint256 debtAmount);
    error PAUSED(address who);
    error L2_SEQUENCER_DOWN();
    error FEED_ZERO_ADDRESS(string ticker);
    error INVALID_SEQUENCER_UPTIME_FEED(address);
    error NO_MINTED_ASSETS(address who);
    error NO_COLLATERALS_DEPOSITED(address who);
    error MISSING_PHASE_3_NFT();
    error MISSING_PHASE_2_NFT();
    error MISSING_PHASE_1_NFT();
    error CANNOT_RE_ENTER();
    error ARRAY_LENGTH_MISMATCH(string ticker, uint256 arr1, uint256 arr2);
    error COLLATERAL_VALUE_GREATER_THAN_REQUIRED(
        uint256 collateralValue,
        uint256 minCollateralValue,
        uint32 ratio
    );
    error ACCOUNT_COLLATERAL_VALUE_LESS_THAN_REQUIRED(
        address who,
        uint256 collateralValue,
        uint256 minCollateralValue,
        uint32 ratio
    );
    error COLLATERAL_VALUE_LESS_THAN_REQUIRED(
        uint256 collateralValue,
        uint256 minCollateralValue,
        uint32 ratio
    );
    error CANNOT_LIQUIDATE_HEALTHY_ACCOUNT(
        address who,
        uint256 collateralValue,
        uint256 minCollateralValue,
        uint32 ratio
    );
    error CANNOT_LIQUIDATE_SELF();
    error LIQUIDATION_AMOUNT_GREATER_THAN_DEBT(
        ID repayAsset,
        uint256 repayAmount,
        uint256 availableAmount
    );
    error LIQUIDATION_SEIZED_LESS_THAN_EXPECTED(ID, uint256, uint256);
    error LIQUIDATION_VALUE_IS_ZERO(ID repayAsset, ID seizeAsset);
    error NOTHING_TO_WITHDRAW(
        address who,
        ID,
        uint256 requested,
        uint256 principal,
        uint256 scaled
    );
    error ACCOUNT_KRASSET_NOT_FOUND(
        address account,
        ID,
        address[] accountCollaterals
    );
    error ACCOUNT_COLLATERAL_NOT_FOUND(
        address account,
        ID,
        address[] accountCollaterals
    );
    error ELEMENT_DOES_NOT_MATCH_PROVIDED_INDEX(
        ID element,
        uint256 index,
        address[] elements
    );
    error REPAY_OVERFLOW(
        ID repayAsset,
        ID seizeAsset,
        uint256 invalid,
        uint256 valid
    );
    error INCOME_AMOUNT_IS_ZERO(ID incomeAsset);
    error NO_LIQUIDITY_TO_GIVE_INCOME_FOR(
        ID incomeAsset,
        uint256 userDeposits,
        uint256 totalDeposits
    );
    error NOT_ENOUGH_SWAP_DEPOSITS_TO_SEIZE(
        ID repayAsset,
        ID seizeAsset,
        uint256 invalid,
        uint256 valid
    );
    error SWAP_ROUTE_NOT_ENABLED(ID assetIn, ID assetOut);
    error RECEIVED_LESS_THAN_DESIRED(ID, uint256 invalid, uint256 valid);
    error SWAP_ZERO_AMOUNT_IN(ID tokenIn);
    error INVALID_WITHDRAW(
        ID withdrawAsset,
        uint256 sharesIn,
        uint256 assetsOut
    );
    error ROUNDING_ERROR(ID asset, uint256 sharesIn, uint256 assetsOut);
    error MAX_DEPOSIT_EXCEEDED(ID asset, uint256 assetsIn, uint256 maxDeposit);
    error COLLATERAL_AMOUNT_LOW(
        ID krAssetCollateral,
        uint256 amount,
        uint256 minAmount
    );
    error MINT_VALUE_LESS_THAN_MIN_DEBT_VALUE(
        ID,
        uint256 value,
        uint256 minRequiredValue
    );
    error NOT_A_CONTRACT(address who);
    error NO_ALLOWANCE(
        address spender,
        address owner,
        uint256 requested,
        uint256 allowed
    );
    error NOT_ENOUGH_BALANCE(address who, uint256 requested, uint256 available);
    error SENDER_NOT_OPERATOR(ID, address sender, address kresko);
    error ZERO_SHARES_FROM_ASSETS(ID, uint256 assets, ID);
    error ZERO_SHARES_OUT(ID, uint256 assets);
    error ZERO_SHARES_IN(ID, uint256 assets);
    error ZERO_ASSETS_FROM_SHARES(ID, uint256 shares, ID);
    error ZERO_ASSETS_OUT(ID, uint256 shares);
    error ZERO_ASSETS_IN(ID, uint256 shares);
    error ZERO_ADDRESS();
    error ZERO_DEPOSIT(ID);
    error ZERO_AMOUNT(ID);
    error ZERO_WITHDRAW(ID);
    error ZERO_MINT(ID);
    error ZERO_REPAY(ID, uint256 repayAmount, uint256 seizeAmount);
    error ZERO_BURN(ID);
    error ZERO_DEBT(ID);
}

library NumericArrayLib {
    // This function sort array in memory using bubble sort algorithm,
    // which performs even better than quick sort for small arrays

    uint256 internal constant BYTES_ARR_LEN_VAR_BS = 32;
    uint256 internal constant UINT256_VALUE_BS = 32;

    error CanNotPickMedianOfEmptyArray();

    // This function modifies the array
    function pickMedian(uint256[] memory arr) internal pure returns (uint256) {
        if (arr.length == 0) {
            revert CanNotPickMedianOfEmptyArray();
        }
        sort(arr);
        uint256 middleIndex = arr.length / 2;
        if (arr.length % 2 == 0) {
            uint256 sum = arr[middleIndex - 1] + arr[middleIndex];
            return sum / 2;
        } else {
            return arr[middleIndex];
        }
    }

    function sort(uint256[] memory arr) internal pure {
        assembly {
            let arrLength := mload(arr)
            let valuesPtr := add(arr, BYTES_ARR_LEN_VAR_BS)
            let endPtr := add(valuesPtr, mul(arrLength, UINT256_VALUE_BS))
            for {
                let arrIPtr := valuesPtr
            } lt(arrIPtr, endPtr) {
                arrIPtr := add(arrIPtr, UINT256_VALUE_BS) // arrIPtr += 32
            } {
                for {
                    let arrJPtr := valuesPtr
                } lt(arrJPtr, arrIPtr) {
                    arrJPtr := add(arrJPtr, UINT256_VALUE_BS) // arrJPtr += 32
                } {
                    let arrI := mload(arrIPtr)
                    let arrJ := mload(arrJPtr)
                    if lt(arrI, arrJ) {
                        mstore(arrIPtr, arrJ)
                        mstore(arrJPtr, arrI)
                    }
                }
            }
        }
    }
}

/**
 * @title Default implementations of virtual redstone consumer base functions
 * @author The Redstone Oracles team
 */
library RedstoneDefaultsLib {
    uint256 internal constant DEFAULT_MAX_DATA_TIMESTAMP_DELAY_SECONDS =
        3 minutes;
    uint256 internal constant DEFAULT_MAX_DATA_TIMESTAMP_AHEAD_SECONDS =
        1 minutes;

    error TimestampFromTooLongFuture(
        uint256 receivedTimestampSeconds,
        uint256 blockTimestamp
    );
    error TimestampIsTooOld(
        uint256 receivedTimestampSeconds,
        uint256 blockTimestamp
    );

    function validateTimestamp(
        uint256 receivedTimestampMilliseconds
    ) internal view {
        // Getting data timestamp from future seems quite unlikely
        // But we've already spent too much time with different cases
        // Where block.timestamp was less than dataPackage.timestamp.
        // Some blockchains may case this problem as well.
        // That's why we add MAX_BLOCK_TIMESTAMP_DELAY
        // and allow data "from future" but with a small delay
        uint256 receivedTimestampSeconds = receivedTimestampMilliseconds / 1000;

        if (block.timestamp < receivedTimestampSeconds) {
            if (
                (receivedTimestampSeconds - block.timestamp) >
                DEFAULT_MAX_DATA_TIMESTAMP_AHEAD_SECONDS
            ) {
                revert TimestampFromTooLongFuture(
                    receivedTimestampSeconds,
                    block.timestamp
                );
            }
        } else if (
            (block.timestamp - receivedTimestampSeconds) >
            DEFAULT_MAX_DATA_TIMESTAMP_DELAY_SECONDS
        ) {
            revert TimestampIsTooOld(receivedTimestampSeconds, block.timestamp);
        }
    }

    function aggregateValues(
        uint256[] memory values
    ) internal pure returns (uint256) {
        return NumericArrayLib.pickMedian(values);
    }
}

library BitmapLib {
    function setBitInBitmap(
        uint256 bitmap,
        uint256 bitIndex
    ) internal pure returns (uint256) {
        return bitmap | (1 << bitIndex);
    }

    function getBitFromBitmap(
        uint256 bitmap,
        uint256 bitIndex
    ) internal pure returns (bool) {
        uint256 bitAtIndex = bitmap & (1 << bitIndex);
        return bitAtIndex > 0;
    }
}

library SignatureLib {
    uint256 internal constant ECDSA_SIG_R_BS = 32;
    uint256 internal constant ECDSA_SIG_S_BS = 32;

    function recoverSignerAddress(
        bytes32 signedHash,
        uint256 signatureCalldataNegativeOffset
    ) internal pure returns (address) {
        bytes32 r;
        bytes32 s;
        uint8 v;
        assembly {
            let signatureCalldataStartPos := sub(
                calldatasize(),
                signatureCalldataNegativeOffset
            )
            r := calldataload(signatureCalldataStartPos)
            signatureCalldataStartPos := add(
                signatureCalldataStartPos,
                ECDSA_SIG_R_BS
            )
            s := calldataload(signatureCalldataStartPos)
            signatureCalldataStartPos := add(
                signatureCalldataStartPos,
                ECDSA_SIG_S_BS
            )
            v := byte(0, calldataload(signatureCalldataStartPos)) // last byte of the signature memory array
        }
        return ecrecover(signedHash, v, r, s);
    }
}

/**
 * @title The base contract with helpful constants
 * @author The Redstone Oracles team
 * @dev It mainly contains redstone-related values, which improve readability
 * of other contracts (e.g. CalldataExtractor and RedstoneConsumerBase)
 */
library RedstoneError {
    // Error messages
    error ProxyCalldataFailedWithoutErrMsg2();
    error ProxyCalldataFailedWithoutErrMsg();
    error CalldataOverOrUnderFlow();
    error ProxyCalldataFailedWithCustomError(bytes result);
    error IncorrectUnsignedMetadataSize();
    error ProxyCalldataFailedWithStringMessage(string);
    error InsufficientNumberOfUniqueSigners(
        uint256 receivedSignersCount,
        uint256 requiredSignersCount
    );
    error EachSignerMustProvideTheSameValue();
    error EmptyCalldataPointersArr();
    error InvalidCalldataPointer();
    error CalldataMustHaveValidPayload();
    error SignerNotAuthorised(address receivedSigner);
}

// solhint-disable no-empty-blocks
// solhint-disable avoid-low-level-calls

// === Abbreviations ===
// BS - Bytes size
// PTR - Pointer (memory location)
// SIG - Signature

library Redstone {
    // Solidity and YUL constants
    uint256 internal constant STANDARD_SLOT_BS = 32;
    uint256 internal constant FREE_MEMORY_PTR = 0x40;
    uint256 internal constant BYTES_ARR_LEN_VAR_BS = 32;
    uint256 internal constant FUNCTION_SIGNATURE_BS = 4;
    uint256 internal constant REVERT_MSG_OFFSET = 68; // Revert message structure described here: https://ethereum.stackexchange.com/a/66173/106364
    uint256 internal constant STRING_ERR_MESSAGE_MASK =
        0x08c379a000000000000000000000000000000000000000000000000000000000;

    // RedStone protocol consts
    uint256 internal constant SIG_BS = 65;
    uint256 internal constant TIMESTAMP_BS = 6;
    uint256 internal constant DATA_PACKAGES_COUNT_BS = 2;
    uint256 internal constant DATA_POINTS_COUNT_BS = 3;
    uint256 internal constant DATA_POINT_VALUE_BYTE_SIZE_BS = 4;
    uint256 internal constant DATA_POINT_SYMBOL_BS = 32;
    uint256 internal constant DEFAULT_DATA_POINT_VALUE_BS = 32;
    uint256 internal constant UNSIGNED_METADATA_BYTE_SIZE_BS = 3;
    uint256 internal constant REDSTONE_MARKER_BS = 9; // byte size of 0x000002ed57011e0000
    uint256 internal constant REDSTONE_MARKER_MASK =
        0x0000000000000000000000000000000000000000000000000002ed57011e0000;

    // Derived values (based on consts)
    uint256
        internal constant TIMESTAMP_NEGATIVE_OFFSET_IN_DATA_PACKAGE_WITH_STANDARD_SLOT_BS =
        104; // SIG_BS + DATA_POINTS_COUNT_BS + DATA_POINT_VALUE_BYTE_SIZE_BS + STANDARD_SLOT_BS
    uint256 internal constant DATA_PACKAGE_WITHOUT_DATA_POINTS_BS = 78; // DATA_POINT_VALUE_BYTE_SIZE_BS + TIMESTAMP_BS + DATA_POINTS_COUNT_BS + SIG_BS
    uint256 internal constant DATA_PACKAGE_WITHOUT_DATA_POINTS_AND_SIG_BS = 13; // DATA_POINT_VALUE_BYTE_SIZE_BS + TIMESTAMP_BS + DATA_POINTS_COUNT_BS
    uint256 internal constant REDSTONE_MARKER_BS_PLUS_STANDARD_SLOT_BS = 41; // REDSTONE_MARKER_BS + STANDARD_SLOT_BS

    // using SafeMath for uint256;
    // inside unchecked these functions are still checked
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

    using {sub, add} for uint256;

    /**
     * @dev This function can be used in a consumer contract to securely extract an
     * oracle value for a given data feed id. Security is achieved by
     * signatures verification, timestamp validation, and aggregating values
     * from different authorised signers into a single numeric value. If any of the
     * required conditions do not match, the function will revert.
     * Note! This function expects that tx calldata contains redstone payload in the end
     * Learn more about redstone payload here: https://github.com/redstone-finance/redstone-oracles-monorepo/tree/main/packages/evm-connector#readme
     * @param dataFeedId bytes32 value that uniquely identifies the data feed
     * @return Extracted and verified numeric oracle value for the given data feed id
     */
    function getPrice(bytes32 dataFeedId) internal view returns (uint256) {
        bytes32[] memory dataFeedIds = new bytes32[](1);
        dataFeedIds[0] = dataFeedId;
        return _securelyExtractOracleValuesFromTxMsg(dataFeedIds)[0];
    }

    function getAuthorisedSignerIndex(
        address signerAddress
    ) internal pure returns (uint8) {
        if (signerAddress == 0x926E370fD53c23f8B71ad2B3217b227E41A92b12)
            return 0;
        if (signerAddress == 0x0C39486f770B26F5527BBBf942726537986Cd7eb)
            return 1;
        // For testing hardhat signer 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 is authorised
        // will be removed in production deployment
        if (signerAddress == 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266)
            return 2;

        revert RedstoneError.SignerNotAuthorised(signerAddress);
    }

    /**
     * @dev This function can be used in a consumer contract to securely extract several
     * numeric oracle values for a given array of data feed ids. Security is achieved by
     * signatures verification, timestamp validation, and aggregating values
     * from different authorised signers into a single numeric value. If any of the
     * required conditions do not match, the function will revert.
     * Note! This function expects that tx calldata contains redstone payload in the end
     * Learn more about redstone payload here: https://github.com/redstone-finance/redstone-oracles-monorepo/tree/main/packages/evm-connector#readme
     * @param dataFeedIds An array of unique data feed identifiers
     * @return An array of the extracted and verified oracle values in the same order
     * as they are requested in the dataFeedIds array
     */
    function getPrices(
        bytes32[] memory dataFeedIds
    ) internal view returns (uint256[] memory) {
        return _securelyExtractOracleValuesFromTxMsg(dataFeedIds);
    }

    /**
     * @dev This function may be overridden by the child consumer contract.
     * It should validate the timestamp against the current time (block.timestamp)
     * It should revert with a helpful message if the timestamp is not valid
     * @param receivedTimestampMilliseconds Timestamp extracted from calldata
     */
    function validateTimestamp(
        uint256 receivedTimestampMilliseconds
    ) internal view {
        // For testing this function is disabled
        // Uncomment this line to enable timestamp validation in prod
        // RedstoneDefaultsLib.validateTimestamp(receivedTimestampMilliseconds);
    }

    /**
     * @dev This function should be overridden by the child consumer contract.
     * @return The minimum required value of unique authorised signers
     */
    function getUniqueSignersThreshold() internal pure returns (uint8) {
        return 1;
    }

    /**
     * @dev This function may be overridden by the child consumer contract.
     * It should aggregate values from different signers to a single uint value.
     * By default, it calculates the median value
     * @param values An array of uint256 values from different signers
     * @return Result of the aggregation in the form of a single number
     */
    function aggregateValues(
        uint256[] memory values
    ) internal pure returns (uint256) {
        return RedstoneDefaultsLib.aggregateValues(values);
    }

    /**
     * @dev This is an internal helpful function for secure extraction oracle values
     * from the tx calldata. Security is achieved by signatures verification, timestamp
     * validation, and aggregating values from different authorised signers into a
     * single numeric value. If any of the required conditions (e.g. too old timestamp or
     * insufficient number of authorised signers) do not match, the function will revert.
     *
     * Note! You should not call this function in a consumer contract. You can use
     * `getOracleNumericValuesFromTxMsg` or `getOracleNumericValueFromTxMsg` instead.
     *
     * @param dataFeedIds An array of unique data feed identifiers
     * @return An array of the extracted and verified oracle values in the same order
     * as they are requested in dataFeedIds array
     */
    function _securelyExtractOracleValuesFromTxMsg(
        bytes32[] memory dataFeedIds
    ) private view returns (uint256[] memory) {
        // Initializing helpful variables and allocating memory
        uint256[] memory uniqueSignerCountForDataFeedIds = new uint256[](
            dataFeedIds.length
        );
        uint256[] memory signersBitmapForDataFeedIds = new uint256[](
            dataFeedIds.length
        );
        uint256[][] memory valuesForDataFeeds = new uint256[][](
            dataFeedIds.length
        );
        for (uint256 i; i < dataFeedIds.length; ) {
            // The line below is commented because newly allocated arrays are filled with zeros
            // But we left it for better readability
            // signersBitmapForDataFeedIds[i] = 0; // <- setting to an empty bitmap
            valuesForDataFeeds[i] = new uint256[](getUniqueSignersThreshold());

            unchecked {
                i++;
            }
        }

        // Extracting the number of data packages from calldata
        uint256 calldataNegativeOffset = _extractByteSizeOfUnsignedMetadata();
        uint256 dataPackagesCount = _extractDataPackagesCountFromCalldata(
            calldataNegativeOffset
        );
        unchecked {
            calldataNegativeOffset += DATA_PACKAGES_COUNT_BS;
        }

        // Saving current free memory pointer
        uint256 freeMemPtr;
        assembly {
            freeMemPtr := mload(FREE_MEMORY_PTR)
        }

        // Data packages extraction in a loop
        for (uint256 dataPackageIndex; dataPackageIndex < dataPackagesCount; ) {
            // Extract data package details and update calldata offset
            uint256 dataPackageByteSize = _extractDataPackage(
                dataFeedIds,
                uniqueSignerCountForDataFeedIds,
                signersBitmapForDataFeedIds,
                valuesForDataFeeds,
                calldataNegativeOffset
            );
            unchecked {
                calldataNegativeOffset += dataPackageByteSize;
            }

            // Shifting memory pointer back to the "safe" value
            assembly {
                mstore(FREE_MEMORY_PTR, freeMemPtr)
            }

            unchecked {
                dataPackageIndex++;
            }
        }

        // Validating numbers of unique signers and calculating aggregated values for each dataFeedId
        return
            _getAggregatedValues(
                valuesForDataFeeds,
                uniqueSignerCountForDataFeedIds
            );
    }

    /**
     * @dev This is a private helpful function, which extracts data for a data package based
     * on the given negative calldata offset, verifies them, and in the case of successful
     * verification updates the corresponding data package values in memory
     *
     * @param dataFeedIds an array of unique data feed identifiers
     * @param uniqueSignerCountForDataFeedIds an array with the numbers of unique signers
     * for each data feed
     * @param signersBitmapForDataFeedIds an array of signer bitmaps for data feeds
     * @param valuesForDataFeeds 2-dimensional array, valuesForDataFeeds[i][j] contains
     * j-th value for the i-th data feed
     * @param calldataNegativeOffset negative calldata offset for the given data package
     *
     * @return An array of the aggregated values
     */
    function _extractDataPackage(
        bytes32[] memory dataFeedIds,
        uint256[] memory uniqueSignerCountForDataFeedIds,
        uint256[] memory signersBitmapForDataFeedIds,
        uint256[][] memory valuesForDataFeeds,
        uint256 calldataNegativeOffset
    ) private view returns (uint256) {
        uint256 signerIndex;

        (
            uint256 dataPointsCount,
            uint256 eachDataPointValueByteSize
        ) = _extractDataPointsDetailsForDataPackage(calldataNegativeOffset);

        // We use scopes to resolve problem with too deep stack
        {
            uint48 extractedTimestamp;
            address signerAddress;
            bytes32 signedHash;
            bytes memory signedMessage;
            uint256 signedMessageBytesCount = dataPointsCount *
                (eachDataPointValueByteSize + DATA_POINT_SYMBOL_BS) +
                DATA_PACKAGE_WITHOUT_DATA_POINTS_AND_SIG_BS; //DATA_POINT_VALUE_BYTE_SIZE_BS + TIMESTAMP_BS + DATA_POINTS_COUNT_BS

            unchecked {
                uint256 timestampCalldataOffset = msg.data.length.sub(
                    calldataNegativeOffset +
                        TIMESTAMP_NEGATIVE_OFFSET_IN_DATA_PACKAGE_WITH_STANDARD_SLOT_BS
                );

                uint256 signedMessageCalldataOffset = msg.data.length.sub(
                    calldataNegativeOffset + SIG_BS + signedMessageBytesCount
                );

                assembly {
                    // Extracting the signed message
                    signedMessage := extractBytesFromCalldata(
                        signedMessageCalldataOffset,
                        signedMessageBytesCount
                    )

                    // Hashing the signed message
                    signedHash := keccak256(
                        add(signedMessage, BYTES_ARR_LEN_VAR_BS),
                        signedMessageBytesCount
                    )

                    // Extracting timestamp
                    extractedTimestamp := calldataload(timestampCalldataOffset)

                    function initByteArray(bytesCount) -> ptr {
                        ptr := mload(FREE_MEMORY_PTR)
                        mstore(ptr, bytesCount)
                        ptr := add(ptr, BYTES_ARR_LEN_VAR_BS)
                        mstore(FREE_MEMORY_PTR, add(ptr, bytesCount))
                    }

                    function extractBytesFromCalldata(offset, bytesCount)
                        -> extractedBytes
                    {
                        let extractedBytesStartPtr := initByteArray(bytesCount)
                        calldatacopy(extractedBytesStartPtr, offset, bytesCount)
                        extractedBytes := sub(
                            extractedBytesStartPtr,
                            BYTES_ARR_LEN_VAR_BS
                        )
                    }
                }
            }
            // Validating timestamp
            validateTimestamp(extractedTimestamp);

            // Verifying the off-chain signature against on-chain hashed data
            signerAddress = SignatureLib.recoverSignerAddress(
                signedHash,
                calldataNegativeOffset + SIG_BS
            );
            signerIndex = getAuthorisedSignerIndex(signerAddress);
        }

        // Updating helpful arrays
        {
            bytes32 dataPointDataFeedId;
            uint256 dataPointValue;
            for (uint256 dataPointIndex; dataPointIndex < dataPointsCount; ) {
                // Extracting data feed id and value for the current data point
                (
                    dataPointDataFeedId,
                    dataPointValue
                ) = _extractDataPointValueAndDataFeedId(
                    calldataNegativeOffset,
                    eachDataPointValueByteSize,
                    dataPointIndex
                );

                for (
                    uint256 dataFeedIdIndex;
                    dataFeedIdIndex < dataFeedIds.length;

                ) {
                    if (dataPointDataFeedId == dataFeedIds[dataFeedIdIndex]) {
                        uint256 bitmapSignersForDataFeedId = signersBitmapForDataFeedIds[
                                dataFeedIdIndex
                            ];

                        if (
                            !BitmapLib.getBitFromBitmap(
                                bitmapSignersForDataFeedId,
                                signerIndex
                            ) /* current signer was not counted for current dataFeedId */ &&
                            uniqueSignerCountForDataFeedIds[dataFeedIdIndex] <
                            getUniqueSignersThreshold()
                        ) {
                            unchecked {
                                // Increase unique signer counter
                                uniqueSignerCountForDataFeedIds[
                                    dataFeedIdIndex
                                ]++;

                                // Add new value
                                valuesForDataFeeds[dataFeedIdIndex][
                                    uniqueSignerCountForDataFeedIds[
                                        dataFeedIdIndex
                                    ] - 1
                                ] = dataPointValue;
                            }
                            // Update signers bitmap
                            signersBitmapForDataFeedIds[
                                dataFeedIdIndex
                            ] = BitmapLib.setBitInBitmap(
                                bitmapSignersForDataFeedId,
                                signerIndex
                            );
                        }

                        // Breaking, as there couldn't be several indexes for the same feed ID
                        break;
                    }
                    unchecked {
                        dataFeedIdIndex++;
                    }
                }
                unchecked {
                    dataPointIndex++;
                }
            }
        }

        // Return total data package byte size
        unchecked {
            return
                DATA_PACKAGE_WITHOUT_DATA_POINTS_BS +
                (eachDataPointValueByteSize + DATA_POINT_SYMBOL_BS) *
                dataPointsCount;
        }
    }

    /**
     * @dev This is a private helpful function, which aggregates values from different
     * authorised signers for the given arrays of values for each data feed
     *
     * @param valuesForDataFeeds 2-dimensional array, valuesForDataFeeds[i][j] contains
     * j-th value for the i-th data feed
     * @param uniqueSignerCountForDataFeedIds an array with the numbers of unique signers
     * for each data feed
     *
     * @return An array of the aggregated values
     */
    function _getAggregatedValues(
        uint256[][] memory valuesForDataFeeds,
        uint256[] memory uniqueSignerCountForDataFeedIds
    ) private pure returns (uint256[] memory) {
        uint256[] memory aggregatedValues = new uint256[](
            valuesForDataFeeds.length
        );
        uint256 uniqueSignersThreshold = getUniqueSignersThreshold();

        for (
            uint256 dataFeedIndex;
            dataFeedIndex < valuesForDataFeeds.length;

        ) {
            if (
                uniqueSignerCountForDataFeedIds[dataFeedIndex] <
                uniqueSignersThreshold
            ) {
                revert RedstoneError.InsufficientNumberOfUniqueSigners(
                    uniqueSignerCountForDataFeedIds[dataFeedIndex],
                    uniqueSignersThreshold
                );
            }
            uint256 aggregatedValueForDataFeedId = aggregateValues(
                valuesForDataFeeds[dataFeedIndex]
            );
            aggregatedValues[dataFeedIndex] = aggregatedValueForDataFeedId;
            unchecked {
                dataFeedIndex++;
            }
        }

        return aggregatedValues;
    }

    function _extractDataPointsDetailsForDataPackage(
        uint256 calldataNegativeOffsetForDataPackage
    )
        private
        pure
        returns (uint256 dataPointsCount, uint256 eachDataPointValueByteSize)
    {
        // Using uint24, because data points count byte size number has 3 bytes
        uint24 dataPointsCount_;

        // Using uint32, because data point value byte size has 4 bytes
        uint32 eachDataPointValueByteSize_;

        // Extract data points count
        unchecked {
            uint256 negativeCalldataOffset = calldataNegativeOffsetForDataPackage +
                    SIG_BS;
            uint256 calldataOffset = msg.data.length.sub(
                negativeCalldataOffset + STANDARD_SLOT_BS
            );
            assembly {
                dataPointsCount_ := calldataload(calldataOffset)
            }

            // Extract each data point value size
            calldataOffset = calldataOffset.sub(DATA_POINTS_COUNT_BS);
            assembly {
                eachDataPointValueByteSize_ := calldataload(calldataOffset)
            }

            // Prepare returned values
            dataPointsCount = dataPointsCount_;
            eachDataPointValueByteSize = eachDataPointValueByteSize_;
        }
    }

    function _extractByteSizeOfUnsignedMetadata()
        private
        pure
        returns (uint256)
    {
        // Checking if the calldata ends with the RedStone marker
        bool hasValidRedstoneMarker;
        assembly {
            let calldataLast32Bytes := calldataload(
                sub(calldatasize(), STANDARD_SLOT_BS)
            )
            hasValidRedstoneMarker := eq(
                REDSTONE_MARKER_MASK,
                and(calldataLast32Bytes, REDSTONE_MARKER_MASK)
            )
        }
        if (!hasValidRedstoneMarker) {
            revert RedstoneError.CalldataMustHaveValidPayload();
        }

        // Using uint24, because unsigned metadata byte size number has 3 bytes
        uint24 unsignedMetadataByteSize;
        if (REDSTONE_MARKER_BS_PLUS_STANDARD_SLOT_BS > msg.data.length) {
            revert RedstoneError.CalldataOverOrUnderFlow();
        }
        assembly {
            unsignedMetadataByteSize := calldataload(
                sub(calldatasize(), REDSTONE_MARKER_BS_PLUS_STANDARD_SLOT_BS)
            )
        }
        unchecked {
            uint256 calldataNegativeOffset = unsignedMetadataByteSize +
                UNSIGNED_METADATA_BYTE_SIZE_BS +
                REDSTONE_MARKER_BS;
            if (
                calldataNegativeOffset + DATA_PACKAGES_COUNT_BS >
                msg.data.length
            ) {
                revert RedstoneError.IncorrectUnsignedMetadataSize();
            }
            return calldataNegativeOffset;
        }
    }

    function _extractDataPackagesCountFromCalldata(
        uint256 calldataNegativeOffset
    ) private pure returns (uint16 dataPackagesCount) {
        unchecked {
            uint256 calldataNegativeOffsetWithStandardSlot = calldataNegativeOffset +
                    STANDARD_SLOT_BS;
            if (calldataNegativeOffsetWithStandardSlot > msg.data.length) {
                revert RedstoneError.CalldataOverOrUnderFlow();
            }
            assembly {
                dataPackagesCount := calldataload(
                    sub(calldatasize(), calldataNegativeOffsetWithStandardSlot)
                )
            }
            return dataPackagesCount;
        }
    }

    function _extractDataPointValueAndDataFeedId(
        uint256 calldataNegativeOffsetForDataPackage,
        uint256 defaultDataPointValueByteSize,
        uint256 dataPointIndex
    )
        private
        pure
        returns (bytes32 dataPointDataFeedId, uint256 dataPointValue)
    {
        uint256 negativeOffsetToDataPoints = calldataNegativeOffsetForDataPackage +
                DATA_PACKAGE_WITHOUT_DATA_POINTS_BS;
        uint256 dataPointNegativeOffset = negativeOffsetToDataPoints +
            ((1 + dataPointIndex) *
                ((defaultDataPointValueByteSize + DATA_POINT_SYMBOL_BS)));
        uint256 dataPointCalldataOffset = msg.data.length.sub(
            dataPointNegativeOffset
        );
        assembly {
            dataPointDataFeedId := calldataload(dataPointCalldataOffset)
            dataPointValue := calldataload(
                add(dataPointCalldataOffset, DATA_POINT_SYMBOL_BS)
            )
        }
    }

    function proxyCalldata(
        address contractAddress,
        bytes memory encodedFunction,
        bool forwardValue
    ) internal returns (bytes memory) {
        bytes memory message = _prepareMessage(encodedFunction);

        (bool success, bytes memory result) = contractAddress.call{
            value: forwardValue ? msg.value : 0
        }(message);

        return _prepareReturnValue(success, result);
    }

    function proxyDelegateCalldata(
        address contractAddress,
        bytes memory encodedFunction
    ) internal returns (bytes memory) {
        bytes memory message = _prepareMessage(encodedFunction);
        (bool success, bytes memory result) = contractAddress.delegatecall(
            message
        );
        return _prepareReturnValue(success, result);
    }

    function proxyCalldataView(
        address contractAddress,
        bytes memory encodedFunction
    ) internal view returns (bytes memory) {
        bytes memory message = _prepareMessage(encodedFunction);
        (bool success, bytes memory result) = contractAddress.staticcall(
            message
        );
        return _prepareReturnValue(success, result);
    }

    function _prepareMessage(
        bytes memory encodedFunction
    ) private pure returns (bytes memory) {
        uint256 encodedFunctionBytesCount = encodedFunction.length;
        uint256 redstonePayloadByteSize = _getRedstonePayloadByteSize();
        uint256 resultMessageByteSize = encodedFunctionBytesCount +
            redstonePayloadByteSize;

        if (redstonePayloadByteSize > msg.data.length) {
            revert RedstoneError.CalldataOverOrUnderFlow();
        }

        bytes memory message;

        assembly {
            message := mload(FREE_MEMORY_PTR) // sets message pointer to first free place in memory

            // Saving the byte size of the result message (it's a standard in EVM)
            mstore(message, resultMessageByteSize)

            // Copying function and its arguments
            for {
                let from := add(BYTES_ARR_LEN_VAR_BS, encodedFunction)
                let fromEnd := add(from, encodedFunctionBytesCount)
                let to := add(BYTES_ARR_LEN_VAR_BS, message)
            } lt(from, fromEnd) {
                from := add(from, STANDARD_SLOT_BS)
                to := add(to, STANDARD_SLOT_BS)
            } {
                // Copying data from encodedFunction to message (32 bytes at a time)
                mstore(to, mload(from))
            }

            // Copying redstone payload to the message bytes
            calldatacopy(
                add(
                    message,
                    add(BYTES_ARR_LEN_VAR_BS, encodedFunctionBytesCount)
                ), // address
                sub(calldatasize(), redstonePayloadByteSize), // offset
                redstonePayloadByteSize // bytes length to copy
            )

            // Updating free memory pointer
            mstore(
                FREE_MEMORY_PTR,
                add(
                    add(
                        message,
                        add(redstonePayloadByteSize, encodedFunctionBytesCount)
                    ),
                    BYTES_ARR_LEN_VAR_BS
                )
            )
        }

        return message;
    }

    function _getRedstonePayloadByteSize() private pure returns (uint256) {
        uint256 calldataNegativeOffset = _extractByteSizeOfUnsignedMetadata();
        uint256 dataPackagesCount = _extractDataPackagesCountFromCalldata(
            calldataNegativeOffset
        );
        calldataNegativeOffset += DATA_PACKAGES_COUNT_BS;
        for (uint256 dataPackageIndex; dataPackageIndex < dataPackagesCount; ) {
            calldataNegativeOffset += _getDataPackageByteSize(
                calldataNegativeOffset
            );
            unchecked {
                dataPackageIndex++;
            }
        }

        return calldataNegativeOffset;
    }

    function _getDataPackageByteSize(
        uint256 calldataNegativeOffset
    ) private pure returns (uint256) {
        (
            uint256 dataPointsCount,
            uint256 eachDataPointValueByteSize
        ) = _extractDataPointsDetailsForDataPackage(calldataNegativeOffset);

        return
            dataPointsCount *
            (DATA_POINT_SYMBOL_BS + eachDataPointValueByteSize) +
            DATA_PACKAGE_WITHOUT_DATA_POINTS_BS;
    }

    function _prepareReturnValue(
        bool success,
        bytes memory result
    ) internal pure returns (bytes memory) {
        if (!success) {
            if (result.length == 0) {
                revert RedstoneError.ProxyCalldataFailedWithoutErrMsg();
            } else {
                bool isStringErrorMessage;
                assembly {
                    let first32BytesOfResult := mload(
                        add(result, BYTES_ARR_LEN_VAR_BS)
                    )
                    isStringErrorMessage := eq(
                        first32BytesOfResult,
                        STRING_ERR_MESSAGE_MASK
                    )
                }

                if (isStringErrorMessage) {
                    string memory receivedErrMsg;
                    assembly {
                        receivedErrMsg := add(result, REVERT_MSG_OFFSET)
                    }
                    revert RedstoneError.ProxyCalldataFailedWithStringMessage(
                        receivedErrMsg
                    );
                } else {
                    revert RedstoneError.ProxyCalldataFailedWithCustomError(
                        result
                    );
                }
            }
        }

        return result;
    }
}

/* -------------------------------------------------------------------------- */
/*                                    Enums                                   */
/* -------------------------------------------------------------------------- */
library Enums {
    /**
     * @dev Minter fees for minting and burning.
     * Open = 0
     * Close = 1
     */
    enum MinterFee {
        Open,
        Close
    }
    /**
     * @notice Swap fee types for shared collateral debt pool swaps.
     * Open = 0
     * Close = 1
     */
    enum SwapFee {
        In,
        Out
    }
    /**
     * @notice Configurable oracle types for assets.
     * Empty = 0
     * Redstone = 1,
     * Chainlink = 2,
     * API3 = 3,
     * Vault = 4
     */
    enum OracleType {
        Empty,
        Redstone,
        Chainlink,
        API3,
        Vault
    }

    /**
     * @notice Protocol core actions.
     * Deposit = 0
     * Withdraw = 1,
     * Repay = 2,
     * Borrow = 3,
     * Liquidate = 4
     * SCDPDeposit = 5,
     * SCDPSwap = 6,
     * SCDPWithdraw = 7,
     * SCDPRepay = 8,
     * SCDPLiquidation = 9
     */
    enum Action {
        Deposit,
        Withdraw,
        Repay,
        Borrow,
        Liquidation,
        SCDPDeposit,
        SCDPSwap,
        SCDPWithdraw,
        SCDPRepay,
        SCDPLiquidation
    }
}

/* -------------------------------------------------------------------------- */
/*                               Access Control                               */
/* -------------------------------------------------------------------------- */

library Role {
    /// @dev Meta role for all roles.
    bytes32 internal constant DEFAULT_ADMIN = 0x00;
    /// @dev keccak256("kresko.roles.minter.admin")
    bytes32 internal constant ADMIN =
        0xb9dacdf02281f2e98ddbadaaf44db270b3d5a916342df47c59f77937a6bcd5d8;
    /// @dev keccak256("kresko.roles.minter.operator")
    bytes32 internal constant OPERATOR =
        0x112e48a576fb3a75acc75d9fcf6e0bc670b27b1dbcd2463502e10e68cf57d6fd;
    /// @dev keccak256("kresko.roles.minter.manager")
    bytes32 internal constant MANAGER =
        0x46925e0f0cc76e485772167edccb8dc449d43b23b55fc4e756b063f49099e6a0;
    /// @dev keccak256("kresko.roles.minter.safety.council")
    bytes32 internal constant SAFETY_COUNCIL =
        0x9c387ecf1663f9144595993e2c602b45de94bf8ba3a110cb30e3652d79b581c0;
}

/* -------------------------------------------------------------------------- */
/*                                    MISC                                    */
/* -------------------------------------------------------------------------- */

library Constants {
    /// @dev Set the initial value to 1, (not hindering possible gas refunds by setting it to 0 on exit).
    uint8 internal constant NOT_ENTERED = 1;
    uint8 internal constant ENTERED = 2;
    uint8 internal constant NOT_INITIALIZING = 1;
    uint8 internal constant INITIALIZING = 2;

    bytes32 internal constant ZERO_BYTES32 = bytes32("");
    /// @dev The min oracle decimal precision
    uint256 internal constant MIN_ORACLE_DECIMALS = 8;
    /// @dev The minimum collateral amount for a kresko asset.
    uint256 internal constant MIN_KRASSET_COLLATERAL_AMOUNT = 1e12;

    /// @dev The maximum configurable minimum debt USD value. 8 decimals.
    uint256 internal constant MAX_MIN_DEBT_VALUE = 1_000 * 1e8; // $1,000
}

library Percents {
    uint16 internal constant ONE = 0.01e4;
    uint16 internal constant HUNDRED = 1e4;
    uint16 internal constant TWENTY_FIVE = 0.25e4;
    uint16 internal constant FIFTY = 0.50e4;
    uint16 internal constant MAX_DEVIATION = TWENTY_FIVE;

    uint16 internal constant BASIS_POINT = 1;
    /// @dev The maximum configurable close fee.
    uint16 internal constant MAX_CLOSE_FEE = 0.25e4; // 25%

    /// @dev The maximum configurable open fee.
    uint16 internal constant MAX_OPEN_FEE = 0.25e4; // 25%

    /// @dev The maximum configurable protocol fee per asset for collateral pool swaps.
    uint16 internal constant MAX_SCDP_FEE = 0.5e4; // 50%

    /// @dev The minimum configurable minimum collateralization ratio.
    uint16 internal constant MIN_LT = HUNDRED + ONE; // 101%
    uint16 internal constant MIN_MCR = HUNDRED + ONE + ONE; // 102%

    /// @dev The minimum configurable liquidation incentive multiplier.
    /// This means liquidator only receives equal amount of collateral to debt repaid.
    uint16 internal constant MIN_LIQ_INCENTIVE = HUNDRED;

    /// @dev The maximum configurable liquidation incentive multiplier.
    /// This means liquidator receives 25% bonus collateral compared to the debt repaid.
    uint16 internal constant MAX_LIQ_INCENTIVE = 1.25e4; // 125%
}

/**
 * @title PercentageMath library
 * @author Aave
 * @notice Provides functions to perform percentage calculations
 * @dev PercentageMath are defined by default with 2 decimals of precision (100.00).
 * The precision is indicated by PERCENTAGE_FACTOR
 * @dev Operations are rounded. If a value is >=.5, will be rounded up, otherwise rounded down.
 **/
library PercentageMath {
    // Maximum percentage factor (100.00%)
    uint256 internal constant PERCENTAGE_FACTOR = 1e4;

    // Half percentage factor (50.00%)
    uint256 internal constant HALF_PERCENTAGE_FACTOR = 0.5e4;

    /**
     * @notice Executes a percentage multiplication
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param value The value of which the percentage needs to be calculated
     * @param percentage The percentage of the value to be calculated
     * @return result value percentmul percentage
     **/
    function percentMul(
        uint256 value,
        uint256 percentage
    ) internal pure returns (uint256 result) {
        // to avoid overflow, value <= (type(uint256).max - HALF_PERCENTAGE_FACTOR) / percentage
        assembly {
            if iszero(
                or(
                    iszero(percentage),
                    iszero(
                        gt(
                            value,
                            div(sub(not(0), HALF_PERCENTAGE_FACTOR), percentage)
                        )
                    )
                )
            ) {
                revert(0, 0)
            }

            result := div(
                add(mul(value, percentage), HALF_PERCENTAGE_FACTOR),
                PERCENTAGE_FACTOR
            )
        }
    }

    /**
     * @notice Executes a percentage division
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param value The value of which the percentage needs to be calculated
     * @param percentage The percentage of the value to be calculated
     * @return result value percentdiv percentage
     **/
    function percentDiv(
        uint256 value,
        uint256 percentage
    ) internal pure returns (uint256 result) {
        // to avoid overflow, value <= (type(uint256).max - halfPercentage) / PERCENTAGE_FACTOR
        assembly {
            if or(
                iszero(percentage),
                iszero(
                    iszero(
                        gt(
                            value,
                            div(
                                sub(not(0), div(percentage, 2)),
                                PERCENTAGE_FACTOR
                            )
                        )
                    )
                )
            ) {
                revert(0, 0)
            }

            result := div(
                add(mul(value, PERCENTAGE_FACTOR), div(percentage, 2)),
                percentage
            )
        }
    }
}

using WadRay for uint256;
using PercentageMath for uint256;
using PercentageMath for uint16;

/* -------------------------------------------------------------------------- */
/*                                   General                                  */
/* -------------------------------------------------------------------------- */

/**
 * @notice Calculate amount for value provided with possible incentive multiplier for value.
 * @param _value Value to convert into amount.
 * @param _price The price to apply.
 * @param _multiplier Multiplier to apply, 1e4 = 100.00% precision.
 */
function valueToAmount(
    uint256 _value,
    uint256 _price,
    uint16 _multiplier
) pure returns (uint256) {
    return _value.percentMul(_multiplier).wadDiv(_price);
}

/**
 * @notice Converts decimal precision of `_amount` to wad decimal precision, which is 18 decimals.
 * @dev Multiplies if precision is less and divides if precision is greater than 18 decimals.
 * @param _amount Amount to convert.
 * @param _decimals Decimal precision for `_amount`.
 * @return uint256 Amount converted to wad precision.
 */
function toWad(uint256 _amount, uint8 _decimals) pure returns (uint256) {
    // Most tokens use 18 decimals.
    if (_decimals == 18 || _amount == 0) return _amount;

    if (_decimals < 18) {
        // Multiply for decimals less than 18 to get a wad value out.
        // If the token has 17 decimals, multiply by 10 ** (18 - 17) = 10
        // Results in a value of 1e18.
        return _amount * (10 ** (18 - _decimals));
    }

    // Divide for decimals greater than 18 to get a wad value out.
    // Loses precision, eg. 1 wei of token with 19 decimals:
    // Results in 1 / 10 ** (19 - 18) =  1 / 10 = 0.
    return _amount / (10 ** (_decimals - 18));
}

function toWad(int256 _amount, uint8 _decimals) pure returns (uint256) {
    return toWad(uint256(_amount), _decimals);
}

/**
 * @notice  Converts wad precision `_amount`  to wad decimal precision, which is 18 decimals.
 * @dev Multiplies if precision is greater and divides if precision is less than 18 decimals.
 * @param _wadAmount Wad precision amount to convert.
 * @param _decimals Decimal precision for the result.
 * @return uint256 Amount converted to `_decimals` precision.
 */
function fromWad(uint256 _wadAmount, uint8 _decimals) pure returns (uint256) {
    // Most tokens use 18 decimals.
    if (_decimals == 18 || _wadAmount == 0) return _wadAmount;

    if (_decimals < 18) {
        // Divide if decimals are less than 18 to get the correct amount out.
        // If token has 17 decimals, dividing by 10 ** (18 - 17) = 10
        // Results in a value of 1e17, which can lose precision.
        return _wadAmount / (10 ** (18 - _decimals));
    }
    // Multiply for decimals greater than 18 to get the correct amount out.
    // If the token has 19 decimals, multiply by 10 ** (19 - 18) = 10
    // Results in a value of 1e19.
    return _wadAmount * (10 ** (_decimals - 18));
}

/**
 * @notice Get the value of `_amount` and convert to 18 decimal precision.
 * @param _amount Amount of tokens to calculate.
 * @param _amountDecimal Precision of `_amount`.
 * @param _price Price to use.
 * @param _priceDecimals Precision of `_price`.
 * @return uint256 Value of `_amount` in 18 decimal precision.
 */
function wadUSD(
    uint256 _amount,
    uint8 _amountDecimal,
    uint256 _price,
    uint8 _priceDecimals
) pure returns (uint256) {
    if (_amount == 0 || _price == 0) return 0;
    return toWad(_amount, _amountDecimal).wadMul(toWad(_price, _priceDecimals));
}

interface IAggregatorV3 {
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

    function getRoundData(
        uint80 _roundId
    )
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    event AnswerUpdated(
        int256 indexed current,
        uint256 indexed roundId,
        uint256 updatedAt
    );

    event NewRound(
        uint256 indexed roundId,
        address indexed startedBy,
        uint256 startedAt
    );
}

/// @dev See DapiProxy.sol for comments about usage
interface IAPI3 {
    function read() external view returns (int224 value, uint32 timestamp);

    function api3ServerV1() external view returns (address);
}

/**
 * @title IVaultRateProvider
 * @author Kresko
 * @notice Minimal exchange rate interface for vaults.
 */
interface IVaultRateProvider {
    /**
     * @notice Gets the exchange rate of one vault share to USD.
     * @return uint256 The current exchange rate of the vault share in 18 decimals precision.
     */
    function exchangeRate() external view returns (uint256);
}

// OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)

/**
 * @dev String operations.
 */
library Strings {
    bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";

    function toString(bytes32 value) internal pure returns (string memory) {
        return string(abi.encodePacked(value));
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` decimal representation.
     */
    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT licence
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
     */
    function toHexString(uint256 value) internal pure returns (string memory) {
        if (value == 0) {
            return "0x00";
        }
        uint256 temp = value;
        uint256 length = 0;
        while (temp != 0) {
            length++;
            temp >>= 8;
        }
        return toHexString(value, length);
    }

    /**
     * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
     */
    function toHexString(
        uint256 value,
        uint256 length
    ) internal pure returns (string memory) {
        bytes memory buffer = new bytes(2 * length + 2);
        buffer[0] = "0";
        buffer[1] = "x";
        for (uint256 i = 2 * length + 1; i > 1; --i) {
            buffer[i] = _HEX_SYMBOLS[value & 0xf];
            value >>= 4;
        }
        if (value != 0) revert Errors.STRING_HEX_LENGTH_INSUFFICIENT();
        return string(buffer);
    }
}

// OpenZeppelin Contracts v4.4.1 (utils/structs/EnumerableSet.sol)

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping(bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes32 lastvalue = set._values[lastIndex];

                // Move the last value to the index where the value to delete is
                set._values[toDeleteIndex] = lastvalue;
                // Update the index for the moved value
                set._indexes[lastvalue] = valueIndex; // Replace lastvalue's index to valueIndex
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(
        Set storage set,
        bytes32 value
    ) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(
        Set storage set,
        uint256 index
    ) private view returns (bytes32) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(
        Bytes32Set storage set,
        bytes32 value
    ) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(
        Bytes32Set storage set,
        bytes32 value
    ) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(
        Bytes32Set storage set,
        bytes32 value
    ) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(
        Bytes32Set storage set,
        uint256 index
    ) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(
        Bytes32Set storage set
    ) internal view returns (bytes32[] memory) {
        return _values(set._inner);
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(
        AddressSet storage set,
        address value
    ) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(
        AddressSet storage set,
        address value
    ) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(
        AddressSet storage set,
        address value
    ) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(
        AddressSet storage set,
        uint256 index
    ) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(
        AddressSet storage set
    ) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        assembly {
            result := store
        }

        return result;
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(
        UintSet storage set,
        uint256 value
    ) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(
        UintSet storage set,
        uint256 value
    ) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(
        UintSet storage set,
        uint256 index
    ) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(
        UintSet storage set
    ) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        assembly {
            result := store
        }

        return result;
    }
}

/// These functions are expected to be called frequently
/// by tools.

struct Facet {
    address facetAddress;
    bytes4[] functionSelectors;
}

struct FacetAddressAndPosition {
    address facetAddress;
    // position in facetFunctionSelectors.functionSelectors array
    uint96 functionSelectorPosition;
}

struct FacetFunctionSelectors {
    bytes4[] functionSelectors;
    // position of facetAddress in facetAddresses array
    uint256 facetAddressPosition;
}

/// @dev  Add=0, Replace=1, Remove=2
enum FacetCutAction {
    Add,
    Replace,
    Remove
}

struct FacetCut {
    address facetAddress;
    FacetCutAction action;
    bytes4[] functionSelectors;
}

struct Initializer {
    address initContract;
    bytes initData;
}

struct DiamondState {
    /// @notice Maps function selector to the facet address and
    /// the position of the selector in the facetFunctionSelectors.selectors array
    mapping(bytes4 => FacetAddressAndPosition) selectorToFacetAndPosition;
    /// @notice Maps facet addresses to function selectors
    mapping(address => FacetFunctionSelectors) facetFunctionSelectors;
    /// @notice Facet addresses
    address[] facetAddresses;
    /// @notice ERC165 query implementation
    mapping(bytes4 => bool) supportedInterfaces;
    /// @notice address(this) replacement for FF
    address self;
    /// @notice Diamond initialized
    bool initialized;
    /// @notice Diamond initializing
    uint8 initializing;
    /// @notice Domain field separator
    bytes32 diamondDomainSeparator;
    /// @notice Current owner of the diamond
    address contractOwner;
    /// @notice Pending new diamond owner
    address pendingOwner;
    /// @notice Storage version
    uint96 storageVersion;
}

// Storage position
bytes32 constant DIAMOND_STORAGE_POSITION = keccak256("kresko.diamond.storage");

/**
 * @notice Ds, a pure free function.
 * @return state A DiamondState value.
 * @custom:signature ds()
 * @custom:selector 0x30dce62b
 */
function ds() pure returns (DiamondState storage state) {
    bytes32 position = DIAMOND_STORAGE_POSITION;
    assembly {
        state.slot := position
    }
}

/* solhint-disable no-inline-assembly */

library Meta {
    bytes32 internal constant EIP712_DOMAIN_TYPEHASH =
        keccak256(
            bytes(
                "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
            )
        );

    function domainSeparator(
        string memory name,
        string memory version
    ) internal view returns (bytes32 domainSeparator_) {
        domainSeparator_ = keccak256(
            abi.encode(
                EIP712_DOMAIN_TYPEHASH,
                keccak256(bytes(name)),
                keccak256(bytes(version)),
                getChainID(),
                address(this)
            )
        );
    }

    function getChainID() internal view returns (uint256 id) {
        assembly {
            id := chainid()
        }
    }

    function msgSender() internal view returns (address sender_) {
        if (msg.sender == address(this)) {
            bytes memory array = msg.data;
            uint256 index = msg.data.length;
            assembly {
                // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
                sender_ := and(
                    mload(add(array, index)),
                    0xffffffffffffffffffffffffffffffffffffffff
                )
            }
        } else {
            sender_ = msg.sender;
        }
    }

    function enforceHasContractCode(address _contract) internal view {
        uint256 contractSize;
        /// @solidity memory-safe-assembly
        assembly {
            contractSize := extcodesize(_contract)
        }
        if (contractSize == 0) {
            revert Errors.ADDRESS_HAS_NO_CODE(_contract);
        }
    }
}

interface IGnosisSafeL2 {
    function isOwner(address owner) external view returns (bool);

    function getOwners() external view returns (address[] memory);
}

/**
 * @title Shared library for access control
 * @author Kresko
 */
library Auth {
    using EnumerableSet for EnumerableSet.AddressSet;
    /* -------------------------------------------------------------------------- */
    /*                                   Events                                   */
    /* -------------------------------------------------------------------------- */

    /**
     * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
     *
     * `ADMIN_ROLE` is the starting admin for all roles, despite
     * {RoleAdminChanged} not being emitted signaling this.
     *
     * _Available since v3.1._
     */
    event RoleAdminChanged(
        bytes32 indexed role,
        bytes32 indexed previousAdminRole,
        bytes32 indexed newAdminRole
    );

    /**
     * @dev Emitted when `account` is granted `role`.
     *
     * `sender` is the account that originated the contract call, an admin role
     * bearer except when using {AccessControl-_setupRole}.
     */
    event RoleGranted(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );

    /**
     * @dev Emitted when `account` is revoked `role`.
     *
     * `sender` is the account that originated the contract call:
     *   - if using `revokeRole`, it is the admin role bearer
     *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
     */
    event RoleRevoked(
        bytes32 indexed role,
        address indexed account,
        address indexed sender
    );

    /* -------------------------------------------------------------------------- */
    /*                                Functionality                               */
    /* -------------------------------------------------------------------------- */

    function hasRole(
        bytes32 role,
        address account
    ) internal view returns (bool) {
        return cs()._roles[role].members[account];
    }

    function getRoleMemberCount(bytes32 role) internal view returns (uint256) {
        return cs()._roleMembers[role].length();
    }

    /**
     * @dev Revert with a standard message if `msg.sender` is missing `role`.
     * Overriding this function changes the behavior of the {onlyRole} modifier.
     *
     * Format of the revert message is described in {_checkRole}.
     *
     * _Available since v4.6._
     */
    function checkRole(bytes32 role) internal view {
        _checkRole(role, msg.sender);
    }

    /**
     * @dev Revert with a standard message if `account` is missing `role`.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     */
    function _checkRole(bytes32 role, address account) internal view {
        if (!hasRole(role, account)) {
            revert(
                string(
                    abi.encodePacked(
                        "AccessControl: account ",
                        Strings.toHexString(uint160(account), 20),
                        " is missing role ",
                        Strings.toHexString(uint256(role), 32)
                    )
                )
            );
        }
    }

    /**
     * @dev Returns the admin role that controls `role`. See {grantRole} and
     * {revokeRole}.
     *
     * To change a role's admin, use {_setRoleAdmin}.
     */
    function getRoleAdmin(bytes32 role) internal view returns (bytes32) {
        return cs()._roles[role].adminRole;
    }

    function getRoleMember(
        bytes32 role,
        uint256 index
    ) internal view returns (address) {
        return cs()._roleMembers[role].at(index);
    }

    /**
     * @notice setups the security council
     *
     */
    function setupSecurityCouncil(address _councilAddress) internal {
        if (getRoleMemberCount(Role.SAFETY_COUNCIL) != 0)
            revert Errors.SAFETY_COUNCIL_ALREADY_EXISTS(
                _councilAddress,
                getRoleMember(Role.SAFETY_COUNCIL, 0)
            );
        if (!IGnosisSafeL2(_councilAddress).isOwner(ds().contractOwner))
            revert Errors.SAFETY_COUNCIL_SETTER_IS_NOT_ITS_OWNER(
                _councilAddress
            );

        cs()._roles[Role.SAFETY_COUNCIL].members[_councilAddress] = true;
        cs()._roleMembers[Role.SAFETY_COUNCIL].add(_councilAddress);

        emit RoleGranted(Role.SAFETY_COUNCIL, _councilAddress, msg.sender);
    }

    function transferSecurityCouncil(address _newCouncil) internal {
        checkRole(Role.SAFETY_COUNCIL);
        uint256 owners = IGnosisSafeL2(_newCouncil).getOwners().length;
        if (owners < 5)
            revert Errors.MULTISIG_NOT_ENOUGH_OWNERS(_newCouncil, owners, 5);

        cs()._roles[Role.SAFETY_COUNCIL].members[msg.sender] = false;
        cs()._roleMembers[Role.SAFETY_COUNCIL].remove(msg.sender);

        cs()._roles[Role.SAFETY_COUNCIL].members[_newCouncil] = true;
        cs()._roleMembers[Role.SAFETY_COUNCIL].add(_newCouncil);
    }

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
    function grantRole(bytes32 role, address account) internal {
        checkRole(getRoleAdmin(role));
        _grantRole(role, account);
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * If `account` had been granted `role`, emits a {RoleRevoked} event.
     *
     * Requirements:
     *
     * - the caller must have ``role``'s admin role.
     */
    function revokeRole(bytes32 role, address account) internal {
        checkRole(getRoleAdmin(role));
        _revokeRole(role, account);
    }

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
     * Requirements:
     *
     * - the caller must be `account`.
     */
    function _renounceRole(bytes32 role, address account) internal {
        if (account != msg.sender)
            revert Errors.ACCESS_CONTROL_NOT_SELF(account, msg.sender);

        _revokeRole(role, account);
    }

    /**
     * @dev Sets `adminRole` as ``role``'s admin role.
     *
     * Emits a {RoleAdminChanged} event.
     */
    function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal {
        bytes32 previousAdminRole = getRoleAdmin(role);
        cs()._roles[role].adminRole = adminRole;
        emit RoleAdminChanged(role, previousAdminRole, adminRole);
    }

    /**
     * @dev Grants `role` to `account`.
     *
     * @notice Cannot grant the role `SAFETY_COUNCIL` - must be done via explicit function.
     *
     * Internal function without access restriction.
     */
    function _grantRole(
        bytes32 role,
        address account
    ) internal ensureNotSafetyCouncil(role) {
        if (!hasRole(role, account)) {
            cs()._roles[role].members[account] = true;
            cs()._roleMembers[role].add(account);
            emit RoleGranted(role, account, msg.sender);
        }
    }

    /**
     * @dev Revokes `role` from `account`.
     *
     * Internal function without access restriction.
     */
    function _revokeRole(bytes32 role, address account) internal {
        if (hasRole(role, account)) {
            cs()._roles[role].members[account] = false;
            cs()._roleMembers[role].remove(account);
            emit RoleRevoked(role, account, Meta.msgSender());
        }
    }

    /**
     * @dev Ensure we use the explicit `grantSafetyCouncilRole` function.
     */
    modifier ensureNotSafetyCouncil(bytes32 role) {
        if (role == Role.SAFETY_COUNCIL)
            revert Errors.SAFETY_COUNCIL_NOT_ALLOWED();
        _;
    }
}

interface IERC1155 {
    function balanceOf(
        address account,
        uint256 id
    ) external view returns (uint256);
}

library SGlobal {
    using WadRay for uint256;
    using PercentageMath for uint256;

    /**
     * @notice Checks whether the shared debt pool can be liquidated.
     * @notice Reverts if collateral value .
     */
    function ensureLiquidatableSCDP(SCDPState storage self) internal view {
        uint256 collateralValue = self.totalCollateralValueSCDP(false);
        uint256 minCollateralValue = sdi().effectiveDebtValue().percentMul(
            self.liquidationThreshold
        );
        if (collateralValue >= minCollateralValue) {
            revert Errors.COLLATERAL_VALUE_GREATER_THAN_REQUIRED(
                collateralValue,
                minCollateralValue,
                self.liquidationThreshold
            );
        }
    }

    /**
     * @notice Checks whether the shared debt pool can be liquidated.
     * @notice Reverts if collateral value .
     */
    function checkCoverableSCDP(SCDPState storage self) internal view {
        uint256 collateralValue = self.totalCollateralValueSCDP(false);
        uint256 minCollateralValue = sdi().effectiveDebtValue().percentMul(
            self.minCollateralRatio
        );
        if (collateralValue >= minCollateralValue) {
            revert Errors.COLLATERAL_VALUE_GREATER_THAN_REQUIRED(
                collateralValue,
                minCollateralValue,
                self.minCollateralRatio
            );
        }
    }

    /**
     * @notice Checks whether the collateral value is less than minimum required.
     * @notice Reverts when collateralValue is below minimum required.
     * @param _ratio Ratio to check in 1e4 percentage precision (uint32).
     */
    function ensureCollateralRatio(
        SCDPState storage self,
        uint32 _ratio
    ) internal view {
        uint256 collateralValue = self.totalCollateralValueSCDP(false);
        uint256 minCollateralValue = sdi().effectiveDebtValue().percentMul(
            _ratio
        );
        if (collateralValue < minCollateralValue) {
            revert Errors.COLLATERAL_VALUE_LESS_THAN_REQUIRED(
                collateralValue,
                minCollateralValue,
                _ratio
            );
        }
    }

    /**
     * @notice Returns the value of the krAsset held in the pool at a ratio.
     * @param _ratio Percentage ratio to apply for the value in 1e4 percentage precision (uint32).
     * @param _ignorekFactor Whether to ignore kFactor
     * @return totalValue Total value in USD
     */
    function totalDebtValueAtRatioSCDP(
        SCDPState storage self,
        uint32 _ratio,
        bool _ignorekFactor
    ) internal view returns (uint256 totalValue) {
        address[] memory assets = self.krAssets;
        for (uint256 i; i < assets.length; ) {
            Asset storage asset = cs().assets[assets[i]];
            uint256 debtAmount = asset.toRebasingAmount(
                self.assetData[assets[i]].debt
            );
            unchecked {
                if (debtAmount != 0) {
                    totalValue += asset.debtAmountToValue(
                        debtAmount,
                        _ignorekFactor
                    );
                }
                i++;
            }
        }

        // Multiply if needed
        if (_ratio != Percents.HUNDRED) {
            totalValue = totalValue.percentMul(_ratio);
        }
    }

    /**
     * @notice Calculates the total collateral value of collateral assets in the pool.
     * @param _ignoreFactors Whether to ignore cFactor.
     * @return totalValue Total value in USD
     */
    function totalCollateralValueSCDP(
        SCDPState storage self,
        bool _ignoreFactors
    ) internal view returns (uint256 totalValue) {
        address[] memory assets = self.collaterals;
        for (uint256 i; i < assets.length; ) {
            Asset storage asset = cs().assets[assets[i]];
            uint256 depositAmount = self.totalDepositAmount(assets[i], asset);
            if (depositAmount != 0) {
                unchecked {
                    totalValue += asset.collateralAmountToValue(
                        depositAmount,
                        _ignoreFactors
                    );
                }
            }

            unchecked {
                i++;
            }
        }
    }

    /**
     * @notice Calculates total collateral value while extracting single asset value.
     * @param _collateralAsset Collateral asset to extract value for
     * @param _ignoreFactors Whether to ignore cFactor.
     * @return totalValue Total value in USD
     * @return assetValue Asset value in USD
     */
    function totalCollateralValueSCDP(
        SCDPState storage self,
        address _collateralAsset,
        bool _ignoreFactors
    ) internal view returns (uint256 totalValue, uint256 assetValue) {
        address[] memory assets = self.collaterals;
        for (uint256 i; i < assets.length; ) {
            Asset storage asset = cs().assets[assets[i]];
            uint256 depositAmount = self.totalDepositAmount(assets[i], asset);
            unchecked {
                if (depositAmount != 0) {
                    uint256 value = asset.collateralAmountToValue(
                        depositAmount,
                        _ignoreFactors
                    );
                    totalValue += value;
                    if (assets[i] == _collateralAsset) {
                        assetValue = value;
                    }
                }
                i++;
            }
        }
    }

    /**
     * @notice Get pool collateral deposits of an asset.
     * @param _assetAddress The asset address
     * @param _asset The asset struct
     * @return Amount of scaled debt.
     */
    function totalDepositAmount(
        SCDPState storage self,
        address _assetAddress,
        Asset storage _asset
    ) internal view returns (uint128) {
        return
            uint128(
                _asset.toRebasingAmount(
                    self.assetData[_assetAddress].totalDeposits
                )
            );
    }

    /**
     * @notice Get pool user collateral deposits of an asset.
     * @param _assetAddress The asset address
     * @param _asset The asset struct
     * @return Amount of scaled debt.
     */
    function userDepositAmount(
        SCDPState storage self,
        address _assetAddress,
        Asset storage _asset
    ) internal view returns (uint256) {
        return
            _asset.toRebasingAmount(
                self.assetData[_assetAddress].totalDeposits -
                    self.assetData[_assetAddress].swapDeposits
            );
    }

    /**
     * @notice Get "swap" collateral deposits.
     * @param _assetAddress The asset address
     * @param _asset The asset struct.
     * @return Amount of debt.
     */
    function swapDepositAmount(
        SCDPState storage self,
        address _assetAddress,
        Asset storage _asset
    ) internal view returns (uint128) {
        return
            uint128(
                _asset.toRebasingAmount(
                    self.assetData[_assetAddress].swapDeposits
                )
            );
    }
}

library SDeposits {
    using WadRay for uint256;
    using WadRay for uint128;

    /**
     * @notice Records a deposit of collateral asset.
     * @dev Saves principal, scaled and global deposit amounts.
     * @param _asset Asset struct for the deposit asset
     * @param _account depositor
     * @param _assetAddr the deposit asset
     * @param _amount amount of collateral asset to deposit
     */
    function handleDepositSCDP(
        SCDPState storage self,
        Asset storage _asset,
        address _account,
        address _assetAddr,
        uint256 _amount
    ) internal {
        uint128 depositAmount = uint128(_asset.toNonRebasingAmount(_amount));

        unchecked {
            // Save global deposits.
            self.assetData[_assetAddr].totalDeposits += depositAmount;
            // Save principal deposits.
            self.depositsPrincipal[_account][_assetAddr] += depositAmount;
            // Save scaled deposits.
            self.deposits[_account][_assetAddr] += depositAmount
                .wadToRay()
                .rayDiv(_asset.liquidityIndexSCDP);
        }
        if (
            self.userDepositAmount(_assetAddr, _asset) > _asset.depositLimitSCDP
        ) {
            revert Errors.EXCEEDS_ASSET_DEPOSIT_LIMIT(
                Errors.id(_assetAddr),
                self.userDepositAmount(_assetAddr, _asset),
                _asset.depositLimitSCDP
            );
        }
    }

    /**
     * @notice Records a withdrawal of collateral asset from the SCDP.
     * @param _asset Asset struct for the deposit asset
     * @param _account The withdrawing account
     * @param _assetAddr the deposit asset
     * @param _amount The amount of collateral withdrawn
     * @return amountOut The actual amount of collateral withdrawn
     * @return feesOut The fees paid for during the withdrawal
     */
    function handleWithdrawSCDP(
        SCDPState storage self,
        Asset storage _asset,
        address _account,
        address _assetAddr,
        uint256 _amount
    ) internal returns (uint256 amountOut, uint256 feesOut) {
        // Get accounts principal deposits.
        uint256 depositsPrincipal = self.accountPrincipalDeposits(
            _account,
            _assetAddr,
            _asset
        );

        if (depositsPrincipal >= _amount) {
            // == Principal can cover possibly rebased `_amount` requested.
            // 1. We send out the requested amount.
            amountOut = _amount;
            // 2. No fees.
            // 3. Possibly un-rebased amount for internal bookeeping.
            uint128 amountWrite = uint128(_asset.toNonRebasingAmount(_amount));
            unchecked {
                // 4. Reduce global deposits.
                self.assetData[_assetAddr].totalDeposits -= amountWrite;
                // 5. Reduce principal deposits.
                self.depositsPrincipal[_account][_assetAddr] -= amountWrite;
                // 6. Reduce scaled deposits.
                self.deposits[_account][_assetAddr] -= amountWrite
                    .wadToRay()
                    .rayDiv(_asset.liquidityIndexSCDP);
            }
        } else {
            // == Principal can't cover possibly rebased `_amount` requested, send full collateral available.
            // 1. We send all collateral.
            amountOut = depositsPrincipal;
            // 2. With fees.
            uint256 scaledDeposits = self.accountScaledDeposits(
                _account,
                _assetAddr,
                _asset
            );
            feesOut = scaledDeposits - depositsPrincipal;
            // 3. Ensure this is actually the case.
            if (feesOut == 0) {
                revert Errors.NOTHING_TO_WITHDRAW(
                    _account,
                    Errors.id(_assetAddr),
                    _amount,
                    depositsPrincipal,
                    scaledDeposits
                );
            }

            // 4. Wipe account collateral deposits.
            self.depositsPrincipal[_account][_assetAddr] = 0;
            self.deposits[_account][_assetAddr] = 0;
            // 5. Reduce global by ONLY by the principal, fees are NOT collateral.
            self.assetData[_assetAddr].totalDeposits -= uint128(
                _asset.toNonRebasingAmount(depositsPrincipal)
            );
        }
    }

    /**
     * @notice This function seizes collateral from the shared pool
     * @notice Adjusts all deposits in the case where swap deposits do not cover the amount.
     * @param _sAsset The asset struct (Asset).
     * @param _assetAddr The seized asset address.
     * @param _seizeAmount The seize amount (uint256).
     */
    function handleSeizeSCDP(
        SCDPState storage self,
        Asset storage _sAsset,
        address _assetAddr,
        uint256 _seizeAmount
    ) internal {
        uint128 swapDeposits = self.swapDepositAmount(_assetAddr, _sAsset);

        if (swapDeposits >= _seizeAmount) {
            uint128 amountOut = uint128(
                _sAsset.toNonRebasingAmount(_seizeAmount)
            );
            // swap deposits cover the amount
            unchecked {
                self.assetData[_assetAddr].swapDeposits -= amountOut;
                self.assetData[_assetAddr].totalDeposits -= amountOut;
            }
        } else {
            // swap deposits do not cover the amount
            uint256 amountToCover = uint128(_seizeAmount - swapDeposits);
            // reduce everyones deposits by the same ratio
            _sAsset.liquidityIndexSCDP -= uint128(
                amountToCover.wadToRay().rayDiv(
                    self.userDepositAmount(_assetAddr, _sAsset).wadToRay()
                )
            );
            self.assetData[_assetAddr].swapDeposits = 0;
            self.assetData[_assetAddr].totalDeposits -= uint128(
                _sAsset.toNonRebasingAmount(amountToCover)
            );
        }
    }
}

library SAccounts {
    using WadRay for uint256;

    /**
     * @notice Get accounts deposit amount that is scaled by the liquidity index.
     * @notice The liquidity index is updated when: A) Income is accrued B) Liquidation occurs.
     * @param _account The account to get the amount for
     * @param _assetAddr The asset address
     * @param _asset The asset struct
     * @return Amount of scaled debt.
     */
    function accountScaledDeposits(
        SCDPState storage self,
        address _account,
        address _assetAddr,
        Asset storage _asset
    ) internal view returns (uint256) {
        uint256 deposits = _asset.toRebasingAmount(
            self.deposits[_account][_assetAddr]
        );
        if (deposits == 0) {
            return 0;
        }
        return deposits.rayMul(_asset.liquidityIndexSCDP).rayToWad();
    }

    /**
     * @notice Get accounts principal deposits.
     * @notice Uses scaled deposits if its lower than principal (realizing liquidations).
     * @param _account The account to get the amount for
     * @param _assetAddr The deposit asset address
     * @param _asset The deposit asset struct
     * @return principalDeposits The principal deposit amount for the account.
     */
    function accountPrincipalDeposits(
        SCDPState storage self,
        address _account,
        address _assetAddr,
        Asset storage _asset
    ) internal view returns (uint256 principalDeposits) {
        uint256 scaledDeposits = self.accountScaledDeposits(
            _account,
            _assetAddr,
            _asset
        );
        if (scaledDeposits == 0) {
            return 0;
        }

        uint256 depositsPrincipal = _asset.toRebasingAmount(
            self.depositsPrincipal[_account][_assetAddr]
        );
        if (scaledDeposits < depositsPrincipal) {
            return scaledDeposits;
        }
        return depositsPrincipal;
    }

    /**
     * @notice Returns the value of the deposits for `_account`.
     * @param _account Account to get total deposit value for
     * @param _ignoreFactors Whether to ignore cFactor and kFactor
     */
    function accountTotalDepositValue(
        SCDPState storage self,
        address _account,
        bool _ignoreFactors
    ) internal view returns (uint256 totalValue) {
        address[] memory assets = self.collaterals;
        for (uint256 i; i < assets.length; ) {
            Asset storage asset = cs().assets[assets[i]];
            uint256 depositAmount = self.accountPrincipalDeposits(
                _account,
                assets[i],
                asset
            );
            unchecked {
                if (depositAmount != 0) {
                    totalValue += asset.collateralAmountToValue(
                        depositAmount,
                        _ignoreFactors
                    );
                }
                i++;
            }
        }
    }

    /**
     * @notice Returns the value of the collateral assets in the pool for `_account` for the scaled deposit amount.
     * @notice Ignores all factors.
     * @param _account account
     */
    function accountTotalScaledDepositsValue(
        SCDPState storage self,
        address _account
    ) internal view returns (uint256 totalValue) {
        address[] memory assets = self.collaterals;
        for (uint256 i; i < assets.length; ) {
            Asset storage asset = cs().assets[assets[i]];
            uint256 scaledDeposits = self.accountScaledDeposits(
                _account,
                assets[i],
                asset
            );
            unchecked {
                if (scaledDeposits != 0) {
                    totalValue += asset.collateralAmountToValue(
                        scaledDeposits,
                        true
                    );
                }
                i++;
            }
        }
    }
}

error APPROVE_FAILED(address, address, address, uint256);
error ETH_TRANSFER_FAILED(address, uint256);
error TRANSFER_FAILED(address, address, address, uint256);

/// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/SafeTransferLib.sol)
/// @dev Use with caution! Some functions in this library knowingly create dirty bits at the destination of the free memory pointer.
/// @dev Note that none of the functions in this library check that a token has code at all! That responsibility is delegated to the caller.
library SafeTransfer {
    /*//////////////////////////////////////////////////////////////
                             ETH OPERATIONS
    //////////////////////////////////////////////////////////////*/

    function safeTransferETH(address to, uint256 amount) internal {
        bool success;

        /// @solidity memory-safe-assembly
        assembly {
            // Transfer the ETH and store if it succeeded or not.
            success := call(gas(), to, amount, 0, 0, 0, 0)
        }

        if (!success) revert ETH_TRANSFER_FAILED(to, amount);
    }

    /*//////////////////////////////////////////////////////////////
                            ERC20 OPERATIONS
    //////////////////////////////////////////////////////////////*/

    function safeTransferFrom(
        IERC20 token,
        address from,
        address to,
        uint256 amount
    ) internal {
        bool success;

        /// @solidity memory-safe-assembly
        assembly {
            // Get a pointer to some free memory.
            let freeMemoryPointer := mload(0x40)

            // Write the abi-encoded calldata into memory, beginning with the function selector.
            mstore(
                freeMemoryPointer,
                0x23b872dd00000000000000000000000000000000000000000000000000000000
            )
            mstore(
                add(freeMemoryPointer, 4),
                and(from, 0xffffffffffffffffffffffffffffffffffffffff)
            ) // Append and mask the "from" argument.
            mstore(
                add(freeMemoryPointer, 36),
                and(to, 0xffffffffffffffffffffffffffffffffffffffff)
            ) // Append and mask the "to" argument.
            mstore(add(freeMemoryPointer, 68), amount) // Append the "amount" argument. Masking not required as it's a full 32 byte type.

            success := and(
                // Set success to whether the call reverted, if not we check it either
                // returned exactly 1 (can't just be non-zero data), or had no return data.
                or(
                    and(eq(mload(0), 1), gt(returndatasize(), 31)),
                    iszero(returndatasize())
                ),
                // We use 100 because the length of our calldata totals up like so: 4 + 32 * 3.
                // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
                // Counterintuitively, this call must be positioned second to the or() call in the
                // surrounding and() call or else returndatasize() will be zero during the computation.
                call(gas(), token, 0, freeMemoryPointer, 100, 0, 32)
            )
        }

        if (!success) revert TRANSFER_FAILED(address(token), from, to, amount);
    }

    function safeTransfer(IERC20 token, address to, uint256 amount) internal {
        bool success;

        /// @solidity memory-safe-assembly
        assembly {
            // Get a pointer to some free memory.
            let freeMemoryPointer := mload(0x40)

            // Write the abi-encoded calldata into memory, beginning with the function selector.
            mstore(
                freeMemoryPointer,
                0xa9059cbb00000000000000000000000000000000000000000000000000000000
            )
            mstore(
                add(freeMemoryPointer, 4),
                and(to, 0xffffffffffffffffffffffffffffffffffffffff)
            ) // Append and mask the "to" argument.
            mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument. Masking not required as it's a full 32 byte type.

            success := and(
                // Set success to whether the call reverted, if not we check it either
                // returned exactly 1 (can't just be non-zero data), or had no return data.
                or(
                    and(eq(mload(0), 1), gt(returndatasize(), 31)),
                    iszero(returndatasize())
                ),
                // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
                // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
                // Counterintuitively, this call must be positioned second to the or() call in the
                // surrounding and() call or else returndatasize() will be zero during the computation.
                call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
            )
        }

        if (!success)
            revert TRANSFER_FAILED(address(token), msg.sender, to, amount);
    }

    function safeApprove(IERC20 token, address to, uint256 amount) internal {
        bool success;

        /// @solidity memory-safe-assembly
        assembly {
            // Get a pointer to some free memory.
            let freeMemoryPointer := mload(0x40)

            // Write the abi-encoded calldata into memory, beginning with the function selector.
            mstore(
                freeMemoryPointer,
                0x095ea7b300000000000000000000000000000000000000000000000000000000
            )
            mstore(
                add(freeMemoryPointer, 4),
                and(to, 0xffffffffffffffffffffffffffffffffffffffff)
            ) // Append and mask the "to" argument.
            mstore(add(freeMemoryPointer, 36), amount) // Append the "amount" argument. Masking not required as it's a full 32 byte type.

            success := and(
                // Set success to whether the call reverted, if not we check it either
                // returned exactly 1 (can't just be non-zero data), or had no return data.
                or(
                    and(eq(mload(0), 1), gt(returndatasize(), 31)),
                    iszero(returndatasize())
                ),
                // We use 68 because the length of our calldata totals up like so: 4 + 32 * 2.
                // We use 0 and 32 to copy up to 32 bytes of return data into the scratch space.
                // Counterintuitively, this call must be positioned second to the or() call in the
                // surrounding and() call or else returndatasize() will be zero during the computation.
                call(gas(), token, 0, freeMemoryPointer, 68, 0, 32)
            )
        }

        if (!success)
            revert APPROVE_FAILED(address(token), msg.sender, to, amount);
    }
}

/* -------------------------------------------------------------------------- */
/*                                   Actions                                  */
/* -------------------------------------------------------------------------- */

/// @notice Burn kresko assets with anchor already known.
/// @param _burnAmount The amount being burned
/// @param _fromAddr The account to burn assets from.
/// @param _anchorAddr The anchor token of the asset being burned.
function burnKrAsset(
    uint256 _burnAmount,
    address _fromAddr,
    address _anchorAddr
) returns (uint256 burned) {
    burned = IKreskoAssetIssuer(_anchorAddr).destroy(_burnAmount, _fromAddr);
    if (burned == 0) revert Errors.ZERO_BURN(Errors.id(_anchorAddr));
}

/// @notice Mint kresko assets with anchor already known.
/// @param _mintAmount The asset amount being minted
/// @param _toAddr The account receiving minted assets.
/// @param _anchorAddr The anchor token of the minted asset.
function mintKrAsset(
    uint256 _mintAmount,
    address _toAddr,
    address _anchorAddr
) returns (uint256 minted) {
    minted = IKreskoAssetIssuer(_anchorAddr).issue(_mintAmount, _toAddr);
    if (minted == 0) revert Errors.ZERO_MINT(Errors.id(_anchorAddr));
}

/// @notice Repay SCDP swap debt.
/// @param _asset the asset being repaid
/// @param _burnAmount the asset amount being burned
/// @param _fromAddr the account to burn assets from
function burnSCDP(
    Asset storage _asset,
    uint256 _burnAmount,
    address _fromAddr
) returns (uint256 destroyed) {
    destroyed = burnKrAsset(_burnAmount, _fromAddr, _asset.anchor);
    sdi().totalDebt -= _asset.debtAmountToSDI(destroyed, false);
}

/// @notice Mint kresko assets from SCDP swap.
/// @param _asset the asset requested
/// @param _mintAmount the asset amount requested
/// @param _toAddr the account to mint the assets to
function mintSCDP(
    Asset storage _asset,
    uint256 _mintAmount,
    address _toAddr
) returns (uint256 issued) {
    issued = mintKrAsset(_mintAmount, _toAddr, _asset.anchor);
    unchecked {
        sdi().totalDebt += _asset.debtAmountToSDI(issued, false);
    }
}

library Swap {
    using WadRay for uint256;
    using SafeTransfer for IERC20;

    /**
     * @notice Records the assets received from account in a swap.
     * Burning any existing shared debt or increasing collateral deposits.
     * @param _assetInAddr The asset received.
     * @param _assetIn The asset in struct.
     * @param _amountIn The amount of the asset received.
     * @param _assetsFrom The account that holds the assets to burn.
     * @return The value of the assets received into the protocol, used to calculate assets out.
     */
    function handleAssetsIn(
        SCDPState storage self,
        address _assetInAddr,
        Asset storage _assetIn,
        uint256 _amountIn,
        address _assetsFrom
    ) internal returns (uint256) {
        SCDPAssetData storage assetData = self.assetData[_assetInAddr];
        uint256 debt = _assetIn.toRebasingAmount(assetData.debt);

        uint256 collateralIn; // assets used increase "swap" owned collateral
        uint256 debtOut; // assets used to burn debt

        if (debt < _amountIn) {
            // == Debt is less than the amount received.
            // 1. Burn full debt.
            debtOut = debt;
            // 2. Increase collateral by remainder.
            unchecked {
                collateralIn = _amountIn - debt;
            }
        } else {
            // == Debt is greater than the amount.
            // 1. Burn full amount received.
            debtOut = _amountIn;
            // 2. No increase in collateral.
        }

        if (collateralIn > 0) {
            uint128 collateralInWrite = uint128(
                _assetIn.toNonRebasingAmount(collateralIn)
            );
            unchecked {
                // 1. Increase collateral deposits.
                assetData.totalDeposits += collateralInWrite;
                // 2. Increase "swap" collateral.
                assetData.swapDeposits += collateralInWrite;
            }
        }

        if (debtOut > 0) {
            unchecked {
                // 1. Burn debt that was repaid from the assets received.
                assetData.debt -= burnSCDP(_assetIn, debtOut, _assetsFrom);
            }
        }

        assert(_amountIn == debtOut + collateralIn);
        return _assetIn.debtAmountToValue(_amountIn, true); // ignore kFactor here
    }

    /**
     * @notice Records the assets to send out in a swap.
     * Increasing debt of the pool by minting new assets when required.
     * @param _assetOutAddr The asset to send out.
     * @param _assetOut The asset out struct.
     * @param _valueIn The value received in.
     * @param _assetsTo The asset receiver.
     * @return amountOut The amount of the asset out.
     */
    function handleAssetsOut(
        SCDPState storage self,
        address _assetOutAddr,
        Asset storage _assetOut,
        uint256 _valueIn,
        address _assetsTo
    ) internal returns (uint256 amountOut) {
        SCDPAssetData storage assetData = self.assetData[_assetOutAddr];
        uint128 swapDeposits = uint128(
            _assetOut.toRebasingAmount(assetData.swapDeposits)
        ); // current "swap" collateral

        // Calculate amount to send out from value received in.
        amountOut = _assetOut.debtValueToAmount(_valueIn, true);

        uint256 collateralOut; // decrease in "swap" collateral
        uint256 debtIn; // new debt required to mint

        if (swapDeposits < amountOut) {
            // == "Swap" owned collateral is less than requested amount.
            // 1. Issue debt for remainder.
            unchecked {
                debtIn = amountOut - swapDeposits;
            }
            // 2. Reduce "swap" owned collateral to zero.
            collateralOut = swapDeposits;
        } else {
            // == "Swap" owned collateral exceeds requested amount
            // 1. No debt issued.
            // 2. Decrease collateral by full amount.
            collateralOut = amountOut;
        }

        if (collateralOut > 0) {
            uint128 amountOutInternal = uint128(
                _assetOut.toNonRebasingAmount(collateralOut)
            );
            unchecked {
                // 1. Decrease collateral deposits.
                assetData.totalDeposits -= amountOutInternal;
                // 2. Decrease "swap" owned collateral.
                assetData.swapDeposits -= amountOutInternal;
            }
            if (_assetsTo != address(this)) {
                // 3. Transfer collateral to receiver if it is not this contract.
                IERC20(_assetOutAddr).safeTransfer(_assetsTo, collateralOut);
            }
        }

        if (debtIn > 0) {
            // 1. Issue required debt to the pool, minting new assets to receiver.
            unchecked {
                assetData.debt += mintSCDP(_assetOut, debtIn, _assetsTo);
                uint256 newTotalDebt = _assetOut.toRebasingAmount(
                    assetData.debt
                );
                if (newTotalDebt > _assetOut.maxDebtSCDP) {
                    revert Errors.EXCEEDS_ASSET_MINTING_LIMIT(
                        Errors.id(_assetOutAddr),
                        newTotalDebt,
                        _assetOut.maxDebtSCDP
                    );
                }
            }
        }

        assert(amountOut == debtIn + collateralOut);
    }

    /**
     * @notice Accumulates fees to deposits as a fixed, instantaneous income.
     * @param _assetAddr The asset address
     * @param _asset The asset struct
     * @param _amount The amount to accumulate
     * @return nextLiquidityIndex The next liquidity index of the reserve
     */
    function cumulateIncome(
        SCDPState storage self,
        address _assetAddr,
        Asset storage _asset,
        uint256 _amount
    ) internal returns (uint256 nextLiquidityIndex) {
        if (_amount == 0) {
            revert Errors.INCOME_AMOUNT_IS_ZERO(Errors.id(_assetAddr));
        }

        uint256 userDeposits = self.userDepositAmount(_assetAddr, _asset);
        if (userDeposits == 0) {
            revert Errors.NO_LIQUIDITY_TO_GIVE_INCOME_FOR(
                Errors.id(_assetAddr),
                userDeposits,
                self.totalDepositAmount(_assetAddr, _asset)
            );
        }
        // liquidity index increment is calculated this way: `(amount / totalLiquidity)`
        // division `amount / totalLiquidity` done in ray for precision
        unchecked {
            return (_asset.liquidityIndexSCDP += uint128(
                (_amount.wadToRay().rayDiv(userDeposits.wadToRay()))
            ));
        }
    }
}

library SDebtIndex {
    using SafeTransfer for IERC20;
    using WadRay for uint256;

    function valueToSDI(
        uint256 valueIn,
        uint8 oracleDecimals
    ) internal view returns (uint256) {
        return (valueIn * 10 ** oracleDecimals).wadDiv(SDIPrice());
    }

    /// @notice Cover by pulling assets.
    function cover(
        SDIState storage self,
        address _assetAddr,
        uint256 _amount
    ) internal returns (uint256 shares, uint256 value) {
        if (_amount == 0) revert Errors.ZERO_AMOUNT(Errors.id(_assetAddr));
        Asset storage asset = cs().onlyCoverAsset(_assetAddr);

        value = wadUSD(
            _amount,
            asset.decimals,
            asset.price(),
            cs().oracleDecimals
        );
        self.totalCover += (shares = valueToSDI(value, cs().oracleDecimals));

        IERC20(_assetAddr).safeTransferFrom(
            msg.sender,
            self.coverRecipient,
            _amount
        );
    }

    /// @notice Returns the total effective debt amount of the SCDP.
    function effectiveDebt(
        SDIState storage self
    ) internal view returns (uint256) {
        uint256 currentCover = self.totalCoverAmount();
        uint256 totalDebt = self.totalDebt;
        if (currentCover >= totalDebt) {
            return 0;
        }
        return (totalDebt - currentCover);
    }

    /// @notice Returns the total effective debt value of the SCDP.
    function effectiveDebtValue(
        SDIState storage self
    ) internal view returns (uint256) {
        uint256 sdiPrice = SDIPrice();
        uint256 coverValue = self.totalCoverValue();
        uint256 coverAmount = coverValue != 0 ? coverValue.wadDiv(sdiPrice) : 0;
        uint256 totalDebt = self.totalDebt;

        if (coverValue == 0) return totalDebt.wadMul(sdiPrice);
        if (coverAmount >= totalDebt) return 0;

        return (totalDebt - coverAmount).wadMul(sdiPrice);
    }

    function totalCoverAmount(
        SDIState storage self
    ) internal view returns (uint256) {
        return self.totalCoverValue().wadDiv(SDIPrice());
    }

    /// @notice Gets the total cover debt value, oracle precision
    function totalCoverValue(
        SDIState storage self
    ) internal view returns (uint256 result) {
        address[] memory assets = self.coverAssets;
        for (uint256 i; i < assets.length; ) {
            unchecked {
                result += coverAssetValue(self, assets[i]);
                i++;
            }
        }
    }

    /// @notice Simply returns the total supply of SDI.
    function totalSDI(SDIState storage self) internal view returns (uint256) {
        return self.totalDebt + self.totalCoverAmount();
    }

    /// @notice Get total deposit value of `asset` in USD, oracle precision.
    function coverAssetValue(
        SDIState storage self,
        address _assetAddr
    ) internal view returns (uint256) {
        uint256 bal = IERC20(_assetAddr).balanceOf(self.coverRecipient);
        if (bal == 0) return 0;

        Asset storage asset = cs().assets[_assetAddr];
        if (!asset.isCoverAsset) return 0;
        return (bal * asset.price()) / 10 ** asset.decimals;
    }
}

/* -------------------------------------------------------------------------- */
/*                                   Usings                                   */
/* -------------------------------------------------------------------------- */

using SGlobal for SCDPState global;
using SDeposits for SCDPState global;
using SAccounts for SCDPState global;
using Swap for SCDPState global;
using SDebtIndex for SDIState global;

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
    address[] coverAssets;
    uint8 sdiPricePrecision;
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

library LibModifiers {
    /// @dev Simple check for the enabled flag
    /// @param _assetAddr The address of the asset.
    /// @param _action The action to this is called from.
    /// @return asset The asset struct.
    function onlyUnpaused(
        CommonState storage self,
        address _assetAddr,
        Enums.Action _action
    ) internal view returns (Asset storage asset) {
        if (
            self.safetyStateSet &&
            self.safetyState[_assetAddr][_action].pause.enabled
        ) {
            revert Errors.ASSET_PAUSED_FOR_THIS_ACTION(
                Errors.id(_assetAddr),
                uint8(_action)
            );
        }
        return self.assets[_assetAddr];
    }

    function onlyExistingAsset(
        CommonState storage self,
        address _assetAddr
    ) internal view returns (Asset storage asset) {
        asset = self.assets[_assetAddr];
        if (!asset.exists()) {
            revert Errors.ASSET_DOES_NOT_EXIST(Errors.id(_assetAddr));
        }
    }

    /**
     * @notice Reverts if address is not a minter collateral asset.
     * @param _assetAddr The address of the asset.
     * @return asset The asset struct.
     */
    function onlyMinterCollateral(
        CommonState storage self,
        address _assetAddr
    ) internal view returns (Asset storage asset) {
        asset = self.assets[_assetAddr];
        if (!asset.isMinterCollateral) {
            revert Errors.ASSET_NOT_MINTER_COLLATERAL(Errors.id(_assetAddr));
        }
    }

    function onlyMinterCollateral(
        CommonState storage self,
        address _assetAddr,
        Enums.Action _action
    ) internal view returns (Asset storage asset) {
        asset = onlyUnpaused(self, _assetAddr, _action);
        if (!asset.isMinterCollateral) {
            revert Errors.ASSET_NOT_MINTER_COLLATERAL(Errors.id(_assetAddr));
        }
    }

    /**
     * @notice Reverts if address is not a Kresko Asset.
     * @param _assetAddr The address of the asset.
     * @return asset The asset struct.
     */
    function onlyMinterMintable(
        CommonState storage self,
        address _assetAddr
    ) internal view returns (Asset storage asset) {
        asset = self.assets[_assetAddr];
        if (!asset.isMinterMintable) {
            revert Errors.ASSET_NOT_MINTABLE_FROM_MINTER(Errors.id(_assetAddr));
        }
    }

    function onlyMinterMintable(
        CommonState storage self,
        address _assetAddr,
        Enums.Action _action
    ) internal view returns (Asset storage asset) {
        asset = onlyUnpaused(self, _assetAddr, _action);
        if (!asset.isMinterMintable) {
            revert Errors.ASSET_NOT_MINTABLE_FROM_MINTER(Errors.id(_assetAddr));
        }
    }

    /**
     * @notice Reverts if address is not depositable to SCDP.
     * @param _assetAddr The address of the asset.
     * @return asset The asset struct.
     */
    function onlySharedCollateral(
        CommonState storage self,
        address _assetAddr
    ) internal view returns (Asset storage asset) {
        asset = self.assets[_assetAddr];
        if (!asset.isSharedCollateral) {
            revert Errors.ASSET_NOT_DEPOSITABLE(Errors.id(_assetAddr));
        }
    }

    /**
     * @notice Reverts if address is not swappable Kresko Asset.
     * @param _assetAddr The address of the asset.
     * @return asset The asset struct.
     */
    function onlySwapMintable(
        CommonState storage self,
        address _assetAddr
    ) internal view returns (Asset storage asset) {
        asset = self.assets[_assetAddr];
        if (!asset.isSwapMintable) {
            revert Errors.ASSET_NOT_SWAPPABLE(Errors.id(_assetAddr));
        }
    }

    function onlyActiveSharedCollateral(
        CommonState storage self,
        address _assetAddr
    ) internal view returns (Asset storage asset) {
        asset = self.assets[_assetAddr];
        if (asset.liquidityIndexSCDP == 0) {
            revert Errors.ASSET_DOES_NOT_HAVE_DEPOSITS(Errors.id(_assetAddr));
        }
    }

    function onlyCoverAsset(
        CommonState storage self,
        address _assetAddr
    ) internal view returns (Asset storage asset) {
        asset = self.assets[_assetAddr];
        if (!asset.isCoverAsset) {
            revert Errors.ASSET_CANNOT_BE_USED_TO_COVER(Errors.id(_assetAddr));
        }
    }

    function onlyIncomeAsset(
        CommonState storage self,
        address _assetAddr
    ) internal view returns (Asset storage asset) {
        if (_assetAddr != scdp().feeAsset) revert Errors.NOT_SUPPORTED_YET();
        asset = onlyActiveSharedCollateral(self, _assetAddr);
        if (!asset.isSharedCollateral)
            revert Errors.ASSET_NOT_DEPOSITABLE(Errors.id(_assetAddr));
    }
}

contract Modifiers {
    /**
     * @dev Modifier that checks if the contract is initializing and if so, gives the caller the ADMIN role
     */
    modifier initializeAsAdmin() {
        if (ds().initializing != Constants.INITIALIZING)
            revert Errors.NOT_INITIALIZING();
        if (!Auth.hasRole(Role.ADMIN, msg.sender)) {
            Auth._grantRole(Role.ADMIN, msg.sender);
            _;
            Auth._revokeRole(Role.ADMIN, msg.sender);
        } else {
            _;
        }
    }
    /**
     * @dev Modifier that checks that an account has a specific role. Reverts
     * with a standardized message including the required role.
     *
     * The format of the revert reason is given by the following regular expression:
     *
     *  /^AccessControl: account (0x[0-9a-f]{40}) is missing role (0x[0-9a-f]{64})$/
     *
     * _Available since v4.1._
     */
    modifier onlyRole(bytes32 role) {
        Auth.checkRole(role);
        _;
    }

    /**
     * @notice Ensure only trusted contracts can act on behalf of `_account`
     * @param _accountIsNotMsgSender The address of the collateral asset.
     */
    modifier onlyRoleIf(bool _accountIsNotMsgSender, bytes32 role) {
        if (_accountIsNotMsgSender) {
            Auth.checkRole(role);
        }
        _;
    }

    modifier nonReentrant() {
        if (cs().entered == Constants.ENTERED) {
            revert Errors.CANNOT_RE_ENTER();
        }
        cs().entered = Constants.ENTERED;
        _;
        cs().entered = Constants.NOT_ENTERED;
    }

    /// @notice Reverts if the caller does not have the required NFT's for the gated phase
    modifier gate() {
        uint8 phase = gs().phase;
        if (phase <= 2) {
            if (IERC1155(gs().kreskian).balanceOf(msg.sender, 0) == 0) {
                revert Errors.MISSING_PHASE_3_NFT();
            }
        }
        if (phase == 1) {
            IERC1155 questForKresk = IERC1155(gs().questForKresk);
            if (
                questForKresk.balanceOf(msg.sender, 2) == 0 &&
                questForKresk.balanceOf(msg.sender, 3) == 0
            ) {
                revert Errors.MISSING_PHASE_2_NFT();
            }
        } else if (phase == 0) {
            if (IERC1155(gs().questForKresk).balanceOf(msg.sender, 3) > 0) {
                revert Errors.MISSING_PHASE_1_NFT();
            }
        }
        _;
    }
}

using LibModifiers for CommonState global;

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
    /// @notice The minimum USD value of an individual synthetic asset debt position.
    uint96 minDebtValue;
    /* -------------------------------------------------------------------------- */
    /*                             Oracle & Sequencer                             */
    /* -------------------------------------------------------------------------- */
    /// @notice L2 sequencer feed address
    address sequencerUptimeFeed;
    /// @notice grace period of sequencer in seconds
    uint32 sequencerGracePeriodTime;
    /// @notice Time in seconds for a feed to be considered stale
    uint32 staleTime;
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

struct GatingState {
    address kreskian;
    address questForKresk;
    uint8 phase;
}

/* -------------------------------------------------------------------------- */
/*                                   Getter                                   */
/* -------------------------------------------------------------------------- */

// Storage position
bytes32 constant COMMON_STORAGE_POSITION = keccak256("kresko.common.storage");

function cs() pure returns (CommonState storage state) {
    bytes32 position = bytes32(COMMON_STORAGE_POSITION);
    assembly {
        state.slot := position
    }
}

bytes32 constant GATING_STORAGE_POSITION = keccak256("kresko.gating.storage");

function gs() pure returns (GatingState storage state) {
    bytes32 position = bytes32(GATING_STORAGE_POSITION);
    assembly {
        state.slot := position
    }
}

/**
 * @notice Checks if the L2 sequencer is up.
 * 1 means the sequencer is down, 0 means the sequencer is up.
 * @param _uptimeFeed The address of the uptime feed.
 * @param _gracePeriod The grace period in seconds.
 * @return bool returns true/false if the sequencer is up/not.
 */
function isSequencerUp(
    address _uptimeFeed,
    uint256 _gracePeriod
) view returns (bool) {
    bool up = true;
    if (_uptimeFeed != address(0)) {
        (, int256 answer, uint256 startedAt, , ) = IAggregatorV3(_uptimeFeed)
            .latestRoundData();

        up = answer == 0;
        if (!up) {
            return false;
        }
        // Make sure the grace period has passed after the
        // sequencer is back up.
        if (block.timestamp - startedAt < _gracePeriod) {
            return false;
        }
    }
    return up;
}

using WadRay for uint256;
using PercentageMath for uint256;
using Strings for bytes32;

/* -------------------------------------------------------------------------- */
/*                                   Getters                                  */
/* -------------------------------------------------------------------------- */

/**
 * @notice Gets the oracle price using safety checks for deviation and sequencer uptime
 * @notice Reverts when price deviates more than `_oracleDeviationPct`
 * @param _ticker Ticker of the price
 * @param _oracles The list of oracle identifiers
 * @param _oracleDeviationPct the deviation percentage
 */
function safePrice(
    bytes32 _ticker,
    Enums.OracleType[2] memory _oracles,
    uint256 _oracleDeviationPct
) view returns (uint256) {
    uint256[2] memory prices = [
        oraclePrice(_oracles[0], _ticker),
        oraclePrice(_oracles[1], _ticker)
    ];
    if (prices[0] == 0 && prices[1] == 0) {
        revert Errors.ZERO_OR_STALE_PRICE(
            _ticker.toString(),
            [uint8(_oracles[0]), uint8(_oracles[1])]
        );
    }

    // Enums.OracleType.Vault uses the same check, reverting if the sequencer is down.
    if (
        _oracles[0] != Enums.OracleType.Vault &&
        !isSequencerUp(cs().sequencerUptimeFeed, cs().sequencerGracePeriodTime)
    ) {
        return handleSequencerDown(_oracles, prices);
    }

    return deducePrice(prices[0], prices[1], _oracleDeviationPct);
}

/**
 * @notice Call the price getter for the oracle provided and return the price.
 * @param _oracleId The oracle id (uint8).
 * @param _ticker Ticker for the asset
 * @return uint256 oracle price.
 * This will return 0 if the oracle is not set.
 */
function oraclePrice(
    Enums.OracleType _oracleId,
    bytes32 _ticker
) view returns (uint256) {
    if (_oracleId == Enums.OracleType.Empty) return 0;
    if (_oracleId == Enums.OracleType.Redstone)
        return Redstone.getPrice(_ticker);

    Oracle storage oracle = cs().oracles[_ticker][_oracleId];
    return oracle.priceGetter(oracle.feed);
}

/**
 * @notice Checks the primary and reference price for deviations.
 * @notice Reverts if the price deviates more than `_oracleDeviationPct`
 * @param _primaryPrice the primary price source to use
 * @param _referencePrice the reference price to compare primary against
 * @param _oracleDeviationPct the deviation percentage to use for the oracle
 * @return uint256 Primary price if its within deviation range of reference price.
 * = the primary price is reference price is 0.
 * = the reference price if primary price is 0.
 * = reverts if price deviates more than `_oracleDeviationPct`
 */
function deducePrice(
    uint256 _primaryPrice,
    uint256 _referencePrice,
    uint256 _oracleDeviationPct
) pure returns (uint256) {
    if (_referencePrice == 0 && _primaryPrice != 0) return _primaryPrice;
    if (_primaryPrice == 0 && _referencePrice != 0) return _referencePrice;
    if (
        (_referencePrice.percentMul(1e4 - _oracleDeviationPct) <=
            _primaryPrice) &&
        (_referencePrice.percentMul(1e4 + _oracleDeviationPct) >= _primaryPrice)
    ) {
        return _primaryPrice;
    }

    // Revert if price deviates more than `_oracleDeviationPct`
    revert Errors.PRICE_UNSTABLE(
        _primaryPrice,
        _referencePrice,
        _oracleDeviationPct
    );
}

/**
 * @notice Handles the prices in case the sequencer is down.
 * @notice Looks for redstone price, reverting if not available for asset.
 * @param oracles The oracle types.
 * @param prices The fetched oracle prices.
 * @return uint256 Usable price of the asset.
 */
function handleSequencerDown(
    Enums.OracleType[2] memory oracles,
    uint256[2] memory prices
) pure returns (uint256) {
    if (oracles[0] == Enums.OracleType.Redstone && prices[0] != 0) {
        return prices[0];
    } else if (oracles[1] == Enums.OracleType.Redstone && prices[1] != 0) {
        return prices[1];
    }
    revert Errors.L2_SEQUENCER_DOWN();
}

/**
 * @notice Gets the price from the provided vault.
 * @dev Vault exchange rate is in 18 decimal precision so we normalize to 8 decimals.
 * @param _vaultAddr The vault address.
 * @return uint256 The price of the vault share in 8 decimal precision.
 */
function vaultPrice(address _vaultAddr) view returns (uint256) {
    return IVaultRateProvider(_vaultAddr).exchangeRate() / 1e10;
}

/// @notice Get the price of SDI in USD, oracle precision.
function SDIPrice() view returns (uint256) {
    uint256 totalValue = scdp().totalDebtValueAtRatioSCDP(
        Percents.HUNDRED,
        false
    );
    if (totalValue == 0) {
        return 10 ** sdi().sdiPricePrecision;
    }
    return totalValue.wadDiv(sdi().totalDebt);
}

/**
 * @notice Gets answer from AggregatorV3 type feed.
 * @param _feedAddr The feed address.
 * @param _staleTime Time in seconds for the feed to be considered stale.
 * @return uint256 Parsed answer from the feed, 0 if its stale.
 */
function aggregatorV3Price(
    address _feedAddr,
    uint256 _staleTime
) view returns (uint256) {
    (, int256 answer, , uint256 updatedAt, ) = IAggregatorV3(_feedAddr)
        .latestRoundData();
    if (answer < 0) {
        revert Errors.NEGATIVE_PRICE(_feedAddr, answer);
    }
    // IMPORTANT: Returning zero when answer is stale, to activate fallback oracle.
    if (block.timestamp - updatedAt > _staleTime) {
        return 0;
    }
    return uint256(answer);
}

/**
 * @notice Gets answer from IAPI3 type feed.
 * @param _feedAddr The feed address.
 * @param _staleTime Staleness threshold.
 * @return uint256 Parsed answer from the feed, 0 if its stale.
 */
function API3Price(
    address _feedAddr,
    uint256 _staleTime
) view returns (uint256) {
    (int256 answer, uint256 updatedAt) = IAPI3(_feedAddr).read();
    if (answer < 0) {
        revert Errors.NEGATIVE_PRICE(_feedAddr, answer);
    }
    // IMPORTANT: Returning zero when answer is stale, to activate fallback oracle.
    if (block.timestamp - updatedAt > _staleTime) {
        return 0;
    }
    return uint256(answer / 1e10); // @todo actual decimals
}

/* -------------------------------------------------------------------------- */
/*                                    Util                                    */
/* -------------------------------------------------------------------------- */

/**
 * @notice Gets raw answer info from AggregatorV3 type feed.
 * @param _feedAddr The feed address.
 * @return RawPrice Unparsed answer with metadata.
 */
function aggregatorV3RawPrice(
    address _feedAddr
) view returns (RawPrice memory) {
    (, int256 answer, , uint256 updatedAt, ) = IAggregatorV3(_feedAddr)
        .latestRoundData();
    bool isStale = block.timestamp - updatedAt > cs().staleTime;
    return
        RawPrice(
            answer,
            updatedAt,
            isStale,
            answer == 0,
            Enums.OracleType.Chainlink,
            _feedAddr
        );
}

/**
 * @notice Gets raw answer info from IAPI3 type feed.
 * @param _feedAddr The feed address.
 * @return RawPrice Unparsed answer with metadata.
 */
function API3RawPrice(address _feedAddr) view returns (RawPrice memory) {
    (int256 answer, uint256 updatedAt) = IAPI3(_feedAddr).read();
    bool isStale = block.timestamp - updatedAt > cs().staleTime;
    return
        RawPrice(
            answer,
            updatedAt,
            isStale,
            answer == 0,
            Enums.OracleType.API3,
            _feedAddr
        );
}

/**
 * @notice Return raw answer info from the oracles provided
 * @param _oracles Oracles to check.
 * @param _ticker Ticker for the asset.
 * @return RawPrice Unparsed answer with metadata.
 */
function rawPrice(
    Enums.OracleType[2] memory _oracles,
    bytes32 _ticker
) view returns (RawPrice memory) {
    for (uint256 i; i < _oracles.length; i++) {
        Enums.OracleType oracleType = _oracles[i];
        Oracle storage oracle = cs().oracles[_ticker][_oracles[i]];

        if (oracleType == Enums.OracleType.Chainlink)
            return aggregatorV3RawPrice(oracle.feed);
        if (oracleType == Enums.OracleType.API3)
            return API3RawPrice(oracle.feed);
        if (oracleType == Enums.OracleType.Vault) {
            int256 answer = int256(vaultPrice(oracle.feed));
            return
                RawPrice(
                    answer,
                    block.timestamp,
                    false,
                    answer == 0,
                    Enums.OracleType.Vault,
                    oracle.feed
                );
        }
    }

    // Revert if no answer is found
    revert Errors.NO_PUSH_ORACLE_SET(_ticker.toString());
}

library Assets {
    using WadRay for uint256;
    using PercentageMath for uint256;

    /* -------------------------------------------------------------------------- */
    /*                                Asset Prices                                */
    /* -------------------------------------------------------------------------- */

    function price(Asset storage self) internal view returns (uint256) {
        return safePrice(self.ticker, self.oracles, cs().maxPriceDeviationPct);
    }

    function price(
        Asset storage self,
        uint256 maxPriceDeviationPct
    ) internal view returns (uint256) {
        return safePrice(self.ticker, self.oracles, maxPriceDeviationPct);
    }

    /**
     * @notice Get value for @param _assetAmount of @param self in uint256
     */
    function uintUSD(
        Asset storage self,
        uint256 _amount
    ) internal view returns (uint256) {
        return self.price().wadMul(_amount);
    }

    /**
     * @notice Get the oracle price of an asset in uint256 with oracleDecimals
     */
    function redstonePrice(Asset storage self) internal view returns (uint256) {
        return Redstone.getPrice(self.ticker);
    }

    function marketStatus(Asset storage) internal pure returns (bool) {
        return true;
    }

    /* -------------------------------------------------------------------------- */
    /*                                 Conversions                                */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Ensure repayment value (and amount), clamp to max if necessary.
     * @param _maxRepayValue The max liquidatable USD (uint256).
     * @param _repayAmount The repay amount (uint256).
     * @return repayValue Effective repayment value.
     * @return repayAmount Effective repayment amount.
     */
    function boundRepayValue(
        Asset storage self,
        uint256 _maxRepayValue,
        uint256 _repayAmount
    ) internal view returns (uint256 repayValue, uint256 repayAmount) {
        uint256 assetPrice = self.price();
        repayValue = _repayAmount.wadMul(assetPrice);

        if (repayValue > _maxRepayValue) {
            _repayAmount = _maxRepayValue.wadDiv(assetPrice);
            repayValue = _maxRepayValue;
        }

        return (repayValue, _repayAmount);
    }

    /**
     * @notice Gets the collateral value for a single collateral asset and amount.
     * @param _amount Amount of asset to get the value for.
     * @param _ignoreFactor Should collateral factor be ignored.
     * @return value  Value for `_amount` of the asset.
     */
    function collateralAmountToValue(
        Asset storage self,
        uint256 _amount,
        bool _ignoreFactor
    ) internal view returns (uint256 value) {
        if (_amount == 0) return 0;
        value = toWad(_amount, self.decimals).wadMul(self.price());

        if (!_ignoreFactor) {
            value = value.percentMul(self.factor);
        }
    }

    /**
     * @notice Gets the collateral value for `_amount` and returns the price used.
     * @param _amount Amount of asset
     * @param _ignoreFactor Should collateral factor be ignored.
     * @return value Value for `_amount` of the asset.
     * @return assetPrice Price of the collateral asset.
     */
    function collateralAmountToValueWithPrice(
        Asset storage self,
        uint256 _amount,
        bool _ignoreFactor
    ) internal view returns (uint256 value, uint256 assetPrice) {
        assetPrice = self.price();
        if (_amount == 0) return (0, assetPrice);
        value = toWad(_amount, self.decimals).wadMul(assetPrice);

        if (!_ignoreFactor) {
            value = value.percentMul(self.factor);
        }
    }

    /**
     * @notice Gets the USD value for a single Kresko asset and amount.
     * @param _amount Amount of the Kresko asset to calculate the value for.
     * @param _ignoreKFactor Boolean indicating if the asset's k-factor should be ignored.
     * @return value Value for the provided amount of the Kresko asset.
     */
    function debtAmountToValue(
        Asset storage self,
        uint256 _amount,
        bool _ignoreKFactor
    ) internal view returns (uint256 value) {
        if (_amount == 0) return 0;
        value = self.uintUSD(_amount);

        if (!_ignoreKFactor) {
            value = value.percentMul(self.kFactor);
        }
    }

    /**
     * @notice Gets the amount for a single debt asset and value.
     * @param _value Value of the asset to calculate the amount for.
     * @param _ignoreKFactor Boolean indicating if the asset's k-factor should be ignored.
     * @return amount Amount for the provided value of the Kresko asset.
     */
    function debtValueToAmount(
        Asset storage self,
        uint256 _value,
        bool _ignoreKFactor
    ) internal view returns (uint256 amount) {
        if (_value == 0) return 0;

        uint256 assetPrice = self.price();
        if (!_ignoreKFactor) {
            assetPrice = assetPrice.percentMul(self.kFactor);
        }

        return _value.wadDiv(assetPrice);
    }

    /// @notice Preview SDI amount from krAsset amount.
    function debtAmountToSDI(
        Asset storage asset,
        uint256 amount,
        bool ignoreFactors
    ) internal view returns (uint256 shares) {
        return
            asset.debtAmountToValue(amount, ignoreFactors).wadDiv(SDIPrice());
    }

    /* -------------------------------------------------------------------------- */
    /*                                 Minter Util                                */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Check that amount does not put the user's debt position below the minimum debt value.
     * @param _asset Asset being burned.
     * @param _burnAmount Debt amount burned.
     * @param _debtAmount Debt amount before burn.
     * @return amount >= minDebtAmount
     */
    function checkDust(
        Asset storage _asset,
        uint256 _burnAmount,
        uint256 _debtAmount
    ) internal view returns (uint256 amount) {
        if (_burnAmount == _debtAmount) return _burnAmount;
        // If the requested burn would put the user's debt position below the minimum
        // debt value, close up to the minimum debt value instead.
        uint256 krAssetValue = _asset.debtAmountToValue(
            _debtAmount - _burnAmount,
            true
        );
        uint256 minDebtValue = cs().minDebtValue;
        if (krAssetValue > 0 && krAssetValue < minDebtValue) {
            uint256 minDebtAmount = minDebtValue.wadDiv(_asset.price());
            amount = _debtAmount - minDebtAmount;
        } else {
            amount = _burnAmount;
        }
    }

    /**
     * @notice Checks min debt value against some amount.
     * @param _asset The asset (Asset).
     * @param _krAsset The kresko asset address.
     * @param _debtAmount The debt amount (uint256).
     */
    function ensureMinDebtValue(
        Asset storage _asset,
        address _krAsset,
        uint256 _debtAmount
    ) internal view {
        uint256 positionValue = _asset.uintUSD(_debtAmount);
        uint256 minDebtValue = cs().minDebtValue;
        if (positionValue < minDebtValue)
            revert Errors.MINT_VALUE_LESS_THAN_MIN_DEBT_VALUE(
                Errors.id(_krAsset),
                positionValue,
                minDebtValue
            );
    }

    /**
     * @notice Get the minimum collateral value required to
     * back a Kresko asset amount at a given collateralization ratio.
     * @param _krAsset Address of the Kresko asset.
     * @param _amount Kresko Asset debt amount.
     * @param _ratio Collateralization ratio for the minimum collateral value.
     * @return minCollateralValue Minimum collateral value required for `_amount` of the Kresko Asset.
     */
    function minCollateralValueAtRatio(
        Asset storage _krAsset,
        uint256 _amount,
        uint32 _ratio
    ) internal view returns (uint256 minCollateralValue) {
        if (_amount == 0) return 0;
        // Calculate the collateral value required to back this Kresko asset amount at the given ratio
        return _krAsset.debtAmountToValue(_amount, false).percentMul(_ratio);
    }

    /* -------------------------------------------------------------------------- */
    /*                                    Utils                                   */
    /* -------------------------------------------------------------------------- */
    function exists(Asset storage self) internal view returns (bool) {
        return self.ticker != Constants.ZERO_BYTES32;
    }

    function isVoid(Asset storage self) internal view returns (bool) {
        return
            self.ticker != Constants.ZERO_BYTES32 &&
            !self.isMinterCollateral &&
            !self.isMinterMintable &&
            !self.isSharedCollateral &&
            !self.isSwapMintable;
    }

    /**
     * @notice EDGE CASE: If the collateral asset is also a kresko asset, ensure that the deposit amount is above the minimum.
     * @dev This is done because kresko assets can be rebased.
     */
    function ensureMinKrAssetCollateral(
        Asset storage self,
        address _self,
        uint256 _newCollateralAmount
    ) internal view {
        if (
            _newCollateralAmount > Constants.MIN_KRASSET_COLLATERAL_AMOUNT ||
            _newCollateralAmount == 0
        ) return;
        if (self.anchor == address(0)) return;
        revert Errors.COLLATERAL_AMOUNT_LOW(
            Errors.id(_self),
            _newCollateralAmount,
            Constants.MIN_KRASSET_COLLATERAL_AMOUNT
        );
    }

    /**
     * @notice Amount of non rebasing tokens -> amount of rebasing tokens
     * @dev DO use this function when reading values storage.
     * @dev DONT use this function when writing to storage.
     * @param _unrebasedAmount Unrebased amount to convert.
     * @return maybeRebasedAmount Possibly rebased amount of asset
     */
    function toRebasingAmount(
        Asset storage self,
        uint256 _unrebasedAmount
    ) internal view returns (uint256 maybeRebasedAmount) {
        if (_unrebasedAmount == 0) return 0;
        if (self.anchor != address(0)) {
            return
                IKreskoAssetAnchor(self.anchor).convertToAssets(
                    _unrebasedAmount
                );
        }
        return _unrebasedAmount;
    }

    /**
     * @notice Amount of rebasing tokens -> amount of non rebasing tokens
     * @dev DONT use this function when reading from storage.
     * @dev DO use this function when writing to storage.
     * @param _maybeRebasedAmount Possibly rebased amount of asset.
     * @return maybeUnrebasedAmount Possibly unrebased amount of asset
     */
    function toNonRebasingAmount(
        Asset storage self,
        uint256 _maybeRebasedAmount
    ) internal view returns (uint256 maybeUnrebasedAmount) {
        if (_maybeRebasedAmount == 0) return 0;
        if (self.anchor != address(0)) {
            return
                IKreskoAssetAnchor(self.anchor).convertToShares(
                    _maybeRebasedAmount
                );
        }
        return _maybeRebasedAmount;
    }
}

using Assets for Asset global;

/* ========================================================================== */
/*                                   Structs                                  */
/* ========================================================================== */

/// @notice Oracle configuration mapped to `Asset.ticker`.
struct Oracle {
    address feed;
    function(address) external view returns (uint256) priceGetter;
}

/**
 * @notice Feed configuration.
 * @param oracleIds List of two supported oracle providers.
 * @param feeds List of two feed addresses matching to the providers supplied. Redstone will be address(0).
 */
struct FeedConfiguration {
    Enums.OracleType[2] oracleIds;
    address[2] feeds;
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
    /// @notice Minter fee percent for opening a debt position. <= 25%.
    /// @notice Fee is deducted from collaterals.
    uint16 openFee;
    /// @notice Minter fee percent for closing a debt position. <= 25%.
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
    /// @notice SCDP liquidity index (RAY precision). Scales the deposits globally:
    /// @notice 1) Increased from fees accrued into deposits.
    /// @notice 2) Decreased from liquidations where swap collateral does not cover value required.
    /// @dev NOTE: uint128
    uint128 liquidityIndexSCDP;
    /// @notice SCDP fee percent when swapped as "asset in". Cap 25% == a.inFee + b.outFee <= 50%.
    uint16 swapInFeeSCDP;
    /// @notice SCDP fee percent when swapped as "asset out". Cap 25% == a.outFee + b.inFee <= 50%.
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
 * @notice Initialization arguments for common values
 */
struct CommonInitArgs {
    address admin;
    address council;
    address treasury;
    uint64 minDebtValue;
    uint16 maxPriceDeviationPct;
    uint8 oracleDecimals;
    address sequencerUptimeFeed;
    uint32 sequencerGracePeriodTime;
    uint32 staleTime;
    address kreskian;
    address questForKresk;
    uint8 phase;
}

struct SCDPCollateralArgs {
    uint256 depositLimit;
    uint128 liquidityIndex; // no need to pack this, it's not used with depositLimit
    uint8 decimals;
}

struct SCDPKrAssetArgs {
    uint256 maxDebtMinter;
    uint16 liqIncentive;
    uint16 protocolFee; // Taken from the open+close fee. Goes to protocol.
    uint16 openFee;
    uint16 closeFee;
}

/**
 * @notice SCDP initializer configuration.
 * @param minCollateralRatio The minimum collateralization ratio.
 * @param liquidationThreshold The liquidation threshold.
 * @param sdiPricePrecision The decimals in SDI price.
 */
struct SCDPInitArgs {
    uint32 minCollateralRatio;
    uint32 liquidationThreshold;
    uint8 sdiPricePrecision;
}

/**
 * @notice SCDP initializer configuration.
 * @param feeAsset Asset that all fees from swaps are collected in.
 * @param minCollateralRatio The minimum collateralization ratio.
 * @param liquidationThreshold The liquidation threshold.
 * @param maxLiquidationRatio The maximum CR resulting from liquidations.
 * @param sdiPricePrecision The decimal precision of SDI price.
 */
struct SCDPParameters {
    address feeAsset;
    uint32 minCollateralRatio;
    uint32 liquidationThreshold;
    uint32 maxLiquidationRatio;
    uint8 sdiPricePrecision;
}

// Used for setting swap pairs enabled or disabled in the pool.
struct SwapRouteSetter {
    address assetIn;
    address assetOut;
    bool enabled;
}

struct SCDPAssetData {
    uint256 debt;
    uint128 totalDeposits;
    uint128 swapDeposits;
}

// give me 256 bits in three
// 128 + 128 = 256

struct GlobalData {
    uint256 collateralValue;
    uint256 collateralValueAdjusted;
    uint256 debtValue;
    uint256 debtValueAdjusted;
    uint256 effectiveDebtValue;
    uint256 cr;
    uint256 crDebtValue;
    uint256 crDebtValueAdjusted;
}

/**
 * Periphery asset data
 */
struct AssetData {
    address addr;
    uint256 depositAmount;
    uint256 depositValue;
    uint256 depositValueAdjusted;
    uint256 debtAmount;
    uint256 debtValue;
    uint256 debtValueAdjusted;
    uint256 swapDeposits;
    Asset asset;
    uint256 assetPrice;
    string symbol;
}

struct UserAssetData {
    address asset;
    uint256 assetPrice;
    uint256 depositAmount;
    uint256 scaledDepositAmount;
    uint256 depositValue;
    uint256 scaledDepositValue;
}

struct UserData {
    address account;
    uint256 totalDepositValue;
    uint256 totalScaledDepositValue;
    uint256 totalFeesValue;
    UserAssetData[] deposits;
}

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
     * @notice Get the collateral pool deposit balance of `_account`. Including fees.
     * @param _account The account.
     * @param _depositAsset The deposit asset.
     */
    function getAccountScaledDepositsSCDP(
        address _account,
        address _depositAsset
    ) external view returns (uint256);

    /**
     * @notice Get the total collateral principal deposits for `_account`
     * @param _account The account.
     * @param _depositAsset The deposit asset
     */
    function getAccountDepositSCDP(
        address _account,
        address _depositAsset
    ) external view returns (uint256);

    function getAccountDepositFeesGainedSCDP(
        address _account,
        address _depositAsset
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

    /**
     * @notice Get the full value of account and fees for `_account`
     * @param _account The account.
     * @param _depositAsset The collateral asset
     */
    function getAccountScaledDepositValueCDP(
        address _account,
        address _depositAsset
    ) external view returns (uint256);

    /**
     * @notice Get the total collateral deposit value for `_account`
     * @param _account The account.
     */
    function getAccountTotalDepositsValueSCDP(
        address _account
    ) external view returns (uint256);

    /**
     * @notice Get the full value of account and fees for `_account`
     * @param _account The account.
     */
    function getAccountTotalScaledDepositsValueSCDP(
        address _account
    ) external view returns (uint256);

    /**
     * @notice Get all pool CollateralAssets
     */
    function getDepositAssetsSCDP() external view returns (address[] memory);

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

    /**
     * @notice Get pool collateral values and debt values with CR.
     * @return GlobalData struct
     */
    function getStatisticsSCDP() external view returns (GlobalData memory);
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
    ) external;

    /**
     * @notice Withdraw collateral for account from the collateral pool.
     * @param _account The account to withdraw for.
     * @param _collateralAsset The collateral asset to withdraw.
     * @param _amount The amount to withdraw.
     */
    function withdrawSCDP(
        address _account,
        address _collateralAsset,
        uint256 _amount
    ) external;

    /**
     * @notice Repay debt for no fees or slippage.
     * @notice Only uses swap deposits, if none available, reverts.
     * @param _repayAssetAddr The asset to repay the debt in.
     * @param _repayAmount The amount of the asset to repay the debt with.
     * @param _seizeAssetAddr The collateral asset to seize.
     */
    function repaySCDP(
        address _repayAssetAddr,
        uint256 _repayAmount,
        address _seizeAssetAddr
    ) external;

    /**
     * @notice Liquidate the collateral pool.
     * @notice Adjusts everyones deposits if swap deposits do not cover the seized amount.
     * @param _repayAssetAddr The asset to repay the debt in.
     * @param _repayAmount The amount of the asset to repay the debt with.
     * @param _seizeAssetAddr The collateral asset to seize.
     */
    function liquidateSCDP(
        address _repayAssetAddr,
        uint256 _repayAmount,
        address _seizeAssetAddr
    ) external;

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
    function getTotalSDIDebt() external view returns (uint256);

    function getEffectiveSDIDebtUSD() external view returns (uint256);

    function getEffectiveSDIDebt() external view returns (uint256);

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

    function SDICover(
        address _assetAddr,
        uint256 _amount
    ) external returns (uint256 shares, uint256 value);

    function enableCoverAssetSDI(address _assetAddr) external;

    function disableCoverAssetSDI(address _assetAddr) external;

    function setCoverRecipientSDI(address _coverRecipient) external;

    function getCoverAssetsSDI() external view returns (address[] memory);
}

interface ISCDPSwapFacet {
    /**
     * @notice Preview the amount out received.
     * @param _assetIn The asset to pay with.
     * @param _assetOut The asset to receive.
     * @param _amountIn The amount of _assetIn to pay.
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
     * @param _account The receiver of amount out.
     * @param _assetIn The asset to pay with.
     * @param _assetOut The asset to receive.
     * @param _amountIn The amount of _assetIn to pay.
     * @param _amountOutMin The minimum amount of _assetOut to receive, this is due to possible oracle price change.
     */
    function swapSCDP(
        address _account,
        address _assetIn,
        address _assetOut,
        uint256 _amountIn,
        uint256 _amountOutMin
    ) external;

    /**
     * @notice Accumulates fees to deposits as a fixed, instantaneous income.
     * @param _depositAssetAddr Deposit asset to give income for
     * @param _incomeAmount Amount to accumulate
     * @return nextLiquidityIndex Next liquidity index for the asset.
     */
    function cumulateIncomeSCDP(
        address _depositAssetAddr,
        uint256 _incomeAmount
    ) external returns (uint256 nextLiquidityIndex);
}

interface IMinterBurnFacet {
    /**
     * @notice Burns existing Kresko assets.
     * @param _account The address to burn kresko assets for
     * @param _krAsset The address of the Kresko asset.
     * @param _burnAmount The amount of the Kresko asset to be burned.
     * @param _mintedKreskoAssetIndex The index of the kresko asset in the user's minted assets array.
     * Only needed if burning all principal debt of a particular collateral asset.
     */
    function burnKreskoAsset(
        address _account,
        address _krAsset,
        uint256 _burnAmount,
        uint256 _mintedKreskoAssetIndex
    ) external;
}

/* ========================================================================== */
/*                                   STRUCTS                                  */
/* ========================================================================== */
/**
 * @notice Internal, used execute _liquidateAssets.
 * @param account The account being liquidated.
 * @param repayAmount Amount of the Kresko Assets repaid.
 * @param seizeAmount Calculated amount of collateral being seized.
 * @param repayAsset Address of the Kresko asset being repaid.
 * @param repayIndex Index of the Kresko asset in the accounts minted assets array.
 * @param seizeAsset Address of the collateral asset being seized.
 * @param seizeAssetIndex Index of the collateral asset in the account's collateral assets array.
 */
struct LiquidateExecution {
    address account;
    uint256 repayAmount;
    uint256 seizeAmount;
    address repayAssetAddr;
    uint256 repayAssetIndex;
    address seizedAssetAddr;
    uint256 seizedAssetIndex;
}

/**
 * @notice External, used when caling liquidate.
 * @param account The account to attempt to liquidate.
 * @param repayAssetAddr Address of the Kresko asset to be repaid.
 * @param repayAmount Amount of the Kresko asset to be repaid.
 * @param seizeAssetAddr Address of the collateral asset to be seized.
 * @param repayAssetIndex Index of the Kresko asset in the user's minted assets array.
 * @param seizeAssetIndex Index of the collateral asset in the account's collateral assets array.
 */
struct LiquidationArgs {
    address account;
    address repayAssetAddr;
    uint256 repayAmount;
    address seizeAssetAddr;
    uint256 repayAssetIndex;
    uint256 seizeAssetIndex;
}

struct MinterAccountState {
    uint256 totalDebtValue;
    uint256 totalCollateralValue;
    uint256 collateralRatio;
}
/**
 * @notice Initialization arguments for the protocol
 */
struct MinterInitArgs {
    uint32 liquidationThreshold;
    uint32 minCollateralRatio;
}

/**
 * @notice Configurable parameters within the protocol
 */

struct MinterParams {
    uint32 minCollateralRatio;
    uint32 liquidationThreshold;
    uint32 maxLiquidationRatio;
}

interface IMinterConfigurationFacet {
    function initializeMinter(MinterInitArgs calldata args) external;

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

interface IMinterMintFacet {
    /**
     * @notice Mints new Kresko assets.
     * @param _account The address to mint assets for.
     * @param _krAsset The address of the Kresko asset.
     * @param _mintAmount The amount of the Kresko asset to be minted.
     */
    function mintKreskoAsset(
        address _account,
        address _krAsset,
        uint256 _mintAmount
    ) external;
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
    ) external;

    /**
     * @notice Withdraws sender's collateral from the protocol.
     * @dev Requires that the post-withdrawal collateral value does not violate minimum collateral requirement.
     * @param _account The address to withdraw assets for.
     * @param _collateralAsset The address of the collateral asset.
     * @param _withdrawAmount The amount of the collateral asset to withdraw.
     * @param _collateralIndex The index of the collateral asset in the sender's deposited collateral
     * assets array. Only needed if withdrawing the entire deposit of a particular collateral asset.
     */
    function withdrawCollateral(
        address _account,
        address _collateralAsset,
        uint256 _withdrawAmount,
        uint256 _collateralIndex
    ) external;

    /**
     * @notice Withdraws sender's collateral from the protocol before checking minimum collateral ratio.
     * @dev Executes post-withdraw-callback triggering onUncheckedCollateralWithdraw on the caller
     * @dev Requires that the post-withdraw-callback collateral value does not violate minimum collateral requirement.
     * @param _account The address to withdraw assets for.
     * @param _collateralAsset The address of the collateral asset.
     * @param _withdrawAmount The amount of the collateral asset to withdraw.
     * @param _collateralIndex The index of the collateral asset in the sender's deposited collateral
     * assets array. Only needed if withdrawing the entire deposit of a particular collateral asset.
     */
    function withdrawCollateralUnchecked(
        address _account,
        address _collateralAsset,
        uint256 _withdrawAmount,
        uint256 _collateralIndex,
        bytes memory _userData
    ) external;
}

interface IMinterStateFacet {
    /// @notice The collateralization ratio at which positions may be liquidated.
    function getLiquidationThresholdMinter() external view returns (uint32);

    /// @notice Multiplies max liquidation multiplier, if a full liquidation happens this is the resulting CR.
    function getMaxLiquidationRatioMinter() external view returns (uint32);

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
    function liquidate(LiquidationArgs memory _args) external;

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

interface ICommonConfigurationFacet {
    /**
     * @notice Updates the fee recipient.
     * @param _newFeeRecipient The new fee recipient.
     */
    function setFeeRecipient(address _newFeeRecipient) external;

    /**
     * @dev Updates the contract's minimum debt value.
     * @param _newMinDebtValue The new minimum debt value as a wad.
     */
    function setMinDebtValue(uint96 _newMinDebtValue) external;

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
     * @notice Sets the time in seconds until a price is considered stale.
     * @param _staleTime Time in seconds.
     */
    function setStaleTime(uint32 _staleTime) external;

    /**
     * @notice Set feeds for a ticker.
     * @param _ticker Ticker in bytes32 eg. bytes32("ETH")
     * @param _feedConfig List oracle configuration containing oracle identifiers and feed addresses.
     * @custom:signature setFeedsForTicker(bytes32,(uint8[2],address[2]))
     * @custom:selector 0xbe079e8e
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
        address[] calldata _feeds
    ) external;

    /**
     * @notice Set api3 feeds for tickers.
     * @dev Has modifiers: onlyRole.
     * @param _tickers Bytes32 list of tickers
     * @param _feeds List of feed addresses.
     */
    function setApi3Feeds(
        bytes32[] calldata _tickers,
        address[] calldata _feeds
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
     * @notice Set ChainLink feed address for ticker.
     * @param _ticker Ticker in bytes32 eg. bytes32("ETH")
     * @param _feedAddr The feed address.
     * @custom:signature setChainLinkFeed(bytes32,address)
     * @custom:selector 0xe091f77a
     */
    function setChainLinkFeed(bytes32 _ticker, address _feedAddr) external;

    /**
     * @notice Set API3 feed address for an asset.
     * @param _ticker Ticker in bytes32 eg. bytes32("ETH")
     * @param _feedAddr The feed address.
     * @custom:signature setApi3Feed(bytes32,address)
     * @custom:selector 0x7e9f9837
     */
    function setApi3Feed(bytes32 _ticker, address _feedAddr) external;

    /**
     * @notice Sets phase of gating mechanism
     * @param _phase phase id
     */
    function setGatingPhase(uint8 _phase) external;

    /**
     * @notice Sets address of Kreskian NFT contract
     * @param _kreskian kreskian nft contract address
     */
    function setKreskianCollection(address _kreskian) external;

    /**
     * @notice Sets address of Quest For Kresk NFT contract
     * @param _questForKresk Quest For Kresk NFT contract address
     */
    function setQuestForKreskCollection(address _questForKresk) external;
}

interface ICommonStateFacet {
    /// @notice The recipient of protocol fees.
    function getFeeRecipient() external view returns (address);

    /// @notice Offchain oracle decimals
    function getDefaultOraclePrecision() external view returns (uint8);

    /// @notice max deviation between main oracle and fallback oracle
    function getOracleDeviationPct() external view returns (uint16);

    /// @notice The minimum USD value of an individual synthetic asset debt position.
    function getMinDebtValue() external view returns (uint96);

    /// @notice Get the L2 sequencer uptime feed address.
    function getSequencerUptimeFeed() external view returns (address);

    /// @notice Get the L2 sequencer uptime feed grace period
    function getSequencerGracePeriod() external view returns (uint32);

    /// @notice Get stale timeout treshold for oracle answers.
    function getOracleTimeout() external view returns (uint32);

    /**
     * @notice Get tickers configured feed address for the oracle type.
     * @param _ticker Ticker in bytes32, eg. bytes32("ETH").
     * @param _oracleType The oracle type.
     * @return feedAddr Feed address matching the oracle type given.
     * @custom:signature getFeedForId(bytes32,address)
     * @custom:selector 0xed1d3e94
     */

    function getFeedForId(
        bytes32 _ticker,
        Enums.OracleType _oracleType
    ) external view returns (address feedAddr);

    /**
     * @notice Price getter for AggregatorV3/Chainlink type feeds.
     * @notice Returns 0-price if answer is stale. This triggers the use of a secondary provider if available.
     * @dev Valid call will revert if the answer is negative.
     * @param _feedAddr AggregatorV3 type feed address.
     * @return uint256 Price answer from the feed, 0 if the price is stale.
     * @custom:signature getChainlinkPrice(address)
     * @custom:selector 0xbd58fe56
     */
    function getChainlinkPrice(
        address _feedAddr
    ) external view returns (uint256);

    /**
     * @notice Price getter for Vault based asset.
     * @notice Reverts if for stale, 0 or negative answers.
     * @param _vaultAddr IVaultFeed type feed address.
     * @return uint256 Current price of one vault share.
     * @custom:signature getVaultPrice(address)
     * @custom:selector 0xec917bca
     */

    function getVaultPrice(address _vaultAddr) external view returns (uint256);

    /**
     * @notice Price getter for Redstone, extracting the price from "hidden" calldata.
     * Reverts for a number of reasons, notably:
     * 1. Invalid calldata
     * 2. Not enough signers for the price data.
     * 2. Wrong signers for the price data.
     * 4. Stale price data.
     * 5. Not enough data points
     * @param _ticker The reference asset ticker in bytes32, eg. bytes32("ETH").
     * @return uint256 Extracted price with enough unique signers.
     * @custom:signature redstonePrice(bytes32,address)
     * @custom:selector 0x0acb75e3
     */
    function redstonePrice(
        bytes32 _ticker,
        address
    ) external view returns (uint256);

    /**
     * @notice Price getter for API3 type feeds.
     * @notice Decimal precision is NOT the same as other sources.
     * @notice Returns 0-price if answer is stale.This triggers the use of a secondary provider if available.
     * @dev Valid call will revert if the answer is negative.
     * @param _feedAddr IProxy type feed address.
     * @return uint256 Price answer from the feed, 0 if the price is stale.
     * @custom:signature getAPI3Price(address)
     * @custom:selector 0xe939010d
     */
    function getAPI3Price(address _feedAddr) external view returns (uint256);
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

interface IAssetConfigurationFacet {
    /**
     * @notice Adds a new asset to the common state.
     * @notice Performs validations according to the `_config` provided.
     * @dev Use validateAssetConfig / static call this for validation.
     * @param _assetAddr Asset address.
     * @param _config Configuration struct to save for the asset.
     * @param _feeds Feed addresses, if both are address(0) they are ignored.
     * @return Asset Result of addAsset.
     * @custom:signature addAsset(address,(bytes32,address,,uint16,uint16,uint16,uint16,uint16,uint256,uint256,uint256,uint128,uint16,uint16,uint16,uint16,uint8,bool,bool,bool,bool,bool,bool),address[2])
     * @custom:selector 0x73320167
     */
    function addAsset(
        address _assetAddr,
        Asset memory _config,
        address[2] memory _feeds
    ) external returns (Asset memory);

    /**
     * @notice Update asset config.
     * @notice Performs validations according to the `_config` set.
     * @dev Use validateAssetConfig / static call this for validation.
     * @param _assetAddr The asset address.
     * @param _config Configuration struct to apply for the asset.
     * @custom:signature updateAsset(address,(bytes32,address,,uint16,uint16,uint16,uint16,uint16,uint256,uint256,uint256,uint128,uint16,uint16,uint16,uint16,uint8,bool,bool,bool,bool,bool,bool))
     * @custom:selector 0xe2f08b19
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
     * @custom:signature validateAssetConfig(address,(bytes32,address,uint8[2],uint16,uint16,uint16,uint16,uint16,uint256,uint256,uint256,uint128,uint16,uint16,uint16,uint16,uint8,bool,bool,bool,bool,bool,bool))
     * @custom:selector 0xcadd46b6
     */
    function validateAssetConfig(
        address _assetAddr,
        Asset memory _config
    ) external view returns (bool);

    /**
     * @notice Update oracle order for an asset.
     * @param _assetAddr The asset address.
     * @param _newOracleOrder List of 2 OracleTypes. 0 is primary and 1 is the reference.
     * @custom:signature setAssetOracleOrder(address,uint8[2])
     * @custom:selector 0x67029b02
     */
    function setAssetOracleOrder(
        address _assetAddr,
        Enums.OracleType[2] memory _newOracleOrder
    ) external;
}

interface IDiamondCutFacet {
    /**
     *@notice Add/replace/remove any number of functions, optionally execute a function with delegatecall
     * @param _diamondCut Contains the facet addresses and function selectors
     * @param _initializer The address of the contract or facet to execute _calldata
     * @param _calldata A function call, including function selector and arguments
     *                  _calldata is executed with delegatecall on _init
     */
    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _initializer,
        bytes calldata _calldata
    ) external;
}

interface IExtendedDiamondCutFacet {
    /**
     * @notice Use an initializer contract without cutting.
     * @param _initializer Address of contract or facet to execute _calldata
     * @param _calldata A function call, including function selector and arguments
     * - _calldata is executed with delegatecall on _init
     */
    function executeInitializer(
        address _initializer,
        bytes calldata _calldata
    ) external;

    /// @notice Execute multiple initializers without cutting.
    function executeInitializers(Initializer[] calldata _initializers) external;
}

// A loupe is a small magnifying glass used to look at diamonds.
// These functions look at diamonds
interface IDiamondLoupeFacet {
    /// @notice Gets all facet addresses and their four byte function selectors.
    /// @return facets_ Facet
    function facets() external view returns (Facet[] memory facets_);

    /// @notice Gets all the function selectors supported by a specific facet.
    /// @param _facet The facet address.
    /// @return facetFunctionSelectors_
    function facetFunctionSelectors(
        address _facet
    ) external view returns (bytes4[] memory facetFunctionSelectors_);

    /// @notice Get all the facet addresses used by a diamond.
    /// @return facetAddresses_
    function facetAddresses()
        external
        view
        returns (address[] memory facetAddresses_);

    /// @notice Gets the facet that supports the given selector.
    /// @dev If facet is not found return address(0).
    /// @param _functionSelector The function selector.
    /// @return facetAddress_ The facet address.
    function facetAddress(
        bytes4 _functionSelector
    ) external view returns (address facetAddress_);
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

// import {IMinterBurnHelperFacet} from "periphery/facets/IMinterBurnHelperFacet.sol";

// solhint-disable-next-line no-empty-blocks
interface IKresko is
    IDiamondCutFacet,
    IDiamondLoupeFacet,
    IDiamondStateFacet,
    IAuthorizationFacet,
    ICommonConfigurationFacet,
    ICommonStateFacet,
    IAssetConfigurationFacet,
    IAssetStateFacet,
    ISCDPSwapFacet,
    ISCDPFacet,
    ISCDPConfigFacet,
    ISCDPStateFacet,
    ISDIFacet,
    IMinterBurnFacet,
    ISafetyCouncilFacet,
    IMinterConfigurationFacet,
    IMinterMintFacet,
    IMinterStateFacet,
    IMinterDepositWithdrawFacet,
    IMinterAccountStateFacet,
    IMinterLiquidationFacet
    // IMinterBurnHelperFacet,
{

}
