// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Wallet} from "./Wallet.s.sol";
import {LibVm, VmSafe} from "./LibVm.s.sol";
import {Script} from "forge-std/Script.sol";
import {__revert} from "./Base.s.sol";

abstract contract Scripted is Script, Wallet {
    using LibVm for VmSafe.CallerMode;

    modifier fork(string memory _uoa) {
        vm.createSelectFork(_uoa);
        _;
    }
    modifier forkId(uint256 _id) {
        vm.selectFork(_id);
        _;
    }

    /// @dev clear any callers
    modifier noCallers() {
        LibVm.clearCallers();
        _;
    }

    modifier broadcastedById(uint32 _mIdx) {
        broadcastWith(_mIdx);
        _;
        LibVm.clearCallers();
    }

    modifier broadcasted(address _addr) {
        broadcastWith(_addr);
        _;
        LibVm.clearCallers();
    }

    modifier broadcastedByPk(string memory _pkEnv) {
        broadcastWith(_pkEnv);
        _;
        LibVm.clearCallers();
    }

    modifier pranked(address _sno) {
        prank(_sno);
        _;
        LibVm.clearCallers();
    }

    /// @dev clear call modes, broadcast function body and restore callers after
    modifier rebroadcasted(address _addr) {
        (VmSafe.CallerMode _m, address _s, address _o) = LibVm.clearCallers();

        vm.startBroadcast(_addr);
        _;
        LibVm.clearCallers();
        _m.restore(_s, _o);
    }

    modifier rebroadcastById(uint32 _mIdx) {
        (VmSafe.CallerMode _m, address _s, address _o) = LibVm.clearCallers();

        vm.startBroadcast(getAddr(_mIdx));
        _;
        LibVm.clearCallers();
        _m.restore(_s, _o);
    }

    modifier rebroadcastedByKey(string memory _pkEnv) {
        (VmSafe.CallerMode _m, address _s, address _o) = LibVm.clearCallers();

        vm.startBroadcast(getAddr(_pkEnv));
        _;
        LibVm.clearCallers();
        _m.restore(_s, _o);
    }

    /// @dev func body with no call modes and restore callers after
    modifier reclearCallers() {
        (VmSafe.CallerMode _m, address _s, address _o) = LibVm.clearCallers();
        _;
        _m.restore(_s, _o);
    }

    /// @dev clear call modes, prank function body and restore callers after
    modifier repranked(address _addr) {
        (VmSafe.CallerMode _m, address _s, address _o) = LibVm.clearCallers();
        vm.startPrank(_addr, _addr);
        _;
        LibVm.clearCallers();
        _m.restore(_s, _o);
    }

    /// @dev clear callers and change to broadcasting
    function broadcastWith(uint32 _mIdx) internal {
        LibVm.clearCallers();
        vm.startBroadcast(getAddr(_mIdx));
    }

    function broadcastWith(address _addr) internal {
        LibVm.clearCallers();
        vm.startBroadcast(_addr);
    }

    function broadcastWith(string memory _pkEnv) internal {
        LibVm.clearCallers();
        vm.startBroadcast(vm.envUint(_pkEnv));
    }

    /// @notice vm.prank, but clears callers first
    function prank(address _sno) internal {
        LibVm.clearCallers();
        vm.startPrank(_sno, _sno);
    }

    function prank(address _s, address _o) internal {
        LibVm.clearCallers();
        vm.startPrank(_s, _o);
    }

    function prank(uint32 _mIdx) internal {
        address who = getAddr(_mIdx);
        prank(who, who);
    }

    function prank(string memory _pkEnv) internal {
        address who = getAddr(_pkEnv);
        prank(who, who);
    }

    function clearCallers() internal {
        LibVm.clearCallers();
    }

    function peekSender() internal returns (address) {
        return LibVm.sender();
    }

    function peekCallers() internal returns (LibVm.Callers memory) {
        return LibVm.callers();
    }

    function _revert(bytes memory _d) internal pure {
        __revert(_d);
    }
}
