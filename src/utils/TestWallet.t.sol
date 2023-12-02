// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Test} from "forge-std/Test.sol";
import {ScriptBase} from "./ScriptBase.s.sol";
import {VmSafe} from "forge-std/Vm.sol";
import {LibVm} from "./Libs.sol";

abstract contract TestWallet is ScriptBase, Test {
    // solhint-disable-next-line no-empty-blocks
    constructor(string memory _mnemonicId) ScriptBase(_mnemonicId) {}

    modifier pranked(uint32 _mnemonicIndex) {
        address who = getAddr(_mnemonicIndex);
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
    }

    modifier prankedKey(string memory _pkEnv) {
        address who = getAddr(_pkEnv);
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
    }

    modifier prankedAddr(address _senderAndTxOrigin) {
        vm.startPrank(_senderAndTxOrigin, _senderAndTxOrigin);
        _;
        vm.stopPrank();
    }

    modifier prankedMake(string memory _newAccountLabel) {
        address who = prankMake(_newAccountLabel).addr;
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
    }

    modifier prankAndRestore(uint32 _mnemonicIndex) {
        (VmSafe.CallerMode mode, address msgSender, address txOrigin) = LibVm
            .unprank();

        address who = getAddr(_mnemonicIndex);
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
        reprank(mode, msgSender, txOrigin);
    }

    modifier prankAddrAndRestore(address _senderAndTxOrigin) {
        (VmSafe.CallerMode mode, address msgSender, address txOrigin) = LibVm
            .unprank();
        vm.startPrank(_senderAndTxOrigin, _senderAndTxOrigin);
        _;
        vm.stopPrank();
        reprank(mode, msgSender, txOrigin);
    }

    modifier prankKeyAndRestore(string memory _pkEnv) {
        (VmSafe.CallerMode mode, address msgSender, address txOrigin) = LibVm
            .unprank();

        address who = getAddr(_pkEnv);
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
        reprank(mode, msgSender, txOrigin);
    }

    modifier prankMakeAndRestore(string memory _newAccountLabel) {
        (VmSafe.CallerMode mode, address msgSender, address txOrigin) = LibVm
            .unprank();

        prankMake(_newAccountLabel);
        _;
        vm.stopPrank();
        reprank(mode, msgSender, txOrigin);
    }

    modifier unprankAndRestore() {
        (VmSafe.CallerMode mode, address msgSender, address txOrigin) = LibVm
            .unprank();

        _;
        reprank(mode, msgSender, txOrigin);
    }

    function reprank(
        VmSafe.CallerMode mode,
        address _storedSender,
        address _storedTxOrigin
    ) private {
        if (mode == VmSafe.CallerMode.Prank) {
            _storedSender == _storedTxOrigin
                ? vm.prank(_storedSender, _storedTxOrigin)
                : vm.prank(_storedSender);
        } else if (mode == VmSafe.CallerMode.RecurrentPrank) {
            _storedSender == _storedTxOrigin
                ? vm.startPrank(_storedSender, _storedTxOrigin)
                : vm.startPrank(_storedSender);
        }
    }

    function prankSender(uint32 _mnemonicIndex) internal {
        vm.startPrank(getAddr(_mnemonicIndex));
    }

    function prankSender(string memory _pkEnv) internal {
        vm.startPrank(getAddr(_pkEnv));
    }

    /// @notice Pranks with a new account derived from label with ether (and the label).
    function prankMake(
        string memory _label
    ) internal returns (Account memory who) {
        who = makeAccount(_label);
        vm.deal(who.addr, 420.69 ether);
        vm.label(who.addr, _label);
        prank(who.addr, who.addr);
    }
}
