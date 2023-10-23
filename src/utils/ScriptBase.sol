// solhint-disable
pragma solidity ^0.8.0;

import {Wallet} from "./Wallet.sol";

abstract contract ScriptBase is Wallet {
    event log_named_decimal_int(string key, int256 val, uint256 decimals);
    event log_named_decimal_uint(string key, uint256 val, uint256 decimals);

    constructor(string memory _mnemonicId) Wallet(_mnemonicId) {}
}
