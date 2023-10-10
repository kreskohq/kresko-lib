// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GnosisSafeL2Mock {
    function setup(
        address[] memory _owners,
        uint256 _threshold,
        address _to,
        bytes memory _data,
        address _fallbackHandler,
        address _paymentToken,
        uint256 _payment
    ) public {}

    function isOwner(address) external pure returns (bool) {
        return true;
    }

    function getOwners() external pure returns (address[] memory) {
        address[] memory owners = new address[](6);
        owners[0] = address(0x0);
        owners[1] = address(0x011);
        owners[2] = address(0x022);
        owners[3] = address(0x033);
        owners[4] = address(0x044);
        owners[5] = address(0x055);
        return owners;
    }
}

library LibSafe {
    address public constant USER1 = address(0x011);
    address public constant USER2 = address(0x022);
    address public constant USER3 = address(0x033);
    address public constant USER4 = address(0x044);

    function createSafe(address admin) internal returns (GnosisSafeL2Mock) {
        return new GnosisSafeL2Mock();
    }
    //     GnosisSafeL2 masterCopy = new GnosisSafeL2();
    //     GnosisSafeProxyFactory proxyFactory = new GnosisSafeProxy();
    //     address[] memory councilUsers = new address[](5);
    //     councilUsers[0] = (admin);
    //     councilUsers[1] = (USER1);
    //     councilUsers[2] = (USER2);
    //     councilUsers[3] = (USER3);
    //     councilUsers[4] = (USER4);

    //     return
    //         proxyFactory.createProxy(
    //             address(masterCopy),
    //             abi.encodeWithSelector(
    //                 masterCopy.setup.selector,
    //                 councilUsers,
    //                 3,
    //                 address(0),
    //                 "0x",
    //                 address(0),
    //                 address(0),
    //                 0,
    //                 admin
    //             )
    //         );
    // }
}
