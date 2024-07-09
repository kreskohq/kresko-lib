// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {PLog} from "./PLog.s.sol";
import {IMinVM, LibVm, mvm} from "./MinVm.s.sol";

// solhint-disable

library Anvil {
    using PLog for *;

    function setStorage(address account, bytes32 slot, bytes32 value) internal {
        mvm.rpc(
            "anvil_setStorageAt",
            string.concat(
                '["',
                mvm.toString(account),
                '","',
                mvm.toString(slot),
                '","',
                mvm.toString(value),
                '"]'
            )
        );
        mine();
    }

    function mine() internal {
        uint256 blockNr = block.number;
        (IMinVM.CallerMode _m, address _s, address _o) = LibVm.clearCallers();

        mvm.rpc("evm_mine", "[]");
        mvm.createSelectFork("localhost", blockNr + 1);

        LibVm.restore(_m, _s, _o);
    }

    function syncTime(uint256 time) internal {
        uint256 current = time != 0 ? time : LibVm.getTime();
        mvm.rpc(
            "evm_setNextBlockTimestamp",
            string.concat("[", mvm.toString(current), "]")
        );
        mine();
    }
}
