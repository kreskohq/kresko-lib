// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {Scripted, LibVm, VmSafe} from "./Scripted.s.sol";

abstract contract Tested is Scripted, Test {
    using LibVm for VmSafe.CallerMode;

    modifier prankedById(uint32 _mIdx) {
        address who = getAddr(_mIdx);
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
    }

    modifier prankedByKey(string memory _pkEnv) {
        address who = getAddr(_pkEnv);
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
    }

    modifier prankedByNew(string memory _label) {
        address who = prankNew(_label).addr;
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
    }

    modifier reprankedById(uint32 _mIdx) {
        (VmSafe.CallerMode _m, address _s, address _o) = LibVm.clearCallers();

        address who = getAddr(_mIdx);
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
        _m.restore(_s, _o);
    }

    modifier reprankedByKey(string memory _pkEnv) {
        (VmSafe.CallerMode _m, address _s, address _o) = LibVm.clearCallers();

        address who = getAddr(_pkEnv);
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
        _m.restore(_s, _o);
    }

    modifier reprankedByNew(string memory _label) {
        (VmSafe.CallerMode _m, address _s, address _o) = LibVm.clearCallers();

        prankNew(_label);
        _;
        vm.stopPrank();
        _m.restore(_s, _o);
    }

    function prank(string memory _pkEnv, string memory _label) internal {
        address who = getAddr(_pkEnv);
        vm.label(who, _label);
        prank(who, who);
    }

    function prank(address _sno, string memory _label) internal {
        vm.label(_sno, _label);
        prank(_sno, _sno);
    }

    function prank(uint32 _mIdx, string memory _label) internal {
        address who = getAddr(_mIdx);
        vm.label(who, _label);
        prank(who, who);
    }

    /// @notice Pranks with a new account derived from label with ether (and the label).
    function prankNew(
        string memory _label
    ) internal returns (Account memory who) {
        who = makeAccount(_label);
        vm.deal(who.addr, 420.69 ether);
        vm.label(who.addr, _label);
        prank(who.addr, who.addr);
    }
}
