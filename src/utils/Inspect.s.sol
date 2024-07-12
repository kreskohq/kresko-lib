// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {IData} from "../core/types/Views.sol";
import {Log, Help} from "./s/LibVm.s.sol";
import {Asset, Oracle, RawPrice} from "../core/types/Data.sol";
import {IERC20} from "../token/IERC20.sol";
import {PythView} from "../vendor/Pyth.sol";
import {ArbDeploy} from "../info/ArbDeploy.sol";
import {IKresko} from "../core/IKresko.sol";
import {PercentageMath} from "../core/Math.sol";
import {Utils} from "./Libs.sol";

// solhint-disable

abstract contract Inspector is ArbDeploy {
    using Log for *;
    using Help for *;
    using Utils for *;
    using PercentageMath for *;

    IData internal constant dataV1 = IData(dataAddr);
    IKresko internal constant kresko = IKresko(kreskoAddr);
    address[] extTokens = [USDTAddr];
    function peekAccount(
        address account,
        PythView memory pythView
    ) public view {
        IData.A memory acc = dataV1.getAccount(pythView, account, extTokens);
        Log.sr();
        account.clg("Account");
        Log.hr();
        acc.minter.totals.cr.dlg("Minter CR", 2);
        acc.minter.totals.valColl.dlg("Minter Collateral", 8);
        acc.minter.totals.valDebt.dlg("Minter Debt", 8);

        Log.hr();
        _logAccMinter(account, pythView);
        uint256 totalValKresko = _logAccSCDPDeposits(acc) +
            acc.minter.totals.valColl;
        Log.sr();
        _logAccBals(account, pythView);
        Log.sr();
        _logCollections(account, pythView);
        Log.hr();
        totalValKresko.dlg("Total Protocol Value", 8);

        Log.sr();
    }

    function _logCollections(
        address account,
        PythView memory pythView
    ) internal view {
        IData.A memory acc = dataV1.getAccount(pythView, account, extTokens);
        for (uint256 i; i < acc.collections.length; i++) {
            acc.collections[i].name.clg("Collection");
            for (uint256 j; j < acc.collections[i].items.length; j++) {
                uint256 bal = acc.collections[i].items[j].balance;
                if (bal == 0) continue;
                string memory info = string.concat(
                    "nft id: ",
                    j.txt(),
                    " balance: ",
                    bal.txt()
                );
                info.clg();
            }
        }
    }

    function _logAccMinter(
        address account,
        PythView memory pythView
    ) internal view {
        IData.A memory acc = dataV1.getAccount(pythView, account, extTokens);
        for (uint256 i; i < acc.minter.deposits.length; i++) {
            acc.minter.deposits[i].symbol.clg("Deposits");
            acc.minter.deposits[i].amount.dlg(
                "Amount",
                acc.minter.deposits[i].config.decimals
            );
            acc.minter.deposits[i].val.dlg("Value", 8);
        }

        for (uint256 i; i < acc.minter.debts.length; i++) {
            acc.minter.debts[i].symbol.clg("Debt");
            acc.minter.debts[i].amount.dlg("Amount");
            acc.minter.debts[i].val.dlg("Value", 8);
        }
    }

    function _logAccSCDPDeposits(
        IData.A memory acc
    ) internal pure returns (uint256 totalVal) {
        for (uint256 i; i < acc.scdp.deposits.length; i++) {
            acc.scdp.deposits[i].symbol.clg("SCDP Deposits");
            acc.scdp.deposits[i].amount.dlg(
                "Amount",
                acc.scdp.deposits[i].config.decimals
            );
            acc.scdp.deposits[i].val.dlg("Value", 8);
            totalVal += acc.scdp.deposits[i].val;
            Log.hr();
        }
    }

    function _logAccBals(
        address account,
        PythView memory pythView
    ) internal view {
        IData.A memory acc = dataV1.getAccount(pythView, account, extTokens);
        uint256 totalVal;
        for (uint256 i; i < acc.tokens.length; i++) {
            acc.tokens[i].symbol.clg("Wallet Balance");
            acc.tokens[i].amount.dlg("Amount", acc.tokens[i].decimals);
            acc.tokens[i].val.dlg("Value", acc.tokens[i].oracleDec);
            totalVal += acc.tokens[i].val;
            Log.hr();
        }

        totalVal.dlg("Total Wallet Value", 8);
        account.balance.dlg("ETH Balance");
    }

    function peekAsset(address asset) internal view {
        Asset memory config = kresko.getAsset(asset);
        IERC20 token = IERC20(asset);
        (
            "/* ------------------------------ Protocol Asset ------------------------------ */"
        ).clg();
        token.symbol().clg("Symbol");
        asset.clg("Address");
        config.decimals.clg("Decimals");
        {
            uint256 tSupply = token.totalSupply();
            tSupply.dlg("Total Supply", config.decimals);
            kresko.getValue(asset, tSupply).dlg("Market Cap", 8);
        }
        if (config.anchor != address(0)) {
            address(config.anchor).clg("Anchor");
            IERC20(config.anchor).symbol().clg("Anchor Symbol");
            IERC20(config.anchor).totalSupply().dlg("Anchor Total Supply");
        } else {
            ("No Anchor").clg();
        }
        ("-------  Oracle --------").clg();
        config.ticker.str().clg("Ticker");
        uint8(config.oracles[0]).clg("Primary Oracle: ");
        uint8(config.oracles[1]).clg("Secondary Oracle: ");
        Log.hr();
        {
            Oracle memory primaryOracle = kresko.getOracleOfTicker(
                config.ticker,
                config.oracles[0]
            );
            uint256 price1 = kresko.getPrice(asset);
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
            (price2.percentMul(1e4 - deviation)).dlg("Min Dev", 8);
            (price2.percentMul(1e4 + deviation)).dlg("Max Dev", 8);
            ((price1 * 1e8) / price2).dlg("Ratio", 8);
        }
        ("-------  Types --------").clg();
        config.isMinterMintable.clg("Minter Mintable");
        config.isMinterCollateral.clg("Minter Collateral");
        config.isSwapMintable.clg("SCDP Swappable");
        config.isSharedCollateral.clg("SCDP Depositable");
        config.isCoverAsset.clg("SCDP Cover");
        peekSCDPAsset(asset);
        config.kFactor.pct("kFactor");
        config.factor.pct("cFactor");
        Log.hr();
        config.depositLimitSCDP.dlg("SCDP Deposit Limit", config.decimals);
        kresko.getValue(asset, config.depositLimitSCDP).dlg("Value", 8);
        config.maxDebtMinter.dlg("Minter Debt Limit", config.decimals);
        kresko.getValue(asset, config.maxDebtMinter).dlg("Value", 8);
        config.maxDebtSCDP.dlg("SCDP Debt Limit", config.decimals);
        kresko.getValue(asset, config.maxDebtSCDP).dlg("Value", 8);
        ("-------  Config --------").clg();
        config.liqIncentiveSCDP.pct("SCDP Liquidation Incentive");
        config.liqIncentive.pct("Minter Liquidation Incentive");
        config.openFee.pct("Minter Open Fee");
        config.closeFee.pct("Minter Close Fee");
        config.swapInFeeSCDP.pct("SCDP Swap In Fee");
        config.swapOutFeeSCDP.pct("SCDP Swap Out Fee");
        config.protocolFeeShareSCDP.pct("SCDP Protocol Fee");
    }

    function peekSCDPAsset(address asset) internal view {
        Asset memory config = kresko.getAsset(asset);
        Log.hr();
        uint256 totalColl = kresko.getTotalCollateralValueSCDP(false);
        uint256 totalDebt = kresko.getEffectiveSDIDebtUSD();

        uint256 debt = kresko.getDebtSCDP(asset);
        uint256 debtVal = kresko.getValue(asset, debt);

        debt.dlg("SCDP Debt", config.decimals);
        debtVal.dlg("Value", 8);
        debtVal.percentDiv(totalDebt).dlg("% of total debt", 2);

        uint256 deposits = kresko.getDepositsSCDP(asset);
        uint256 depositVal = kresko.getValue(asset, deposits);

        deposits.dlg("SCDP Deposits", config.decimals);
        depositVal.dlg("Value", 8);
        depositVal.percentDiv(totalColl).dlg("% of total collateral", 2);
        Log.hr();
    }
}
