// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Asset, Oracle, RawPrice} from "../core/types/Data.sol";
import {getPythData} from "./ffi/PythScript.s.sol";
import {ArbDeployAddr} from "../info/ArbDeployAddr.sol";
import {mvm} from "./MinVm.s.sol";
import {__revert} from "./Base.s.sol";
import {IDataV1} from "../core/IData.sol";
import {Log, Help} from "./Libs.s.sol";
import {IKresko} from "../core/IKresko.sol";
import {IERC20} from "../token/IERC20.sol";
import {IPyth, PythView} from "../vendor/IPyth.sol";
import {IAggregatorV3} from "../vendor/IAggregatorV3.sol";
import {ISwapRouter} from "../vendor/ISwapRouter.sol";
import {IQuoterV2} from "../vendor/IQuoterV2.sol";

// solhint-disable avoid-low-level-calls, state-visibility, const-name-snakecase

abstract contract ArbBase is ArbDeployAddr {
    using Log for *;
    using Help for *;

    bytes[] pythUpdate;
    PythView pythView;

    string pythScript;
    address[] clAssets;
    string pythAssets;
    IAggregatorV3 constant CL_ETH =
        IAggregatorV3(0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612);

    ISwapRouter constant routerV3 =
        ISwapRouter(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45);
    IQuoterV2 constant quoterV2 =
        IQuoterV2(0x61fFE014bA17989E743c5F6cB21bF9697530B21e);

    IPyth constant pythEP = IPyth(pythAddr);
    IDataV1 constant dataV1 = IDataV1(dataV1Addr);
    IKresko constant kresko = IKresko(kreskoAddr);

    constructor(
        address[] memory _clAssets,
        string memory _pythAssets,
        string memory _pythScript
    ) {
        clAssets = _clAssets;
        pythAssets = _pythAssets;
        pythScript = _pythScript;
    }

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

    function getValue(
        address asset,
        uint256 amount
    ) internal returns (uint256) {
        ValQuery[] memory queries = new ValQuery[](1);
        queries[0] = ValQuery(asset, amount);
        return getValues(queries)[0].value;
    }

    function getPrice(address asset) internal returns (uint256) {
        ValQuery[] memory queries = new ValQuery[](1);
        queries[0] = ValQuery(asset, 1e18);
        return getValues(queries)[0].price;
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

    function peekAccount(address account, bool fetch) internal {
        if (fetch) fetchPyth();
        IDataV1.DAccount memory acc = dataV1.getAccount(pythView, account);
        Log.sr();
        account.clg("Account");
        uint256 totalValInternal = acc.protocol.minter.totals.valColl;
        uint256 totalValWallet = 0;
        Log.hr();
        acc.protocol.minter.totals.cr.dlg("Minter CR", 2);
        acc.protocol.minter.totals.valColl.dlg("Minter Collateral", 8);
        acc.protocol.minter.totals.valDebt.dlg("Minter Debt", 8);
        Log.hr();
        for (uint256 i; i < acc.protocol.minter.deposits.length; i++) {
            acc.protocol.minter.deposits[i].symbol.clg("Deposits");
            acc.protocol.minter.deposits[i].amount.dlg(
                "Amount",
                acc.protocol.minter.deposits[i].config.decimals
            );
            acc.protocol.minter.deposits[i].val.dlg("Value", 8);
            Log.hr();
        }
        for (uint256 i; i < acc.protocol.minter.debts.length; i++) {
            acc.protocol.minter.debts[i].symbol.clg("Debt");
            acc.protocol.minter.debts[i].amount.dlg("Amount");
            acc.protocol.minter.debts[i].val.dlg("Value", 8);
            Log.hr();
        }
        Log.sr();
        for (uint256 i; i < acc.protocol.scdp.deposits.length; i++) {
            acc.protocol.scdp.deposits[i].symbol.clg("SCDP Deposits");
            acc.protocol.scdp.deposits[i].amount.dlg(
                "Amount",
                acc.protocol.scdp.deposits[i].config.decimals
            );
            acc.protocol.scdp.deposits[i].val.dlg("Value", 8);
            totalValInternal += acc.protocol.scdp.deposits[i].val;
            Log.hr();
        }

        for (uint256 i; i < acc.protocol.bals.length; i++) {
            acc.protocol.bals[i].symbol.clg("Wallet Balance");
            acc.protocol.bals[i].amount.dlg(
                "Amount",
                acc.protocol.bals[i].decimals
            );
            acc.protocol.bals[i].val.dlg("Value", 8);
            totalValWallet += acc.protocol.bals[i].val;
            Log.hr();
        }
        Log.sr();
        for (uint256 i; i < acc.collections.length; i++) {
            acc.collections[i].name.clg("Collection");
            for (uint256 j; j < acc.collections[i].items.length; j++) {
                uint256 bal = acc.collections[i].items[j].balance;
                if (bal == 0) continue;
                string memory info = ("nft id: ")
                    .and(mvm.toString(j))
                    .and(" balance: ")
                    .and(mvm.toString(bal));
                info.clg();
            }
        }
        Log.hr();
        totalValInternal.dlg("Total Protocol Value", 8);
        totalValWallet.dlg("Total Wallet Value", 8);
        account.balance.dlg("ETH Balance");
        mvm.getNonce(account).clg("Nonce");
        Log.sr();
    }

    function peekAsset(address asset, bool fetch) internal {
        if (fetch) fetchPythAndUpdate();

        Asset memory config = kresko.getAsset(asset);
        IERC20 token = IERC20(asset);

        (
            "/* ------------------------------ Protocol Asset ------------------------------ */"
        ).clg();
        token.symbol().clg("Symbol");
        asset.clg("Address");
        config.decimals.clg("Decimals");
        uint256 tSupply = token.totalSupply();
        tSupply.dlg("Total Supply", config.decimals);
        getValue(asset, tSupply).dlg("Market Cap", 8);
        if (config.anchor != address(0)) {
            address(config.anchor).clg("Anchor");
            IERC20(config.anchor).symbol().clg("Anchor Symbol");
            IERC20(config.anchor).totalSupply().dlg("Anchor Total Supply");
        } else {
            ("No Anchor").clg();
        }

        ("-------  Oracle --------").clg();
        config.ticker.blg2txt("Ticker");
        uint8(config.oracles[0]).clg("Primary Oracle: ");
        uint8(config.oracles[1]).clg("Secondary Oracle: ");

        Log.hr();
        Oracle memory primaryOracle = kresko.getOracleOfTicker(
            config.ticker,
            config.oracles[0]
        );
        uint256 price1 = getPrice(asset);
        price1.dlg("Primary Price", 8);
        primaryOracle.staleTime.clg("Staletime (s)");
        primaryOracle.invertPyth.clg("Inverted Price: ");
        primaryOracle.pythId.blg();
        Log.hr();

        Oracle memory secondaryOracle = kresko.getOracleOfTicker(
            config.ticker,
            config.oracles[1]
        );
        RawPrice memory secondaryPrice = kresko.getPushPrice(asset);
        uint256 price2 = uint256(secondaryPrice.answer);
        price2.dlg("Secondary Price", 8);
        secondaryPrice.staleTime.clg("Staletime (s): ");
        secondaryOracle.feed.clg("Feed: ");
        (block.timestamp - secondaryPrice.timestamp).clg(
            "Seconds since update: "
        );
        Log.hr();
        uint256 deviation = kresko.getOracleDeviationPct();
        (price2.pctMul(1e4 - deviation)).dlg("Min Dev", 8);
        (price2.pctMul(1e4 + deviation)).dlg("Max Dev", 8);
        ((price1 * 1e8) / price2).dlg("Ratio", 8);
        ("-------  Types --------").clg();
        config.isMinterMintable.clg("Minter Mintable");
        config.isMinterCollateral.clg("Minter Collateral");
        config.isSwapMintable.clg("SCDP Swappable");
        config.isSharedCollateral.clg("SCDP Depositable");
        config.isCoverAsset.clg("SCDP Cover");

        peekSCDPAsset(asset, false);
        config.kFactor.pct("kFactor");
        config.factor.pct("cFactor");
        Log.hr();
        config.depositLimitSCDP.dlg("SCDP Deposit Limit", config.decimals);
        getValue(asset, config.depositLimitSCDP).dlg("Value", 8);
        config.maxDebtMinter.dlg("Minter Debt Limit", config.decimals);
        getValue(asset, config.maxDebtMinter).dlg("Value", 8);
        config.maxDebtSCDP.dlg("SCDP Debt Limit", config.decimals);
        getValue(asset, config.maxDebtSCDP).dlg("Value", 8);

        ("-------  Config --------").clg();
        config.liqIncentiveSCDP.pct("SCDP Liquidation Incentive");
        config.liqIncentive.pct("Minter Liquidation Incentive");
        config.openFee.pct("Minter Open Fee");
        config.closeFee.pct("Minter Close Fee");
        config.swapInFeeSCDP.pct("SCDP Swap In Fee");
        config.swapOutFeeSCDP.pct("SCDP Swap Out Fee");
        config.protocolFeeShareSCDP.pct("SCDP Protocol Fee");
    }

    function peekSCDPAsset(address asset, bool fetch) internal {
        if (fetch) fetchPyth();
        Asset memory config = kresko.getAsset(asset);
        Log.hr();
        uint256 totalColl = kresko.getTotalCollateralValueSCDP(false);
        uint256 totalDebt = kresko.getEffectiveSDIDebtUSD();

        uint256 debt = kresko.getDebtSCDP(asset);
        uint256 debtVal = getValue(asset, debt);

        debt.dlg("SCDP Debt", config.decimals);
        debtVal.dlg("Value", 8);
        debtVal.pctDiv(totalDebt).dlg("% of total debt", 2);

        uint256 deposits = kresko.getDepositsSCDP(asset);
        uint256 depositVal = getValue(asset, deposits);

        deposits.dlg("SCDP Deposits", config.decimals);
        depositVal.dlg("Value", 8);
        depositVal.pctDiv(totalColl).dlg("% of total collateral", 2);
        Log.hr();
    }
}
