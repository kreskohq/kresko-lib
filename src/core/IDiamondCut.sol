// SPDX-License-Identifier: MIT
// solhint-disable
pragma solidity ^0.8.0;

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

interface IExtendedDiamondCutFacet is IDiamondCutFacet {
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
