// SPDX-License-Identifier: MIT
// solhint-disable
pragma solidity ^0.8.0;

import {ArbDeployAddr} from "./ArbDeployAddr.sol";
import {IKresko1155} from "../token/IKresko1155.sol";
import {IKISS} from "../core/IKISS.sol";
import {IKreskoAsset, IKreskoAssetAnchor} from "../core/IKreskoAsset.sol";
import {IKresko} from "../core/IKresko.sol";
import {IVault} from "../core/IVault.sol";
import {IPyth} from "../vendor/IPyth.sol";
import {IMarketStatus} from "../core/IMarketStatus.sol";

abstract contract ArbDeploy is ArbDeployAddr {
    IKresko1155 constant kreskian = IKresko1155(kreskianAddr);
    IKresko1155 constant qfk = IKresko1155(questAddr);

    IKresko constant kresko = IKresko(kreskoAddr);
    IVault constant vault = IVault(vaultAddr);
    IKISS constant kiss = IKISS(kissAddr);

    IKreskoAsset constant krETH = IKreskoAsset(krETHAddr);
    IKreskoAsset constant krBTC = IKreskoAsset(krBTCAddr);
    IKreskoAsset constant krSOL = IKreskoAsset(krSOLAddr);
    IKreskoAsset constant krEUR = IKreskoAsset(krEURAddr);
    IKreskoAsset constant krJPY = IKreskoAsset(krJPYAddr);

    IKreskoAssetAnchor constant akrETH = IKreskoAssetAnchor(akrETHAddr);
    IKreskoAssetAnchor constant akrBTC = IKreskoAssetAnchor(akrBTCAddr);
    IKreskoAssetAnchor constant akrSOL = IKreskoAssetAnchor(akrSOLAddr);
    IKreskoAssetAnchor constant akrEUR = IKreskoAssetAnchor(akrEURAddr);
    IKreskoAssetAnchor constant akrJPY = IKreskoAssetAnchor(akrJPYAddr);

    IPyth constant pythEP = IPyth(pythAddr);
    IMarketStatus constant marketStatus = IMarketStatus(marketStatusAddr);
}
