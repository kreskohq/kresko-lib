// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface VM {
    function ffi(string[] memory _cmd) external returns (bytes memory);
}

VM constant vm = VM(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
