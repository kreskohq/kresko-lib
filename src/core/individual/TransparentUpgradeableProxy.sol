// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (proxy/transparent/TransparentUpgradeableProxy.sol)

pragma solidity ^0.8.20;

import {ERC1967Utils, ERC1967Proxy, ITransparentUpgradeableProxy} from "@oz/proxy/transparent/TransparentUpgradeableProxy.sol";

contract TransparentUpgradeableProxy is ERC1967Proxy {
    address private immutable _admin;

    error ProxyDeniedAdminAccess();

    /**
     * @dev Initializes an upgradeable proxy managed by an instance of a {ProxyAdmin} with an `initialOwner`,
     * backed by the implementation at `_logic`, and optionally initialized with `_data` as explained in
     * {ERC1967Proxy-constructor}.
     *
     * @notice Kresko
     * @dev Removed ProxyAdmin construction - instead using the creator {DeploymentFactory} as {ProxyAdmin}.
     * @dev Factory address is explicitly passed as argument (and not as msg.sender) to support "CREATE3".
     */
    constructor(
        address _logic,
        address _factory,
        bytes memory _data
    ) payable ERC1967Proxy(_logic, _data) {
        _admin = _factory;
        // Set the storage value and emit an event for ERC-1967 compatibility
        ERC1967Utils.changeAdmin(_proxyAdmin());
    }

    /**
     * @dev Returns the admin of this proxy.
     */
    function _proxyAdmin() internal virtual returns (address) {
        return _admin;
    }

    /**
     * @dev If caller is the admin process the call internally, otherwise transparently fallback to the proxy behavior.
     */
    function _fallback() internal virtual override {
        if (msg.sender == _proxyAdmin()) {
            if (
                msg.sig !=
                ITransparentUpgradeableProxy.upgradeToAndCall.selector
            ) {
                revert ProxyDeniedAdminAccess();
            } else {
                _dispatchUpgradeToAndCall();
            }
        } else {
            super._fallback();
        }
    }

    /**
     * @dev Upgrade the implementation of the proxy. See {ERC1967Utils-upgradeToAndCall}.
     *
     * Requirements:
     *
     * - If `data` is empty, `msg.value` must be zero.
     */
    function _dispatchUpgradeToAndCall() private {
        (address newImplementation, bytes memory data) = abi.decode(
            msg.data[4:],
            (address, bytes)
        );
        ERC1967Utils.upgradeToAndCall(newImplementation, data);
    }
}
