pragma solidity ^0.8.0;

import {Wallet} from "./Wallet.sol";

abstract contract ScriptBase is Deployments, Wallet {
    constructor(string memory _mnemonicId) Wallet(_mnemonicId) {}

    uint256 internal constant MAX_256 = type(uint256).max;
}
