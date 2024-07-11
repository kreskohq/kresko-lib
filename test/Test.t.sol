// solhint-disable
// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import {Tested} from "../src/utils/s/Tested.t.sol";
import {LibVm, Help, Log} from "../src/utils/s/LibVm.s.sol";
import {ShortAssert} from "../src/utils/s/ShortAssert.t.sol";
import {PLog, logp} from "../src/utils/s/PLog.s.sol";
import {Utils} from "../src/utils/Libs.sol";
import {split} from "../src/utils/Bytes.s.sol";
import {__revert} from "../src/utils/s/Base.s.sol";

contract Sandbox is Tested {
    TestContract internal thing;
    using LibVm for *;
    using Log for *;
    using Help for *;
    using Utils for *;
    using ShortAssert for *;

    function setUp() public {
        useMnemonic("MNEMONIC");
        emit log_string("setUp");
        thing = new TestContract();
    }

    function testDlg() public {
        uint256 valA = 12.5e8;

        valA.dlg("valA", 8);
    }

    function testStrings() public {
        bytes32 val = bytes32("foo");
        bytes(val.txt()).length.eq(66, "str");
        bytes(val.str()).length.eq(3, "txt");

        12.5e8.strDec(8).eq("12.50000000", "dec");
    }

    function testDecimals() public {
        uint256 wad = 1e18;
        uint256 ray = 1e27;

        wad.toDec(18, 27).eq(ray, "wad-ray");
        ray.toDec(27, 18).eq(wad, "ray-wad");

        1.29e18.toDec(18, 1).eq(12, "a-b");
    }

    function testBytes() public {
        bytes32 val = bytes32(abi.encodePacked(uint192(192), uint64(64)));
        (uint192 a, uint64 b) = abi.decode(split(val, 192), (uint192, uint64));
        a.eq(192, "a");
        b.eq(64, "b");
    }

    function testRevert() public {
        vm.expectRevert(
            abi.encodeWithSelector(
                TestContract2.TestError.selector,
                "nope",
                1 ether,
                TestContract2.Structy("hello", 1 ether)
            )
        );
        thing.nope();
    }

    function testLogs() public {
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

    TestContract2 public thing2;

    constructor() {
        thing2 = new TestContract2();
    }

    function save() public {
        addr = msg.sender;
    }

    function func() public {
        Log.clg("TestContract");
        uint256[] memory nums = new uint256[](3);

        nums[0] = 1 ether;
        nums[1] = 100 ether;
        nums[2] = 0 ether;

        Log.logCallers();
    }

    function nope() public view {
        (, bytes memory data) = address(thing2).staticcall(
            abi.encodeWithSelector(thing2.nope.selector)
        );
        __revert(data);
    }
}

contract TestContract2 {
    struct Structy {
        string mesg;
        uint256 val;
    }
    error TestError(string mesg, uint256 val, Structy _struct);

    function nope() public pure {
        revert TestError("nope", 1 ether, Structy("hello", 1 ether));
    }
}
