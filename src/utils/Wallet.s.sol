// solhint-disable
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
