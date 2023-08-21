// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import { Wallet } from './Wallet.sol';
import { Test, DSTest } from 'forge-std/Test.sol';

string constant testnet = 'MNEMONIC_TESTNET';
string constant mainnet = 'MNEMONIC';

string constant pk = 'PRIVATE_KEY';
string constant pkTestnet = 'PRIVATE_KEY_TESTNET';

abstract contract TestWallet is Wallet, Test {
  // solhint-disable-next-line no-empty-blocks
  constructor(string memory _mnemonicId) Wallet(_mnemonicId) {}

  modifier prankKey(string memory key) {
    vm.startPrank(getAddr(key), getAddr(key));
    _;
    vm.stopPrank();
  }

  modifier prankAddr(address addr) {
    vm.startPrank(addr, addr);
    _;
    vm.stopPrank();
  }

  modifier prankMnemonic(uint32 index) {
    vm.startPrank(getAddr(index), getAddr(index));
    _;
    vm.stopPrank();
  }
}
