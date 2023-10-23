// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {console2, Script} from "forge-std/Script.sol";
import {VmSafe} from "forge-std/Vm.sol";

contract Wallet is Script {
    string private __mnemonicId;

    constructor(string memory _mnemonicId) {
        __mnemonicId = _mnemonicId;
    }

    /* ----------------------------------- Get ---------------------------------- */

    function getPk(uint32 _mnemonicIndex) public view returns (uint256) {
        return vm.deriveKey(vm.envString(__mnemonicId), _mnemonicIndex);
    }

    function getAddr(uint32 _mnemonicIndex) public view returns (address) {
        return
            vm.addr(vm.deriveKey(vm.envString(__mnemonicId), _mnemonicIndex));
    }

    function getAddr(string memory _pkEnv) public view returns (address) {
        return vm.addr(vm.envUint(_pkEnv));
    }

    /* -------------------------------- Broadcast ------------------------------- */

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

    modifier broadcastedKey(string memory _pkEnv) {
        vm.startBroadcast(vm.envUint(_pkEnv));
        _;
        vm.stopBroadcast();
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

    function broadcastWith(string memory _pkEnv) public {
        unbroadcast();
        vm.startBroadcast(vm.envUint(_pkEnv));
    }

    // just clear even if no call.
    function unbroadcast()
        internal
        returns (VmSafe.CallerMode mode_, address msgSender_, address txOrigin_)
    {
        (mode_, msgSender_, txOrigin_) = vm.readCallers();
        if (
            mode_ == VmSafe.CallerMode.Broadcast ||
            mode_ == VmSafe.CallerMode.RecurrentBroadcast
        ) {
            vm.stopBroadcast();
        }
    }

    /* ---------------------------------- Prank --------------------------------- */
    function prank(address _msgSenderAndTxOrigin) internal {
        vm.startPrank(_msgSenderAndTxOrigin, _msgSenderAndTxOrigin);
    }

    function prank(address _sender, address _txOrigin) internal {
        vm.startPrank(_sender, _txOrigin);
    }

    /// @notice Pranks using a mnemonic index.
    function prank(uint32 _mnemonicIndex) internal {
        address who = getAddr(_mnemonicIndex);
        prank(who, who);
    }

    /// @notice Pranks using a private key
    function prank(string memory _pkEnv) internal {
        address who = getAddr(_pkEnv);
        prank(who, who);
    }

    /// @notice Pranks using a private key
    function prank(string memory _pkEnv, string memory _label) internal {
        address who = getAddr(_pkEnv);
        vm.label(who, _label);
        prank(who, who);
    }

    /// @notice Pranks using an address and label.
    function prank(
        address _msgSenderAndTxOrigin,
        string memory _label
    ) internal {
        vm.label(_msgSenderAndTxOrigin, _label);
        prank(_msgSenderAndTxOrigin, _msgSenderAndTxOrigin);
    }

    /// @notice Pranks using a mnemonic index and label
    function prank(uint32 _mnemonicIndex, string memory _label) internal {
        address who = getAddr(_mnemonicIndex);
        vm.label(who, _label);
        prank(who, who);
    }

    // just clear even if no call.
    function unprank()
        internal
        returns (VmSafe.CallerMode mode_, address msgSender_, address txOrigin_)
    {
        (mode_, msgSender_, txOrigin_) = vm.readCallers();
        if (
            mode_ == VmSafe.CallerMode.Prank ||
            mode_ == VmSafe.CallerMode.RecurrentPrank
        ) {
            vm.stopPrank();
        }
    }

    /* ---------------------------------- Misc ---------------------------------- */

    function peekMode() internal returns (string memory) {
        (VmSafe.CallerMode mode, , ) = vm.readCallers();
        return _getModeString(mode);
    }

    function _getModeString(
        VmSafe.CallerMode _mode
    ) internal pure returns (string memory) {
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

    function peekSender() internal returns (address msgSender_) {
        (, msgSender_, ) = vm.readCallers();
    }

    function peekSenderAndMode() internal returns (address, string memory) {
        (VmSafe.CallerMode mode_, address msgSender_, ) = vm.readCallers();
        return (msgSender_, _getModeString(mode_));
    }

    function peekCallers()
        internal
        returns (address msgSender_, address txOrigin_)
    {
        (, msgSender_, txOrigin_) = vm.readCallers();
    }

    function logCallers() internal {
        (VmSafe.CallerMode mode, address msgSender, address txOrigin) = vm
            .readCallers();
        console2.log("msg.sender", msgSender);
        console2.log("tx.origin", txOrigin);
        console2.log("mode", _getModeString(mode));
    }
}
