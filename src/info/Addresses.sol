// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IQuoterV2} from "../vendor/IQuoterV2.sol";
import {ISwapRouter} from "../vendor/ISwapRouter.sol";
import {IUniswapV3Factory} from "../vendor/IUniswapV3Factory.sol";
import {IUniswapV3NFTManager} from "../vendor/IUniswapV3NFTManager.sol";
import {ERC20} from "../core/IVault.sol";
import {IWETH9} from "../vendor/IWETH9.sol";

struct V3Pools {
    address usdcweth500;
    address usdceusdt100;
    address usdceusdc100;
    address wethusdt500;
    address wethwbtc500;
    address daiusdce100; // 0xF0428617433652c9dc6D1093A42AdFbF30D29f74
    address arbusdc500;
    address arbweth500;
    address gmxweth3000;
    address gmxweth500;
}

library Arbitrum {
    ERC20 constant arb = ERC20(0x912CE59144191C1204E64559FE8253a0e49E6548);
    ERC20 constant frax = ERC20(0x17FC002b466eEc40DaE837Fc4bE5c67993ddBd6F);
    ERC20 constant dai = ERC20(0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1);
    ERC20 constant usdc = ERC20(0xaf88d065e77c8cC2239327C5EDb3A432268e5831);
    ERC20 constant usdce = ERC20(0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8);
    ERC20 constant link = ERC20(0xf97f4df75117a78c1A5a0DBb814Af92458539FB4);
    ERC20 constant wbtc = ERC20(0x2f2a2543B76A4166549F7aaB2e75Bef0aefC5B0f);
    ERC20 constant usdt = ERC20(0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9);
    ERC20 constant gmx = ERC20(0xfc5A1A6EB076a2C7aD06eD22C90d7E710E35ad0a);
    ERC20 constant gns = ERC20(0x18c11FD286C5EC11c3b683Caa813B77f5163A122);
    IWETH9 constant weth = IWETH9(0x82aF49447D8a07e3bd95BD0d56f35241523fBab1);

    uint24 constant defaultFee = 3000;
    address constant V3TickLensAddr =
        0xbfd8137f7d1516D3ea5cA83523914859ec47F573;
    address constant V3NFTPosDescriptorAddr =
        0x91ae842A5Ffd8d12023116943e72A606179294f3;
    address constant V3NFTDescriptorAddr =
        0x42B24A95702b9986e82d421cC3568932790A48Ec;
    address constant V3RouterAddr = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    ISwapRouter constant V3Router02 =
        ISwapRouter(0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45);
    IQuoterV2 constant V3QuoterV2 =
        IQuoterV2(0x61fFE014bA17989E743c5F6cB21bF9697530B21e);
    IUniswapV3NFTManager constant V3NFTManager =
        IUniswapV3NFTManager(0xC36442b4a4522E871399CD717aBDD847Ab11FE88);
    IUniswapV3Factory constant V3Factory =
        IUniswapV3Factory(0x1F98431c8aD98523631AE4a59f267346ea31F984);

    function poolv3() internal pure returns (V3Pools memory) {
        return
            V3Pools({
                usdceusdt100: 0x8c9D230D45d6CfeE39a6680Fb7CB7E8DE7Ea8E71,
                usdceusdc100: 0x8e295789c9465487074a65b1ae9Ce0351172393f,
                usdcweth500: 0xC31E54c7a869B9FcBEcc14363CF510d1c41fa443,
                daiusdce100: 0xF0428617433652c9dc6D1093A42AdFbF30D29f74,
                wethusdt500: 0x641C00A822e8b671738d32a431a4Fb6074E5c79d,
                wethwbtc500: 0x2f5e87C9312fa29aed5c179E456625D79015299c,
                arbusdc500: 0xb0f6cA40411360c03d41C5fFc5F179b8403CdcF8,
                arbweth500: 0xC6F780497A95e246EB9449f5e4770916DCd6396A,
                gmxweth3000: 0x1aEEdD3727A6431b8F070C0aFaA81Cc74f273882,
                gmxweth500: 0x80A9ae39310abf666A87C743d6ebBD0E8C42158E
            });
    }
}
