// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import {Test, console} from "forge-std/Test.sol";

contract CounterTest is Test {
    function setUp() public {}

    function test() public {
        string memory testing = "";
        console.log(bytes(testing).length);
    }
}
