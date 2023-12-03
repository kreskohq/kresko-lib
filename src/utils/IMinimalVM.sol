// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMinimalVM {
    function ffi(string[] memory _cmd) external returns (bytes memory);

    function readFile(string memory _path) external returns (string memory);

    function writeJson(string calldata json, string calldata path) external;

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
}

IMinimalVM constant vm = IMinimalVM(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
