// SPDX-License-Identifier: MIT
// solhint-disable
pragma solidity ^0.8.0;

interface IERC165_0 {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC165Internal {}

interface IERC721Internal {
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );

    event Approval(
        address indexed owner,
        address indexed operator,
        uint256 indexed tokenId
    );

    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );
}

interface IERC721Enumerable {
    function totalSupply() external view returns (uint256);

    /**
     * @notice get token of given owner at given internal storage index
     * @param owner token holder to query
     * @param index position in owner's token list to query
     * @return tokenId id of retrieved token
     */
    function tokenOfOwnerByIndex(
        address owner,
        uint256 index
    ) external view returns (uint256 tokenId);

    /**
     * @notice get token at given internal storage index
     * @param index position in global token list to query
     * @return tokenId id of retrieved token
     */
    function tokenByIndex(
        uint256 index
    ) external view returns (uint256 tokenId);
}

// src/core/interfaces/IActionFacet.sol

interface IActionFacet {
    function link(uint256 tokenId) external;

    function unlink() external;

    function lock1155(
        address[] memory nfts,
        uint256[] memory tokenIds,
        uint256[] memory amounts
    ) external;

    function unlock1155(
        address[] calldata nfts,
        uint256[] calldata tokenIds,
        uint256[] calldata amounts
    ) external;
}

// src/core/interfaces/IClaimerFacet.sol

interface IClaimerFacet {
    function claimAndMint(
        uint256 airdropId,
        bytes32[] calldata proof,
        uint256 amount
    ) external;

    function claim(
        uint256 airdropId,
        bytes32[] calldata proof,
        uint256 amount
    ) external;

    function burnKreditsAndMint(
        uint256 airdropId,
        bytes32[] calldata proof,
        uint256 amount
    ) external;

    function burnAndMint() external;
}

// src/core/libs/Errors.sol

interface Errors {
    error NotOwner(address sender, address owner);
    error OnlyUnlinked();
    error OnlyLinked();
    error InvalidClaimId(uint256 id);
    error AlreadyClaimed(address who, uint256 id);

    error NotStarted(uint256 id, uint256 startTime);
    error ClaimWindowEnded(uint256 id, uint256 endTime);

    error NotLinked(address who);

    error NotMintingClaim(uint256 id);
    error NotBurningClaim(uint256 id);
}

interface IDiamondCutFacet {
    struct Initializer {
        address initializer;
        bytes data;
    }

    enum FacetCutAction {
        Add,
        Replace,
        Remove
    }
    // Add=0, Replace=1, Remove=2

    struct FacetCut {
        address facetAddress;
        FacetCutAction action;
        bytes4[] functionSelectors;
    }

    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external;

    event DiamondCut(FacetCut[] _diamondCut, address _init, bytes _calldata);
}

interface IExtendedDiamondCutFacet is IDiamondCutFacet {
    function executeInitializer(Initializer calldata _init) external;
}

interface IDiamondLoupeFacet {
    struct Facet {
        address facetAddress;
        bytes4[] functionSelectors;
    }

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

interface IERC173 {
    /// @dev This emits when ownership of a contract changes.
    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /// @notice Get the address of the owner
    /// @return owner_ The address of the owner.
    function owner() external view returns (address owner_);

    /// @notice Set the address of the new owner of the contract
    /// @dev Set _newOwner to address(0) to renounce any ownership.
    /// @param _newOwner The address of the new owner of the contract
    function transferOwnership(address _newOwner) external;
}

/**
 * @dev Required interface of an ERC1155 compliant contract, as defined in the
 * https://eips.ethereum.org/EIPS/eip-1155[EIP].
 */
interface IERC1155 is IERC165_0 {
    /**
     * @dev Emitted when `value` amount of tokens of type `id` are transferred from `from` to `to` by `operator`.
     */
    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 value
    );

    /**
     * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
     * transfers.
     */
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] values
    );

    /**
     * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
     * `approved`.
     */
    event ApprovalForAll(
        address indexed account,
        address indexed operator,
        bool approved
    );

    /**
     * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
     *
     * If an {URI} event was emitted for `id`, the standard
     * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
     * returned by {IERC1155MetadataURI-uri}.
     */
    event URI(string value, uint256 indexed id);

    /**
     * @dev Returns the value of tokens of token type `id` owned by `account`.
     *
     * Requirements:
     *
     * - `account` cannot be the zero address.
     */
    function balanceOf(
        address account,
        uint256 id
    ) external view returns (uint256);

    /**
     * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
     *
     * Requirements:
     *
     * - `accounts` and `ids` must have the same length.
     */
    function balanceOfBatch(
        address[] calldata accounts,
        uint256[] calldata ids
    ) external view returns (uint256[] memory);

    /**
     * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
     *
     * Emits an {ApprovalForAll} event.
     *
     * Requirements:
     *
     * - `operator` cannot be the caller.
     */
    function setApprovalForAll(address operator, bool approved) external;

    /**
     * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
     *
     * See {setApprovalForAll}.
     */
    function isApprovedForAll(
        address account,
        address operator
    ) external view returns (bool);

    /**
     * @dev Transfers a `value` amount of tokens of type `id` from `from` to `to`.
     *
     * WARNING: This function can potentially allow a reentrancy attack when transferring tokens
     * to an untrusted contract, when invoking {onERC1155Received} on the receiver.
     * Ensure to follow the checks-effects-interactions pattern and consider employing
     * reentrancy guards when interacting with untrusted contracts.
     *
     * Emits a {TransferSingle} event.
     *
     * Requirements:
     *
     * - `to` cannot be the zero address.
     * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
     * - `from` must have a balance of tokens of type `id` of at least `value` amount.
     * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
     * acceptance magic value.
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external;

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external;
}

interface IERC165_1 is IERC165Internal {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

/**
 * @title ERC721 base interface
 */
interface IERC721BaseInternal is IERC721Internal {
    error ERC721Base__NotOwnerOrApproved();
    error ERC721Base__SelfApproval();
    error ERC721Base__BalanceQueryZeroAddress();
    error ERC721Base__ERC721ReceiverNotImplemented();
    error ERC721Base__InvalidOwner();
    error ERC721Base__MintToZeroAddress();
    error ERC721Base__NonExistentToken();
    error ERC721Base__NotTokenOwner();
    error ERC721Base__TokenAlreadyMinted();
    error ERC721Base__TransferToZeroAddress();
}

interface IOwnershipFacet is IERC173 {}

interface IERC721MetadataInternal is IERC721BaseInternal {
    error ERC721Metadata__NonExistentToken();
}

/**
 * @title Claim Event
 * @param merkleRoot Merkle root of the claim
 * @param startDate Start date of the claim
 * @param claimWindow Claim window of the claim
 * @param minting Is the claim a minting event
 * @param burning Is the claim a burning event
 * @dev Claim event struct
 */
struct ClaimEvent {
    bytes32 merkleRoot;
    uint128 startDate;
    uint128 claimWindow;
    bool minting;
    bool burning;
}

/**
 * @title Storage layout for the registry state
 * @author Kresko
 */
struct RegistryState {
    // Airdrops
    uint256 airdropsIds;
    // Kredits to be burnt for Minting 721
    uint256 kreditsForMint;
    // Mapping kredits airdrop to merkle roots
    mapping(uint256 => ClaimEvent) claimEvents;
    // Claimed airdrops
    mapping(address => mapping(uint256 => bool)) claimed;
    // ERC721 Minted
    uint256 currentTokenIds;
    // Valid Kresko 1155 NFT
    mapping(address => bool) isValid;
    // Mapping from token ID to kredits
    mapping(uint256 => uint256) kredits;
    // Mapping from user to token ID
    mapping(address => uint256) linkedId;
    // NFT token Id to 1155 token to 1155 id to amounts locked
    mapping(uint256 => mapping(address => mapping(uint256 => uint256))) locked;
}

// Storage position
bytes32 constant REGISTRY_STORAGE_POSITION = keccak256(
    "kresko.registry.storage"
);

/* -------------------------------------------------------------------------- */
/*                                   Getter                                   */
/* -------------------------------------------------------------------------- */

function rs() pure returns (RegistryState storage state) {
    bytes32 position = REGISTRY_STORAGE_POSITION;
    assembly {
        state.slot := position
    }
}

// lib/solidstate/contracts/interfaces/IERC721.sol

/**
 * @title ERC721 interface
 * @dev see https://eips.ethereum.org/EIPS/eip-721
 */
interface IERC721 is IERC721Internal, IERC165_1 {
    /**
     * @notice query the balance of given address
     * @return balance quantity of tokens held
     */
    function balanceOf(address account) external view returns (uint256 balance);

    /**
     * @notice query the owner of given token
     * @param tokenId token to query
     * @return owner token owner
     */
    function ownerOf(uint256 tokenId) external view returns (address owner);

    /**
     * @notice transfer token between given addresses, checking for ERC721Receiver implementation if applicable
     * @param from sender of token
     * @param to receiver of token
     * @param tokenId token id
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external payable;

    /**
     * @notice transfer token between given addresses, checking for ERC721Receiver implementation if applicable
     * @param from sender of token
     * @param to receiver of token
     * @param tokenId token id
     * @param data data payload
     */
    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external payable;

    /**
     * @notice transfer token between given addresses, without checking for ERC721Receiver implementation if applicable
     * @param from sender of token
     * @param to receiver of token
     * @param tokenId token id
     */
    function transferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external payable;

    /**
     * @notice grant approval to given account to spend token
     * @param operator address to be approved
     * @param tokenId token to approve
     */
    function approve(address operator, uint256 tokenId) external payable;

    /**
     * @notice get approval status for given token
     * @param tokenId token to query
     * @return operator address approved to spend token
     */
    function getApproved(
        uint256 tokenId
    ) external view returns (address operator);

    /**
     * @notice grant approval to or revoke approval from given account to spend all tokens held by sender
     * @param operator address to be approved
     * @param status approval status
     */
    function setApprovalForAll(address operator, bool status) external;

    /**
     * @notice query approval status of given operator with respect to given address
     * @param account address to query for approval granted
     * @param operator address to query for approval received
     * @return status whether operator is approved to spend tokens held by account
     */
    function isApprovedForAll(
        address account,
        address operator
    ) external view returns (bool status);
}

// lib/solidstate/contracts/token/ERC721/metadata/IERC721Metadata.sol

/**
 * @title ERC721Metadata interface
 */
interface IERC721Metadata is IERC721MetadataInternal {
    /**
     * @notice get token name
     * @return token name
     */
    function name() external view returns (string memory);

    /**
     * @notice get token symbol
     * @return token symbol
     */
    function symbol() external view returns (string memory);

    /**
     * @notice get generated URI for given token
     * @return token URI
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}

// src/core/interfaces/IClaimerConfigFacet.sol

interface IClaimerConfigFacet {
    function createClaim(ClaimEvent memory config) external returns (uint256);

    function updateClaim(uint256 airdropId, ClaimEvent memory config) external;

    function setKreditsForMint(uint256 amount) external;

    function mintProfile(address to, bool link) external returns (uint256);
}

// src/core/interfaces/IViewFacet.sol

interface IViewFacet {
    struct AccountInfo {
        bool linked;
        uint256 linkedId;
        uint256 points;
        uint256 walletProfileId;
        bool claimedCurrent;
        uint256[] lockedQFKs;
        bool hasKreskian;
        uint256 currentClaimId;
    }

    function getAccountInfo(
        address _account
    ) external view returns (AccountInfo memory account);

    function getBurnNftAddress() external view returns (address);

    function getClaimed(
        address user,
        uint256 airdropId
    ) external view returns (bool);

    function getIsValid(address nft) external view returns (bool);

    function getKredits(uint256 tokenId) external view returns (uint256);

    function getLinkedId(address user) external view returns (uint256);

    function getLocked(
        uint256 tokenId721,
        address nft,
        uint256 tokenId1155
    ) external view returns (uint256);

    function getConfigIds() external view returns (uint256);

    function getTokenIds() external view returns (uint256);

    function getConfig(
        uint256 airdropId
    ) external view returns (ClaimEvent memory);

    function getKreditsForMint() external view returns (uint256);
}

// src/core/libs/Events.sol

interface Events {
    event Linked(address indexed user, uint256 tokenId);
    event Unlinked(address indexed user, uint256 tokenId);
    event KreditsAdded(uint256 tokenId, uint256 amount);
    event KreditsRemoved(uint256 tokenId, uint256 amount);
    event Locked(
        address indexed user,
        uint256 tokenId721,
        address indexed token,
        uint256 amount,
        uint256 indexed tokenId
    );
    event Unlocked(
        address indexed user,
        uint256 tokenId721,
        address indexed token,
        uint256 amount,
        uint256 indexed tokenId
    );
    event Claimed(
        address indexed user,
        uint256 tokenId721,
        uint256 airdropId,
        uint256 amount
    );
    event ClaimCreated(uint256 airdropId, ClaimEvent config);
    event ClaimUpdated(uint256 airdropId, ClaimEvent config);
    event KreditsForMintSet(uint256 amount);
}

interface IERC721Base is IERC721BaseInternal, IERC721 {}

interface IERC721Facet is IERC721Base, IERC721Enumerable, IERC721Metadata {
    function supportsInterface(bytes4 interfaceId) external view returns (bool);

    function onERC721Received(
        address operator,
        address from,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata values,
        bytes calldata data
    ) external returns (bytes4);

    function onERC1155Received(
        address operator,
        address from,
        uint256 id,
        uint256 value,
        bytes calldata data
    ) external returns (bytes4);
}

interface IKreditsDiamond is
    IDiamondCutFacet,
    IDiamondLoupeFacet,
    IOwnershipFacet,
    IClaimerFacet,
    IClaimerConfigFacet,
    IActionFacet,
    IViewFacet,
    IERC721Facet,
    Errors,
    Events
{}
