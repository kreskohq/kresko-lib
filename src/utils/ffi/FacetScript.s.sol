// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;
import {vmFFI} from "../Base.s.sol";

interface ILoupe {
    function facetFunctionSelectors(
        address
    ) external view returns (bytes4[] memory);

    function facetAddresses() external view returns (address[] memory);

    function facetAddress(bytes4) external view returns (address);
}

abstract contract FacetScript {
    string __facetScript;
    error ContainsWhitespace(string str);
    error NoSelectorsFound(string facetName);
    error EmptyString();

    constructor(string memory script) {
        if (bytes(script).length != 0) {
            __facetScript = script;
        } else {
            revert("FacetScript: no script");
        }
    }

    function getSelectors(
        string memory _artifact
    ) internal returns (bytes4[] memory selectors) {
        bytes memory b = bytes(_artifact);

        if (b.length == 0) revert EmptyString();

        for (uint256 i; i < b.length; i++) {
            if (b[i] == 0x20) revert ContainsWhitespace(_artifact);
        }

        string[] memory cmd = new string[](2);
        cmd[0] = __facetScript;
        cmd[1] = _artifact;

        selectors = abi.decode(vmFFI.ffi(cmd), (bytes4[]));

        if (selectors.length == 0) revert NoSelectorsFound(_artifact);
    }

    function getSelectorsFromLoupe(
        address _diamond,
        address _facet
    ) internal view returns (bytes4[] memory) {
        return ILoupe(_diamond).facetFunctionSelectors(_facet);
    }

    function getFacetBySelectorFromLoupe(
        address _diamond,
        bytes4 _selector
    ) internal view returns (address) {
        return ILoupe(_diamond).facetAddress(_selector);
    }
}
