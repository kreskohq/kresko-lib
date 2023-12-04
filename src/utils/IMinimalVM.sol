// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMinimalVM {
    function ffi(string[] memory _cmd) external returns (bytes memory);

    function readFile(string memory _path) external returns (string memory);

    function writeFile(string calldata, string calldata) external;

    function writeJson(string calldata json, string calldata path) external;

    function exists(string calldata) external returns (bool);

    function writeJson(
        string calldata json,
        string calldata path,
        string calldata valueKey
    ) external;

    function parseJson(
        string calldata json
    ) external pure returns (bytes memory abiEncodedData);

    function parseJson(
        string calldata json,
        string calldata key
    ) external pure returns (bytes memory abiEncodedData);

    function keyExists(
        string calldata json,
        string calldata key
    ) external view returns (bool);

    function isFile(string calldata) external view returns (bool);

    function snapshot() external returns (uint256);

    function revertTo(uint256) external returns (bool);

    function warp(uint256 newTimestamp) external;

    function projectRoot() external view returns (string memory path);

    // Returns the time since unix epoch in milliseconds
    function unixTime() external returns (uint256 milliseconds);
}

IMinimalVM constant vm = IMinimalVM(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
