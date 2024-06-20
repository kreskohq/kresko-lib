// SPDX-License-Identifier: MIT
// solhint-disable
pragma solidity ^0.8.0;

import {IKreskoAsset} from "../IKreskoAsset.sol";
import {PythView} from "../../vendor/Pyth.sol";
import {Asset, RawPrice} from "./Data.sol";
import {VaultAsset} from "../IVault.sol";

library View {
    struct AssetData {
        uint256 amountColl;
        address addr;
        string symbol;
        uint256 amountCollFees;
        uint256 valColl;
        uint256 valCollAdj;
        uint256 valCollFees;
        uint256 amountDebt;
        uint256 valDebt;
        uint256 valDebtAdj;
        uint256 amountSwapDeposit;
        uint256 price;
        Asset config;
    }

    struct STotals {
        uint256 valColl;
        uint256 valCollAdj;
        uint256 valFees;
        uint256 valDebt;
        uint256 valDebtOg;
        uint256 valDebtOgAdj;
        uint256 sdiPrice;
        uint256 cr;
        uint256 crOg;
        uint256 crOgAdj;
    }

    struct Protocol {
        SCDP scdp;
        Gate gate;
        Minter minter;
        AssetView[] assets;
        uint32 sequencerGracePeriodTime;
        address pythEp;
        uint32 maxPriceDeviationPct;
        uint8 oracleDecimals;
        uint32 sequencerStartedAt;
        bool safetyStateSet;
        bool isSequencerUp;
        uint32 timestamp;
        uint256 blockNr;
        uint256 tvl;
    }

    struct Account {
        address addr;
        Balance[] bals;
        MAccount minter;
        SAccount scdp;
    }

    struct Balance {
        address addr;
        string name;
        address token;
        string symbol;
        uint256 amount;
        uint256 val;
        uint8 decimals;
    }

    struct Minter {
        uint32 MCR;
        uint32 LT;
        uint32 MLR;
        uint256 minDebtValue;
    }

    struct SCDP {
        uint32 MCR;
        uint32 LT;
        uint32 MLR;
        SDeposit[] deposits;
        Position[] debts;
        STotals totals;
        uint32 coverIncentive;
        uint32 coverThreshold;
    }

    struct Gate {
        address kreskian;
        address questForKresk;
        uint256 phase;
    }

    struct Synthwrap {
        address token;
        uint256 openFee;
        uint256 closeFee;
    }

    struct AssetView {
        IKreskoAsset.Wrapping synthwrap;
        RawPrice priceRaw;
        string name;
        string symbol;
        address addr;
        bool isMarketOpen;
        uint256 tSupply;
        uint256 price;
        Asset config;
    }

    struct MAccount {
        MTotals totals;
        Position[] deposits;
        Position[] debts;
    }

    struct MTotals {
        uint256 valColl;
        uint256 valDebt;
        uint256 cr;
    }

    struct SAccountTotals {
        uint256 valColl;
        uint256 valFees;
    }

    struct SAccount {
        address addr;
        SAccountTotals totals;
        SDepositUser[] deposits;
    }

    struct SDeposit {
        uint256 amount;
        address addr;
        string symbol;
        uint256 amountSwapDeposit;
        uint256 amountFees;
        uint256 val;
        uint256 valAdj;
        uint256 valFees;
        uint256 feeIndex;
        uint256 liqIndex;
        uint256 price;
        Asset config;
    }

    struct SDepositUser {
        uint256 amount;
        address addr;
        string symbol;
        uint256 amountFees;
        uint256 val;
        uint256 feeIndexAccount;
        uint256 feeIndexCurrent;
        uint256 liqIndexAccount;
        uint256 liqIndexCurrent;
        uint256 accountIndexTimestamp;
        uint256 valFees;
        uint256 price;
        Asset config;
    }

    struct Position {
        uint256 amount;
        address addr;
        string symbol;
        uint256 amountAdj;
        uint256 val;
        uint256 valAdj;
        int256 index;
        uint256 price;
        Asset config;
    }
}

interface IDataV1 {
    struct ExternalTokenArgs {
        address token;
        address feed;
    }

    struct DVAsset {
        address addr;
        string name;
        string symbol;
        uint8 oracleDecimals;
        uint256 vSupply;
        bool isMarketOpen;
        uint256 tSupply;
        RawPrice priceRaw;
        VaultAsset config;
        uint256 price;
    }

    struct DVToken {
        string symbol;
        uint8 decimals;
        string name;
        uint256 price;
        uint8 oracleDecimals;
        uint256 tSupply;
    }

    struct DVault {
        DVAsset[] assets;
        DVToken token;
    }

    struct DCollection {
        address addr;
        string name;
        string symbol;
        string uri;
        DCollectionItem[] items;
    }

    struct DCollectionItem {
        uint256 id;
        string uri;
        uint256 balance;
    }

    struct DGlobal {
        View.Protocol protocol;
        DVault vault;
        DCollection[] collections;
        uint256 chainId;
    }

    struct DVTokenBalance {
        address addr;
        string name;
        string symbol;
        uint256 amount;
        uint256 tSupply;
        uint8 oracleDecimals;
        uint256 val;
        uint8 decimals;
        uint256 price;
        RawPrice priceRaw;
        uint256 chainId;
    }

    struct DAccount {
        View.Account protocol;
        DCollection[] collections;
        DVTokenBalance vault;
        bool eligible;
        uint8 phase;
        uint256 chainId;
    }

    function getGlobals(
        PythView calldata prices
    ) external view returns (DGlobal memory);

    function getExternalTokens(
        ExternalTokenArgs[] memory tokens,
        address _account
    ) external view returns (DVTokenBalance[] memory);

    function getAccount(
        PythView calldata prices,
        address _account
    ) external view returns (DAccount memory);

    function getVault() external view returns (DVault memory);

    function getVAssets() external view returns (DVAsset[] memory);
}
