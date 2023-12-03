// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;
import {vm} from "./IMinimalVM.sol";

interface ILoupe {
    function facetFunctionSelectors(
        address _facet
    ) external view returns (bytes4[] memory facetFunctionSelectors_);

    function facetAddresses()
        external
        view
        returns (address[] memory facetAddresses_);

    function facetAddress(
        bytes4 _functionSelector
    ) external view returns (address facetAddress_);
}

abstract contract FacetScript {
    string internal _selectorGetterScript;
    error ContainsWhitespace(string str);
    error NoSelectorsFound(string facetName);
    error EmptyString();

    constructor(string memory scriptLocation) {
        if (bytes(scriptLocation).length != 0) {
            _selectorGetterScript = scriptLocation;
        } else {
            revert("FacetScript: script location is empty");
        }
    }

    /// @dev Retrieves the function selectors for a given facet name from its JSON artifact.
    /// @param _facetName The name of the facet.
    /// @return selectors The function selectors for the facet.
    function getSelectorsFromArtifact(
        string memory _facetName
    ) internal returns (bytes4[] memory selectors) {
        bytes memory b = bytes(_facetName);

        if (b.length == 0) revert EmptyString();

        for (uint256 i; i < b.length; i++) {
            if (b[i] == 0x20) revert ContainsWhitespace(_facetName);
        }

        string[] memory cmd = new string[](2);
        cmd[0] = _selectorGetterScript;
        cmd[1] = _facetName;

        bytes memory res = vm.ffi(cmd);

        selectors = abi.decode(res, (bytes4[]));

        if (selectors.length == 0) revert NoSelectorsFound(_facetName);
    }

    /// @dev Retrieves the function selectors for a given facet address from the diamond loupe.
    /// @param diamondAddress The address of the diamond contract.
    /// @param facetAddress The address of the facet.
    /// @return _facetFunctionSelectors The function selectors for the facet.
    function getFacetSelectorsFromLoupe(
        address diamondAddress,
        address facetAddress
    ) internal view returns (bytes4[] memory _facetFunctionSelectors) {
        _facetFunctionSelectors = ILoupe(diamondAddress).facetFunctionSelectors(
            facetAddress
        );
    }

    /// @dev Retrieves the facet address for a given function selector from the diamond loupe.
    /// @param diamondAddress The address of the diamond contract.
    /// @param functionSelector The function selector.
    /// @return _facetAddress The address of the facet.
    function getFacetBySelectorFromLoupe(
        address diamondAddress,
        bytes4 functionSelector
    ) internal view returns (address _facetAddress) {
        _facetAddress = ILoupe(diamondAddress).facetAddress(functionSelector);
    }
}
