// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {TestWallet, DSTest} from "./TestWallet.sol";

abstract contract TestBase is TestWallet {
    address public user0;
    address public user1;
    address public user2;

    modifier fork(string memory f) {
        vm.createSelectFork(f);
        _;
    }

    constructor(string memory _mnemonicId) TestWallet(_mnemonicId) {}

    uint256 internal constant MAX = type(uint256).max;

    modifier usersMnemonic(
        uint32 a,
        uint32 b,
        uint32 c
    ) {
        user0 = getAddr(a);
        user1 = getAddr(b);
        user2 = getAddr(c);
        _;
    }
    modifier users(
        address a,
        address b,
        address c
    ) {
        user0 = a;
        user1 = b;
        user2 = c;
        _;
    }
}
