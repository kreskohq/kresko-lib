// solhint-disable
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import {console} from "forge-std/Test.sol";
import {TestWallet} from "../src/utils/TestWallet.t.sol";
import {LibVm, Help, Log} from "../src/utils/Libs.sol";

contract Sandbox is TestWallet("MNEMONIC") {
    TestContract internal thing;
    using LibVm for *;
    using Log for *;

    // using Help for *;

    function setUp() public {
        emit log_string("setUp");
        thing = new TestContract();
    }

    function testFunc() public {
        vm.startBroadcast(address(5));
        broadcastWith(address(2));
        prank(address(5));
        Log.logCallers();
        thing.func();
        uint16 a = 150e2;
        a.pct("pct");

        uint32 b = 150e2;
        b.pct("pct");

        uint256 c = 150e2;
        c.pct("pct");

        string memory s = "hello";
        bytes memory bts = bytes(s);
        bytes32 bts32 = bytes32("val");
        s.clg();
        s.blg(bts);
        bts.blg();
        bts32.blg(s);
    }
}

contract TestContract {
    using Log for *;
    using LibVm for *;
    using Help for *;

    function func() public {
        console.log("TestContract");
        uint256[] memory nums = new uint256[](3);

        nums[0] = 1 ether;
        nums[1] = 100 ether;
        nums[2] = 0 ether;

        Log.logCallers();
    }
}
