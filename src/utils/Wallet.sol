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

    /* ---------------------------------- View ---------------------------------- */

    function getPk(uint32 _mnemonicIndex) internal view returns (uint256) {
        return vm.deriveKey(vm.envString(__mnemonicId), _mnemonicIndex);
    }

    function getAddr(uint32 _mnemonicIndex) internal view returns (address) {
        return
            vm.addr(vm.deriveKey(vm.envString(__mnemonicId), _mnemonicIndex));
    }

    function getAddr(string memory _pkEnv) internal view returns (address) {
        return vm.addr(vm.envUint(_pkEnv));
    }

    function peekMode() internal returns (string memory) {
        (VmSafe.CallerMode mode, , ) = vm.readCallers();
        return _getModeString(mode);
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

    /* -------------------------------- Broadcast ------------------------------- */

    /// @notice "Safe" as in does not clear existing caller modifications.
    modifier safeBroadcastWithIdx(uint32 _mnemonicIndex) {
        vm.startBroadcast(
            vm.deriveKey(vm.envString(__mnemonicId), _mnemonicIndex)
        );
        _;
        vm.stopBroadcast();
    }

    /// @notice "Safe" as in does not clear existing caller modifications.
    modifier safeBroadcastWithAddr(address _addr) {
        vm.startBroadcast(_addr);
        _;
        vm.stopBroadcast();
    }

    /// @notice "Safe" as in does not clear existing caller modifications.
    modifier safeBroadcastWithKey(string memory _pkEnv) {
        vm.startBroadcast(vm.envUint(_pkEnv));
        _;
        vm.stopBroadcast();
    }

    /// @dev Clears existing caller modifications before calling startBroadcast.
    modifier broadcastWithIdx(uint32 _mnemonicIndex) {
        broadcastWith(_mnemonicIndex);
        _;
        vm.stopBroadcast();
    }

    /// @dev Clears existing caller modifications before calling startBroadcast.
    modifier broadcastWithAddr(address _addr) {
        broadcastWith(_addr);
        _;
        vm.stopBroadcast();
    }

    /// @dev Clears existing caller modifications before calling startBroadcast.
    modifier broadcastWithKey(string memory _pkEnv) {
        broadcastWith(_pkEnv);
        _;
        vm.stopBroadcast();
    }

    /// @dev Clears existing caller modifications before calling startBroadcast.
    function broadcastWith(uint32 _mnemonicIndex) internal {
        clearCallers();
        vm.startBroadcast(
            vm.deriveKey(vm.envString(__mnemonicId), _mnemonicIndex)
        );
    }

    /// @dev Clears existing caller modifications before calling startBroadcast.
    function broadcastWith(address _addr) internal {
        clearCallers();
        vm.startBroadcast(_addr);
    }

    /// @dev Clears existing caller modifications before calling startBroadcast
    function broadcastWith(string memory _pkEnv) internal {
        clearCallers();
        vm.startBroadcast(vm.envUint(_pkEnv));
    }

    /* ---------------------------------- Prank --------------------------------- */

    /// @notice vm.prank, but clears existing caller modifications which skips regular forge reverts.
    function prank(address _msgSenderAndTxOrigin) internal {
        clearCallers();
        vm.startPrank(_msgSenderAndTxOrigin, _msgSenderAndTxOrigin);
    }

    /// @notice vm.prank, but clears existing caller modifications which skips regular forge reverts.
    function prank(address _sender, address _txOrigin) internal {
        clearCallers();
        vm.startPrank(_sender, _txOrigin);
    }

    function prank(uint32 _mnemonicIndex) internal {
        address who = getAddr(_mnemonicIndex);
        prank(who, who);
    }

    function prank(string memory _pkEnv) internal {
        address who = getAddr(_pkEnv);
        prank(who, who);
    }

    function prank(string memory _pkEnv, string memory _label) internal {
        address who = getAddr(_pkEnv);
        vm.label(who, _label);
        prank(who, who);
    }

    function prank(
        address _msgSenderAndTxOrigin,
        string memory _label
    ) internal {
        vm.label(_msgSenderAndTxOrigin, _label);
        prank(_msgSenderAndTxOrigin, _msgSenderAndTxOrigin);
    }

    function prank(uint32 _mnemonicIndex, string memory _label) internal {
        address who = getAddr(_mnemonicIndex);
        vm.label(who, _label);
        prank(who, who);
    }

    /* ---------------------------------- Call ---------------------------------- */

    /// @notice Avoids forge reverts so abit unsafe.
    function clearCallers() internal {
        (VmSafe.CallerMode mode, , ) = vm.readCallers();
        if (
            mode == VmSafe.CallerMode.Broadcast ||
            mode == VmSafe.CallerMode.RecurrentBroadcast
        ) {
            vm.stopBroadcast();
        } else if (
            mode == VmSafe.CallerMode.Prank ||
            mode == VmSafe.CallerMode.RecurrentPrank
        ) {
            vm.stopPrank();
        }
    }

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

    function logCallers() internal {
        (VmSafe.CallerMode mode, address msgSender, address txOrigin) = vm
            .readCallers();
        console2.log("msg.sender", msgSender);
        console2.log("tx.origin", txOrigin);
        console2.log("mode", _getModeString(mode));
    }
}
