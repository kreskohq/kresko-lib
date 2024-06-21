// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

// solhint-disable

import {IPyth, Price, PriceFeed, PythEPs, PythView} from "../../vendor/Pyth.sol";
import {execFFI, getFFIPath} from "../Base.s.sol";
import {mvm} from "../MinVm.s.sol";

contract PythScript {
    string private _PYTH_FFI_SCRIPT;
    string[] private ffiArgs = ["bun", "run"];
    string internal pythTickers =
        "BTC,ETH,USDC,ARB,SOL,GBP,EUR,JPY,XAU,XAG,DOGE";
    bytes[] internal pythData;
    uint256 internal pythUpdateCost;
    PythView internal pythView;
    PythEPs internal pyth;

    function updatePyth() internal {
        fetchPyth(pythTickers);
        pyth.get[block.chainid].updatePriceFeeds{value: pythUpdateCost}(
            pythData
        );
    }

    function fetchPyth() internal {
        fetchPyth(pythTickers);
    }

    function fetchPyth(string memory _tickerOrIds) internal {
        delete pythView;
        (bytes[] memory update, PriceFeed[] memory values) = getPythData(
            _tickerOrIds
        );
        pythData = update;
        pythView.ids = new bytes32[](values.length);
        pythView.prices = new Price[](values.length);
        pythUpdateCost = pyth.get[block.chainid].getUpdateFee(pythData);
        for (uint256 i; i < values.length; i++) {
            pythView.ids.push(values[i].id);
            pythView.prices.push(values[i].price);
        }
    }

    constructor() {
        _PYTH_FFI_SCRIPT = getFFIPath("ffi-pyth.ts");
        ffiArgs.push(_PYTH_FFI_SCRIPT);

        pyth.avax = IPyth(0x4305FB66699C3B2702D4d05CF36551390A4c69C6);
        pyth.arbitrum = IPyth(0xff1a0f4744e8582DF1aE09D5611b887B6a12925C);
        pyth.bsc = IPyth(0x4D7E825f80bDf85e913E0DD2A2D54927e9dE1594);
        pyth.blast = IPyth(0xA2aa501b19aff244D90cc15a4Cf739D2725B5729);
        pyth.mainnet = IPyth(0x4305FB66699C3B2702D4d05CF36551390A4c69C6);
        pyth.optimism = IPyth(0xff1a0f4744e8582DF1aE09D5611b887B6a12925C);
        pyth.polygon = IPyth(0xff1a0f4744e8582DF1aE09D5611b887B6a12925C);
        pyth.polygonzkevm = IPyth(0xC5E56d6b40F3e3B5fbfa266bCd35C37426537c65);
        pyth.get[43114] = pyth.avax;
        pyth.get[42161] = pyth.arbitrum;
        pyth.get[56] = pyth.bsc;
        pyth.get[81457] = pyth.blast;
        pyth.get[1] = pyth.mainnet;
        pyth.get[10] = pyth.optimism;
        pyth.get[137] = pyth.polygon;
        pyth.get[1101] = pyth.polygonzkevm;
    }

    /**
     * @notice Update the Pyth price feeds for the given `_tickers` in the current chain
     * @param _tickers Tickers to update the price feeds for eg. "BTC,ETH"
     * @dev The Pyth endpoint for the current chain must be set
     */
    function updatePythPrices(string memory _tickers) public {
        (pythData, ) = getPythData(_tickers);
        IPyth ep = pyth.get[block.chainid];
        require(address(ep) != address(0), "PythScript: invalid chain id");
        ep.updatePriceFeeds{value: ep.getUpdateFee(pythData)}(pythData);
    }

    /**
     * @notice Update the Pyth price feeds for the given `_ids` in the current chain
     * @param _ids Pyth IDs to update the price feeds for eg. [0xff61491a931112ddf1bd8147cd1b641375f79f5825126d665480874634fd0ace]"
     * @dev The Pyth endpoint for the current chain must be set
     */
    function updatePythPrices(bytes32[] memory _ids) public {
        (pythData, ) = getPythData(_ids);
        IPyth ep = pyth.get[block.chainid];
        require(address(ep) != address(0), "PythScript: invalid chain id");
        ep.updatePriceFeeds{value: ep.getUpdateFee(pythData)}(pythData);
    }

    function getPythData(
        string memory _tickers
    ) public returns (bytes[] memory payload, PriceFeed[] memory priceData) {
        ffiArgs.push(_tickers);
        return _exec();
    }

    function getPythData(
        bytes32[] memory _ids
    ) public returns (bytes[] memory payload, PriceFeed[] memory priceData) {
        string memory arg;
        for (uint256 i; i < _ids.length; i++) {
            arg = string.concat(arg, i == 0 ? "" : ",", mvm.toString(_ids[i]));
        }
        ffiArgs.push(arg);
        return _exec();
    }

    /**
     * @notice Get the price for a given Pyth ID
     * @param _id Pyth ID to get the price for
     * @return price Price data returned from the hermes endpoint
     */
    function getPrice(bytes32 _id) public returns (Price memory) {
        bytes32[] memory ids = new bytes32[](1);
        ids[0] = _id;
        (, PriceFeed[] memory priceData) = getPythData(ids);
        return priceData[0].price;
    }

    /**
     * @notice Get the price for a given ticker
     * @param _ticker Ticker to get the price for
     * @return price Price data returned from the hermes endpoint
     */
    function getTickerPrice(
        string memory _ticker
    ) public returns (Price memory) {
        (, PriceFeed[] memory priceData) = getPythData(_ticker);
        return priceData[0].price;
    }

    function _exec()
        private
        returns (bytes[] memory payload, PriceFeed[] memory data)
    {
        bytes memory res = execFFI(ffiArgs);
        ffiArgs = ["bun", "run", _PYTH_FFI_SCRIPT];

        return abi.decode(res, (bytes[], PriceFeed[]));
    }
}
