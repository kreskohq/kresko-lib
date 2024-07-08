// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;
import {WadRay} from "../core/Math.sol";

/// @dev https://github.com/pyth-network/pyth-sdk-solidity/blob/main/PythStructs.sol
/// @dev Extra ticker is included in the struct
struct PriceFeed {
    // The price ID.
    bytes32 id;
    // Latest available price
    Price price;
    // Latest available exponentially-weighted moving average price
    Price emaPrice;
}

/// @dev  https://github.com/pyth-network/pyth-sdk-solidity/blob/main/PythStructs.sol
struct Price {
    // Price
    int64 price;
    // Confidence interval around the price
    uint64 conf;
    // Price exponent
    int32 expo;
    // Unix timestamp describing when the price was published
    uint256 publishTime;
}

struct PythEPs {
    mapping(uint256 chainId => IPyth pythEp) get;
    IPyth avax;
    IPyth bsc;
    IPyth blast;
    IPyth mainnet;
    IPyth arbitrum;
    IPyth optimism;
    IPyth polygon;
    IPyth polygonzkevm;
    bytes[] update;
    uint256 cost;
    PythView viewData;
    string tickers;
}

struct PythView {
    bytes32[] ids;
    Price[] prices;
}

function getPythPriceView(
    PriceFeed[] memory feeds
) pure returns (PythView memory view_) {
    view_.ids = new bytes32[](feeds.length);
    view_.prices = new Price[](feeds.length);
    for (uint256 i; i < feeds.length; i++) {
        view_.ids[i] = feeds[i].id;
        view_.prices[i] = feeds[i].price;
    }
}

interface IPyth {
    function getPriceNoOlderThan(
        bytes32 _id,
        uint256 _maxAge
    ) external view returns (Price memory);

    function getPriceUnsafe(bytes32 _id) external view returns (Price memory);

    function getUpdateFee(
        bytes[] memory _updateData
    ) external view returns (uint256);

    function updatePriceFeeds(bytes[] memory _updateData) external payable;

    function updatePriceFeedsIfNecessary(
        bytes[] memory _updateData,
        bytes32[] memory _ids,
        uint64[] memory _publishTimes
    ) external payable;

    // Function arguments are invalid (e.g., the arguments lengths mismatch)
    // Signature: 0xa9cb9e0d
    error InvalidArgument();
    // Update data is coming from an invalid data source.
    // Signature: 0xe60dce71
    error InvalidUpdateDataSource();
    // Update data is invalid (e.g., deserialization error)
    // Signature: 0xe69ffece
    error InvalidUpdateData();
    // Insufficient fee is paid to the method.
    // Signature: 0x025dbdd4
    error InsufficientFee();
    // There is no fresh update, whereas expected fresh updates.
    // Signature: 0xde2c57fa
    error NoFreshUpdate();
    // There is no price feed found within the given range or it does not exists.
    // Signature: 0x45805f5d
    error PriceFeedNotFoundWithinRange();
    // Price feed not found or it is not pushed on-chain yet.
    // Signature: 0x14aebe68
    error PriceFeedNotFound();
    // Requested price is stale.
    // Signature: 0x19abf40e
    error StalePrice();
    // Given message is not a valid Wormhole VAA.
    // Signature: 0x2acbe915
    error InvalidWormholeVaa();
    // Governance message is invalid (e.g., deserialization error).
    // Signature: 0x97363b35
    error InvalidGovernanceMessage();
    // Governance message is not for this contract.
    // Signature: 0x63daeb77
    error InvalidGovernanceTarget();
    // Governance message is coming from an invalid data source.
    // Signature: 0x360f2d87
    error InvalidGovernanceDataSource();
    // Governance message is old.
    // Signature: 0x88d1b847
    error OldGovernanceMessage();
    // The wormhole address to set in SetWormholeAddress governance is invalid.
    // Signature: 0x13d3ed82
    error InvalidWormholeAddressToSet();
}

using WadRay for uint256;
function pythPrice(
    address _pythEp,
    bytes32 _id,
    bool _invert,
    uint256 _staleTime
) view returns (uint256 price, uint8 expo) {
    return
        processPyth(
            IPyth(_pythEp).getPriceNoOlderThan(_id, _staleTime),
            _invert
        );
}
function processPyth(
    Price memory _price,
    bool _invert
) pure returns (uint256 price, uint8 expo) {
    if (!_invert) {
        (price, expo) = normalizePythPrice(_price, 8);
    } else {
        (price, expo) = invertNormalizePythPrice(_price, 8);
    }

    if (price == 0 || price > type(uint56).max) {
        revert IPyth.PriceFeedNotFoundWithinRange();
    }
}

function normalizePythPrice(
    Price memory _price,
    uint8 oracleDec
) pure returns (uint256 price, uint8 expo) {
    price = uint64(_price.price);
    expo = uint8(uint32(-_price.expo));

    if (expo > oracleDec) {
        price = price / 10 ** (expo - oracleDec);
    } else if (expo < oracleDec) {
        price = price * 10 ** (oracleDec - expo);
    }
}

function invertNormalizePythPrice(
    Price memory _price,
    uint8 oracleDec
) pure returns (uint256 price, uint8 expo) {
    _price.price = int64(
        uint64(1 * (10 ** uint32(-_price.expo)).wadDiv(uint64(_price.price)))
    );
    _price.expo = -18;
    return normalizePythPrice(_price, oracleDec);
}
