// solhint-disable
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import {console} from "forge-std/Test.sol";
import {Tested} from "../src/utils/Tested.t.sol";
import {Help, Log} from "../src/utils/Libs.s.sol";
import {LibVm} from "../src/utils/LibVm.s.sol";
import {ShortAssert} from "../src/utils/ShortAssert.t.sol";
import {PLog, logp} from "../src/utils/PLog.s.sol";

contract Sandbox is Tested {
    TestContract internal thing;
    using LibVm for *;
    using Log for *;
    using ShortAssert for *;

    // using Help for *;

    function setUp() public {
        useMnemonic("MNEMONIC");
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

    function testBroadcasts() public {
        address first = getAddr(0);
        address second = getAddr(1);
        address third = getAddr(2);
        vm.startBroadcast(first);
        peekSender().eq(first);

        broadcastWith(second);
        peekSender().eq(second);

        broadcastWith(first);
        _broadcastRestored().eq(second);

        peekSender().eq(first);
        thing.addr().eq(second);

        broadcastWith(third);
        _unbroadcastedRestored().eq(msg.sender);
        peekSender().eq(third);
        vm.stopBroadcast();

        _unbroadcastedRestored();
    }

    function _broadcastRestored()
        internal
        rebroadcasted(getAddr(1))
        returns (address)
    {
        thing.save();
        return peekSender();
    }

    function _unbroadcastedRestored()
        internal
        reclearCallers
        returns (address)
    {
        thing.save();
        return peekSender();
    }

    function testPranks() public {
        address first = getAddr(0);
        address second = getAddr(1);
        address third = getAddr(2);
        vm.startPrank(first);
        peekSender().eq(first);

        prank(second);
        peekSender().eq(second);

        prank(first);
        _prankRestored().eq(second);
        peekSender().eq(first);
        thing.addr().eq(second);

        prank(third);
        _unprankRestored().eq(msg.sender);
        peekSender().eq(third);
    }

    function _prankRestored() internal repranked(getAddr(1)) returns (address) {
        thing.save();
        return peekSender();
    }

    function _unprankRestored() internal reclearCallers returns (address) {
        thing.save();
        return peekSender();
    }

    function testMinLog() public pure {
        logp(abi.encodeWithSignature("log(string,uint256)", "hello", 1 ether));
    }
}

contract TestContract {
    using Log for *;
    using LibVm for *;
    using Help for *;
    address public addr;

    function save() public {
        addr = msg.sender;
    }

    function func() public {
        console.log("TestContract");
        uint256[] memory nums = new uint256[](3);

        nums[0] = 1 ether;
        nums[1] = 100 ether;
        nums[2] = 0 ether;

        Log.logCallers();
    }
}
