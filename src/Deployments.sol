// SPDX-License-Identifier: MIT
pragma solidity >=0.8.14;
import {IKresko} from "./interfaces/IKresko.sol";
import {IGnosisSafeL2} from "./vendor/safe/IGnosisSafeL2.sol";
import {IUniswapV2Router02, IUniswapV2Factory} from "./vendor/uniswapV2/IUniswap.sol";
import {IWETH} from "./vendor/IWETH.sol";
import {IUniswapV2Oracle} from "./interfaces/IUniswapV2Oracle.sol";
import {IKrStaking} from "./staking/IKrStaking.sol";
import {KrStakingHelper} from "./staking/StakingHelper.sol";

library OPGOERLI {
    address constant DefaultProxyAdmin =
        0xfE22930C8ADaEDe1DFBC450CEd51C5a53C67c4d9;
    IKresko constant Kresko =
        IKresko(0x0921a7234a2762aaB3C43d3b1F51dB5D8094a04b);

    IGnosisSafeL2 constant Multisig =
        IGnosisSafeL2(0xC4489F3A82079C5a7b0b610Fc85952B6E585E697);
    address constant krCUBE = 0xB7E7B5D9C553ea7C8B6274a8079939e9064b46c3;
    IKrStaking constant Staking =
        IKrStaking(0x5843Cd37d7566173158c0B2655DA6A57422d4734);
    KrStakingHelper constant StakingHelper =
        KrStakingHelper(0xB1A13FbC46800276671403CeDdd528D01a447c8F);
    IWETH constant WETH = IWETH(0x4200000000000000000000000000000000000006);
    IUniswapV2Router02 constant UniswapV2Router =
        IUniswapV2Router02(0x1f693246650f93a7E9f4a713479695881b96b5F1);
    IUniswapV2Factory constant UniswapV2Factory =
        IUniswapV2Factory(0xc88508156D93BfF0Adce6c84d4269Efc82D4C827);
    IUniswapV2Oracle constant UniswapV2Oracle =
        IUniswapV2Oracle(0x1B855054ebd895Cf9E08587b537D6864f947620F);
}
