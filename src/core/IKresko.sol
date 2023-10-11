// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

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

interface IERC20Permit {
    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function allowance(address, address) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function balanceOf(address) external view returns (uint256);

    function decimals() external view returns (uint8);

    function name() external view returns (string memory);

    function nonces(address) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    function symbol() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

/// @title KreskoAsset issuer interface
/// @author Kresko
/// @notice Contract that can issue/destroy Kresko Assets through Kresko
/// @dev This interface is used by KISS & KreskoAssetAnchor
interface IKreskoAssetIssuer {
    /**
     * @notice Mints @param _assets of krAssets for @param _to,
     * @notice Mints relative @return _shares of wkrAssets
     */
    function issue(
        uint256 _assets,
        address _to
    ) external returns (uint256 shares);

    /**
     * @notice Burns @param _assets of krAssets from @param _from,
     * @notice Burns relative @return _shares of wkrAssets
     */
    function destroy(
        uint256 _assets,
        address _from
    ) external returns (uint256 shares);

    /**
     * @notice Returns the total amount of anchor tokens out
     */
    function convertToShares(
        uint256 assets
    ) external view returns (uint256 shares);

    /**
     * @notice Returns the total amount of krAssets out
     */
    function convertToAssets(
        uint256 shares
    ) external view returns (uint256 assets);
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
        bool positive;
        uint256 denominator;
    }

    /**
     * @notice Initializes a KreskoAsset ERC20 token.
     * @dev Intended to be operated by the Kresko smart contract.
     * @param _name The name of the KreskoAsset.
     * @param _symbol The symbol of the KreskoAsset.
     * @param _decimals Decimals for the asset.
     * @param _admin The adminstrator of this contract.
     * @param _kresko The protocol, can perform mint and burn.
     * @param _underlying The underlying token if available.
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
        address _underlying,
        address _feeRecipient,
        uint48 _openFee,
        uint40 _closeFee
    ) external;

    function kresko() external view returns (address);

    function rebaseInfo() external view returns (Rebase memory);

    function isRebased() external view returns (bool);

    /**
     * @notice Perform a rebase, changing the denumerator and its operator
     * @param _denominator the denumerator for the operator, 1 ether = 1
     * @param _positive supply increasing/reducing rebase
     * @param _pools UniswapV2Pair address to sync so we wont get rekt by skim() calls.
     * @dev denumerator values 0 and 1 ether will disable the rebase
     */
    function rebase(
        uint256 _denominator,
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
     * @notice Returns the total supply of the token.
     * @notice This amount is adjusted by rebases.
     * @inheritdoc IERC20Permit
     */
    function totalSupply()
        external
        view
        override(IERC20Permit)
        returns (uint256);

    /**
     * @notice Returns the balance of @param _account
     * @notice This amount is adjusted by rebases.
     * @inheritdoc IERC20Permit
     */
    function balanceOf(
        address _account
    ) external view override(IERC20Permit) returns (uint256);

    /// @inheritdoc IERC20Permit
    function allowance(
        address _owner,
        address _account
    ) external view override(IERC20Permit) returns (uint256);

    /// @inheritdoc IERC20Permit
    function approve(
        address spender,
        uint256 amount
    ) external override returns (bool);

    /// @inheritdoc IERC20Permit
    function transfer(
        address _to,
        uint256 _amount
    ) external override(IERC20Permit) returns (bool);

    /// @inheritdoc IERC20Permit
    function transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) external override(IERC20Permit) returns (bool);

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
     * @param _underlying The underlying address.
     */
    function setUnderlying(address _underlying) external;
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

/* solhint-disable max-line-length */
library CError {
    error DIAMOND_CALLDATA_IS_NOT_EMPTY();
    error ADDRESS_HAS_NO_CODE(address);
    error DIAMOND_INIT_ADDRESS_ZERO_BUT_CALLDATA_NOT_EMPTY();
    error DIAMOND_INIT_NOT_ZERO_BUT_CALLDATA_IS_EMPTY();
    error DIAMOND_INIT_HAS_NO_CODE();
    error DIAMOND_FUNCTION_ALREADY_EXISTS(address, address, bytes4);
    error DIAMOND_INIT_FAILED(address);
    error DIAMOND_INCORRECT_FACET_CUT_ACTION();
    error DIAMOND_REMOVE_FUNCTIONS_NONZERO_FACET_ADDRESS(address);
    error DIAMOND_NO_FACET_SELECTORS(address);
    error ETH_TRANSFER_FAILED(address, uint256);
    error TRANSFER_FAILED(address, address, address, uint256);
    error INVALID_SIGNER(address, address);
    error APPROVE_FAILED(address, address, address, uint256);
    error PERMIT_DEADLINE_EXPIRED(address, address, uint256, uint256);
    error SAFE_ERC20_PERMIT_ERC20_OPERATION_FAILED(address);
    error SAFE_ERC20_PERMIT_APPROVE_NON_ZERO(address, uint256, uint256);
    error DIAMOND_REMOVE_FUNCTION_FACET_IS_ZERO();
    error DIAMOND_REPLACE_FUNCTION_DUPLICATE();
    error STRING_HEX_LENGTH_INSUFFICIENT();
    error ALREADY_INITIALIZED();
    error SAFE_ERC20_PERMIT_DECREASE_BELOW_ZERO(address, uint256, uint256);
    error INVALID_SENDER(address, address);
    error NOT_OWNER(address who, address owner);
    error NOT_PENDING_OWNER(address who, address pendingOwner);
    error SEIZE_UNDERFLOW(uint256, uint256);
    error MARKET_CLOSED(address, string);
    error SCDP_ASSET_ECONOMY(
        address seizeAsset,
        uint256 seizeReductionPct,
        address repayAsset,
        uint256 repayIncreasePct
    );
    error MINTER_ASSET_ECONOMY(
        address seizeAsset,
        uint256 seizeReductionPct,
        address repayAsset,
        uint256 repayIncreasePct
    );
    error INVALID_ASSET(address asset);
    error DEBT_EXCEEDS_COLLATERAL(
        uint256 collateralValue,
        uint256 minCollateralValue,
        uint32 ratio
    );
    error DEPOSIT_LIMIT(address asset, uint256 deposits, uint256 limit);
    error INVALID_MIN_DEBT(uint256 invalid, uint256 valid);
    error INVALID_SCDP_FEE(address asset, uint256 invalid, uint256 valid);
    error INVALID_MCR(uint256 invalid, uint256 valid);
    error COLLATERAL_DOES_NOT_EXIST(address asset);
    error KRASSET_DOES_NOT_EXIST(address asset);
    error SAFETY_COUNCIL_NOT_ALLOWED();
    error NATIVE_TOKEN_DISABLED();
    error SAFETY_COUNCIL_INVALID_ADDRESS(address);
    error SAFETY_COUNCIL_ALREADY_EXISTS();
    error MULTISIG_NOT_ENOUGH_OWNERS(uint256 owners, uint256 required);
    error ACCESS_CONTROL_NOT_SELF(address who, address self);
    error INVALID_MLR(uint256 invalid, uint256 valid);
    error INVALID_LT(uint256 invalid, uint256 valid);
    error INVALID_ASSET_FEE(address asset, uint256 invalid, uint256 valid);
    error INVALID_ORACLE_DEVIATION(uint256 invalid, uint256 valid);
    error INVALID_ORACLE_TYPE(uint8 invalid);
    error INVALID_FEE_RECIPIENT(address invalid);
    error INVALID_LIQ_INCENTIVE(address asset, uint256 invalid, uint256 valid);
    error LIQ_AMOUNT_OVERFLOW(uint256 invalid, uint256 valid);
    error MAX_LIQ_OVERFLOW(uint256 value);
    error SCDP_WITHDRAWAL_VIOLATION(
        address asset,
        uint256 requested,
        uint256 principal,
        uint256 scaled
    );
    error INVALID_DEPOSIT_ASSET(address asset);
    error IDENTICAL_ASSETS();
    error NO_PUSH_PRICE(string underlyingId);
    error NO_PUSH_ORACLE_SET(string underlyingId);
    error INVALID_FEE_TYPE(uint8 invalid, uint8 valid);
    error ZERO_ADDRESS();
    error WRAP_NOT_SUPPORTED();
    error BURN_AMOUNT_OVERFLOW(uint256 burnAmount, uint256 debtAmount);
    error PAUSED(address who);
    error ZERO_OR_STALE_PRICE(string underlyingId);
    error SEQUENCER_DOWN_NO_REDSTONE_AVAILABLE();
    error NEGATIVE_PRICE(address asset, int256 price);
    error STALE_PRICE(string, uint256 timeFromUpdate, uint256 threshold);
    error PRICE_UNSTABLE(uint256 primaryPrice, uint256 referencePrice);
    error ORACLE_ZERO_ADDRESS(string underlyingId);
    error ASSET_DOES_NOT_EXIST(address asset);
    error ASSET_ALREADY_EXISTS(address asset);
    error INVALID_SEQUENCER_UPTIME_FEED(address);
    error INVALID_ASSET_ID(address asset);
    error NO_MINTED_ASSETS(address who);
    error NO_COLLATERALS_DEPOSITED(address who);
    error MISSING_PHASE_3_NFT();
    error MISSING_PHASE_2_NFT();
    error MISSING_PHASE_1_NFT();
    error DIAMOND_FUNCTION_NOT_FOUND(bytes4);
    error RE_ENTRANCY();
    error INVALID_VAULT_PRICE(string underlyingId);
    error INVALID_API3_PRICE(string underlyingId);
    error INVALID_CL_PRICE(string underlyingId);
    error ARRAY_LENGTH_MISMATCH(string asset, uint256 arr1, uint256 arr2);
    error ACTION_PAUSED_FOR_ASSET();
    error INVALID_KFACTOR(address asset, uint256 invalid, uint256 valid);
    error INVALID_CFACTOR(address asset, uint256 invalid, uint256 valid);
    error INVALID_MINTER_FEE(address asset, uint256 invalid, uint256 valid);
    error INVALID_DECIMALS(address asset, uint256 decimals);
    error INVALID_KRASSET_CONTRACT(address asset);
    error INVALID_KRASSET_ANCHOR(address asset);
    error SUPPLY_LIMIT(address asset, uint256 invalid, uint256 valid);
    error CANNOT_LIQUIDATE(uint256 collateralValue, uint256 minCollateralValue);
    error CANNOT_COVER(uint256 collateralValue, uint256 minCollateralValue);
    error INVALID_KRASSET_OPERATOR(address invalidOperator);
    error INVALID_ASSET_INDEX(address asset, uint256 index, uint256 maxIndex);
    error ZERO_DEPOSIT(address asset);
    error ZERO_AMOUNT(address asset);
    error ZERO_WITHDRAW(address asset);
    error ZERO_MINT(address asset);
    error ZERO_REPAY(address asset);
    error ZERO_BURN(address asset);
    error ZERO_DEBT(address asset);
    error SELF_LIQUIDATION();
    error REPAY_OVERFLOW(uint256 invalid, uint256 valid);
    error CUMULATE_AMOUNT_ZERO();
    error CUMULATE_NO_DEPOSITS();
    error REPAY_TOO_MUCH(uint256 invalid, uint256 valid);
    error SWAP_NOT_ENABLED(address assetIn, address assetOut);
    error SWAP_SLIPPAGE(uint256 invalid, uint256 valid);
    error SWAP_ZERO_AMOUNT();
    error NOT_INCOME_ASSET(address incomeAsset);
    error ASSET_NOT_ENABLED(address asset);
    error INVALID_ASSET_SDI(address asset);
    error ASSET_ALREADY_ENABLED(address asset);
    error ASSET_ALREADY_DISABLED(address asset);
    error INVALID_PRICE(address token, address oracle, int256 price);
    error INVALID_DEPOSIT(address token, uint256 assetsIn, uint256 sharesOut);
    error INVALID_WITHDRAW(address asset, uint256 sharesIn, uint256 assetsOut);
    error ROUNDING_ERROR(string desc, uint256 sharesIn, uint256 assetsOut);
    error MAX_DEPOSIT_EXCEEDED(
        address asset,
        uint256 assetsIn,
        uint256 maxDeposit
    );
    error MAX_SUPPLY_EXCEEDED(address asset, uint256 supply, uint256 maxSupply);
    error COLLATERAL_VALUE_LOW(uint256 value, uint256 minRequiredValue);
    error MINT_VALUE_LOW(
        address asset,
        uint256 value,
        uint256 minRequiredValue
    );
    error INVALID_FEE(uint256 invalid, uint256 valid);
    error NOT_A_CONTRACT(address who);
    error NO_ALLOWANCE(
        address spender,
        address owner,
        uint256 requested,
        uint256 allowed
    );
    error NOT_ENOUGH_BALANCE(address who, uint256 requested, uint256 available);
    error INVALID_DENOMINATOR(uint256 denominator, uint256 valid);
    error INVALID_OPERATOR(address who, address valid);
    error ZERO_SHARES(address asset);
    error ZERO_SHARES_OUT(address asset, uint256 assets);
    error ZERO_SHARES_IN(address asset, uint256 assets);
    error ZERO_ASSETS(address asset);
    error ZERO_ASSETS_OUT(address asset, uint256 shares);
    error ZERO_ASSETS_IN(address asset, uint256 shares);
}

library NumericArrayLib {
    // This function sort array in memory using bubble sort algorithm,
    // which performs even better than quick sort for small arrays

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
    uint256 constant DEFAULT_MAX_DATA_TIMESTAMP_DELAY_SECONDS = 3 minutes;
    uint256 constant DEFAULT_MAX_DATA_TIMESTAMP_AHEAD_SECONDS = 1 minutes;

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
    uint256 constant ECDSA_SIG_R_BS = 32;
    uint256 constant ECDSA_SIG_S_BS = 32;

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

// === Abbreviations ===
// BS - Bytes size
// PTR - Pointer (memory location)
// SIG - Signature

// Solidity and YUL constants
uint256 constant STANDARD_SLOT_BS = 32;
uint256 constant FREE_MEMORY_PTR = 0x40;
uint256 constant BYTES_ARR_LEN_VAR_BS = 32;
uint256 constant FUNCTION_SIGNATURE_BS = 4;
uint256 constant REVERT_MSG_OFFSET = 68; // Revert message structure described here: https://ethereum.stackexchange.com/a/66173/106364
uint256 constant STRING_ERR_MESSAGE_MASK = 0x08c379a000000000000000000000000000000000000000000000000000000000;

// RedStone protocol consts
uint256 constant SIG_BS = 65;
uint256 constant TIMESTAMP_BS = 6;
uint256 constant DATA_PACKAGES_COUNT_BS = 2;
uint256 constant DATA_POINTS_COUNT_BS = 3;
uint256 constant DATA_POINT_VALUE_BYTE_SIZE_BS = 4;
uint256 constant DATA_POINT_SYMBOL_BS = 32;
uint256 constant DEFAULT_DATA_POINT_VALUE_BS = 32;
uint256 constant UNSIGNED_METADATA_BYTE_SIZE_BS = 3;
uint256 constant REDSTONE_MARKER_BS = 9; // byte size of 0x000002ed57011e0000
uint256 constant REDSTONE_MARKER_MASK = 0x0000000000000000000000000000000000000000000000000002ed57011e0000;

// Derived values (based on consts)
uint256 constant TIMESTAMP_NEGATIVE_OFFSET_IN_DATA_PACKAGE_WITH_STANDARD_SLOT_BS = 104; // SIG_BS + DATA_POINTS_COUNT_BS + DATA_POINT_VALUE_BYTE_SIZE_BS + STANDARD_SLOT_BS
uint256 constant DATA_PACKAGE_WITHOUT_DATA_POINTS_BS = 78; // DATA_POINT_VALUE_BYTE_SIZE_BS + TIMESTAMP_BS + DATA_POINTS_COUNT_BS + SIG_BS
uint256 constant DATA_PACKAGE_WITHOUT_DATA_POINTS_AND_SIG_BS = 13; // DATA_POINT_VALUE_BYTE_SIZE_BS + TIMESTAMP_BS + DATA_POINTS_COUNT_BS
uint256 constant REDSTONE_MARKER_BS_PLUS_STANDARD_SLOT_BS = 41; // REDSTONE_MARKER_BS + STANDARD_SLOT_BS

library Redstone {
    // using SafeMath for uint256;
    // inside unchecked these functions are still checked
    using {sub, add} for uint256;

    // solhint-disable no-empty-blocks
    // solhint-disable avoid-low-level-calls

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        return a + b;
    }

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
interface IProxy {
    function read() external view returns (int224 value, uint32 timestamp);

    function api3ServerV1() external view returns (address);
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
        if (value != 0) revert CError.STRING_HEX_LENGTH_INSUFFICIENT();
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

struct CommonState {
    /* -------------------------------------------------------------------------- */
    /*                                    Core                                    */
    /* -------------------------------------------------------------------------- */
    /// @notice asset address -> asset data
    mapping(address => Asset) assets;
    /// @notice asset -> oracle type -> oracle
    mapping(bytes32 => mapping(OracleType => Oracle)) oracles;
    /// @notice asset -> action -> state
    mapping(address => mapping(Action => SafetyState)) safetyState;
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
    /// @notice timeout for oracle in seconds
    uint32 oracleTimeout;
    /// @notice The oracle deviation percentage between the main oracle and fallback oracle.
    uint16 oracleDeviationPct;
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

bytes12 constant EMPTY_BYTES12 = bytes12("");

/* -------------------------------------------------------------------------- */
/*                                 Reentrancy                                 */
/* -------------------------------------------------------------------------- */

/// @dev Set the initial value to 1, (not hindering possible gas refunds by setting it to 0 on exit).
uint8 constant NOT_ENTERED = 1;
uint8 constant ENTERED = 2;

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

    uint16 internal constant BASIS_POINT = 1;
    /// @dev The maximum configurable close fee.
    uint16 internal constant MAX_CLOSE_FEE = 0.25e4; // 25%

    /// @dev The maximum configurable open fee.
    uint16 internal constant MAX_OPEN_FEE = 0.25e4; // 25%

    /// @dev The maximum configurable protocol fee per asset for collateral pool swaps.
    uint16 internal constant MAX_SCDP_FEE = 0.5e4; // 50%

    /// @dev The minimum configurable minimum collateralization ratio.
    uint16 internal constant MIN_CR = HUNDRED + ONE; // 101%

    /// @dev The minimum configurable liquidation incentive multiplier.
    /// This means liquidator only receives equal amount of collateral to debt repaid.
    uint16 internal constant MIN_LIQ_INCENTIVE = HUNDRED;

    /// @dev The maximum configurable liquidation incentive multiplier.
    /// This means liquidator receives 25% bonus collateral compared to the debt repaid.
    uint16 internal constant MAX_LIQ_INCENTIVE = 1.25e4; // 125%
}

library SGlobal {
    using WadRay for uint256;
    using PercentageMath for uint256;

    /**
     * @notice Checks whether the shared debt pool can be liquidated.
     * @notice Reverts if collateral value .
     */
    function checkLiquidatableSCDP(SCDPState storage self) internal view {
        uint256 collateralValue = self.totalCollateralValueSCDP(false);
        uint256 minCollateralValue = sdi().effectiveDebtValue().percentMul(
            self.liquidationThreshold
        );
        if (collateralValue >= minCollateralValue) {
            revert CError.CANNOT_LIQUIDATE(collateralValue, minCollateralValue);
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
            revert CError.CANNOT_COVER(collateralValue, minCollateralValue);
        }
    }

    /**
     * @notice Checks whether the collateral value is less than minimum required.
     * @notice Reverts when collateralValue is below minimum required.
     * @param _ratio Ratio to check in 1e4 percentage precision (uint32).
     */
    function checkCollateralValue(
        SCDPState storage self,
        uint32 _ratio
    ) internal view {
        uint256 collateralValue = self.totalCollateralValueSCDP(false);
        uint256 minCollateralValue = sdi().effectiveDebtValue().percentMul(
            _ratio
        );
        if (collateralValue < minCollateralValue) {
            revert CError.DEBT_EXCEEDS_COLLATERAL(
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
     * @param _account depositor
     * @param _assetAddr the deposit asset
     * @param _amount amount of collateral asset to deposit
     */
    function handleDepositSCDP(
        SCDPState storage self,
        address _account,
        address _assetAddr,
        uint256 _amount
    ) internal {
        Asset storage asset = cs().assets[_assetAddr];
        if (!asset.isSCDPDepositAsset) {
            revert CError.INVALID_DEPOSIT_ASSET(_assetAddr);
        }

        uint128 depositAmount = uint128(asset.toNonRebasingAmount(_amount));

        unchecked {
            // Save global deposits.
            self.assetData[_assetAddr].totalDeposits += depositAmount;
            // Save principal deposits.
            self.depositsPrincipal[_account][_assetAddr] += depositAmount;
            // Save scaled deposits.
            self.deposits[_account][_assetAddr] += depositAmount
                .wadToRay()
                .rayDiv(asset.liquidityIndexSCDP);
        }
        if (
            self.userDepositAmount(_assetAddr, asset) > asset.depositLimitSCDP
        ) {
            revert CError.DEPOSIT_LIMIT(
                _assetAddr,
                self.userDepositAmount(_assetAddr, asset),
                asset.depositLimitSCDP
            );
        }
    }

    /**
     * @notice Records a withdrawal of collateral asset from the SCDP.
     * @param _account The withdrawing account
     * @param _assetAddr the deposit asset
     * @param _amount The amount of collateral withdrawn
     * @return amountOut The actual amount of collateral withdrawn
     * @return feesOut The fees paid for during the withdrawal
     */
    function handleWithdrawSCDP(
        SCDPState storage self,
        address _account,
        address _assetAddr,
        uint256 _amount
    ) internal returns (uint256 amountOut, uint256 feesOut) {
        // Do not check for isEnabled, always allow withdrawals.
        Asset storage asset = cs().assets[_assetAddr];

        // Get accounts principal deposits.
        uint256 depositsPrincipal = self.accountPrincipalDeposits(
            _account,
            _assetAddr,
            asset
        );

        if (depositsPrincipal >= _amount) {
            // == Principal can cover possibly rebased `_amount` requested.
            // 1. We send out the requested amount.
            amountOut = _amount;
            // 2. No fees.
            // 3. Possibly un-rebased amount for internal bookeeping.
            uint128 amountWrite = uint128(asset.toNonRebasingAmount(_amount));
            unchecked {
                // 4. Reduce global deposits.
                self.assetData[_assetAddr].totalDeposits -= amountWrite;
                // 5. Reduce principal deposits.
                self.depositsPrincipal[_account][_assetAddr] -= amountWrite;
                // 6. Reduce scaled deposits.
                self.deposits[_account][_assetAddr] -= amountWrite
                    .wadToRay()
                    .rayDiv(asset.liquidityIndexSCDP);
            }
        } else {
            // == Principal can't cover possibly rebased `_amount` requested, send full collateral available.
            // 1. We send all collateral.
            amountOut = depositsPrincipal;
            // 2. With fees.
            uint256 scaledDeposits = self.accountScaledDeposits(
                _account,
                _assetAddr,
                asset
            );
            feesOut = scaledDeposits - depositsPrincipal;
            // 3. Ensure this is actually the case.
            if (feesOut == 0) {
                revert CError.SCDP_WITHDRAWAL_VIOLATION(
                    _assetAddr,
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
                asset.toNonRebasingAmount(depositsPrincipal)
            );
        }
    }

    /**
     * @notice This function seizes collateral from the shared pool
     * @notice Adjusts all deposits in the case where swap deposits do not cover the amount.
     * @param _sAssetAddr The seized asset address.
     * @param _sAsset The asset struct (Asset).
     * @param _seizeAmount The seize amount (uint256).
     */
    function handleSeizeSCDP(
        SCDPState storage self,
        address _sAssetAddr,
        Asset storage _sAsset,
        uint256 _seizeAmount
    ) internal {
        uint128 swapDeposits = self.swapDepositAmount(_sAssetAddr, _sAsset);

        if (swapDeposits >= _seizeAmount) {
            uint128 amountOut = uint128(
                _sAsset.toNonRebasingAmount(_seizeAmount)
            );
            // swap deposits cover the amount
            unchecked {
                self.assetData[_sAssetAddr].swapDeposits -= amountOut;
                self.assetData[_sAssetAddr].totalDeposits -= amountOut;
            }
        } else {
            // swap deposits do not cover the amount
            uint256 amountToCover = uint128(_seizeAmount - swapDeposits);
            // reduce everyones deposits by the same ratio
            _sAsset.liquidityIndexSCDP -= uint128(
                amountToCover.wadToRay().rayDiv(
                    self.userDepositAmount(_sAssetAddr, _sAsset).wadToRay()
                )
            );
            self.assetData[_sAssetAddr].swapDeposits = 0;
            self.assetData[_sAssetAddr].totalDeposits -= uint128(
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

// OpenZeppelin Contracts (last updated v5.0.0) (utils/Address.sol)

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev The ETH balance of the account is not enough to perform the operation.
     */
    error AddressInsufficientBalance(address account);

    /**
     * @dev There's no code at `target` (it is not a contract).
     */
    error AddressEmptyCode(address target);

    /**
     * @dev A call to an address target failed. The target may have reverted.
     */
    error FailedInnerCall();

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://consensys.net/diligence/blog/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.8.20/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        if (address(this).balance < amount) {
            revert AddressInsufficientBalance(address(this));
        }

        (bool success, ) = recipient.call{value: amount}("");
        if (!success) {
            revert FailedInnerCall();
        }
    }

    /**
     * @dev Performs a Solidity function call using a low level `call`. A
     * plain `call` is an unsafe replacement for a function call: use this
     * function instead.
     *
     * If `target` reverts with a revert reason or custom error, it is bubbled
     * up by this function (like regular Solidity function calls). However, if
     * the call reverted with no returned reason, this function reverts with a
     * {FailedInnerCall} error.
     *
     * Returns the raw returned data. To convert to the expected return value,
     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
     *
     * Requirements:
     *
     * - `target` must be a contract.
     * - calling `target` with `data` must not revert.
     */
    function functionCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        return functionCallWithValue(target, data, 0);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but also transferring `value` wei to `target`.
     *
     * Requirements:
     *
     * - the calling contract must have an ETH balance of at least `value`.
     * - the called Solidity function must be `payable`.
     */
    function functionCallWithValue(
        address target,
        bytes memory data,
        uint256 value
    ) internal returns (bytes memory) {
        if (address(this).balance < value) {
            revert AddressInsufficientBalance(address(this));
        }
        (bool success, bytes memory returndata) = target.call{value: value}(
            data
        );
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a static call.
     */
    function functionStaticCall(
        address target,
        bytes memory data
    ) internal view returns (bytes memory) {
        (bool success, bytes memory returndata) = target.staticcall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
     * but performing a delegate call.
     */
    function functionDelegateCall(
        address target,
        bytes memory data
    ) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = target.delegatecall(data);
        return verifyCallResultFromTarget(target, success, returndata);
    }

    /**
     * @dev Tool to verify that a low level call to smart-contract was successful, and reverts if the target
     * was not a contract or bubbling up the revert reason (falling back to {FailedInnerCall}) in case of an
     * unsuccessful call.
     */
    function verifyCallResultFromTarget(
        address target,
        bool success,
        bytes memory returndata
    ) internal view returns (bytes memory) {
        if (!success) {
            _revert(returndata);
        } else {
            // only check if target is a contract if the call was successful and the return data is empty
            // otherwise we already know that it was a contract
            if (returndata.length == 0 && target.code.length == 0) {
                revert AddressEmptyCode(target);
            }
            return returndata;
        }
    }

    /**
     * @dev Tool to verify that a low level call was successful, and reverts if it wasn't, either by bubbling the
     * revert reason or with a default {FailedInnerCall} error.
     */
    function verifyCallResult(
        bool success,
        bytes memory returndata
    ) internal pure returns (bytes memory) {
        if (!success) {
            _revert(returndata);
        } else {
            return returndata;
        }
    }

    /**
     * @dev Reverts with returndata if present. Otherwise reverts with {FailedInnerCall}.
     */
    function _revert(bytes memory returndata) private pure {
        // Look for revert reason and bubble it up if present
        if (returndata.length > 0) {
            // The easiest way to bubble the revert reason is using memory via assembly
            /// @solidity memory-safe-assembly
            assembly {
                let returndata_size := mload(returndata)
                revert(add(32, returndata), returndata_size)
            }
        } else {
            revert FailedInnerCall();
        }
    }
}

/**
 * @title SafeERC20Permit
 * @dev Wrappers around ERC20 operations that throw on failure (when the token
 * contract returns false). Tokens that return no value (and instead revert or
 * throw on failure) are also supported, non-reverting calls are assumed to be
 * successful.
 * To use this library you can add a `using SafeERC20Permit for IERC20;` statement to your contract,
 * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
 */
library SafeERC20Permit {
    using Address for address;

    function safeTransfer(
        IERC20Permit token,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transfer.selector, to, value)
        );
    }

    function safeTransferFrom(
        IERC20Permit token,
        address from,
        address to,
        uint256 value
    ) internal {
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.transferFrom.selector, from, to, value)
        );
    }

    /**
     * @dev Deprecated. This function has issues similar to the ones found in
     * {IERC20-approve}, and its usage is discouraged.
     *
     * Whenever possible, use {safeIncreaseAllowance} and
     * {safeDecreaseAllowance} instead.
     */
    function safeApprove(
        IERC20Permit token,
        address spender,
        uint256 value
    ) internal {
        // safeApprove should only be called when setting an initial allowance,
        // or when resetting it to zero. To increase and decrease it, use
        // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
        if (value != 0 || token.allowance(address(this), spender) != 0) {
            revert CError.SAFE_ERC20_PERMIT_APPROVE_NON_ZERO(
                spender,
                value,
                token.allowance(address(this), spender)
            );
        }
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(token.approve.selector, spender, value)
        );
    }

    function safeIncreaseAllowance(
        IERC20Permit token,
        address spender,
        uint256 value
    ) internal {
        uint256 newAllowance = token.allowance(address(this), spender) + value;
        _callOptionalReturn(
            token,
            abi.encodeWithSelector(
                token.approve.selector,
                spender,
                newAllowance
            )
        );
    }

    function safeDecreaseAllowance(
        IERC20Permit token,
        address spender,
        uint256 value
    ) internal {
        unchecked {
            uint256 oldAllowance = token.allowance(address(this), spender);
            if (value > oldAllowance)
                revert CError.SAFE_ERC20_PERMIT_DECREASE_BELOW_ZERO(
                    spender,
                    value,
                    oldAllowance
                );
            uint256 newAllowance = oldAllowance - value;
            _callOptionalReturn(
                token,
                abi.encodeWithSelector(
                    token.approve.selector,
                    spender,
                    newAllowance
                )
            );
        }
    }

    /**
     * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
     * on the return value: the return value is optional (but if data is returned, it must not be false).
     * @param token The token targeted by the call.
     * @param data The call data (encoded using abi.encode or one of its variants).
     */
    function _callOptionalReturn(
        IERC20Permit token,
        bytes memory data
    ) private {
        // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
        // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
        // the target address contains contract code and also asserts for success in the low-level call.

        bytes memory returndata = address(token).functionCall(data);
        if (returndata.length > 0) {
            // Return data is optional
            if (!abi.decode(returndata, (bool)))
                revert CError.SAFE_ERC20_PERMIT_ERC20_OPERATION_FAILED(
                    address(token)
                );
        }
    }
}

/* -------------------------------------------------------------------------- */
/*                                   Actions                                  */
/* -------------------------------------------------------------------------- */

/// @notice Burn kresko assets with anchor already known.
/// @param _anchor The anchor token of the asset being burned.
/// @param _burnAmount The amount being burned
/// @param _from The account to burn assets from.
function burnKrAsset(
    uint256 _burnAmount,
    address _from,
    address _anchor
) returns (uint256 burned) {
    burned = IKreskoAssetIssuer(_anchor).destroy(_burnAmount, _from);
    if (burned == 0) revert CError.ZERO_BURN(_anchor);
}

/// @notice Mint kresko assets with anchor already known.
/// @param _amount The asset amount being minted
/// @param _to The account receiving minted assets.
/// @param _anchor The anchor token of the minted asset.
function mintKrAsset(
    uint256 _amount,
    address _to,
    address _anchor
) returns (uint256 minted) {
    minted = IKreskoAssetIssuer(_anchor).issue(_amount, _to);
    if (minted == 0) revert CError.ZERO_MINT(_anchor);
}

/// @notice Repay SCDP swap debt.
/// @param _asset the asset being repaid
/// @param _burnAmount the asset amount being burned
/// @param _from the account to burn assets from
function burnSCDP(
    Asset storage _asset,
    uint256 _burnAmount,
    address _from
) returns (uint256 destroyed) {
    destroyed = burnKrAsset(_burnAmount, _from, _asset.anchor);
    sdi().totalDebt -= _asset.debtAmountToSDI(destroyed, false);
}

/// @notice Mint kresko assets from SCDP swap.
/// @param _asset the asset requested
/// @param _amount the asset amount requested
/// @param _to the account to mint the assets to
function mintSCDP(
    Asset storage _asset,
    uint256 _amount,
    address _to
) returns (uint256 issued) {
    issued = mintKrAsset(_amount, _to, _asset.anchor);
    unchecked {
        sdi().totalDebt += _asset.debtAmountToSDI(issued, false);
    }
}

library Swap {
    using WadRay for uint256;
    using SafeERC20Permit for IERC20Permit;

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
                IERC20Permit(_assetOutAddr).safeTransfer(
                    _assetsTo,
                    collateralOut
                );
            }
        }

        if (debtIn > 0) {
            // 1. Issue required debt to the pool, minting new assets to receiver.
            unchecked {
                assetData.debt += mintSCDP(_assetOut, debtIn, _assetsTo);
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
            revert CError.CUMULATE_AMOUNT_ZERO();
        }

        uint256 poolDeposits = self.userDepositAmount(_assetAddr, _asset);
        if (poolDeposits == 0) {
            revert CError.CUMULATE_NO_DEPOSITS();
        }
        // liquidity index increment is calculated this way: `(amount / totalLiquidity)`
        // division `amount / totalLiquidity` done in ray for precision
        unchecked {
            return (_asset.liquidityIndexSCDP += uint128(
                (_amount.wadToRay().rayDiv(poolDeposits.wadToRay()))
            ));
        }
    }
}

library SDebtIndex {
    using SafeERC20Permit for IERC20Permit;
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
        address coverAssetAddr,
        uint256 amount
    ) internal returns (uint256 shares, uint256 value) {
        if (amount == 0) revert CError.ZERO_AMOUNT(coverAssetAddr);
        Asset storage asset = cs().assets[coverAssetAddr];
        if (!asset.isSCDPCoverAsset)
            revert CError.ASSET_NOT_ENABLED(coverAssetAddr);

        value = wadUSD(
            amount,
            asset.decimals,
            asset.price(),
            cs().oracleDecimals
        );
        self.totalCover += (shares = valueToSDI(value, cs().oracleDecimals));

        IERC20Permit(coverAssetAddr).safeTransferFrom(
            msg.sender,
            self.coverRecipient,
            amount
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
        if (coverValue == 0) {
            return totalDebt.wadMul(sdiPrice);
        } else if (coverAmount >= totalDebt) {
            return 0;
        }
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
        uint256 bal = IERC20Permit(_assetAddr).balanceOf(self.coverRecipient);
        if (bal == 0) return 0;

        Asset storage asset = cs().assets[_assetAddr];
        if (!asset.isSCDPCoverAsset) return 0;
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
    mapping(address => mapping(address => bool)) isSwapEnabled;
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
    /// @notice User swap fee receiver
    address swapFeeRecipient;
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

/**
 * @title IVaultFeed
 * @author Kresko
 * @notice Minimal interface to consume exchange rate of a vault share
 */
interface IVaultRateConsumer {
    /**
     * @notice Gets the exchange rate of one vault share to USD.
     * @return uint256 The current exchange rate of the vault share in 18 decimals precision.
     */
    function exchangeRate() external view returns (uint256);
}

using WadRay for uint256;
using PercentageMath for uint256;
using Strings for bytes12;

/* -------------------------------------------------------------------------- */
/*                                   Getters                                  */
/* -------------------------------------------------------------------------- */

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
 * @notice Get the oracle price using safety checks for deviation and sequencer uptime
 * @notice reverts if the price deviates more than `_oracleDeviationPct`
 * @param _assetId The asset id
 * @param _oracles The list of oracle identifiers
 * @param _oracleDeviationPct the deviation percentage
 */
function safePrice(
    bytes12 _assetId,
    OracleType[2] memory _oracles,
    uint256 _oracleDeviationPct
) view returns (uint256) {
    uint256[2] memory prices = [
        oraclePrice(_oracles[0], _assetId),
        oraclePrice(_oracles[1], _assetId)
    ];
    if (prices[0] == 0 && prices[1] == 0) {
        revert CError.ZERO_OR_STALE_PRICE(_assetId.toString());
    }

    // OracleType.Vault uses the same check, reverting if the sequencer is down.
    if (
        _oracles[0] != OracleType.Vault &&
        !isSequencerUp(cs().sequencerUptimeFeed, cs().sequencerGracePeriodTime)
    ) {
        return handleSequencerDown(_oracles, prices);
    }

    return deducePrice(prices[0], prices[1], _oracleDeviationPct);
}

/**
 * @notice Call the price getter for the oracle provided and return the price.
 * @param _oracleId The oracle id (uint8).
 * @param _assetId The asset id (bytes12).
 * @return uint256 oracle price.
 * This will return 0 if the oracle is not set.
 */
function oraclePrice(
    OracleType _oracleId,
    bytes12 _assetId
) view returns (uint256) {
    if (_oracleId == OracleType.Empty) return 0;
    if (_oracleId == OracleType.Redstone) return Redstone.getPrice(_assetId);

    Oracle storage oracle = cs().oracles[_assetId][_oracleId];
    return oracle.priceGetter(oracle.feed);
}

/**
 * @notice Return push oracle price.
 * @param _oracles The oracles defined.
 * @param _assetId The asset id (bytes12).
 * @return PushPrice The push oracle price and timestamp.
 */
function pushPrice(
    OracleType[2] memory _oracles,
    bytes12 _assetId
) view returns (PushPrice memory) {
    for (uint8 i; i < _oracles.length; i++) {
        OracleType oracleType = _oracles[i];
        Oracle storage oracle = cs().oracles[_assetId][_oracles[i]];

        if (oracleType == OracleType.Chainlink)
            return aggregatorV3PriceWithTimestamp(oracle.feed);
        if (oracleType == OracleType.API3)
            return API3PriceWithTimestamp(oracle.feed);
        if (oracleType == OracleType.Vault)
            return PushPrice(vaultPrice(oracle.feed), block.timestamp);
    }

    // Revert if no push oracle is found
    revert CError.NO_PUSH_ORACLE_SET(_assetId.toString());
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
    revert CError.PRICE_UNSTABLE(_primaryPrice, _referencePrice);
}

/**
 * @notice Handles the prices in case the sequencer is down.
 * @notice Looks for redstone price, reverting if not available for asset.
 * @param oracles The oracle types.
 * @param prices The fetched oracle prices.
 * @return uint256 Usable price of the asset.
 */
function handleSequencerDown(
    OracleType[2] memory oracles,
    uint256[2] memory prices
) pure returns (uint256) {
    if (oracles[0] == OracleType.Redstone && prices[0] != 0) {
        return prices[0];
    } else if (oracles[1] == OracleType.Redstone && prices[1] != 0) {
        return prices[1];
    }
    revert CError.SEQUENCER_DOWN_NO_REDSTONE_AVAILABLE();
}

/**
 * @notice Gets the price from the provided vault.
 * @dev Vault exchange rate is in 18 decimal precision so we normalize to 8 decimals.
 * @param _vaultAddr The vault address.
 * @return uint256 The price of the vault share in 8 decimal precision.
 */
function vaultPrice(address _vaultAddr) view returns (uint256) {
    return IVaultRateConsumer(_vaultAddr).exchangeRate() / 1e10;
}

/**
 * @notice Gets answer from AggregatorV3 type feed.
 * @param _feedAddr The feed address.
 * @return uint256 Parsed answer from the feed, 0 if its stale.
 */
function aggregatorV3Price(
    address _feedAddr,
    uint256 _oracleTimeout
) view returns (uint256) {
    (, int256 answer, , uint256 updatedAt, ) = IAggregatorV3(_feedAddr)
        .latestRoundData();
    if (answer < 0) {
        revert CError.NEGATIVE_PRICE(_feedAddr, answer);
    }
    // returning zero if oracle price is too old so that fallback oracle is used instead.
    if (block.timestamp - updatedAt > _oracleTimeout) {
        return 0;
    }
    return uint256(answer);
}

/**
 * @notice Gets answer from AggregatorV3 type feed with timestamp.
 * @param _feedAddr The feed address.
 * @return PushPrice Parsed answer and timestamp.
 */
function aggregatorV3PriceWithTimestamp(
    address _feedAddr
) view returns (PushPrice memory) {
    (, int256 answer, , uint256 updatedAt, ) = IAggregatorV3(_feedAddr)
        .latestRoundData();
    if (answer < 0) {
        revert CError.NEGATIVE_PRICE(_feedAddr, answer);
    }
    // returning zero if oracle price is too old so that fallback oracle is used instead.
    if (block.timestamp - updatedAt > cs().oracleTimeout) {
        return PushPrice(0, updatedAt);
    }
    return PushPrice(uint256(answer), updatedAt);
}

/**
 * @notice Gets answer from IProxy type feed.
 * @param _feedAddr The feed address.
 * @return uint256 Parsed answer from the feed, 0 if its stale.
 */
function API3Price(address _feedAddr) view returns (uint256) {
    (int256 answer, uint256 updatedAt) = IProxy(_feedAddr).read();
    if (answer < 0) {
        revert CError.NEGATIVE_PRICE(_feedAddr, answer);
    }
    // returning zero if oracle price is too old so that fallback oracle is used instead.
    // NOTE: there can be a case where both chainlink and api3 oracles are down, in that case 0 will be returned ???
    if (block.timestamp - updatedAt > cs().oracleTimeout) {
        return 0;
    }
    return uint256(answer / 1e10); // @todo actual decimals
}

/**
 * @notice Gets answer from IProxy type feed with timestamp.
 * @param _feedAddr The feed address.
 * @return PushPrice Parsed answer and timestamp.
 */
function API3PriceWithTimestamp(
    address _feedAddr
) view returns (PushPrice memory) {
    (int256 answer, uint256 updatedAt) = IProxy(_feedAddr).read();
    if (answer < 0) {
        revert CError.NEGATIVE_PRICE(_feedAddr, answer);
    }
    // returning zero if oracle price is too old so that fallback oracle is used instead.
    // NOTE: there can be a case where both chainlink and api3 oracles are down, in that case 0 will be returned ???
    if (block.timestamp - updatedAt > cs().oracleTimeout) {
        return PushPrice(0, updatedAt);
    }
    return PushPrice(uint256(answer / 1e10), updatedAt); // @todo actual decimals
}

library CAsset {
    using WadRay for uint256;
    using PercentageMath for uint256;

    /* -------------------------------------------------------------------------- */
    /*                                Asset Prices                                */
    /* -------------------------------------------------------------------------- */

    function price(Asset storage self) internal view returns (uint256) {
        return
            safePrice(self.underlyingId, self.oracles, cs().oracleDeviationPct);
    }

    function price(
        Asset storage self,
        uint256 oracleDeviationPct
    ) internal view returns (uint256) {
        return safePrice(self.underlyingId, self.oracles, oracleDeviationPct);
    }

    function pushedPrice(
        Asset storage self
    ) internal view returns (PushPrice memory) {
        return pushPrice(self.oracles, self.underlyingId);
    }

    function checkOracles(
        Asset memory self
    ) internal view returns (PushPrice memory) {
        return pushPrice(self.oracles, self.underlyingId);
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
        return Redstone.getPrice(self.underlyingId);
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
    function ensureRepayValue(
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
     * @param _kreskoAsset The kresko asset address.
     * @param _debtAmount The debt amount (uint256).
     */
    function checkMinDebtValue(
        Asset storage _asset,
        address _kreskoAsset,
        uint256 _debtAmount
    ) internal view {
        uint256 positionValue = _asset.uintUSD(_debtAmount);
        uint256 minDebtValue = cs().minDebtValue;
        if (positionValue < minDebtValue)
            revert CError.MINT_VALUE_LOW(
                _kreskoAsset,
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
    /*                                   Rebase                                   */
    /* -------------------------------------------------------------------------- */

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

using CAsset for Asset global;

/* ========================================================================== */
/*                                   Structs                                  */
/* ========================================================================== */

/// @notice Oracle configuration mapped to `Asset.underlyingId`.
struct Oracle {
    address feed;
    function(address) external view returns (uint256) priceGetter;
}

/// @notice Supported oracle providers.
enum OracleType {
    Empty,
    Redstone,
    Chainlink,
    API3,
    Vault
}

/**
 * @notice Feed configuration.
 * @param oracleIds List of two supported oracle providers.
 * @param feeds List of two feed addresses matching to the providers supplied. Redstone will be address(0).
 */
struct FeedConfiguration {
    OracleType[2] oracleIds;
    address[2] feeds;
}

/**
 * @title Protocol Asset Configuration
 * @author Kresko
 * @notice All assets in the protocol share this configuration.
 * @notice underlyingId is not unique, eg. krETH and WETH both would use bytes12('ETH')
 * @dev Percentages use 2 decimals: 1e4 (10000) == 100.00%. See {PercentageMath.sol}.
 * @dev Note that the percentage value for uint16 caps at 655.36%.
 */
struct Asset {
    /// @notice Bytes identifier for the underlying, not unique, matches Redstone IDs. eg. bytes12('ETH').
    /// @notice Packed to 12, so maximum 12 chars.
    bytes12 underlyingId;
    /// @notice Kresko Asset Anchor address.
    address anchor;
    /// @notice Oracle provider priority for this asset.
    /// @notice Provider at index 0 is the primary price source.
    /// @notice Provider at index 1 is the reference price for deviation check and also the fallback price.
    OracleType[2] oracles;
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
    /// @dev NOTE: uint128
    uint128 supplyLimit;
    /// @notice SCDP deposit limit for the asset.
    /// @dev NOTE: uint128.
    uint128 depositLimitSCDP;
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
    bool isCollateral;
    /// @notice Asset can be minted as debt from the Minter.
    bool isKrAsset;
    /// @notice Asset can be deposited as collateral in the SCDP.
    bool isSCDPDepositAsset;
    /// @notice Asset can be minted through swaps in the SCDP.
    bool isSCDPKrAsset;
    /// @notice Asset is included in the total collateral value calculation for the SCDP.
    /// @notice KrAssets will be true by default - since they are indirectly deposited through swaps.
    bool isSCDPCollateral;
    /// @notice Asset can be used to cover SCDP debt.
    bool isSCDPCoverAsset;
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

/// @notice Convenience struct for returning push price data
struct PushPrice {
    uint256 price;
    uint256 timestamp;
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
    uint16 oracleDeviationPct;
    uint8 oracleDecimals;
    address sequencerUptimeFeed;
    uint32 sequencerGracePeriodTime;
    uint32 oracleTimeout;
    address kreskian;
    address questForKresk;
    uint8 phase;
}

struct SCDPCollateralArgs {
    uint128 liquidityIndex; // no need to pack this, it's not used with depositLimit
    uint128 depositLimit;
    uint8 decimals;
}

struct SCDPKrAssetArgs {
    uint128 supplyLimit;
    uint16 liqIncentive;
    uint16 protocolFee; // Taken from the open+close fee. Goes to protocol.
    uint16 openFee;
    uint16 closeFee;
}

/* -------------------------------------------------------------------------- */
/*                                    ENUM                                    */
/* -------------------------------------------------------------------------- */

/**
 * @dev Protocol user facing actions
 *
 * Deposit = 0
 * Withdraw = 1,
 * Repay = 2,
 * Borrow = 3,
 * Liquidate = 4
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

/**
 * @notice SCDP initializer configuration.
 * @param swapFeeRecipient The swap fee recipient.
 * @param minCollateralRatio The minimum collateralization ratio.
 * @param liquidationThreshold The liquidation threshold.
 * @param liquidationThreshold The decimals in SDI price.
 */
struct SCDPInitArgs {
    address swapFeeRecipient;
    uint32 minCollateralRatio;
    uint32 liquidationThreshold;
    uint8 sdiPricePrecision;
}

// Used for setting swap pairs enabled or disabled in the pool.
struct PairSetter {
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
    function getCurrentParametersSCDP()
        external
        view
        returns (SCDPInitArgs memory);

    function setFeeAssetSCDP(address asset) external;

    /// @notice Set the pool minimum collateralization ratio.
    function setMinCollateralRatioSCDP(uint32 _mcr) external;

    /// @notice Set the pool liquidation threshold.
    function setLiquidationThresholdSCDP(uint32 _lt) external;

    /// @notice Set the pool max liquidation ratio.
    function setMaxLiquidationRatioSCDP(uint32 _mlr) external;

    /// @notice Set the @param _newliqIncentive for @param _krAsset.
    function updateLiquidationIncentiveSCDP(
        address _krAsset,
        uint16 _newLiquidationIncentive
    ) external;

    /**
     * @notice Update the deposit asset limit configuration.
     * Only callable by admin.
     * @param _asset The Collateral asset to update
     * @param _newDepositLimit The new deposit limit for the collateral
     * emits PoolCollateralUpdated
     */
    function updateDepositLimitSCDP(
        address _asset,
        uint128 _newDepositLimit
    ) external;

    /**
     * @notice Disable or enable a deposit asset. Reverts if invalid asset.
     * Only callable by admin.
     * @param _assetAddr Asset to set.
     * @param _enabled Whether to enable or disable the asset.
     */
    function setDepositAssetSCDP(address _assetAddr, bool _enabled) external;

    /**
     * @notice Disable or enable asset from collateral value calculations.
     * Reverts if invalid asset and if disabling asset that has user deposits.
     * Only callable by admin.
     * @param _assetAddr Asset to set.
     * @param _enabled Whether to enable or disable the asset.
     */
    function setCollateralSCDP(address _assetAddr, bool _enabled) external;

    /**
     * @notice Disable or enable a kresko asset in SCDP.
     * Reverts if invalid asset. Enabling will also add it to collateral value calculations.
     * Only callable by admin.
     * @param _assetAddr Asset to set.
     * @param _enabled Whether to enable or disable the asset.
     */
    function setKrAssetSCDP(address _assetAddr, bool _enabled) external;

    /**
     * @notice Set whether pairs are enabled or not. Both ways.
     * Only callable by admin.
     * @param _setters The configurations to set.
     */
    function setSwapPairs(PairSetter[] calldata _setters) external;

    /**
     * @notice Set whether a swap pair is enabled or not.
     * Only callable by admin.
     * @param _setter The configuration to set
     */
    function setSwapPairsSingle(PairSetter calldata _setter) external;

    /**
     * @notice Sets the fees for a kresko asset
     * @dev Only callable by admin.
     * @param _krAsset The kresko asset to set fees for.
     * @param _openFee The new open fee.
     * @param _closeFee The new close fee.
     * @param _protocolFee The protocol fee share.
     */
    function setSwapFee(
        address _krAsset,
        uint16 _openFee,
        uint16 _closeFee,
        uint16 _protocolFee
    ) external;
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
     * @notice Get the collateral debt amount for `_kreskoAsset`
     * @param _kreskoAsset The KreskoAsset
     */
    function getDebtSCDP(address _kreskoAsset) external view returns (uint256);

    /**
     * @notice Get the debt value for `_kreskoAsset`
     * @param _kreskoAsset The KreskoAsset
     * @param _ignoreFactors Ignore factors when calculating collateral and debt value.
     */
    function getDebtValueSCDP(
        address _kreskoAsset,
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
     * @notice Get the swap fee recipient
     */
    function getFeeRecipientSCDP() external view returns (address);

    /**
     * @notice Get enabled state of asset
     */
    function getAssetEnabledSCDP(address _asset) external view returns (bool);

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
    function initialize(address coverRecipient) external;

    function getTotalSDIDebt() external view returns (uint256);

    function getEffectiveSDIDebtUSD() external view returns (uint256);

    function getEffectiveSDIDebt() external view returns (uint256);

    function getSDICoverAmount() external view returns (uint256);

    function previewSCDPBurn(
        address _asset,
        uint256 _burnAmount,
        bool _ignoreFactors
    ) external view returns (uint256 shares);

    function previewSCDPMint(
        address _asset,
        uint256 _mintAmount,
        bool _ignoreFactors
    ) external view returns (uint256 shares);

    /// @notice Simply returns the total supply of SDI.
    function totalSDI() external view returns (uint256);

    /// @notice Get the price of SDI in USD, oracle precision.
    function getSDIPrice() external view returns (uint256);

    function SDICover(
        address _asset,
        uint256 _amount
    ) external returns (uint256 shares, uint256 value);

    function enableCoverAssetSDI(address _asset) external;

    function disableCoverAssetSDI(address _asset) external;

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

interface IBurnFacet {
    /**
     * @notice Burns existing Kresko assets.
     * @param _account The address to burn kresko assets for
     * @param _kreskoAsset The address of the Kresko asset.
     * @param _burnAmount The amount of the Kresko asset to be burned.
     * @param _mintedKreskoAssetIndex The index of the kresko asset in the user's minted assets array.
     * Only needed if burning all principal debt of a particular collateral asset.
     */
    function burnKreskoAsset(
        address _account,
        address _kreskoAsset,
        uint256 _burnAmount,
        uint256 _mintedKreskoAssetIndex
    ) external;
}

interface IBurnHelperFacet {
    /**
     * @notice Attempts to close all debt positions and interest
     * @notice Account must have enough of krAsset balance to burn and enough KISS to cover interest
     * @param _account The address to close the positions for
     */
    function closeAllDebtPositions(address _account) external;

    /**
     * @notice Burns all Kresko asset debt and repays interest.
     * @notice Account must have enough of krAsset balance to burn and enough KISS to cover interest
     * @param _account The address to close the position for
     * @param _kreskoAsset The address of the Kresko asset.
     */
    function closeDebtPosition(address _account, address _kreskoAsset) external;
}

/* ========================================================================== */
/*                                   STRUCTS                                  */
/* ========================================================================== */
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

/**
 * @dev Fee types
 *
 * Open = 0
 * Close = 1
 */
enum MinterFee {
    Open,
    Close
}

interface IConfigurationFacet {
    function initializeMinter(MinterInitArgs calldata args) external;

    /**
     * @notice Updates the liquidation incentive multiplier.
     * @param _collateralAsset The collateral asset to update.
     * @param _newLiquidationIncentive The new liquidation incentive multiplier for the asset.
     */
    function updateLiquidationIncentive(
        address _collateralAsset,
        uint16 _newLiquidationIncentive
    ) external;

    /**
     * @notice  Updates the cFactor of a KreskoAsset.
     * @param _collateralAsset The collateral asset.
     * @param _newFactor The new collateral factor.
     */
    function updateCollateralFactor(
        address _collateralAsset,
        uint16 _newFactor
    ) external;

    /**
     * @notice Updates the kFactor of a KreskoAsset.
     * @param _kreskoAsset The KreskoAsset.
     * @param _kFactor The new kFactor.
     */
    function updateKFactor(address _kreskoAsset, uint16 _kFactor) external;

    /**
     * @dev Updates the contract's collateralization ratio.
     * @param _newMinCollateralRatio The new minimum collateralization ratio as wad.
     */
    function updateMinCollateralRatio(uint32 _newMinCollateralRatio) external;

    /**
     * @dev Updates the contract's liquidation threshold value
     * @param _newThreshold The new liquidation threshold value
     */
    function updateLiquidationThreshold(uint32 _newThreshold) external;

    /**
     * @notice Updates the max liquidation ratior value.
     * @notice This is the maximum collateral ratio that liquidations can liquidate to.
     * @param _newMaxLiquidationRatio Percent value in wad precision.
     */
    function updateMaxLiquidationRatio(uint32 _newMaxLiquidationRatio) external;
}

interface IMintFacet {
    /**
     * @notice Mints new Kresko assets.
     * @param _account The address to mint assets for.
     * @param _kreskoAsset The address of the Kresko asset.
     * @param _mintAmount The amount of the Kresko asset to be minted.
     */
    function mintKreskoAsset(
        address _account,
        address _kreskoAsset,
        uint256 _mintAmount
    ) external;
}

interface IDepositWithdrawFacet {
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

interface IStateFacet {
    /// @notice The collateralization ratio at which positions may be liquidated.
    function getLiquidationThreshold() external view returns (uint32);

    /// @notice Multiplies max liquidation multiplier, if a full liquidation happens this is the resulting CR.
    function getMaxLiquidationRatio() external view returns (uint32);

    /// @notice The minimum ratio of collateral to debt that can be taken by direct action.
    function getMinCollateralRatio() external view returns (uint32);

    /// @notice simple check if kresko asset exists
    function getKrAssetExists(address _krAsset) external view returns (bool);

    /// @notice simple check if collateral asset exists
    function getCollateralExists(
        address _collateralAsset
    ) external view returns (bool);

    /// @notice get all meaningful protocol parameters
    function getMinterParameters() external view returns (MinterParams memory);

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
     * @param _kreskoAsset The address of the Kresko asset.
     * @param _amount The amount of the Kresko asset to calculate the value for.
     * @return value The unadjusted value for the provided amount of the debt asset.
     * @return adjustedValue The (kFactor) adjusted value for the provided amount of the debt asset.
     * @return price The price of the debt asset.
     */
    function getDebtValueWithPrice(
        address _kreskoAsset,
        uint256 _amount
    )
        external
        view
        returns (uint256 value, uint256 adjustedValue, uint256 price);
}

interface ILiquidationFacet {
    /**
     * @notice Attempts to liquidate an account by repaying the portion of the account's Kresko asset
     * debt, receiving in return a portion of the account's collateral at a discounted rate.
     * @param _account Account to attempt to liquidate.
     * @param _repayAssetAddr Address of the Kresko asset to be repaid.
     * @param _repayAmount Amount of the Kresko asset to be repaid.
     * @param _seizeAssetAddr Address of the collateral asset to be seized.
     * @param _repayAssetIndex Index of the Kresko asset in the account's minted assets array.
     * @param _seizeAssetIndex Index of the collateral asset in the account's collateral assets array.
     */
    function liquidate(
        address _account,
        address _repayAssetAddr,
        uint256 _repayAmount,
        address _seizeAssetAddr,
        uint256 _repayAssetIndex,
        uint256 _seizeAssetIndex
    ) external;

    /**
     * @notice Internal, used execute _liquidateAssets.
     * @param account The account to attempt to liquidate.
     * @param repayAmount Amount of the Kresko asset to be repaid.
     * @param seizeAmount Alculated amount of collateral assets to be seized.
     * @param repayAsset Address of the Kresko asset to be repaid.
     * @param repayIndex Index of the Kresko asset in the user's minted assets array.
     * @param seizeAsset Address of the collateral asset to be seized.
     * @param seizeAssetIndex Index of the collateral asset in the account's collateral assets array.
     */
    struct ExecutionParams {
        address account;
        uint256 repayAmount;
        uint256 seizeAmount;
        address repayAssetAddr;
        uint256 repayAssetIndex;
        address seizedAssetAddr;
        uint256 seizedAssetIndex;
    }

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

interface IAccountStateFacet {
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
     * @param _kreskoAsset The asset lookup address.
     * @return index The index of asset in the minted assets array.
     */
    function getAccountMintIndex(
        address _account,
        address _kreskoAsset
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
     * @param _asset The asset address
     * @param _account The account to query amount for
     * @return uint256 Amount of debt for `_asset`
     */
    function getAccountDebtAmount(
        address _account,
        address _asset
    ) external view returns (uint256);

    /**
     * @notice Get the unadjusted and the adjusted value of collateral deposits of `_asset` for `_account`.
     * @notice Adjusted value means it is multiplied by cFactor.
     * @param _account Account to get the collateral values for.
     * @param _asset Asset to get the collateral values for.
     * @return value Unadjusted value of the collateral deposits.
     * @return valueAdjusted cFactor adjusted value of the collateral deposits.
     * @return price Price for the collateral asset
     */
    function getAccountCollateralValues(
        address _account,
        address _asset
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
     * @notice Get `_account` collateral deposit amount for `_asset`
     * @param _asset The asset address
     * @param _account The account to query amount for
     * @return uint256 Amount of collateral deposited for `_asset`
     */
    function getAccountCollateralAmount(
        address _account,
        address _asset
    ) external view returns (uint256);

    /**
     * @notice Calculates the expected fee to be taken from a user's deposited collateral assets,
     *         by imitating calcFee without modifying state.
     * @param _account Account to charge the open fee from.
     * @param _kreskoAsset Address of the kresko asset being burned.
     * @param _kreskoAssetAmount Amount of the kresko asset being minted.
     * @param _feeType Fee type (open or close).
     * @return assets Collateral types as an array of addresses.
     * @return amounts Collateral amounts as an array of uint256.
     */
    function previewFee(
        address _account,
        address _kreskoAsset,
        uint256 _kreskoAssetAmount,
        MinterFee _feeType
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
        Action _action,
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
     * @param _asset krAsset / collateral asset
     * @param _action One of possible user actions:
     *
     *  Deposit = 0
     *  Withdraw = 1,
     *  Repay = 2,
     *  Borrow = 3,
     *  Liquidate = 4
     */
    function safetyStateFor(
        address _asset,
        Action _action
    ) external view returns (SafetyState memory);

    /**
     * @notice Check if `_asset` has a pause enabled for `_action`
     * @param _action enum `Action`
     *  Deposit = 0
     *  Withdraw = 1,
     *  Repay = 2,
     *  Borrow = 3,
     *  Liquidate = 4
     * @return true if `_action` is paused
     */
    function assetActionPaused(
        Action _action,
        address _asset
    ) external view returns (bool);
}

interface ICommonConfigurationFacet {
    /**
     * @notice Updates the fee recipient.
     * @param _newFeeRecipient The new fee recipient.
     */
    function updateFeeRecipient(address _newFeeRecipient) external;

    /**
     * @dev Updates the contract's minimum debt value.
     * @param _newMinDebtValue The new minimum debt value as a wad.
     */
    function updateMinDebtValue(uint96 _newMinDebtValue) external;

    /**
     * @notice Sets the decimal precision of external oracle
     * @param _decimals Amount of decimals
     */
    function updateExtOracleDecimals(uint8 _decimals) external;

    /**
     * @notice Sets the decimal precision of external oracle
     * @param _oracleDeviationPct Amount of decimals
     */
    function updateOracleDeviationPct(uint16 _oracleDeviationPct) external;

    /**
     * @notice Sets L2 sequencer uptime feed address
     * @param _sequencerUptimeFeed sequencer uptime feed address
     */
    function updateSequencerUptimeFeed(address _sequencerUptimeFeed) external;

    /**
     * @notice Sets sequencer grace period time
     * @param _sequencerGracePeriodTime grace period time
     */
    function updateSequencerGracePeriodTime(
        uint32 _sequencerGracePeriodTime
    ) external;

    /**
     * @notice Sets oracle timeout
     * @param _oracleTimeout oracle timeout in seconds
     */
    function updateOracleTimeout(uint32 _oracleTimeout) external;

    /**
     * @notice Sets phase of gating mechanism
     * @param _phase phase id
     */
    function updatePhase(uint8 _phase) external;

    /**
     * @notice Sets address of Kreskian NFT contract
     * @param _kreskian kreskian nft contract address
     */
    function updateKreskian(address _kreskian) external;

    /**
     * @notice Sets address of Quest For Kresk NFT contract
     * @param _questForKresk Quest For Kresk NFT contract address
     */
    function updateQuestForKresk(address _questForKresk) external;
}

interface ICommonStateFacet {
    /// @notice The EIP-712 typehash for the contract's domain.
    function domainSeparator() external view returns (bytes32);

    /// @notice amount of times the storage has been upgraded
    function getStorageVersion() external view returns (uint96);

    /// @notice The recipient of protocol fees.
    function getFeeRecipient() external view returns (address);

    /// @notice Offchain oracle decimals
    function getExtOracleDecimals() external view returns (uint8);

    /// @notice max deviation between main oracle and fallback oracle
    function getOracleDeviationPct() external view returns (uint16);

    /// @notice The minimum USD value of an individual synthetic asset debt position.
    function getMinDebtValue() external view returns (uint96);

    /// @notice Get the L2 sequencer uptime feed address.
    function getSequencerUptimeFeed() external view returns (address);

    /// @notice Get the L2 sequencer uptime feed grace period
    function getSequencerUptimeFeedGracePeriod() external view returns (uint32);

    /// @notice Get stale timeout treshold for oracle answers.
    function getOracleTimeout() external view returns (uint32);
}

interface IAssetStateFacet {
    /**
     * @notice Get the state of a specific asset
     * @param _assetAddr Address of the asset.
     * @return State of assets `asset` struct
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
     * @notice Gets the feed address for this underlying + oracle type.
     * @param _underlyingId The underlying asset id in 12 bytes.
     * @param _oracleType The oracle type.
     * @return feedAddr Feed address matching the oracle type given.
     * @custom:signature getFeedForId(bytes12,uint8)
     * @custom:selector 0x708a9e64
     */
    function getFeedForId(
        bytes12 _underlyingId,
        OracleType _oracleType
    ) external view returns (address feedAddr);

    /**
     * @notice Gets corresponding feed address for the oracle type and asset address.
     * @param _assetAddr The asset address.
     * @param _oracleType The oracle type.
     * @return feedAddr Feed address that the asset uses with the oracle type.
     */
    function getFeedForAddress(
        address _assetAddr,
        OracleType _oracleType
    ) external view returns (address feedAddr);

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
     * @notice Price getter for Redstone, extracting the price from the supplied "hidden" calldata.
     * Reverts for a number of reasons, notably:
     * 1. Invalid calldata
     * 2. Not enough signers for the price data.
     * 2. Wrong signers for the price data.
     * 4. Stale price data.
     * 5. Not enough data points
     * @param _underlyingId The reference asset id (bytes12).
     * @return uint256 Extracted price with enough unique signers.
     * @custom:signature redstonePrice(bytes12,address)
     * @custom:selector 0xcc3c1f12
     */
    function redstonePrice(
        bytes12 _underlyingId,
        address
    ) external view returns (uint256);

    /**
     * @notice Price getter for IProxy/API3 type feeds.
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

interface IAssetConfigurationFacet {
    /**
     * @notice Adds a new asset to the system.
     * @notice Performs validations according to the config set.
     * @dev Use validatConfig or staticCall to validate config before calling this function.
     * @param _assetAddr The asset address.
     * @param _config The configuration for the asset.
     * @param _feedConfig The feed configuration for the asset.
     * @param _setFeeds Whether to actually set feeds or not.
     * @custom:signature addAsset(address,(bytes12,address,uint8[2],uint16,uint16,uint16,uint16,uint16,uint128,uint128,uint128,uint16,uint16,uint16,uint16,uint8,bool,bool,bool,bool,bool,bool),(uint8[2],address[2]),bool)
     * @custom:selector 0x3027bfba
     */
    function addAsset(
        address _assetAddr,
        Asset memory _config,
        FeedConfiguration memory _feedConfig,
        bool _setFeeds
    ) external;

    /**
     * @notice Update asset config.
     * @notice Performs validations according to the config set.
     * @dev Use validatConfig or staticCall to validate config before calling this function.
     * @param _assetAddr The asset address.
     * @param _config The configuration for the asset.
     * @custom:selector 0xb10fd488
     */
    function updateAsset(address _assetAddr, Asset memory _config) external;

    /**
     * @notice Set feeds for an asset Id.
     * @param _assetId Asset id.
     * @param _feedConfig List oracle configuration containing oracle identifiers and feed addresses.
     * @custom:signature updateFeeds(bytes12,(uint8[2],address[2]))
     * @custom:selector 0x4d58b9c3
     */
    function updateFeeds(
        bytes12 _assetId,
        FeedConfiguration memory _feedConfig
    ) external;

    /**
     * @notice Validate supplied asset config. Reverts with information if invalid.
     * @param _assetAddr The asset address.
     * @param _config The configuration for the asset.
     * @custom:signature validateAssetConfig(address,(bytes12,address,uint8[2],uint16,uint16,uint16,uint16,uint16,uint128,uint128,uint128,uint16,uint16,uint16,uint16,uint8,bool,bool,bool,bool,bool,bool))
     * @custom:selector 0x2fb2c6b5
     */
    function validateAssetConfig(
        address _assetAddr,
        Asset memory _config
    ) external view;

    /**
     * @notice Set chainlink feeds for assetIds.
     * @dev Has modifiers: onlyRole.
     * @param _assetIds List of asset id's.
     * @param _feeds List of feed addresses.
     */
    function setChainlinkFeeds(
        bytes12[] calldata _assetIds,
        address[] calldata _feeds
    ) external;

    /**
     * @notice Set api3 feeds for assetIds.
     * @dev Has modifiers: onlyRole.
     * @param _assetIds List of asset id's.
     * @param _feeds List of feed addresses.
     */
    function setApi3Feeds(
        bytes12[] calldata _assetIds,
        address[] calldata _feeds
    ) external;

    /**
     * @notice Set a vault feed for assetId.
     * @dev Has modifiers: onlyRole.
     * @param _assetId Asset id to set.
     * @param _vaultAddr Vault address
     */
    function setVaultFeed(bytes12 _assetId, address _vaultAddr) external;

    /**
     * @notice Set chain link feed for an asset.
     * @param _assetId The asset (bytes12).
     * @param _feedAddr The feed address.
     * @custom:signature setChainLinkFeed(bytes12,address,address)
     * @custom:selector 0x0a924d27
     */
    function setChainLinkFeed(bytes12 _assetId, address _feedAddr) external;

    /**
     * @notice Set api3 feed address for an asset.
     * @param _assetId The asset (bytes12).
     * @param _feedAddr The feed address.
     * @custom:signature setApi3Feed(bytes12,address)
     * @custom:selector 0x1e347859
     */
    function setApi3Feed(bytes12 _assetId, address _feedAddr) external;

    /**
     * @notice Update oracle order for an asset.
     * @param _assetAddr The asset address.
     * @param _newOracleOrder List of 2 OracleTypes. 0 is primary and 1 is the reference.
     * @custom:signature updateOracleOrder(address,uint8[2])
     * @custom:selector 0x8b6a306c
     */
    function updateOracleOrder(
        address _assetAddr,
        OracleType[2] memory _newOracleOrder
    ) external;
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

struct Initialization {
    address initContract;
    bytes initData;
}

interface IDiamondCutFacet {
    /**
     *@notice Add/replace/remove any number of functions, optionally execute a function with delegatecall
     * @param _diamondCut Contains the facet addresses and function selectors
     * @param _init The address of the contract or facet to execute _calldata
     * @param _calldata A function call, including function selector and arguments
     *                  _calldata is executed with delegatecall on _init
     */
    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external;

    /**
     * @notice Use an initializer contract without doing modifications
     * @param _init The address of the contract or facet to execute _calldata
     * @param _calldata A function call, including function selector and arguments
     * - _calldata is executed with delegatecall on _init
     */
    function upgradeState(address _init, bytes calldata _calldata) external;
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

/// @title Contract Ownership
interface IDiamondOwnershipFacet {
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
     * @notice emits a {AuthEvent.PendingOwnershipTransfer} event
     * @param _newOwner address that is set as the pending new owner
     */
    function transferOwnership(address _newOwner) external;

    /**
     * @notice Transfer the ownership to the new pending owner
     * @notice caller must be the pending owner
     * @notice emits a {AuthEvent.OwnershipTransferred} event
     */
    function acceptOwnership() external;

    /**
     * @notice Check if the contract is initialized
     * @return initialized_ bool True if the contract is initialized, false otherwise.
     */
    function initialized() external view returns (bool initialized_);
}

// solhint-disable-next-line no-empty-blocks
interface IKresko is
    IDiamondCutFacet,
    IDiamondLoupeFacet,
    IDiamondOwnershipFacet,
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
    IBurnFacet,
    IBurnHelperFacet,
    ISafetyCouncilFacet,
    IConfigurationFacet,
    IMintFacet,
    IStateFacet,
    IDepositWithdrawFacet,
    IAccountStateFacet,
    ILiquidationFacet
{

}
