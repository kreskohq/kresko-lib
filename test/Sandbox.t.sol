// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import {console} from "forge-std/Test.sol";
import {TestWallet} from "../src/utils/TestWallet.t.sol";
import {LibVm, Stash, Help, Log} from "../src/utils/Libs.sol";

contract Sandbox is TestWallet("MNEMONIC") {
    TestContract internal thing;
    using LibVm for *;
    using Log for *;

    function setUp() public {
        emit log_string("setUp");
        thing = new TestContract();
    }

    function testFunc() public {
        vm.startBroadcast(address(5));
        broadcastWith(address(2));
        prank(address(5));
        logCallers();
        thing.func();
    }
}

contract TestContract {
    using Log for *;
    using LibVm for *;
    using Stash for *;
    using Help for *;

    function func() public {
        console.log("TestContract");
        address[] memory addrs = new address[](2);
        uint256[] memory nums = new uint256[](3);

        nums[0] = 1 ether;
        nums[1] = 100 ether;
        nums[2] = 0 ether;

        addrs[0] = address(1);
        addrs[1] = address(2);
        nums.stash();
        nums[0].stash();
        nums[0].appendStash();

        addrs.stash();
        addrs.appendStash(address(3));

        [address(4), address(99)].dyn().replaceStash();
        addrs.clg();
        addrs.clg("ok");
        Log.clg_callers();
    }
}
