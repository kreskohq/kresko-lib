// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import {console} from "forge-std/Test.sol";
import {TestWallet} from "../src/utils/TestWallet.sol";
import {LibTest} from "../src/utils/LibTest.sol";

contract CounterTest is TestWallet("MNEMONIC") {
    TestContract internal thing;

    function setUp() public {
        emit log_string("setUp");
        thing = new TestContract();
    }

    function testStuff() public {
        vm.startBroadcast(address(5));
        broadcastWith(address(2));
        prank(address(5));
        logCallers();
        thing.func();
    }
}

contract TestContract {
    function func() public {
        console.log("TestContract");

        LibTest.log_caller();
    }
}
