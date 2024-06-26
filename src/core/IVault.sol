// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {IERC20} from "../token/IERC20.sol";
import {IAggregatorV3} from "../vendor/IAggregatorV3.sol";

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
    address pendingGovernance;
    address feeRecipient;
    uint8 oracleDecimals;
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

interface IVault is IERC20 {
    /* -------------------------------------------------------------------------- */
    /*                                   Events                                   */
    /* -------------------------------------------------------------------------- */

    event Deposit(
        address indexed caller,
        address indexed receiver,
        address indexed asset,
        uint256 assetsIn,
        uint256 sharesOut
    );

    event OracleSet(
        address indexed asset,
        address indexed feed,
        uint256 staletime,
        uint256 price,
        uint256 timestamp
    );

    event AssetAdded(
        address indexed asset,
        address indexed feed,
        string indexed symbol,
        uint256 staletime,
        uint256 price,
        uint256 depositLimit,
        uint256 timestamp
    );

    event AssetRemoved(address indexed asset, uint256 timestamp);

    event AssetEnabledChange(
        address indexed asset,
        bool enabled,
        uint256 timestamp
    );

    event Withdraw(
        address indexed caller,
        address indexed receiver,
        address indexed asset,
        address owner,
        uint256 assetsOut,
        uint256 sharesIn
    );

    /**
     * @notice This function deposits `assetsIn` of `asset`, regardless of the amount of vault shares minted.
     * @notice If depositFee > 0, `depositFee` of `assetsIn` is sent to the fee recipient.
     * @dev emits Deposit(caller, receiver, asset, assetsIn, sharesOut);
     * @param assetAddr Asset to deposit.
     * @param assetsIn Amount of `asset` to deposit.
     * @param receiver Address to receive `sharesOut` of vault shares.
     * @return sharesOut Amount of vault shares minted for `assetsIn`.
     * @return assetFee Amount of fees paid in `asset`.
     */
    function deposit(
        address assetAddr,
        uint256 assetsIn,
        address receiver
    ) external returns (uint256 sharesOut, uint256 assetFee);

    /**
     * @notice This function mints `sharesOut` of vault shares, regardless of the amount of `asset` received.
     * @notice If depositFee > 0, `depositFee` of `assetsIn` is sent to the fee recipient.
     * @param assetAddr Asset to deposit.
     * @param sharesOut Amount of vault shares desired to mint.
     * @param receiver Address to receive `sharesOut` of shares.
     * @return assetsIn Assets used to mint `sharesOut` of vault shares.
     * @return assetFee Amount of fees paid in `asset`.
     * @dev emits Deposit(caller, receiver, asset, assetsIn, sharesOut);
     */
    function mint(
        address assetAddr,
        uint256 sharesOut,
        address receiver
    ) external returns (uint256 assetsIn, uint256 assetFee);

    /**
     * @notice This function burns `sharesIn` of shares from `owner`, regardless of the amount of `asset` received.
     * @notice If withdrawFee > 0, `withdrawFee` of `assetsOut` is sent to the fee recipient.
     * @param assetAddr Asset to redeem.
     * @param sharesIn Amount of vault shares to redeem.
     * @param receiver Address to receive the redeemed assets.
     * @param owner Owner of vault shares.
     * @return assetsOut Amount of `asset` used for redeem `assetsOut`.
     * @return assetFee Amount of fees paid in `asset`.
     * @dev emits Withdraw(caller, receiver, asset, owner, assetsOut, sharesIn);
     */
    function redeem(
        address assetAddr,
        uint256 sharesIn,
        address receiver,
        address owner
    ) external returns (uint256 assetsOut, uint256 assetFee);

    /**
     * @notice This function withdraws `assetsOut` of assets, regardless of the amount of vault shares required.
     * @notice If withdrawFee > 0, `withdrawFee` of `assetsOut` is sent to the fee recipient.
     * @param assetAddr Asset to withdraw.
     * @param assetsOut Amount of `asset` desired to withdraw.
     * @param receiver Address to receive the withdrawn assets.
     * @param owner Owner of vault shares.
     * @return sharesIn Amount of vault shares used to withdraw `assetsOut` of `asset`.
     * @return assetFee Amount of fees paid in `asset`.
     * @dev emits Withdraw(caller, receiver, asset, owner, assetsOut, sharesIn);
     */
    function withdraw(
        address assetAddr,
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
     * @notice Array of all assets
     */
    function allAssets() external view returns (VaultAsset[] memory assets);

    /**
     * @notice Assets array used for iterating through the assets in the shares contract
     */
    function assetList(uint256 index) external view returns (address assetAddr);

    /**
     * @notice Returns the asset struct for a given asset
     * @param asset Supported asset address
     * @return asset Asset struct for `asset`
     */
    function assets(address) external view returns (VaultAsset memory asset);

    function assetPrice(address assetAddr) external view returns (uint256);

    /**
     * @notice This function is used for previewing the amount of shares minted for `assetsIn` of `asset`.
     * @param assetAddr Supported asset address
     * @param assetsIn Amount of `asset` in.
     * @return sharesOut Amount of vault shares minted.
     * @return assetFee Amount of fees paid in `asset`.
     */
    function previewDeposit(
        address assetAddr,
        uint256 assetsIn
    ) external view returns (uint256 sharesOut, uint256 assetFee);

    /**
     * @notice This function is used for previewing `assetsIn` of `asset` required to mint `sharesOut` of vault shares.
     * @param assetAddr Supported asset address
     * @param sharesOut Desired amount of vault shares to mint.
     * @return assetsIn Amount of `asset` required.
     * @return assetFee Amount of fees paid in `asset`.
     */
    function previewMint(
        address assetAddr,
        uint256 sharesOut
    ) external view returns (uint256 assetsIn, uint256 assetFee);

    /**
     * @notice This function is used for previewing `assetsOut` of `asset` received for `sharesIn` of vault shares.
     * @param assetAddr Supported asset address
     * @param sharesIn Desired amount of vault shares to burn.
     * @return assetsOut Amount of `asset` received.
     * @return assetFee Amount of fees paid in `asset`.
     */
    function previewRedeem(
        address assetAddr,
        uint256 sharesIn
    ) external view returns (uint256 assetsOut, uint256 assetFee);

    /**
     * @notice This function is used for previewing `sharesIn` of vault shares required to burn for `assetsOut` of `asset`.
     * @param assetAddr Supported asset address
     * @param assetsOut Desired amount of `asset` out.
     * @return sharesIn Amount of vault shares required.
     * @return assetFee Amount of fees paid in `asset`.
     */
    function previewWithdraw(
        address assetAddr,
        uint256 assetsOut
    ) external view returns (uint256 sharesIn, uint256 assetFee);

    /**
     * @notice Returns the maximum deposit amount of `asset`
     * @param assetAddr Supported asset address
     * @return assetsIn Maximum depositable amount of assets.
     */
    function maxDeposit(
        address assetAddr
    ) external view returns (uint256 assetsIn);

    /**
     * @notice Returns the maximum mint using `asset`
     * @param assetAddr Supported asset address.
     * @param owner Owner of assets.
     * @return sharesOut Maximum mint amount.
     */
    function maxMint(
        address assetAddr,
        address owner
    ) external view returns (uint256 sharesOut);

    /**
     * @notice Returns the maximum redeemable amount for `user`
     * @param assetAddr Supported asset address.
     * @param owner Owner of vault shares.
     * @return sharesIn Maximum redeemable amount of `shares` (vault share balance)
     */
    function maxRedeem(
        address assetAddr,
        address owner
    ) external view returns (uint256 sharesIn);

    /**
     * @notice Returns the maximum redeemable amount for `user`
     * @param assetAddr Supported asset address.
     * @param owner Owner of vault shares.
     * @return amountOut Maximum amount of `asset` received.
     */
    function maxWithdraw(
        address assetAddr,
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
     * @param assetConfig Asset to add
     */
    function addAsset(
        VaultAsset memory assetConfig
    ) external returns (VaultAsset memory);

    /**
     * @notice Removes an asset from the vault
     * @param assetAddr Asset address to remove
     * emits assetRemoved(asset, block.timestamp);
     */
    function removeAsset(address assetAddr) external;

    /**
     * @notice Current governance sets a new governance address
     * @param newGovernance The new governance address
     */
    function setGovernance(address newGovernance) external;

    function acceptGovernance() external;

    /**
     * @notice Current governance sets a new fee recipient address
     * @param newFeeRecipient The new fee recipient address
     */
    function setFeeRecipient(address newFeeRecipient) external;

    /**
     * @notice Sets a new oracle for a asset
     * @param assetAddr Asset to set the oracle for
     * @param feedAddr Feed to set
     * @param newStaleTime Time in seconds for the feed to be considered stale
     */
    function setAssetFeed(
        address assetAddr,
        address feedAddr,
        uint24 newStaleTime
    ) external;

    /**
     * @notice Sets a new oracle decimals
     * @param newDecimals New oracle decimal precision
     */
    function setFeedPricePrecision(uint8 newDecimals) external;

    /**
     * @notice Sets the max deposit amount for a asset
     * @param assetAddr Asset to set the max deposits for
     * @param newMaxDeposits Max deposits to set
     */
    function setMaxDeposits(address assetAddr, uint248 newMaxDeposits) external;

    /**
     * @notice Sets the enabled status for a asset
     * @param assetAddr Asset to set the enabled status for
     * @param isEnabled Enabled status to set
     */
    function setAssetEnabled(address assetAddr, bool isEnabled) external;

    /**
     * @notice Sets the deposit fee for a asset
     * @param assetAddr Asset to set the deposit fee for
     * @param newDepositFee Fee to set
     */
    function setDepositFee(address assetAddr, uint16 newDepositFee) external;

    /**
     * @notice Sets the withdraw fee for a asset
     * @param assetAddr Asset to set the withdraw fee for
     * @param newWithdrawFee Fee to set
     */
    function setWithdrawFee(address assetAddr, uint16 newWithdrawFee) external;
}
