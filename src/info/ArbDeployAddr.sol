// SPDX-License-Identifier: MIT
// solhint-disable no-inline-assembly, one-contract-per-file, state-visibility, const-name-snakecase
pragma solidity ^0.8.0;
import {IWETH9} from "../token/IWETH9.sol";
import {IERC20} from "../token/IERC20.sol";
import {Meta} from "./Periphery.sol";

abstract contract ArbDeployAddr {
    address constant kreskoAddr = 0x0000000000177abD99485DCaea3eFaa91db3fe72;
    address constant kreditsAddr = 0x8E84a3B8e0b074c149b8277c753Dc6396bB95F48;
    address constant multicallAddr = 0xC35A7648B434f0A161c12BD144866bdf93c4a4FC;
    address constant factoryAddr = 0x000000000070AB95211e32fdA3B706589D3482D5;
    address constant vaultAddr = 0x2dF01c1e472eaF880e3520C456b9078A5658b04c;
    address constant dataV1Addr = 0xF21De5aBac99514610F33Ca15113Bb6bCfCD476d;
    address constant marketStatusAddr =
        0xf6188e085ebEB716a730F8ecd342513e72C8AD04;

    address constant USDCAddr = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    address constant ARBAddr = 0x912CE59144191C1204E64559FE8253a0e49E6548;
    address constant USDCeAddr = 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8;
    address constant WBTCAddr = 0x2f2a2543B76A4166549F7aaB2e75Bef0aefC5B0f;
    address constant wethAddr = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    address constant DAIAddr = 0xDA10009cBd5D07dd0CeCc66161FC93D7c9000da1;

    address constant kissAddr = 0x6A1D6D2f4aF6915e6bBa8F2db46F442d18dB5C9b;

    address constant krETHAddr = 0x24dDC92AA342e92f26b4A676568D04d2E3Ea0abc;
    address constant krBTCAddr = 0x11EF4EcF3ff1c8dB291bc3259f3A4aAC6e4d2325;
    address constant krSOLAddr = 0x96084d2E3389B85f2Dc89E321Aaa3692Aed05eD2;
    address constant krEURAddr = 0x83BB68a7437b02ebBe1ab2A0E8B464CC5510Aafe;
    address constant krJPYAddr = 0xc4fEE1b0483eF73352447b1357adD351Bfddae77;
    address constant krGBPAddr = 0xdb274afDfA7f395ef73ab98C18cDf3D9C03b538C;
    address constant krXAUAddr = 0xe0A49C9215206f9cfb79981901bDF1f2716d3215;

    address constant akrETHAddr = 0x3103570A28ca026e818c79608F1FF804F4Bde284;
    address constant akrBTCAddr = 0xc67a33599f73928D24D32fC0015e187157233410;
    address constant akrSOLAddr = 0x362cB60d235Cf8258042DAfB2a3Cdb14302D9D0f;
    address constant akrEURAddr = 0xBb6053898C5f6e536405fA324839141aA102b6D9;
    address constant akrJPYAddr = 0x3438Eb57e5b0f1CbEca257Aea9644B26b1B61EaC;
    address constant akrGBPAddr = 0x37BddA32281c15716D35f901b8141f7F382220C1;
    address constant akrXAUAddr = 0x3A1ffd3426916B16878AAa072B74DdaEC3e31007;

    address constant safe = 0x266489Bde85ff0dfe1ebF9f0a7e6Fed3a973cEc3;
    address constant nftMultisig = 0x389297F0d8C489954D65e04ff0690FC54E57Dad6;
    address constant og_deployer = 0x5a6B3E907b83DE2AbD9010509429683CF5ad5984;
    address constant kreskianAddr = 0xAbDb949a18d27367118573A217E5353EDe5A0f1E;
    address constant questAddr = 0x1C04925779805f2dF7BbD0433ABE92Ea74829bF6;

    IWETH9 constant weth = IWETH9(wethAddr);
    IERC20 constant USDC = IERC20(USDCAddr);
    IERC20 constant USDCe = IERC20(USDCeAddr);
    IERC20 constant WBTC = IERC20(WBTCAddr);
    IERC20 constant ARB = IERC20(ARBAddr);

    address constant binanceAddr = 0xB38e8c17e38363aF6EbdCb3dAE12e0243582891D;
    address constant pythAddr = 0xff1a0f4744e8582DF1aE09D5611b887B6a12925C;
    address constant routerv3Addr = 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;
    address constant quoterV2Addr = 0x61fFE014bA17989E743c5F6cB21bF9697530B21e;

    function getKrAddr(
        string memory _symbol
    ) public view returns (Meta.KrAssetAddr memory) {
        return Meta.krAssetAddr(factoryAddr, _symbol);
    }
}
