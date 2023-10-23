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

    modifier prankedMake(string memory _label) {
        Account memory who = prankMake(_label);
        vm.startPrank(who.addr, who.addr);
        _;
        vm.stopPrank();
    }

    /// @notice Pranks mnemonic index, restores original prank after
    modifier repranked(uint32 _mnemonicIndex) {
        (
            VmSafe.CallerMode mode,
            address msgSender,
            address txOrigin
        ) = unprank();

        address who = getAddr(_mnemonicIndex);
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
        reprank(mode, msgSender, txOrigin);
    }

    /// @notice Pranks address, restores original prank after
    modifier reprankedAddr(address _senderAndTxOrigin) {
        (
            VmSafe.CallerMode mode,
            address msgSender,
            address txOrigin
        ) = unprank();
        vm.startPrank(_senderAndTxOrigin, _senderAndTxOrigin);
        _;
        vm.stopPrank();
        reprank(mode, msgSender, txOrigin);
    }

    /// @notice Pranks private key, restores original prank after
    modifier reprankedKey(string memory _pkEnv) {
        (
            VmSafe.CallerMode mode,
            address msgSender,
            address txOrigin
        ) = unprank();

        address who = getAddr(_pkEnv);
        vm.startPrank(who, who);
        _;
        vm.stopPrank();
        reprank(mode, msgSender, txOrigin);
    }

    /// @notice Pranks with a new account from label, restores original prank after
    modifier reprankedLabel(string memory _label) {
        (
            VmSafe.CallerMode mode,
            address msgSender,
            address txOrigin
        ) = unprank();

        prankMake(_label);
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

    /// @notice Check if some prank is active and restore it.
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

    /* ------------------------- vm.startPrank shortcuts ------------------------ */

    /// @notice Pranks sender only with mnemonic index.
    function prankSender(uint32 _mnemonicIndex) internal {
        vm.startPrank(getAddr(_mnemonicIndex));
    }

    /// @notice Pranks sender only with private key
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
        vm.startPrank(who.addr, who.addr);
    }
}
