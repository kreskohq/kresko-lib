// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {IDataV1} from "../core/types/Views.sol";
import {Log, Help} from "./Libs.s.sol";
import {Asset, Oracle, RawPrice} from "../core/types/Data.sol";
import {IERC20} from "../token/IERC20.sol";
import {PythView} from "../vendor/Pyth.sol";
import {ArbDeploy} from "../info/ArbDeploy.sol";
import {IKresko} from "../core/IKresko.sol";

// solhint-disable

abstract contract Inspector is ArbDeploy {
    using Log for *;
    using Help for *;

    IDataV1 internal constant dataV1 = IDataV1(dataV1Addr);
    IKresko internal constant kresko = IKresko(kreskoAddr);

    function peekAccount(address account, PythView memory pythView) public {
        IDataV1.DAccount memory acc = dataV1.getAccount(pythView, account);
        Log.sr();
        account.clg("Account");
        Log.hr();
        acc.protocol.minter.totals.cr.dlg("Minter CR", 2);
        acc.protocol.minter.totals.valColl.dlg("Minter Collateral", 8);
        acc.protocol.minter.totals.valDebt.dlg("Minter Debt", 8);

        Log.hr();
        _logAccMinter(account, pythView);
        uint256 totalValKresko = _logAccSCDPDeposits(acc) +
            acc.protocol.minter.totals.valColl;
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
        IDataV1.DAccount memory acc = dataV1.getAccount(pythView, account);
        for (uint256 i; i < acc.collections.length; i++) {
            acc.collections[i].name.clg("Collection");
            for (uint256 j; j < acc.collections[i].items.length; j++) {
                uint256 bal = acc.collections[i].items[j].balance;
                if (bal == 0) continue;
                string memory info = string.concat(
                    "nft id: ",
                    j.str(),
                    " balance: ",
                    bal.str()
                );
                info.clg();
            }
        }
    }

    function _logAccMinter(address account, PythView memory pythView) internal {
        IDataV1.DAccount memory acc = dataV1.getAccount(pythView, account);
        for (uint256 i; i < acc.protocol.minter.deposits.length; i++) {
            acc.protocol.minter.deposits[i].symbol.clg("Deposits");
            acc.protocol.minter.deposits[i].amount.dlg(
                "Amount",
                acc.protocol.minter.deposits[i].config.decimals
            );
            acc.protocol.minter.deposits[i].val.dlg("Value", 8);
        }

        for (uint256 i; i < acc.protocol.minter.debts.length; i++) {
            acc.protocol.minter.debts[i].symbol.clg("Debt");
            acc.protocol.minter.debts[i].amount.dlg("Amount");
            acc.protocol.minter.debts[i].val.dlg("Value", 8);
        }
    }

    function _logAccSCDPDeposits(
        IDataV1.DAccount memory acc
    ) internal returns (uint256 totalVal) {
        for (uint256 i; i < acc.protocol.scdp.deposits.length; i++) {
            acc.protocol.scdp.deposits[i].symbol.clg("SCDP Deposits");
            acc.protocol.scdp.deposits[i].amount.dlg(
                "Amount",
                acc.protocol.scdp.deposits[i].config.decimals
            );
            acc.protocol.scdp.deposits[i].val.dlg("Value", 8);
            totalVal += acc.protocol.scdp.deposits[i].val;
            Log.hr();
        }
    }

    function _logAccBals(address account, PythView memory pythView) internal {
        IDataV1.DAccount memory acc = dataV1.getAccount(pythView, account);
        uint256 totalVal;
        for (uint256 i; i < acc.protocol.bals.length; i++) {
            acc.protocol.bals[i].symbol.clg("Wallet Balance");
            acc.protocol.bals[i].amount.dlg(
                "Amount",
                acc.protocol.bals[i].decimals
            );
            acc.protocol.bals[i].val.dlg("Value", 8);
            totalVal += acc.protocol.bals[i].val;
            Log.hr();
        }

        totalVal.dlg("Total Wallet Value", 8);
        account.balance.dlg("ETH Balance");
    }

    function peekAsset(address asset) internal {
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
        config.ticker.blg2txt("Ticker");
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
            (price2.pctMul(1e4 - deviation)).dlg("Min Dev", 8);
            (price2.pctMul(1e4 + deviation)).dlg("Max Dev", 8);
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

    function peekSCDPAsset(address asset) internal {
        Asset memory config = kresko.getAsset(asset);
        Log.hr();
        uint256 totalColl = kresko.getTotalCollateralValueSCDP(false);
        uint256 totalDebt = kresko.getEffectiveSDIDebtUSD();

        uint256 debt = kresko.getDebtSCDP(asset);
        uint256 debtVal = kresko.getValue(asset, debt);

        debt.dlg("SCDP Debt", config.decimals);
        debtVal.dlg("Value", 8);
        debtVal.pctDiv(totalDebt).dlg("% of total debt", 2);

        uint256 deposits = kresko.getDepositsSCDP(asset);
        uint256 depositVal = kresko.getValue(asset, deposits);

        deposits.dlg("SCDP Deposits", config.decimals);
        depositVal.dlg("Value", 8);
        depositVal.pctDiv(totalColl).dlg("% of total collateral", 2);
        Log.hr();
    }
}
