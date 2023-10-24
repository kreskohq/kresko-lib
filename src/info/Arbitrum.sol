// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IQuoterV2} from "../vendor/IQuoterV2.sol";
import {ISwapRouter} from "../vendor/ISwapRouter.sol";
import {IUniswapV3Factory} from "../vendor/IUniswapV3Factory.sol";
import {IUniswapV3NFTManager} from "../vendor/IUniswapV3NFTManager.sol";
import {IAggregatorV3} from "../vendor/IAggregatorV3.sol";
import {IERC20} from "../token/IERC20.sol";
import {IAPI3} from "../vendor/IAPI3.sol";
import {IWETH9} from "../token/IWETH9.sol";

library Addr {
    address internal constant ZERO = address(0);
    address internal constant KRESKO_SAFE =
        0x389297F0d8C489954D65e04ff0690FC54E57Dad6;
    address internal constant OFFICIALLY_KRESKIAN =
        0xAbDb949a18d27367118573A217E5353EDe5A0f1E;
    address internal constant QUEST_FOR_KRESK =
        0x1C04925779805f2dF7BbD0433ABE92Ea74829bF6;

    address internal constant gDAI = 0xd85E038593d7A098614721EaE955EC2022B9B91B;
    address internal constant DAI = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1;
    address internal constant ARB = 0x912CE59144191C1204E64559FE8253a0e49E6548;
    address internal constant FRAX = 0x17FC002b466eEc40DaE837Fc4bE5c67993ddBd6F;
    address internal constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    address internal constant WBTC = 0x2f2a2543B76A4166549F7aaB2e75Bef0aefC5B0f;
    address internal constant USDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    address internal constant USDCe =
        0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8;
    address internal constant USDT = 0xFd086bC7CD5C481DCC9C85ebE478A1C0b69FCbb9;
    address internal constant LINK = 0xf97f4df75117a78c1A5a0DBb814Af92458539FB4;
    address internal constant GMX = 0xfc5A1A6EB076a2C7aD06eD22C90d7E710E35ad0a;
    address internal constant GNS = 0x18c11FD286C5EC11c3b683Caa813B77f5163A122;

    address internal constant V3_Router =
        0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address internal constant V3_Router02 =
        0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;
    address internal constant V3_QuoterV2 =
        0x61fFE014bA17989E743c5F6cB21bF9697530B21e;
    address internal constant V3_Factory =
        0x1F98431c8aD98523631AE4a59f267346ea31F984;
    address internal constant V3_NFT =
        0xC36442b4a4522E871399CD717aBDD847Ab11FE88;
    address internal constant V3_TickLens =
        0xbfd8137f7d1516D3ea5cA83523914859ec47F573;
    address internal constant V3_NFTPosDescriptor =
        0x91ae842A5Ffd8d12023116943e72A606179294f3;
    address internal constant V3_NFTDescriptor =
        0x42B24A95702b9986e82d421cC3568932790A48Ec;
    address internal constant V3_USDCe_USDT_100 =
        0x8c9D230D45d6CfeE39a6680Fb7CB7E8DE7Ea8E71;
    address internal constant V3_USDCe_USDC_100 =
        0x8e295789c9465487074a65b1ae9Ce0351172393f;
    address internal constant V3_USDC_WETH_500 =
        0xC31E54c7a869B9FcBEcc14363CF510d1c41fa443;
    address internal constant V3_DAI_USDCe_100 =
        0xF0428617433652c9dc6D1093A42AdFbF30D29f74;
    address internal constant V3_WETH_USD_500 =
        0x641C00A822e8b671738d32a431a4Fb6074E5c79d;
    address internal constant V3_WETH_WBTC_500 =
        0x2f5e87C9312fa29aed5c179E456625D79015299c;
    address internal constant V3_ARB_USDC_500 =
        0xb0f6cA40411360c03d41C5fFc5F179b8403CdcF8;
    address internal constant V3_ARB_WETH_500 =
        0xC6F780497A95e246EB9449f5e4770916DCd6396A;
    address internal constant V3_GMX_WETH_3000 =
        0x1aEEdD3727A6431b8F070C0aFaA81Cc74f273882;
    address internal constant V3_GMX_WETH_500 =
        0x80A9ae39310abf666A87C743d6ebBD0E8C42158E;

    address internal constant CL_SEQ_UPTIME =
        0xFdB631F5EE196F0ed6FAa767959853A9F217697D;
    address internal constant CL_ARB =
        0xb2A824043730FE05F3DA2efaFa1CBbe83fa548D6;
    address internal constant CL_EUR =
        0xA14d53bC1F1c0F31B4aA3BD109344E5009051a84;
    address internal constant CL_TMCAP =
        0x7519bCA20e21725557Bb98d9032124f8885a26C2;
    address internal constant CL_ETHMCAP =
        0xB1f70A229FE7cceD0428245db8B1f6C48c7Ea82a;
    address internal constant CL_NFTBC =
        0x8D0e319eBAA8DF32e088e469062F85abF2eBe599;
    address internal constant CL_VOLATIVITY =
        0xbcD8bEA7831f392bb019ef3a672CC15866004536;
    address internal constant CL_BUSD =
        0x8FCb0F3715A82D83270777b3a5f3a7CF95Ce8Eec;
    address internal constant CL_CNY =
        0xcC3370Bde6AFE51e1205a5038947b9836371eCCb;
    address internal constant CL_GBP =
        0x9C4424Fd84C6661F97D8d6b3fc3C1aAc2BeDd137;
    address internal constant CL_CBETH_USD =
        0xa668682974E3f121185a3cD94f00322beC674275;
    address internal constant CL_CBETH_ETH =
        0x0518673439245BB95A58688Bc31cd513F3D5bDd6;
    address internal constant CL_STETH_USD =
        0x07C5b924399cc23c24a95c8743DE4006a32b7f2a;
    address internal constant CL_STETH_ETH =
        0xded2c52b75B24732e9107377B7Ba93eC1fFa4BAf;
    address internal constant CL_W_STETH_ETH =
        0xb523AE262D20A936BC152e6023996e46FDC2A95D;
    address internal constant CL_RETH_ETH =
        0xD6aB2298946840262FcC278fF31516D39fF611eF;
    address internal constant CL_AAPL =
        0x8d0CC5f38f9E802475f2CFf4F9fc7000C2E1557c;
    address internal constant CL_AMZN =
        0xd6a77691f071E98Df7217BED98f38ae6d2313EBA;
    address internal constant CL_META =
        0xcd1bd86fDc33080DCF1b5715B6FCe04eC6F85845;
    address internal constant CL_TSLA =
        0x3609baAa0a9b1f0FE4d6CC01884585d0e191C3E3;
    address internal constant CL_MSFT =
        0xDde33fb9F21739602806580bdd73BAd831DcA867;
    address internal constant CL_SPY =
        0x46306F3795342117721D8DEd50fbcF6DF2b3cc10;
    address internal constant CL_GOOGL =
        0x1D1a83331e9D255EB1Aaf75026B60dFD00A252ba;
    address internal constant CL_BTC =
        0x6ce185860a4963106506C203335A2910413708e9;
    address internal constant CL_WBTC =
        0xd0C7101eACbB49F3deCcCc166d238410D6D46d57;
    address internal constant CL_WBTC_BTC =
        0x0017abAc5b6f291F9164e35B1234CA1D697f9CF4;
    address internal constant CL_DAI =
        0xc5C8E77B397E531B8EC06BFb0048328B30E9eCfB;
    address internal constant CL_FRAX =
        0x0809E3d38d1B4214958faf06D8b1B1a2b73f2ab8;
    address internal constant CL_ETH =
        0x639Fe6ab55C921f74e7fac1ee960C0B6293ba612;
    address internal constant CL_LINK =
        0x86E53CF1B870786351Da77A57575e79CB55812CB;
    address internal constant CL_JPY =
        0x3dD6e51CB9caE717d5a8778CF79A04029f9cFDF8;
    address internal constant CL_KRW =
        0x85bb02E0Ae286600d1c68Bb6Ce22Cc998d411916;
    address internal constant CL_SGD =
        0xF0d38324d1F86a176aC727A4b0c43c9F9d9c5EB1;
    address internal constant CL_USDT =
        0x3f3f5dF88dC9F13eac63DF89EC16ef6e7E25DdE7;
    address internal constant CL_USDC =
        0x50834F3163758fcC1Df9973b6e91f0F0F0434aD3;

    address internal constant API3_EUR =
        0xA37F6f5a04b7D5eB8DF71799e09D683f8CeC22F3;
    address internal constant API3_ARB =
        0x0cB281EC7DFB8497d07196Dc0f86D2eFD21066A5;
    address internal constant API3_BTC =
        0xe5Cf15fED24942E656dBF75165aF1851C89F21B5;
    address internal constant API3_ETH =
        0x26690F9f17FdC26D419371315bc17950a0FC90eD;
    address internal constant API3_CNY =
        0xb0C30FD871b54eFfdD9e0158EfD086fe6472cF75;
    address internal constant API3_GBP =
        0x2760445db099427F9A394fb1365e1Aa08Ed1f84d;

    address internal constant ARB_GAS_INFO =
        0x000000000000000000000000000000000000006C;
    address internal constant ARB_STATISTICS =
        0x000000000000000000000000000000000000006F;
    address internal constant ARB_L1_GOERLI_BRIDGE =
        0x6BEbC4925716945D46F0Ec336D5C2564F419682C;
    address internal constant ARB_L1_MAINNET_BRIDGE =
        0x4Dbd4fc535Ac27206064B68FfCf827b0A60BAB3f;
    address internal constant ARB_L1_MAINNET_BRIDGE_NOVA =
        0xc4448b71118c9071Bcb9734A0EAc55D18A153949;

    address internal constant DAI_L1 =
        0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address internal constant DAI_L1_GATEWAY =
        0xD3B5b60020504bc3489D6949d545893982BA3011;
    address internal constant DAI_L1_ESCROW =
        0xA10c7CE4b876998858b1a9E12b10092229539400;
    address internal constant DAI_L2_GATEWAY =
        0x467194771dAe2967Aef3ECbEDD3Bf9a310C76C65;
}

library Tokens {
    IERC20 internal constant gDAI = IERC20(Addr.gDAI);
    IERC20 internal constant ARB = IERC20(Addr.ARB);
    IERC20 internal constant FRAX = IERC20(Addr.FRAX);
    IERC20 internal constant DAI = IERC20(Addr.DAI);
    IERC20 internal constant USDC = IERC20(Addr.USDC);
    IERC20 internal constant USDCe = IERC20(Addr.USDCe);
    IERC20 internal constant LINK = IERC20(Addr.LINK);
    IERC20 internal constant WBTC = IERC20(Addr.WBTC);
    IWETH9 internal constant WETH = IWETH9(Addr.WETH);
    IERC20 internal constant USDT = IERC20(Addr.USDT);
    IERC20 internal constant GMX = IERC20(Addr.GMX);
    IERC20 internal constant GNS = IERC20(Addr.GNS);
}

interface IArbitrumBridge {
    function depositEth() external payable;
}

interface L2DaiGateway {
    function outboundTransfer(
        address l1Token,
        address to,
        uint256 amount,
        bytes calldata data
    ) external returns (bytes memory);

    function counterpartGateway() external view returns (address);
}

interface L1DaiGateway {
    function outboundTransfer(
        address l1Token,
        address to,
        uint256 amount,
        uint256 maxGas,
        uint256 gasPriceBid,
        bytes calldata data
    ) external payable returns (bytes memory);

    function calculateL2TokenAddress(
        address l1Token
    ) external view returns (address);

    function counterpartGateway() external view returns (address);
}

library bridges {
    L1DaiGateway internal constant DAI_L1_GATEWAY =
        L1DaiGateway(Addr.DAI_L1_GATEWAY);
    L2DaiGateway internal constant DAI_L2_GATEWAY =
        L2DaiGateway(Addr.DAI_L2_GATEWAY);
    IArbitrumBridge internal constant ARB_L1_GOERLI =
        IArbitrumBridge(Addr.ARB_L1_GOERLI_BRIDGE);
    IArbitrumBridge internal constant ARB_L1_MAINNET =
        IArbitrumBridge(Addr.ARB_L1_MAINNET_BRIDGE);
    IArbitrumBridge internal constant ARB_L1_MAINNET_NOVA =
        IArbitrumBridge(Addr.ARB_L1_MAINNET_BRIDGE_NOVA);
}

/* -------------------------------------------------------------------------- */
/*                                     EXT                                    */
/* -------------------------------------------------------------------------- */
library UniswapV3 {
    uint24 internal constant defaultFee = 3000;
    ISwapRouter internal constant Router02 = ISwapRouter(Addr.V3_Router02);
    IQuoterV2 internal constant QuoterV2 = IQuoterV2(Addr.V3_QuoterV2);
    IUniswapV3NFTManager internal constant NFT =
        IUniswapV3NFTManager(Addr.V3_NFT);
    IUniswapV3Factory internal constant V3Factory =
        IUniswapV3Factory(Addr.V3_Factory);
}

library API3 {
    IAPI3 internal constant ARB = IAPI3(Addr.API3_ARB);
    IAPI3 internal constant EUR = IAPI3(Addr.API3_EUR);
    IAPI3 internal constant BTC = IAPI3(Addr.API3_BTC);
    IAPI3 internal constant ETH = IAPI3(Addr.API3_ETH);
    IAPI3 internal constant CNY = IAPI3(Addr.API3_CNY);
    IAPI3 internal constant GBP = IAPI3(Addr.API3_GBP);

    function price(IAPI3 proxy) internal view returns (uint256) {
        (int224 value, ) = proxy.read();
        return uint256(int256(value));
    }

    function price8(IAPI3 proxy) internal view returns (uint256) {
        (int224 value, ) = proxy.read();
        return uint256(int256(value)) / 1e10;
    }

    function stale(IAPI3 proxy) internal view returns (bool) {
        (, uint32 timestamp) = proxy.read();
        return block.timestamp - timestamp > 1 days;
    }
}

library ChainLink {
    function price(IAggregatorV3 feed) internal view returns (uint256) {
        (, int256 answer, , , ) = feed.latestRoundData();
        return uint256(answer);
    }

    function price18(IAggregatorV3 feed) internal view returns (uint256) {
        (, int256 answer, , , ) = feed.latestRoundData();
        return uint256(answer) * 1e10;
    }

    function stale(IAggregatorV3 feed) internal view returns (bool) {
        (, , , uint256 updatedAt, ) = feed.latestRoundData();
        return block.timestamp - updatedAt > 1 days;
    }

    IAggregatorV3 internal constant BTC = IAggregatorV3(Addr.CL_BTC);
    IAggregatorV3 internal constant DAI = IAggregatorV3(Addr.CL_DAI);
    IAggregatorV3 internal constant ETH = IAggregatorV3(Addr.CL_ETH);
    IAggregatorV3 internal constant JPY = IAggregatorV3(Addr.CL_JPY);
    IAggregatorV3 internal constant USDT = IAggregatorV3(Addr.CL_USDT);
    IAggregatorV3 internal constant USDC = IAggregatorV3(Addr.CL_USDC);
    IAggregatorV3 internal constant SEQ_UPTIME =
        IAggregatorV3(Addr.CL_SEQ_UPTIME);
    IAggregatorV3 internal constant EUR = IAggregatorV3(Addr.CL_EUR);
    IAggregatorV3 internal constant ARB = IAggregatorV3(Addr.CL_ARB);
    IAggregatorV3 internal constant FRAX = IAggregatorV3(Addr.CL_FRAX);
    IAggregatorV3 internal constant LINK = IAggregatorV3(Addr.CL_LINK);
    IAggregatorV3 internal constant KRW = IAggregatorV3(Addr.CL_KRW);
    IAggregatorV3 internal constant SGD = IAggregatorV3(Addr.CL_SGD);
    IAggregatorV3 internal constant WBTC = IAggregatorV3(Addr.CL_WBTC);
    IAggregatorV3 internal constant WETH = IAggregatorV3(Addr.CL_ETH);
    IAggregatorV3 internal constant WETH_BTC = IAggregatorV3(Addr.CL_WBTC_BTC);
    IAggregatorV3 internal constant AAPL = IAggregatorV3(Addr.CL_AAPL);
    IAggregatorV3 internal constant AMZN = IAggregatorV3(Addr.CL_AMZN);
    IAggregatorV3 internal constant META = IAggregatorV3(Addr.CL_META);
    IAggregatorV3 internal constant TSLA = IAggregatorV3(Addr.CL_TSLA);
    IAggregatorV3 internal constant MSFT = IAggregatorV3(Addr.CL_MSFT);
    IAggregatorV3 internal constant SPY = IAggregatorV3(Addr.CL_SPY);
    IAggregatorV3 internal constant GOOGL = IAggregatorV3(Addr.CL_GOOGL);
    IAggregatorV3 internal constant CBETH_USD =
        IAggregatorV3(Addr.CL_CBETH_USD);
}
