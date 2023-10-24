// solhint-disable state-visibility, max-states-count, var-name-mixedcase, no-global-import, const-name-snakecase, no-empty-blocks, no-console
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console2, Script} from "forge-std/Script.sol";
import {VmSafe} from "forge-std/Vm.sol";

/// @notice Broadcast + prank utils wont revert like forge. If unsure - just use regular vm.
contract Wallet is Script {
    string private __mnemonicId;

    constructor(string memory _mnemonicId) {
        __mnemonicId = _mnemonicId;
    }

    function getPk(uint32 _mnemonicIndex) internal view returns (uint256) {
        return vm.deriveKey(vm.envString(__mnemonicId), _mnemonicIndex);
    }

    function getAddr(uint32 _mnemonicIndex) internal returns (address account) {
        (account, ) = deriveRememberKey(
            vm.envString(__mnemonicId),
            _mnemonicIndex
        );
    }

    function getAddr(string memory _pkEnv) internal returns (address) {
        return vm.rememberKey(vm.envUint(_pkEnv));
    }
}

library Envs {
    string constant LOCAL_ACCOUNTS = "MNEMONIC_DEVNET";
    string constant TEST_ACCOUNTS = "MNEMONIC_TESTNET";
    string constant MAIN_ACCOUNTS = "MNEMONIC";

    string constant MAIN_ACCOUNT = "PRIVATE_KEY";
    string constant TEST_ACCOUNT = "PRIVATE_KEY_TESTNET";
    string constant LOCAL_ACCOUNT = "PRIVATE_KEY_DEVNET";
}
