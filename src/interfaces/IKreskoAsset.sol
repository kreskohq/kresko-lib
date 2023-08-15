// SPDX-License-Identifier: MIT
pragma solidity >=0.8.14;

import {IERC20} from "../vendor/IERC20.sol";

interface IKreskoAsset is IERC20 {
    /**
     * @notice Rebase information
     * @param positive supply increasing/reducing rebase
     * @param denominator the denominator for the operator, 1 ether = 1
     */
    struct Rebase {
        bool positive;
        uint256 denominator;
    }

    function initialize(
        string memory _name,
        string memory _symbol,
        uint8 _decimals,
        address _owner,
        address _kresko
    ) external;

    function kresko() external view returns (address);

    function mint(address _to, uint256 _amount) external;

    function burn(address _from, uint256 _amount) external;

    function rebaseInfo() external view returns (Rebase memory);

    function isRebased() external view returns (bool);

    function rebase(
        uint256 _denominator,
        bool _positive,
        address[] calldata pools
    ) external;

    function reinitializeERC20(
        string memory _name,
        string memory _symbol,
        uint8 _version
    ) external;
}
