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

abstract contract ArbDeploy is ArbDeployAddr {
    IKresko1155 kreskian = IKresko1155(kreskianAddr);
    IKresko1155 qfk = IKresko1155(questAddr);

    IKresko kresko = IKresko(kreskoAddr);
    IVault vault = IVault(vaultAddr);
    IKISS kiss = IKISS(kissAddr);

    IKreskoAsset krETH = IKreskoAsset(krETHAddr);
    IKreskoAsset krBTC = IKreskoAsset(krBTCAddr);
    IKreskoAsset krSOL = IKreskoAsset(krSOLAddr);

    IKreskoAssetAnchor akrETH = IKreskoAssetAnchor(akrETHAddr);
    IKreskoAssetAnchor akrBTC = IKreskoAssetAnchor(akrBTCAddr);
    IKreskoAssetAnchor akrSOL = IKreskoAssetAnchor(akrSOLAddr);
    IPyth pythEP = IPyth(pythAddr);
}
