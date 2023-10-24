// solhint-disable
pragma solidity ^0.8.0;

import {Wallet} from "./Wallet.s.sol";
import {LibVm, Log} from "./Libs.sol";

abstract contract ScriptBase is Wallet {
    constructor(string memory _mnemonicId) Wallet(_mnemonicId) {}

    /// @notice "Safe" as in does not clear existing caller modifications.
    modifier safeBroadcastWithIdx(uint32 _mnemonicIndex) {
        vm.startBroadcast(getAddr(_mnemonicIndex));
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
        LibVm.clearCallers();
        vm.startBroadcast(getAddr(_mnemonicIndex));
    }

    /// @dev Clears existing caller modifications before calling startBroadcast.
    function broadcastWith(address _addr) internal {
        LibVm.clearCallers();
        vm.startBroadcast(_addr);
    }

    /// @dev Clears existing caller modifications before calling startBroadcast
    function broadcastWith(string memory _pkEnv) internal {
        LibVm.clearCallers();
        vm.startBroadcast(vm.envUint(_pkEnv));
    }

    /// @notice vm.prank, but clears existing caller modifications which skips regular forge reverts.
    function prank(address _msgSenderAndTxOrigin) internal {
        LibVm.clearCallers();
        vm.startPrank(_msgSenderAndTxOrigin, _msgSenderAndTxOrigin);
    }

    /// @notice vm.prank, but clears existing caller modifications which skips regular forge reverts.
    function prank(address _sender, address _txOrigin) internal {
        LibVm.clearCallers();
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

    function unprank() internal {
        LibVm.unprank();
    }

    modifier unpranked() {
        LibVm.unprank();
        _;
    }

    function peekSender() internal returns (address msgSender_) {
        return LibVm.sender();
    }

    function peekCallers() internal returns (LibVm.Callers memory) {
        return LibVm.callers();
    }

    function logCallers() internal {
        Log.clg_callers();
    }

    modifier logGas() {
        uint256 startGas = gasleft();
        _;
        uint256 endGas = gasleft();
        emit Log.log_named_uint("gas used", startGas - endGas);
    }
}
