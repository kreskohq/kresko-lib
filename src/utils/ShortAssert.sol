// solhint-disable
pragma solidity ^0.8.0;

import {stdMath} from "forge-std/StdMath.sol";
import {Vm, VmSafe} from "forge-std/Vm.sol";
import {LibVm, store, Log} from "./Libs.sol";

library ShortAssert {
    bool constant IS_TEST = true;

    function failed() public returns (bool) {
        if (store()._failed) {
            return store()._failed;
        } else {
            bool globalFailed = false;
            if (LibVm.hasHEVMContext()) {
                (, bytes memory retdata) = LibVm.HEVM_ADDRESS.call(
                    abi.encodePacked(
                        bytes4(keccak256("load(address,bytes32)")),
                        abi.encode(LibVm.HEVM_ADDRESS, bytes32("failed"))
                    )
                );
                globalFailed = abi.decode(retdata, (bool));
            }
            return globalFailed;
        }
    }

    function fail() internal {
        if (LibVm.hasHEVMContext()) {
            (bool status, ) = LibVm.HEVM_ADDRESS.call(
                abi.encodePacked(
                    bytes4(keccak256("store(address,bytes32,bytes32)")),
                    abi.encode(
                        LibVm.HEVM_ADDRESS,
                        bytes32("failed"),
                        bytes32(uint256(0x01))
                    )
                )
            );
            status; // Silence compiler warnings
        }
        store()._failed = true;
    }

    function eqz(uint256 a) internal returns (bool) {
        if (a != 0) {
            emit Log.log("Error: a == 0 not satisfied [uint]");
            emit Log.log_named_uint("  Value a", a);
            fail();
        }

        return !store()._failed;
    }

    function eqz(uint256 a, string memory err) internal returns (bool) {
        if (a != 0) {
            emit Log.log_named_string("Error", err);
            eqz(a);
        }

        return !store()._failed;
    }

    function gtz(uint256 a) internal returns (bool) {
        if (a <= 0) {
            emit Log.log("Error: a > 0 not satisfied [uint]");
            fail();
        }

        return !store()._failed;
    }

    function gtz(uint256 a, string memory err) internal returns (bool) {
        if (a <= 0) {
            emit Log.log_named_string("Error", err);
            gtz(a);
        }

        return !store()._failed;
    }

    function gtz(int256 a) internal returns (bool) {
        if (a <= 0) {
            emit Log.log("Error: a > 0 not satisfied [int]");
            emit Log.log_named_int("  Value a", a);
            fail();
        }

        return !store()._failed;
    }

    function gtz(int256 a, string memory err) internal returns (bool) {
        if (a <= 0) {
            emit Log.log_named_string("Error", err);
            gtz(a);
        }

        return !store()._failed;
    }

    function assertTrue(bool condition) internal {
        if (!condition) {
            emit Log.log("Error: Assertion Failed");
            fail();
        }
    }

    function assertTrue(bool condition, string memory err) internal {
        if (!condition) {
            emit Log.log_named_string("Error", err);
            assertTrue(condition);
        }
    }

    function eq(address a, address b) internal returns (bool) {
        if (a != b) {
            emit Log.log("Error: a == b not satisfied [address]");
            emit Log.log_named_address("      Left", a);
            emit Log.log_named_address("     Right", b);
            fail();
        }
        return !store()._failed;
    }

    function eq(
        address a,
        address b,
        string memory err
    ) internal returns (bool) {
        if (a != b) {
            emit Log.log_named_string("Error", err);
            eq(a, b);
        }
        return !store()._failed;
    }

    function eq(bytes32 a, bytes32 b) internal {
        if (a != b) {
            emit Log.log("Error: a == b not satisfied [bytes32]");
            emit Log.log_named_bytes32("      Left", a);
            emit Log.log_named_bytes32("     Right", b);
            fail();
        }
    }

    function eq(bytes32 a, bytes32 b, string memory err) internal {
        if (a != b) {
            emit Log.log_named_string("Error", err);
            eq(a, b);
        }
    }

    function eq(int a, int b) internal returns (bool) {
        if (a != b) {
            emit Log.log("Error: a == b not satisfied [int]");
            emit Log.log_named_int("      Left", a);
            emit Log.log_named_int("     Right", b);
            fail();
        }
        return !store()._failed;
    }

    function eq(int a, int b, string memory err) internal returns (bool) {
        if (a != b) {
            emit Log.log_named_string("Error", err);
            eq(a, b);
        }
        return !store()._failed;
    }

    function eq(uint a, uint b) internal returns (bool) {
        if (a != b) {
            emit Log.log("Error: a == b not satisfied [uint]");
            emit Log.log_named_uint("      Left", a);
            emit Log.log_named_uint("     Right", b);
            fail();
        }
        return !store()._failed;
    }

    function eq(uint a, uint b, string memory err) internal returns (bool) {
        if (a != b) {
            emit Log.log_named_string("Error", err);
            return eq(a, b);
        }

        return !store()._failed;
    }

    function eqDecimal(int a, int b, uint decimals) internal {
        if (a != b) {
            emit Log.log("Error: a == b not satisfied [decimal int]");
            emit Log.log_named_decimal_int("      Left", a, decimals);
            emit Log.log_named_decimal_int("     Right", b, decimals);
            fail();
        }
    }

    function eqDecimal(
        int a,
        int b,
        uint decimals,
        string memory err
    ) internal {
        if (a != b) {
            emit Log.log_named_string("Error", err);
            eqDecimal(a, b, decimals);
        }
    }

    function eqDecimal(uint a, uint b, uint decimals) internal {
        if (a != b) {
            emit Log.log("Error: a == b not satisfied [decimal uint]");
            emit Log.log_named_decimal_uint("      Left", a, decimals);
            emit Log.log_named_decimal_uint("     Right", b, decimals);
            fail();
        }
    }

    function eqDecimal(
        uint a,
        uint b,
        uint decimals,
        string memory err
    ) internal {
        if (a != b) {
            emit Log.log_named_string("Error", err);
            eqDecimal(a, b, decimals);
        }
    }

    function notEq(address a, address b) internal {
        if (a == b) {
            emit Log.log("Error: a != b not satisfied [address]");
            emit Log.log_named_address("      Left", a);
            emit Log.log_named_address("     Right", b);
            fail();
        }
    }

    function notEq(address a, address b, string memory err) internal {
        if (a == b) {
            emit Log.log_named_string("Error", err);
            notEq(a, b);
        }
    }

    function notEq(bytes32 a, bytes32 b) internal {
        if (a == b) {
            emit Log.log("Error: a != b not satisfied [bytes32]");
            emit Log.log_named_bytes32("      Left", a);
            emit Log.log_named_bytes32("     Right", b);
            fail();
        }
    }

    function notEq(bytes32 a, bytes32 b, string memory err) internal {
        if (a == b) {
            emit Log.log_named_string("Error", err);
            notEq(a, b);
        }
    }

    function notEq32(bytes32 a, bytes32 b) internal {
        notEq(a, b);
    }

    function notEq32(bytes32 a, bytes32 b, string memory err) internal {
        notEq(a, b, err);
    }

    function notEq(int a, int b) internal returns (bool) {
        if (a == b) {
            emit Log.log("Error: a != b not satisfied [int]");
            emit Log.log_named_int("      Left", a);
            emit Log.log_named_int("     Right", b);
            fail();
        }

        return !store()._failed;
    }

    function notEq(int a, int b, string memory err) internal returns (bool) {
        if (a == b) {
            emit Log.log_named_string("Error", err);
            notEq(a, b);
        }

        return !store()._failed;
    }

    function notEq(uint a, uint b) internal returns (bool) {
        if (a == b) {
            emit Log.log("Error: a != b not satisfied [uint]");
            emit Log.log_named_uint("      Left", a);
            emit Log.log_named_uint("     Right", b);
            fail();
        }

        return !store()._failed;
    }

    function notEq(uint a, uint b, string memory err) internal returns (bool) {
        if (a == b) {
            emit Log.log_named_string("Error", err);
            notEq(a, b);
        }

        return !store()._failed;
    }

    function notEqDecimal(int a, int b, uint decimals) internal {
        if (a == b) {
            emit Log.log("Error: a != b not satisfied [decimal int]");
            emit Log.log_named_decimal_int("      Left", a, decimals);
            emit Log.log_named_decimal_int("     Right", b, decimals);
            fail();
        }
    }

    function notEqDecimal(
        int a,
        int b,
        uint decimals,
        string memory err
    ) internal {
        if (a == b) {
            emit Log.log_named_string("Error", err);
            notEqDecimal(a, b, decimals);
        }
    }

    function notEqDecimal(uint a, uint b, uint decimals) internal {
        if (a == b) {
            emit Log.log("Error: a != b not satisfied [decimal uint]");
            emit Log.log_named_decimal_uint("      Left", a, decimals);
            emit Log.log_named_decimal_uint("     Right", b, decimals);
            fail();
        }
    }

    function notEqDecimal(
        uint a,
        uint b,
        uint decimals,
        string memory err
    ) internal {
        if (a == b) {
            emit Log.log_named_string("Error", err);
            notEqDecimal(a, b, decimals);
        }
    }

    function gt(uint a, uint b) internal returns (bool) {
        if (a <= b) {
            emit Log.log("Error: a > b not satisfied [uint]");
            emit Log.log_named_uint("  Value a", a);
            emit Log.log_named_uint("  Value b", b);
            fail();
        }

        return !store()._failed;
    }

    function gt(uint a, uint b, string memory err) internal returns (bool) {
        if (a <= b) {
            emit Log.log_named_string("Error", err);
            gt(a, b);
        }

        return !store()._failed;
    }

    function gt(int a, int b) internal returns (bool) {
        if (a <= b) {
            emit Log.log("Error: a > b not satisfied [int]");
            emit Log.log_named_int("  Value a", a);
            emit Log.log_named_int("  Value b", b);
            fail();
        }

        return !store()._failed;
    }

    function gt(int a, int b, string memory err) internal returns (bool) {
        if (a <= b) {
            emit Log.log_named_string("Error", err);
            gt(a, b);
        }

        return !store()._failed;
    }

    function gtDecimal(int a, int b, uint decimals) internal {
        if (a <= b) {
            emit Log.log("Error: a > b not satisfied [decimal int]");
            emit Log.log_named_decimal_int("  Value a", a, decimals);
            emit Log.log_named_decimal_int("  Value b", b, decimals);
            fail();
        }
    }

    function gtDecimal(
        int a,
        int b,
        uint decimals,
        string memory err
    ) internal {
        if (a <= b) {
            emit Log.log_named_string("Error", err);
            gtDecimal(a, b, decimals);
        }
    }

    function gtDecimal(uint a, uint b, uint decimals) internal {
        if (a <= b) {
            emit Log.log("Error: a > b not satisfied [decimal uint]");
            emit Log.log_named_decimal_uint("  Value a", a, decimals);
            emit Log.log_named_decimal_uint("  Value b", b, decimals);
            fail();
        }
    }

    function gtDecimal(
        uint a,
        uint b,
        uint decimals,
        string memory err
    ) internal {
        if (a <= b) {
            emit Log.log_named_string("Error", err);
            gtDecimal(a, b, decimals);
        }
    }

    function gte(uint a, uint b) internal returns (bool) {
        if (a < b) {
            emit Log.log("Error: a >= b not satisfied [uint]");
            emit Log.log_named_uint("  Value a", a);
            emit Log.log_named_uint("  Value b", b);
            fail();
        }

        return !store()._failed;
    }

    function gte(uint a, uint b, string memory err) internal returns (bool) {
        if (a < b) {
            emit Log.log_named_string("Error", err);
            gte(a, b);
        }

        return !store()._failed;
    }

    function gte(int a, int b) internal returns (bool) {
        if (a < b) {
            emit Log.log("Error: a >= b not satisfied [int]");
            emit Log.log_named_int("  Value a", a);
            emit Log.log_named_int("  Value b", b);
            fail();
        }

        return !store()._failed;
    }

    function gte(int a, int b, string memory err) internal returns (bool) {
        if (a < b) {
            emit Log.log_named_string("Error", err);
            gte(a, b);
        }

        return !store()._failed;
    }

    function gteDecimal(int a, int b, uint decimals) internal {
        if (a < b) {
            emit Log.log("Error: a >= b not satisfied [decimal int]");
            emit Log.log_named_decimal_int("  Value a", a, decimals);
            emit Log.log_named_decimal_int("  Value b", b, decimals);
            fail();
        }
    }

    function gteDecimal(
        int a,
        int b,
        uint decimals,
        string memory err
    ) internal {
        if (a < b) {
            emit Log.log_named_string("Error", err);
            gteDecimal(a, b, decimals);
        }
    }

    function gteDecimal(uint a, uint b, uint decimals) internal {
        if (a < b) {
            emit Log.log("Error: a >= b not satisfied [decimal uint]");
            emit Log.log_named_decimal_uint("  Value a", a, decimals);
            emit Log.log_named_decimal_uint("  Value b", b, decimals);
            fail();
        }
    }

    function gteDecimal(
        uint a,
        uint b,
        uint decimals,
        string memory err
    ) internal {
        if (a < b) {
            emit Log.log_named_string("Error", err);
            gteDecimal(a, b, decimals);
        }
    }

    function lt(uint a, uint b) internal returns (bool) {
        if (a >= b) {
            emit Log.log("Error: a < b not satisfied [uint]");
            emit Log.log_named_uint("  Value a", a);
            emit Log.log_named_uint("  Value b", b);
            fail();
        }

        return !store()._failed;
    }

    function lt(uint a, uint b, string memory err) internal returns (bool) {
        if (a >= b) {
            emit Log.log_named_string("Error", err);
            lt(a, b);
        }

        return !store()._failed;
    }

    function lt(int a, int b) internal returns (bool) {
        if (a >= b) {
            emit Log.log("Error: a < b not satisfied [int]");
            emit Log.log_named_int("  Value a", a);
            emit Log.log_named_int("  Value b", b);
            fail();
        }

        return !store()._failed;
    }

    function lt(int a, int b, string memory err) internal returns (bool) {
        if (a >= b) {
            emit Log.log_named_string("Error", err);
            lt(a, b);
        }

        return !store()._failed;
    }

    function ltDecimal(int a, int b, uint decimals) internal {
        if (a >= b) {
            emit Log.log("Error: a < b not satisfied [decimal int]");
            emit Log.log_named_decimal_int("  Value a", a, decimals);
            emit Log.log_named_decimal_int("  Value b", b, decimals);
            fail();
        }
    }

    function ltDecimal(
        int a,
        int b,
        uint decimals,
        string memory err
    ) internal {
        if (a >= b) {
            emit Log.log_named_string("Error", err);
            ltDecimal(a, b, decimals);
        }
    }

    function ltDecimal(uint a, uint b, uint decimals) internal {
        if (a >= b) {
            emit Log.log("Error: a < b not satisfied [decimal uint]");
            emit Log.log_named_decimal_uint("  Value a", a, decimals);
            emit Log.log_named_decimal_uint("  Value b", b, decimals);
            fail();
        }
    }

    function ltDecimal(
        uint a,
        uint b,
        uint decimals,
        string memory err
    ) internal {
        if (a >= b) {
            emit Log.log_named_string("Error", err);
            ltDecimal(a, b, decimals);
        }
    }

    function lte(uint a, uint b) internal returns (bool) {
        if (a > b) {
            emit Log.log("Error: a <= b not satisfied [uint]");
            emit Log.log_named_uint("  Value a", a);
            emit Log.log_named_uint("  Value b", b);
            fail();
        }

        return !store()._failed;
    }

    function lte(uint a, uint b, string memory err) internal returns (bool) {
        if (a > b) {
            emit Log.log_named_string("Error", err);
            lte(a, b);
        }

        return !store()._failed;
    }

    function lte(int a, int b) internal returns (bool) {
        if (a > b) {
            emit Log.log("Error: a <= b not satisfied [int]");
            emit Log.log_named_int("  Value a", a);
            emit Log.log_named_int("  Value b", b);
            fail();
        }

        return !store()._failed;
    }

    function lte(int a, int b, string memory err) internal returns (bool) {
        if (a > b) {
            emit Log.log_named_string("Error", err);
            lte(a, b);
        }
        return !store()._failed;
    }

    function lteDecimal(int a, int b, uint decimals) internal {
        if (a > b) {
            emit Log.log("Error: a <= b not satisfied [decimal int]");
            emit Log.log_named_decimal_int("  Value a", a, decimals);
            emit Log.log_named_decimal_int("  Value b", b, decimals);
            fail();
        }
    }

    function lteDecimal(
        int a,
        int b,
        uint decimals,
        string memory err
    ) internal {
        if (a > b) {
            emit Log.log_named_string("Error", err);
            lteDecimal(a, b, decimals);
        }
    }

    function lteDecimal(uint a, uint b, uint decimals) internal {
        if (a > b) {
            emit Log.log("Error: a <= b not satisfied [decimal uint]");
            emit Log.log_named_decimal_uint("  Value a", a, decimals);
            emit Log.log_named_decimal_uint("  Value b", b, decimals);
            fail();
        }
    }

    function lteDecimal(
        uint a,
        uint b,
        uint decimals,
        string memory err
    ) internal {
        if (a > b) {
            emit Log.log_named_string("Error", err);
            lteDecimal(a, b, decimals);
        }
    }

    function eq(string memory a, string memory b) internal {
        if (keccak256(abi.encodePacked(a)) != keccak256(abi.encodePacked(b))) {
            emit Log.log("Error: a == b not satisfied [string]");
            emit Log.log_named_string("      Left", a);
            emit Log.log_named_string("     Right", b);
            fail();
        }
    }

    function eq(string memory a, string memory b, string memory err) internal {
        if (keccak256(abi.encodePacked(a)) != keccak256(abi.encodePacked(b))) {
            emit Log.log_named_string("Error", err);
            eq(a, b);
        }
    }

    function notEq(string memory a, string memory b) internal {
        if (keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b))) {
            emit Log.log("Error: a != b not satisfied [string]");
            emit Log.log_named_string("      Left", a);
            emit Log.log_named_string("     Right", b);
            fail();
        }
    }

    function notEq(
        string memory a,
        string memory b,
        string memory err
    ) internal {
        if (keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b))) {
            emit Log.log_named_string("Error", err);
            notEq(a, b);
        }
    }

    function checkEq0(
        bytes memory a,
        bytes memory b
    ) internal pure returns (bool ok) {
        ok = true;
        if (a.length == b.length) {
            for (uint i = 0; i < a.length; i++) {
                if (a[i] != b[i]) {
                    ok = false;
                }
            }
        } else {
            ok = false;
        }
    }

    function eq0(bytes memory a, bytes memory b) internal {
        if (!checkEq0(a, b)) {
            emit Log.log("Error: a == b not satisfied [bytes]");
            emit Log.log_named_bytes("      Left", a);
            emit Log.log_named_bytes("     Right", b);
            fail();
        }
    }

    function eq0(bytes memory a, bytes memory b, string memory err) internal {
        if (!checkEq0(a, b)) {
            emit Log.log_named_string("Error", err);
            eq0(a, b);
        }
    }

    function notEq0(bytes memory a, bytes memory b) internal {
        if (checkEq0(a, b)) {
            emit Log.log("Error: a != b not satisfied [bytes]");
            emit Log.log_named_bytes("      Left", a);
            emit Log.log_named_bytes("     Right", b);
            fail();
        }
    }

    function notEq0(
        bytes memory a,
        bytes memory b,
        string memory err
    ) internal {
        if (checkEq0(a, b)) {
            emit Log.log_named_string("Error", err);
            notEq0(a, b);
        }
    }

    function isFalse(bool data) internal {
        assertTrue(!data);
    }

    function isFalse(bool data, string memory err) internal {
        assertTrue(!data, err);
    }

    function eq(bool a, bool b) internal {
        if (a != b) {
            emit Log.log("Error: a == b not satisfied [bool]");
            emit Log.log_named_string("      Left", a ? "true" : "false");
            emit Log.log_named_string("     Right", b ? "true" : "false");
            fail();
        }
    }

    function eq(bool a, bool b, string memory err) internal {
        if (a != b) {
            emit Log.log_named_string("Error", err);
            eq(a, b);
        }
    }

    function eq(bytes memory a, bytes memory b) internal {
        eq0(a, b);
    }

    function eq(bytes memory a, bytes memory b, string memory err) internal {
        eq0(a, b, err);
    }

    function eq(uint256[] memory a, uint256[] memory b) internal {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit Log.log("Error: a == b not satisfied [uint[]]");
            emit Log.log_named_array("      Left", a);
            emit Log.log_named_array("     Right", b);
            fail();
        }
    }

    function eq(int256[] memory a, int256[] memory b) internal {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit Log.log("Error: a == b not satisfied [int[]]");
            emit Log.log_named_array("      Left", a);
            emit Log.log_named_array("     Right", b);
            fail();
        }
    }

    function eq(address[] memory a, address[] memory b) internal {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit Log.log("Error: a == b not satisfied [address[]]");
            emit Log.log_named_array("      Left", a);
            emit Log.log_named_array("     Right", b);
            fail();
        }
    }

    function eq(
        uint256[] memory a,
        uint256[] memory b,
        string memory err
    ) internal {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit Log.log_named_string("Error", err);
            eq(a, b);
        }
    }

    function eq(
        int256[] memory a,
        int256[] memory b,
        string memory err
    ) internal {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit Log.log_named_string("Error", err);
            eq(a, b);
        }
    }

    function eq(
        address[] memory a,
        address[] memory b,
        string memory err
    ) internal {
        if (keccak256(abi.encode(a)) != keccak256(abi.encode(b))) {
            emit Log.log_named_string("Error", err);
            eq(a, b);
        }
    }

    // Legacy helper
    function eqUint(uint256 a, uint256 b) internal {
        eq(uint256(a), uint256(b));
    }

    function closeTo(
        uint256 a,
        uint256 b,
        uint256 maxDelta
    ) internal returns (bool) {
        uint256 delta = stdMath.delta(a, b);

        if (delta > maxDelta) {
            emit Log.log("Error: a ~= b not satisfied [uint]");
            emit Log.log_named_uint("      Left", a);
            emit Log.log_named_uint("     Right", b);
            emit Log.log_named_uint(" Max Delta", maxDelta);
            emit Log.log_named_uint("     Delta", delta);
            fail();
        }

        return !store()._failed;
    }

    function closeTo(
        uint256 a,
        uint256 b,
        uint256 maxDelta,
        string memory err
    ) internal returns (bool) {
        uint256 delta = stdMath.delta(a, b);

        if (delta > maxDelta) {
            emit Log.log_named_string("Error", err);
            closeTo(a, b, maxDelta);
        }

        return !store()._failed;
    }

    function closeToDecimal(
        uint256 a,
        uint256 b,
        uint256 maxDelta,
        uint256 decimals
    ) internal returns (bool) {
        uint256 delta = stdMath.delta(a, b);

        if (delta > maxDelta) {
            emit Log.log("Error: a ~= b not satisfied [uint]");
            emit Log.log_named_decimal_uint("      Left", a, decimals);
            emit Log.log_named_decimal_uint("     Right", b, decimals);
            emit Log.log_named_decimal_uint(" Max Delta", maxDelta, decimals);
            emit Log.log_named_decimal_uint("     Delta", delta, decimals);
            fail();
        }

        return !store()._failed;
    }

    function closeToDecimal(
        uint256 a,
        uint256 b,
        uint256 maxDelta,
        uint256 decimals,
        string memory err
    ) internal {
        uint256 delta = stdMath.delta(a, b);

        if (delta > maxDelta) {
            emit Log.log_named_string("Error", err);
            closeToDecimal(a, b, maxDelta, decimals);
        }
    }

    function closeTo(
        int256 a,
        int256 b,
        uint256 maxDelta
    ) internal returns (bool) {
        uint256 delta = stdMath.delta(a, b);

        if (delta > maxDelta) {
            emit Log.log("Error: a ~= b not satisfied [int]");
            emit Log.log_named_int("       Left", a);
            emit Log.log_named_int("      Right", b);
            emit Log.log_named_uint(" Max Delta", maxDelta);
            emit Log.log_named_uint("     Delta", delta);
            fail();
        }

        return !store()._failed;
    }

    function closeTo(
        int256 a,
        int256 b,
        uint256 maxDelta,
        string memory err
    ) internal returns (bool) {
        uint256 delta = stdMath.delta(a, b);

        if (delta > maxDelta) {
            emit Log.log_named_string("Error", err);
            closeTo(a, b, maxDelta);
        }

        return !store()._failed;
    }

    function closeToDecimal(
        int256 a,
        int256 b,
        uint256 maxDelta,
        uint256 decimals
    ) internal returns (bool) {
        uint256 delta = stdMath.delta(a, b);

        if (delta > maxDelta) {
            emit Log.log("Error: a ~= b not satisfied [int]");
            emit Log.log_named_decimal_int("      Left", a, decimals);
            emit Log.log_named_decimal_int("     Right", b, decimals);
            emit Log.log_named_decimal_uint(" Max Delta", maxDelta, decimals);
            emit Log.log_named_decimal_uint("     Delta", delta, decimals);
            fail();
        }

        return !store()._failed;
    }

    function closeToDecimal(
        int256 a,
        int256 b,
        uint256 maxDelta,
        uint256 decimals,
        string memory err
    ) internal returns (bool) {
        uint256 delta = stdMath.delta(a, b);

        if (delta > maxDelta) {
            emit Log.log_named_string("Error", err);
            closeToDecimal(a, b, maxDelta, decimals);
        }

        return !store()._failed;
    }

    function eq(
        function() external view returns (uint256) a,
        uint256 b
    ) internal returns (bool) {
        return eq(a(), b);
    }

    function eqInt(
        function() external view returns (int256) a,
        int256 b
    ) internal returns (bool) {
        return eq(a(), b);
    }

    function eqInt(
        function() external view returns (int256) a,
        uint256 b,
        string memory str
    ) internal returns (bool) {
        return eq(uint256(a()), b, str);
    }

    function eq(
        function() external view returns (uint256) a,
        uint256 b,
        string memory str
    ) internal returns (bool) {
        return eq(a(), b, str);
    }

    function eq(
        function() external view returns (int256) a,
        int256 b,
        string memory str
    ) internal returns (bool) {
        return eq(a(), b, str);
    }

    struct Tuple {
        uint256 a;
        uint256 b;
    }

    function and(
        function() external view returns (uint256) a,
        function() external view returns (uint256) b
    ) internal view returns (Tuple memory) {
        return Tuple(a(), b());
    }

    function eq(
        function() external view returns (uint256) a,
        function() external view returns (uint256) b
    ) internal returns (bool) {
        return eq(a(), b());
    }

    function eq(
        function() external view returns (uint256) a,
        function() external view returns (uint256) b,
        string memory str
    ) internal returns (bool) {
        return eq(a(), b(), str);
    }

    function eq(
        Tuple memory values,
        function() external view returns (uint256) c
    ) internal returns (bool) {
        return eq(values, c());
    }

    function eq(
        Tuple memory values,
        function() external view returns (uint256) c,
        string memory str
    ) internal returns (bool) {
        return eq(values, c(), str);
    }

    function eq(Tuple memory values, uint256 c) internal returns (bool) {
        return eq(values.a, values.b) && eq(values.b, c);
    }

    function eq(
        Tuple memory values,
        uint256 c,
        string memory str
    ) internal returns (bool) {
        return eq(values.b, values.a, str) && eq(values.b, c, str);
    }

    function eq(
        Tuple memory values,
        function() external view returns (uint256) c,
        uint256 d
    ) internal returns (bool) {
        return eq(values, c()) && eq(c(), d);
    }

    function eq(
        Tuple memory values,
        function() external view returns (uint256) c,
        uint256 d,
        string memory str
    ) internal returns (bool) {
        return eq(values, c(), str) && eq(c(), d, str);
    }

    function and(
        bool prev,
        function() external view returns (uint256) next
    ) internal returns (uint256) {
        if (!prev) {
            emit Log.log("Error: Previous value was false");
        }
        return next();
    }
}
