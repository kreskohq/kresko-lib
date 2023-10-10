// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.0;

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

/// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
/// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
/// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
/// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
abstract contract ERC20 {
    /*//////////////////////////////////////////////////////////////
                                 EVENTS
    //////////////////////////////////////////////////////////////*/

    event Transfer(address indexed from, address indexed to, uint256 amount);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 amount
    );

    /*//////////////////////////////////////////////////////////////
                            METADATA STORAGE
    //////////////////////////////////////////////////////////////*/

    string public name;

    string public symbol;

    uint8 public immutable decimals;

    /*//////////////////////////////////////////////////////////////
                              ERC20 STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 internal _totalSupply;

    mapping(address => uint256) public balanceOf;

    mapping(address => mapping(address => uint256)) public allowance;

    /*//////////////////////////////////////////////////////////////
                            EIP-2612 STORAGE
    //////////////////////////////////////////////////////////////*/

    uint256 internal immutable INITIAL_CHAIN_ID;

    bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;

    mapping(address => uint256) public nonces;

    /*//////////////////////////////////////////////////////////////
                               CONSTRUCTOR
    //////////////////////////////////////////////////////////////*/

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;

        INITIAL_CHAIN_ID = block.chainid;
        INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
    }

    /*//////////////////////////////////////////////////////////////
                               ERC20 LOGIC
    //////////////////////////////////////////////////////////////*/

    function totalSupply() public view virtual returns (uint256) {
        return _totalSupply;
    }

    function approve(
        address spender,
        uint256 amount
    ) public virtual returns (bool) {
        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function transfer(
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        balanceOf[msg.sender] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(msg.sender, to, amount);

        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual returns (bool) {
        uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.

        if (allowed != type(uint256).max)
            allowance[from][msg.sender] = allowed - amount;

        balanceOf[from] -= amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(from, to, amount);

        return true;
    }

    /*//////////////////////////////////////////////////////////////
                             EIP-2612 LOGIC
    //////////////////////////////////////////////////////////////*/

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) public virtual {
        if (block.timestamp > deadline)
            revert CError.PERMIT_DEADLINE_EXPIRED(
                owner,
                spender,
                deadline,
                block.timestamp
            );

        // Unchecked because the only math done is incrementing
        // the owner's nonce which cannot realistically overflow.
        unchecked {
            address recoveredAddress = ecrecover(
                keccak256(
                    abi.encodePacked(
                        "\x19\x01",
                        DOMAIN_SEPARATOR(),
                        keccak256(
                            abi.encode(
                                keccak256(
                                    "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
                                ),
                                owner,
                                spender,
                                value,
                                nonces[owner]++,
                                deadline
                            )
                        )
                    )
                ),
                v,
                r,
                s
            );

            if (recoveredAddress == address(0) || recoveredAddress != owner)
                revert CError.INVALID_SIGNER(owner, recoveredAddress);

            allowance[recoveredAddress][spender] = value;
        }

        emit Approval(owner, spender, value);
    }

    function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
        return
            block.chainid == INITIAL_CHAIN_ID
                ? INITIAL_DOMAIN_SEPARATOR
                : computeDomainSeparator();
    }

    function computeDomainSeparator() internal view virtual returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    keccak256(
                        "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
                    ),
                    keccak256(bytes(name)),
                    keccak256("1"),
                    block.chainid,
                    address(this)
                )
            );
    }

    /*//////////////////////////////////////////////////////////////
                        INTERNAL MINT/BURN LOGIC
    //////////////////////////////////////////////////////////////*/

    function _mint(address to, uint256 amount) internal virtual {
        _totalSupply += amount;

        // Cannot overflow because the sum of all user
        // balances can't exceed the max uint256 value.
        unchecked {
            balanceOf[to] += amount;
        }

        emit Transfer(address(0), to, amount);
    }

    function _burn(address from, uint256 amount) internal virtual {
        balanceOf[from] -= amount;

        // Cannot underflow because a user's balance
        // will never be larger than the total supply.
        unchecked {
            _totalSupply -= amount;
        }

        emit Transfer(from, address(0), amount);
    }
}

interface AggregatorV3Interface {
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

/**
 * @notice Asset struct for deposit assets in contract
 * @param token The ERC20 token
 * @param oracle AggregatorV3Interface supporting oracle for the asset
 * @param maxDeposits Max deposits allowed for the asset
 * @param depositFee Deposit fee of the asset
 * @param withdrawFee Withdraw fee of the asset
 * @param enabled Enabled status of the asset
 */
struct VaultAsset {
    ERC20 token;
    AggregatorV3Interface oracle;
    uint24 oracleTimeout;
    uint8 decimals;
    uint32 depositFee;
    uint32 withdrawFee;
    uint248 maxDeposits;
    bool enabled;
}

/**
 * @notice Vault configuration struct
 * @param sequencerUptimeFeed The feed address for the sequencer uptime
 * @param sequencerGracePeriodTime The grace period time for the sequencer
 * @param governance The governance address
 * @param feeRecipient The fee recipient address
 * @param oracleDecimals The oracle decimals
 */
struct VaultConfiguration {
    address sequencerUptimeFeed;
    uint96 sequencerGracePeriodTime;
    address governance;
    address feeRecipient;
    uint8 oracleDecimals;
}

interface IVault {
    /* -------------------------------------------------------------------------- */
    /*                                Functionality                               */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice This function deposits `assetsIn` of `asset`, regardless of the amount of vault shares minted.
     * @notice If depositFee > 0, `depositFee` of `assetsIn` is sent to the fee recipient.
     * @dev emits Deposit(caller, receiver, asset, assetsIn, sharesOut);
     * @param asset Asset to deposit.
     * @param assetsIn Amount of `asset` to deposit.
     * @param receiver Address to receive `sharesOut` of vault shares.
     * @return sharesOut Amount of vault shares minted for `assetsIn`.
     * @return assetFee Amount of fees paid in `asset`.
     */
    function deposit(
        address asset,
        uint256 assetsIn,
        address receiver
    ) external returns (uint256 sharesOut, uint256 assetFee);

    /**
     * @notice This function mints `sharesOut` of vault shares, regardless of the amount of `asset` received.
     * @notice If depositFee > 0, `depositFee` of `assetsIn` is sent to the fee recipient.
     * @param asset Asset to deposit.
     * @param sharesOut Amount of vault shares desired to mint.
     * @param receiver Address to receive `sharesOut` of shares.
     * @return assetsIn Assets used to mint `sharesOut` of vault shares.
     * @return assetFee Amount of fees paid in `asset`.
     * @dev emits Deposit(caller, receiver, asset, assetsIn, sharesOut);
     */
    function mint(
        address asset,
        uint256 sharesOut,
        address receiver
    ) external returns (uint256 assetsIn, uint256 assetFee);

    /**
     * @notice This function burns `sharesIn` of shares from `owner`, regardless of the amount of `asset` received.
     * @notice If withdrawFee > 0, `withdrawFee` of `assetsOut` is sent to the fee recipient.
     * @param asset Asset to redeem.
     * @param sharesIn Amount of vault shares to redeem.
     * @param receiver Address to receive the redeemed assets.
     * @param owner Owner of vault shares.
     * @return assetsOut Amount of `asset` used for redeem `assetsOut`.
     * @return assetFee Amount of fees paid in `asset`.
     * @dev emits Withdraw(caller, receiver, asset, owner, assetsOut, sharesIn);
     */
    function redeem(
        address asset,
        uint256 sharesIn,
        address receiver,
        address owner
    ) external returns (uint256 assetsOut, uint256 assetFee);

    /**
     * @notice This function withdraws `assetsOut` of assets, regardless of the amount of vault shares required.
     * @notice If withdrawFee > 0, `withdrawFee` of `assetsOut` is sent to the fee recipient.
     * @param asset Asset to withdraw.
     * @param assetsOut Amount of `asset` desired to withdraw.
     * @param receiver Address to receive the withdrawn assets.
     * @param owner Owner of vault shares.
     * @return sharesIn Amount of vault shares used to withdraw `assetsOut` of `asset`.
     * @return assetFee Amount of fees paid in `asset`.
     * @dev emits Withdraw(caller, receiver, asset, owner, assetsOut, sharesIn);
     */
    function withdraw(
        address asset,
        uint256 assetsOut,
        address receiver,
        address owner
    ) external returns (uint256 sharesIn, uint256 assetFee);

    /* -------------------------------------------------------------------------- */
    /*                                    Views                                   */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Returns the current vault configuration
     * @return config Vault configuration struct
     */
    function getConfig()
        external
        view
        returns (VaultConfiguration memory config);

    /**
     * @notice Returns the total value of all assets in the shares contract in USD WAD precision.
     */
    function totalAssets() external view returns (uint256 result);

    /**
     * @notice Assets array used for iterating through the assets in the shares contract
     */
    function assetList(uint256 index) external view returns (address asset);

    /**
     * @notice Returns the asset struct for a given asset
     * @param asset Supported asset address
     * @return asset Asset struct for `asset`
     */
    function assets(address) external view returns (VaultAsset memory asset);

    /**
     * @notice This function is used for previewing the amount of shares minted for `assetsIn` of `asset`.
     * @param asset Supported asset address
     * @param assetsIn Amount of `asset` in.
     * @return sharesOut Amount of vault shares minted.
     * @return assetFee Amount of fees paid in `asset`.
     */
    function previewDeposit(
        address asset,
        uint256 assetsIn
    ) external view returns (uint256 sharesOut, uint256 assetFee);

    /**
     * @notice This function is used for previewing `assetsIn` of `asset` required to mint `sharesOut` of vault shares.
     * @param asset Supported asset address
     * @param sharesOut Desired amount of vault shares to mint.
     * @return assetsIn Amount of `asset` required.
     * @return assetFee Amount of fees paid in `asset`.
     */
    function previewMint(
        address asset,
        uint256 sharesOut
    ) external view returns (uint256 assetsIn, uint256 assetFee);

    /**
     * @notice This function is used for previewing `assetsOut` of `asset` received for `sharesIn` of vault shares.
     * @param asset Supported asset address
     * @param sharesIn Desired amount of vault shares to burn.
     * @return assetsOut Amount of `asset` received.
     * @return assetFee Amount of fees paid in `asset`.
     */
    function previewRedeem(
        address asset,
        uint256 sharesIn
    ) external view returns (uint256 assetsOut, uint256 assetFee);

    /**
     * @notice This function is used for previewing `sharesIn` of vault shares required to burn for `assetsOut` of `asset`.
     * @param asset Supported asset address
     * @param assetsOut Desired amount of `asset` out.
     * @return sharesIn Amount of vault shares required.
     * @return assetFee Amount of fees paid in `asset`.
     */
    function previewWithdraw(
        address asset,
        uint256 assetsOut
    ) external view returns (uint256 sharesIn, uint256 assetFee);

    /**
     * @notice Returns the maximum deposit amount of `asset`
     * @param asset Supported asset address
     * @return assetsIn Maximum depositable amount of assets.
     */
    function maxDeposit(address asset) external view returns (uint256 assetsIn);

    /**
     * @notice Returns the maximum mint using `asset`
     * @param asset Supported asset address.
     * @param owner Owner of assets.
     * @return sharesOut Maximum mint amount.
     */
    function maxMint(
        address asset,
        address owner
    ) external view returns (uint256 sharesOut);

    /**
     * @notice Returns the maximum redeemable amount for `user`
     * @param asset Supported asset address.
     * @param owner Owner of vault shares.
     * @return sharesIn Maximum redeemable amount of `shares` (vault share balance)
     */
    function maxRedeem(
        address asset,
        address owner
    ) external view returns (uint256 sharesIn);

    /**
     * @notice Returns the maximum redeemable amount for `user`
     * @param asset Supported asset address.
     * @param owner Owner of vault shares.
     * @return amountOut Maximum amount of `asset` received.
     */
    function maxWithdraw(
        address asset,
        address owner
    ) external view returns (uint256 amountOut);

    /**
     * @notice Returns the exchange rate of one vault share to USD.
     * @return rate Exchange rate of one vault share to USD in wad precision.
     */
    function exchangeRate() external view returns (uint256 rate);

    /* -------------------------------------------------------------------------- */
    /*                                    Admin                                   */
    /* -------------------------------------------------------------------------- */

    /**
     * @notice Adds a new asset to the vault
     * @param asset Asset to add
     */
    function addAsset(VaultAsset memory asset) external;

    /**
     * @notice Removes an asset from the vault
     * @param asset Asset address to remove
     * emits assetRemoved(asset, block.timestamp);
     */
    function removeAsset(address asset) external;

    /**
     * @notice Current governance sets a new governance address
     * @param _newGovernance The new governance address
     */
    function setGovernance(address _newGovernance) external;

    /**
     * @notice Current governance sets a new fee recipient address
     * @param _newFeeRecipient The new fee recipient address
     */
    function setFeeRecipient(address _newFeeRecipient) external;

    /**
     * @notice Sets a new oracle for a asset
     * @param asset Asset to set the oracle for
     * @param oracle Oracle to set
     * @param timeout Oracle timeout to set
     */
    function setOracle(address asset, address oracle, uint24 timeout) external;

    /**
     * @notice Sets a new oracle decimals
     * @param _oracleDecimals New oracle decimal precision
     */
    function setOracleDecimals(uint8 _oracleDecimals) external;

    /**
     * @notice Sets the max deposit amount for a asset
     * @param asset Asset to set the max deposits for
     * @param maxDeposits Max deposits to set
     */
    function setMaxDeposits(address asset, uint248 maxDeposits) external;

    /**
     * @notice Sets the enabled status for a asset
     * @param asset Asset to set the enabled status for
     * @param isEnabled Enabled status to set
     */
    function setAssetEnabled(address asset, bool isEnabled) external;

    /**
     * @notice Sets the deposit fee for a asset
     * @param asset Asset to set the deposit fee for
     * @param fee Fee to set
     */
    function setDepositFee(address asset, uint32 fee) external;

    /**
     * @notice Sets the withdraw fee for a asset
     * @param asset Asset to set the withdraw fee for
     * @param fee Fee to set
     */
    function setWithdrawFee(address asset, uint32 fee) external;

    /* -------------------------------------------------------------------------- */
    /*                                   Errors                                   */
    /* -------------------------------------------------------------------------- */
}
