// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Help, Log} from "./Libs.s.sol";
import {__revert} from "./Base.s.sol";
import {FacetCut, FacetCutAction, IDiamond, IDiamondLoupeFacet, Initializer} from "../core/IDiamond.sol";
import {defaultFacetLoc, FacetData, getFacet, getFacets} from "./ffi/ffi-facets.s.sol";
import {Scripted} from "./Scripted.s.sol";
import {ArbDeploy} from "../info/ArbDeploy.sol";
import {Factory, Files} from "./Files.s.sol";

contract Cutter is ArbDeploy, Files, Scripted {
    using Help for *;
    using Log for *;

    IDiamond internal _diamond;
    FacetCut[] internal _cuts;
    string[] _files;
    Initializer internal _initializer;

    constructor() {
        createMode = CreateMode.Create1;
    }

    function cutterBase(address _diamondAddr, CreateMode _createMode) internal {
        _diamond = IDiamond(_diamondAddr);
        createMode = _createMode;
    }

    /// @notice execute stored cuts, save to json with `_id`
    function executeCuts(
        string memory _id,
        bool _dry
    ) internal withJSON(_id) returns (bytes memory _txData) {
        jsonKey(string.concat("diamondCut-", _id));
        json(address(_diamond), "to");
        json(
            _txData = abi.encodeWithSelector(
                _diamond.diamondCut.selector,
                _cuts,
                _initializer.initContract,
                _initializer.initData
            ),
            "calldata"
        );
        if (!_dry) {
            (bool success, bytes memory retdata) = address(_diamond).call(
                _txData
            );
            if (!success) {
                __revert(retdata);
            }
        }
    }

    function fullUpgrade() internal {
        fullUpgrade(defaultFacetLoc);
    }

    /**
     * @param _facetsLoc search string for facets, wildcard support
     */
    function fullUpgrade(string memory _facetsLoc) internal {
        _createAllFacets(_facetsLoc);
        executeCuts("full", false);
    }

    /**
     * @notice Deploys a new facet and executes the diamond cut.
     */
    function createFacetAndCut(
        string memory _artifact,
        CreateMode _createMode
    ) internal {
        createMode = _createMode;
        createFacet(_artifact);
        executeCuts(_artifact, false);
    }

    /**
     * @notice Deploys a new facet and adds it to the diamond cut without executing the cut.
     */
    function createFacet(string memory _artifact) internal {
        _handleFacet(getFacet(_artifact));
    }

    function _createAllFacets(string memory _facetsLoc) private {
        FacetData[] memory facetDatas = getFacets(_facetsLoc);
        for (uint256 i; i < facetDatas.length; i++) _handleFacet(facetDatas[i]);
    }

    function _handleFacet(
        FacetData memory _facet
    ) private returns (address facetAddr) {
        address oldFacet = IDiamondLoupeFacet(address(_diamond)).facetAddress(
            _facet.selectors[0]
        );
        if (oldFacet == address(0)) {
            oldFacet = IDiamondLoupeFacet(address(_diamond)).facetAddress(
                _facet.selectors[_facet.selectors.length - 1]
            );
        }

        bytes4[] memory oldSelectors;
        if (oldFacet != address(0) && !_facet.file.equals("")) {
            bytes memory code = vm.getDeployedCode(
                string.concat(_facet.file, ".sol:", _facet.file)
            );
            // skip if code is the same
            if (
                keccak256(abi.encodePacked(code)) ==
                keccak256(abi.encodePacked(oldFacet.code))
            ) {
                jsonKey(string.concat(_facet.file, "-skip"));
                json(oldFacet);
                json(true, "skipped");
                jsonKey();
                return oldFacet;
            }

            oldSelectors = IDiamondLoupeFacet(address(_diamond))
                .facetFunctionSelectors(oldFacet);
            _cuts.push(
                FacetCut({
                    facetAddress: address(0),
                    action: FacetCutAction.Remove,
                    functionSelectors: oldSelectors
                })
            );
            _files.push(
                string.concat(
                    "Remove Facet -> ",
                    _facet.file,
                    " (",
                    oldFacet.str(),
                    ")"
                )
            );
        }
        jsonKey(_facet.file);
        json(oldSelectors.length, "oldSelectors");
        facetAddr = _deployFacet(_facet.facet, _facet.file);
        json(facetAddr);

        _cuts.push(
            FacetCut({
                facetAddress: facetAddr,
                action: FacetCutAction.Add,
                functionSelectors: _facet.selectors
            })
        );
        _files.push(string.concat("New Facet -> ", _facet.file));
        json(_facet.selectors.length, "newSelectors");
        jsonKey();
    }

    function _deployFacet(
        bytes memory _code,
        string memory _salt
    ) internal returns (address addr) {
        if (createMode == CreateMode.Create1) {
            addr = _create1(_code);
        } else if (createMode == CreateMode.Create2) {
            addr = Factory.d2(_code, "", bytes32(bytes(_salt))).implementation;
        } else {
            addr = Factory
                .d3(_code, "", keccak256(abi.encodePacked(_code)))
                .implementation;
        }
    }

    function logCuts() internal view {
        _cuts.length.clg("FacetCuts:");
        for (uint256 i; i < _cuts.length; i++) {
            Log.br();
            Log.hr();
            _files[i].clg(string.concat("[CUT #", i.str(), "]"));
            _cuts[i].facetAddress.clg("Facet Address");
            uint8(_cuts[i].action).clg("Action");
            uint256 selectorLength = _cuts[i].functionSelectors.length;

            string memory selectorStr = "[";
            for (uint256 sel; sel < selectorLength; sel++) {
                selectorStr = string.concat(
                    selectorStr,
                    string(
                        abi.encodePacked(_cuts[i].functionSelectors[sel]).str()
                    ),
                    sel == selectorLength - 1 ? "" : ","
                );
            }
            string.concat(selectorStr, "]").clg(
                string.concat("Selectors (", selectorLength.str(), ")")
            );
            selectorLength.clg("Selector Count");
        }
    }
}
