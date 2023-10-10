pragma solidity ^0.8.0;

import {Wallet} from "./Wallet.sol";

abstract contract ScriptBase is Wallet {
    constructor(string memory _mnemonicId) Wallet(_mnemonicId) {}
}
