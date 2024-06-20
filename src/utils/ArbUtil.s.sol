// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {getPythData} from "./ffi/PythScript.s.sol";
import {ArbDeploy} from "../info/ArbDeploy.sol";
import {__revert} from "./Base.s.sol";
import {IDataV1} from "../core/types/Views.sol";
import {Log, Help} from "./Libs.s.sol";
import {PythView} from "../vendor/Pyth.sol";
import {IAggregatorV3} from "../vendor/IAggregatorV3.sol";

// solhint-disable avoid-low-level-calls, state-visibility, const-name-snakecase

abstract contract ArbBase is ArbDeploy {
    using Log for *;
    using Help for *;
    IDataV1 constant dataV1 = IDataV1(dataV1Addr);
    bytes[] pythUpdate;
    PythView pythView;

    string pythScript;
    address[] clAssets;
    string pythAssets;
    IAggregatorV3 constant CL_ETH =
        IAggregatorV3(0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612);

    function fetchPyth(string memory assets) internal {
        (bytes[] memory update, PythView memory values) = getPythData(
            assets,
            pythScript
        );
        pythUpdate = update;
        pythView.ids = values.ids;
        delete pythView.prices;
        for (uint256 i; i < values.prices.length; i++) {
            pythView.prices.push(values.prices[i]);
        }
    }

    function fetchPyth() internal {
        fetchPyth(pythAssets);
    }

    function fetchPythAndUpdate() internal {
        fetchPyth();
        pythEP.updatePriceFeeds{value: pythEP.getUpdateFee(pythUpdate)}(
            pythUpdate
        );
    }

    function getValuePrice(
        address asset,
        uint256 amount
    ) internal returns (ValQueryRes memory) {
        ValQuery[] memory queries = new ValQuery[](1);
        queries[0] = ValQuery(asset, amount);
        return getValues(queries)[0];
    }

    function getValues(
        ValQuery[] memory queries
    ) internal returns (ValQueryRes[] memory res) {
        (bytes[] memory valCalls, bytes[] memory priceCalls) = (
            new bytes[](queries.length),
            new bytes[](queries.length)
        );
        for (uint256 i; i < queries.length; i++) {
            (valCalls[i], priceCalls[i]) = (
                abi.encodeWithSelector(
                    0xc7bf8cf5,
                    queries[i].asset,
                    queries[i].amount
                ),
                abi.encodeWithSelector(0x41976e09, queries[i].asset)
            );
        }

        bytes[] memory vals = krBatchStatic(valCalls, pythUpdate);
        bytes[] memory prices = krBatchStatic(priceCalls, pythUpdate);

        res = new ValQueryRes[](queries.length);
        for (uint256 i; i < queries.length; i++) {
            (uint256 value, uint256 price) = (
                abi.decode(vals[i], (uint256)),
                abi.decode(prices[i], (uint256))
            );
            res[i] = ValQueryRes(
                queries[i].asset,
                queries[i].amount,
                value,
                price
            );
        }
    }

    function krBatchStatic(
        bytes[] memory calls,
        bytes[] memory update
    ) internal returns (bytes[] memory results) {
        (bool success, bytes memory data) = kreskoAddr.call(
            abi.encodeWithSignature(
                "batchCallStatic(bytes[],bytes[])",
                calls,
                update
            )
        );
        if (!success) __revert(data);
        (, results) = abi.decode(data, (uint256, bytes[]));
    }

    function krBatch(bytes[] memory calls, bytes[] memory update) internal {
        (bool success, bytes memory data) = kreskoAddr.call(
            abi.encodeWithSignature(
                "batchCallStatic(bytes[],bytes[])",
                calls,
                update
            )
        );

        if (!success) __revert(data);
    }

    struct ValQuery {
        address asset;
        uint256 amount;
    }

    struct ValQueryRes {
        address asset;
        uint256 amount;
        uint256 value;
        uint256 price;
    }
}
