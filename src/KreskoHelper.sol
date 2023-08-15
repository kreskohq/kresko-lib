// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IERC20} from "./vendor/IERC20.sol";
import {WadRay} from "./libs/WadRay.sol";
import {UniswapV2Library} from "./vendor/uniswapv2/UniswapV2Library.sol";
import {UniswapV2LiquidityMathLibrary} from "./vendor/uniswapv2/UniswapV2LiquidityMathLibrary.sol";
import {Deployment, IUniswapV2Pair} from "./Deployments.sol";

library KreskoHelpers {
    struct AssetParams {
        IERC20 asset;
        uint256 assetAmount;
    }

    struct Users {
        address user0;
        address user1;
        address user2;
    }
    using WadRay for uint256;
    using KreskoHelpers for Deployment;
    using KreskoHelpers for AssetParams;

    function exitKreskoAsset(
        Deployment memory deployment,
        address user,
        address asset
    ) internal {
        // 1. repay debt
        uint256 debtAsset = deployment.Kresko.kreskoAssetDebtPrincipal(
            user,
            asset
        );
        if (debtAsset > 0) {
            uint256 index = deployment.Kresko.getMintedKreskoAssetsIndex(
                user,
                asset
            );
            deployment.Kresko.burnKreskoAsset(user, asset, debtAsset, index);
        }

        // 2. try withdraw asset deposits
        uint256 depositsAsset = deployment.Kresko.collateralDeposits(
            user,
            asset
        );
        if (depositsAsset > 0) {
            uint256 index = deployment.Kresko.getDepositedCollateralAssetIndex(
                user,
                asset
            );
            deployment.Kresko.withdrawCollateral(
                user,
                asset,
                depositsAsset,
                index
            );
        }
    }

    function assetPriceAMM(
        Deployment memory deployment,
        AssetParams storage assetParams,
        address pairToken
    ) internal view returns (uint256) {
        IUniswapV2Pair pair = IUniswapV2Pair(
            deployment.UniswapV2Factory.getPair(
                address(assetParams.asset),
                pairToken
            )
        );
        (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
        if (address(assetParams.asset) == pair.token1()) {
            return UniswapV2Library.quote(1 ether, reserve1, reserve0);
        }
        return UniswapV2Library.quote(1 ether, reserve0, reserve1);
    }

    function assetPriceOracle(
        Deployment memory deployment,
        AssetParams storage assetParams
    ) internal view returns (uint256) {
        return
            deployment.Kresko.getKrAssetValue(
                address(assetParams.asset),
                1 ether,
                true
            );
    }

    function getKrAssetDebtValue(
        Deployment memory deployment,
        AssetParams storage assetParams,
        address user
    ) internal view returns (uint256) {
        uint256 priceAsset = deployment.Kresko.getKrAssetValue(
            address(assetParams.asset),
            1 ether,
            true
        );
        return priceAsset.wadMul(assetParams.asset.balanceOf(user));
    }

    function removeAllLiquidity(
        Deployment memory deployment,
        AssetParams storage assetParams,
        address user,
        address pairToken
    ) internal {
        IUniswapV2Pair pair = IUniswapV2Pair(
            deployment.UniswapV2Factory.getPair(
                address(assetParams.asset),
                pairToken
            )
        );
        deployment.UniswapV2Router.removeLiquidity(
            address(assetParams.asset),
            pairToken,
            pair.balanceOf(user),
            0,
            0,
            user,
            block.timestamp
        );
    }

    function sortTokens(
        AssetParams storage self,
        address pairToken
    ) internal view returns (address, address) {
        return UniswapV2Library.sortTokens(address(self.asset), pairToken);
    }

    function quoteA(
        Deployment memory deployment,
        AssetParams storage assetParams,
        address pairToken,
        address quoteToken,
        uint256 amount
    ) internal view returns (uint256) {
        IUniswapV2Pair pair = IUniswapV2Pair(
            deployment.UniswapV2Factory.getPair(
                address(assetParams.asset),
                pairToken
            )
        );
        (uint256 reserveA, uint256 reserveB, ) = pair.getReserves();
        (address tokenA, ) = assetParams.sortTokens(pairToken);
        return
            quoteToken != tokenA
                ? UniswapV2Library.quote(amount, reserveA, reserveB)
                : UniswapV2Library.quote(amount, reserveB, reserveA);
    }

    function quoteB(
        Deployment memory deployment,
        AssetParams storage assetParams,
        address pairToken,
        address quoteToken,
        uint256 amount
    ) internal view returns (uint256) {
        IUniswapV2Pair pair = IUniswapV2Pair(
            deployment.UniswapV2Factory.getPair(
                address(assetParams.asset),
                pairToken
            )
        );
        (uint256 reserveA, uint256 reserveB, ) = pair.getReserves();
        (address tokenA, ) = assetParams.sortTokens(pairToken);
        return
            quoteToken == tokenA
                ? UniswapV2Library.quote(amount, reserveA, reserveB)
                : UniswapV2Library.quote(amount, reserveB, reserveA);
    }

    function getLPValue(
        Deployment memory deployment,
        AssetParams storage assetParams,
        address user,
        address pairToken
    ) internal view returns (uint256 amountAsset, uint256 amountOther) {
        IUniswapV2Pair pair = IUniswapV2Pair(
            deployment.UniswapV2Factory.getPair(
                address(assetParams.asset),
                pairToken
            )
        );
        (address tokenA, address tokenB) = sortTokens(assetParams, pairToken);

        (uint256 amountA, uint256 amountB) = UniswapV2LiquidityMathLibrary
            .getLiquidityValue(
                address(deployment.UniswapV2Factory),
                tokenA,
                tokenB,
                pair.balanceOf(user)
            );

        (amountAsset, amountOther) = tokenA == address(assetParams.asset)
            ? (amountA, amountB)
            : (amountB, amountA);
    }

    function addLiquidityPCT(
        Deployment memory deployment,
        AssetParams storage assetParams,
        address user,
        address pairToken,
        uint256 pct
    ) internal {
        (address tokenA, address tokenB) = sortTokens(assetParams, pairToken);
        uint256 amountAsset = (assetParams.asset.balanceOf(user) * pct) / 100;
        uint256 amountOther = deployment.quoteB(
            assetParams,
            tokenA,
            tokenA,
            amountAsset
        );
        bool isAssetA = tokenA == address(assetParams.asset);
        deployment.UniswapV2Router.addLiquidity(
            tokenA,
            tokenB,
            isAssetA ? amountAsset : amountOther,
            isAssetA ? amountOther : amountAsset,
            0,
            0,
            user,
            block.timestamp
        );
    }
}
