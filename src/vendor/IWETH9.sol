// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IWETH9 {
    function symbol() external view returns (string memory);

    function approve(address, uint256) external;

    function balanceOf(address) external returns (uint256);

    function allowance(address, address) external view returns (uint256);

    function transfer(address, uint256) external;

    function decimals() external view returns (uint8);

    function transferFrom(address, address, uint256) external;

    /// @notice Deposit ether to get wrapped ether
    function deposit() external payable;

    /// @notice Withdraw wrapped ether to get ether
    function withdraw(uint256) external;
}
