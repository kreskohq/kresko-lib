// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script} from "forge-std/Script.sol";

contract Wallet is Script {
    string private __mnemonicId;

    constructor(string memory _mnemonicId) {
        __mnemonicId = _mnemonicId;
    }

    modifier broadcastedIdx(uint32 _mnemonicIndex) {
        vm.startBroadcast(
            vm.deriveKey(vm.envString(__mnemonicId), _mnemonicIndex)
        );
        _;
        vm.stopBroadcast();
    }

    modifier broadcastedAddr(address _addr) {
        vm.startBroadcast(_addr);
        _;
        vm.stopBroadcast();
    }

    modifier broadcastedKey(string memory _pk) {
        vm.startBroadcast(vm.envUint(key));
        _;
        vm.stopBroadcast();
    }

    // just clear even if no call.
    function unbroadcast()
        internal
        returns (VmSafe.CallerMode mode, address msgSender, address txOrigin)
    {
        (mode, msgSender, txOrigin) = vm.readCallers();
        if (
            mode == VmSafe.CallerMode.Broadcast ||
            mode == VmSafe.CallerMode.RecurrentBroadcast
        ) {
            vm.stopBroadcast();
        }
    }

    function broadcastWith(uint32 _mnemonicIndex) public {
        unbroadcast();
        vm.startBroadcast(
            vm.deriveKey(vm.envString(__mnemonicId), _mnemonicIndex)
        );
    }

    function broadcastWith(address _addr) public {
        unbroadcast();
        vm.startBroadcast(_addr);
    }

    function broadcastWith(string memory _pk) public {
        unbroadcast();
        vm.startBroadcast(vm.envUint(_pk));
    }

    function getPk(uint32 _mnemonicIndex) public view returns (uint256) {
        return vm.deriveKey(vm.envString(__mnemonicId), _mnemonicIndex);
    }

    function getAddr(uint32 _mnemonicIndex) public view returns (address) {
        return
            vm.addr(vm.deriveKey(vm.envString(__mnemonicId), _mnemonicIndex));
    }

    function getAddr(string memory _pk) public view returns (address) {
        return vm.addr(vm.envUint(_pk));
    }

    function peekMode() internal returns (string memory) {
        (VmSafe.CallerMode mode, , ) = vm.readCallers();
        return _getModeString(mode);
    }

    function _getModeString(VmSafe.CallerMode _mode) internal {
        if (_mode == VmSafe.CallerMode.Broadcast) {
            return "broadcast";
        } else if (_mode == VmSafe.CallerMode.RecurrentBroadcast) {
            return "persistent broadcast";
        } else if (_mode == VmSafe.CallerMode.Prank) {
            return "prank";
        } else if (_mode == VmSafe.CallerMode.RecurrentPrank) {
            return "persistent prank";
        } else if (_mode == VmSafe.CallerMode.None) {
            return "none";
        } else {
            return "unknown mode";
        }
    }

    function peekSender() internal returns (address msgSender) {
        (, msgSender, ) = vm.readCallers();
    }

    function peekSenderAndMode() internal returns (address, string memory) {
        (VmSafe.CallerMode mode, address msgSender, ) = vm.readCallers();
        return (msgSender, _getModeString(mode));
    }

    function peekCallers()
        internal
        returns (address msgSender, address txOrigin)
    {
        (, msgSender, txOrigin) = vm.readCallers();
    }
}
