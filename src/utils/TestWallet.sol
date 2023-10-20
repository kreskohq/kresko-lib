// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Wallet} from "./Wallet.sol";
import {Test, console} from "forge-std/Test.sol";
import {VmSafe} from "forge-std/Vm.sol";

library Env {
    string internal constant LOCAL_ACCOUNTS = "MNEMONIC_LOCALNET";
    string internal constant TEST_ACCOUNTS = "MNEMONIC_TESTNET";
    string internal constant MAIN_ACCOUNTS = "MNEMONIC";

    string internal constant MAIN_ACCOUNT = "PRIVATE_KEY";
    string internal constant TEST_ACCOUNT = "PRIVATE_KEY_TESTNET";
    string internal constant LOCAL_ACCOUNT = "PRIVATE_KEY_LOCALNET";
}

abstract contract TestWallet is Wallet, Test {
    error InvalidPrank(string, address sender, address origin, uint256 mode);

    // solhint-disable-next-line no-empty-blocks
    constructor(string memory _mnemonicId) Wallet(_mnemonicId) {}

    modifier pranked(uint32 index) {
        address who = getAddr(index);
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
    }

    modifier prankedKey(string memory key) {
        address who = getAddr(key);
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
    }

    modifier prankedAddr(address addr) {
        vm.startPrank(addr, addr);
        _;
        vm.stopPrank();
    }

    modifier prankedLabel(string memory label) {
        Account memory who = prankMake(label);
        vm.startPrank(who.addr, who.addr);
        _;
        vm.stopPrank();
    }

    /// @notice Pranks mnemonic index, restores original prank after
    modifier repranked(uint32 index) {
        (
            VmSafe.CallerMode mode,
            address msgSender,
            address txOrigin
        ) = unprank();

        address who = getAddr(index);
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
        reprank(mode, msgSender, txOrigin);
    }

    /// @notice Pranks address, restores original prank after
    modifier reprankedAddr(address who) {
        (
            VmSafe.CallerMode mode,
            address msgSender,
            address txOrigin
        ) = unprank();
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
        reprank(mode, msgSender, txOrigin);
    }

    /// @notice Pranks private key, restores original prank after
    modifier reprankedKey(string memory pk) {
        (
            VmSafe.CallerMode mode,
            address msgSender,
            address txOrigin
        ) = unprank();

        address who = getAddr(pk);
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
        reprank(mode, msgSender, txOrigin);
    }

    /// @notice Pranks with a new account from label, restores original prank after
    modifier reprankedLabel(string memory label) {
        (
            VmSafe.CallerMode mode,
            address msgSender,
            address txOrigin
        ) = unprank();

        prankMake(label);
        _;
        vm.stopPrank();
        reprank(mode, msgSender, txOrigin);
    }

    modifier unpranked() {
        unprank();
        _;
    }

    /// @notice Removes pranks and restores original prank after
    modifier reunpranked() {
        (
            VmSafe.CallerMode mode,
            address msgSender,
            address txOrigin
        ) = unprank();

        _;
        reprank(mode, msgSender, txOrigin);
    }

    // just clear even if no call.
    function unprank()
        internal
        returns (VmSafe.CallerMode mode, address msgSender, address txOrigin)
    {
        (mode, msgSender, txOrigin) = vm.readCallers();
        if (
            mode == VmSafe.CallerMode.Prank ||
            mode == VmSafe.CallerMode.RecurrentPrank
        ) {
            vm.stopPrank();
        }
    }

    /// @notice Check if some prank is active and restore it.
    function reprank(
        VmSafe.CallerMode mode,
        address msgSender,
        address txOrigin
    ) private {
        if (mode == VmSafe.CallerMode.Prank) {
            msgSender == txOrigin
                ? vm.prank(msgSender, txOrigin)
                : vm.prank(msgSender);
        } else if (mode == VmSafe.CallerMode.RecurrentPrank) {
            msgSender == txOrigin
                ? vm.startPrank(msgSender, txOrigin)
                : vm.startPrank(msgSender);
        }
    }

    /* ------------------------- vm.startPrank shortcuts ------------------------ */
    function prank(address who) internal {
        vm.startPrank(who, who);
    }

    function prank(address who, address origin) internal {
        vm.startPrank(who, origin);
    }

    /// @notice Pranks using a mnemonic index.
    function prank(uint32 index) internal {
        address who = getAddr(index);
        vm.startPrank(who, who);
    }

    /// @notice Pranks using a private key
    function prank(string memory pk) internal {
        address who = getAddr(pk);
        vm.startPrank(who, who);
    }

    /// @notice Pranks using a private key
    function prank(string memory pk, string memory label) internal {
        address who = getAddr(pk);
        vm.label(who, label);
        vm.startPrank(who, who);
    }

    /// @notice Pranks using an address and label.
    function prank(address who, string memory label) internal {
        vm.label(who, label);
        vm.startPrank(who, who);
    }

    /// @notice Pranks using a mnemonic index and label
    function prank(uint32 index, string memory label) internal {
        address who = getAddr(index);
        vm.label(who, label);
        vm.startPrank(who, who);
    }

    /// @notice Pranks sender only with mnemonic index.
    function prankSender(uint32 index) internal {
        vm.startPrank(getAddr(index));
    }

    /// @notice Pranks sender only with private key
    function prankSender(string memory pk) internal {
        vm.startPrank(getAddr(pk));
    }

    /// @notice Pranks with a new account derived from label with ether (and the label).
    function prankMake(
        string memory label
    ) internal returns (Account memory who) {
        who = makeAccount(label);
        vm.deal(who.addr, 420.69 ether);
        vm.label(who.addr, label);
        vm.startPrank(who.addr, who.addr);
    }

    function log_caller() internal {
        (VmSafe.CallerMode mode, address msgSender, address txOrigin) = vm
            .readCallers();
        emit log_named_address("msg.sender", msgSender);
        emit log_named_address("tx.origin", txOrigin);
        emit log_named_uint(
            "Mode [None,Broadcast,RecurrentBroadcast,Prank,RecurrentPrank]",
            uint256(uint8(mode))
        );
    }

    function peekSender() internal returns (address msgSender) {
        (, msgSender, ) = vm.readCallers();
    }

    function peekCallers()
        internal
        returns (address msgSender, address txOrigin)
    {
        (, msgSender, txOrigin) = vm.readCallers();
    }
}
