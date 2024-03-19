// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {PLog} from "./PLog.s.sol";
import {Vm} from "forge-std/Vm.sol";
import {IMinVM, LibVm} from "./LibVm.s.sol";
import {IAggregatorV3} from "../vendor/IAggregatorV3.sol";
import {split} from "./Bytes.s.sol";

// solhint-disable
Vm constant vm = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

library Anvil {
    using PLog for *;

    function setStorage(address account, bytes32 slot, bytes32 value) internal {
        vm.rpc(
            "anvil_setStorageAt",
            string.concat(
                '["',
                vm.toString(account),
                '","',
                vm.toString(slot),
                '","',
                vm.toString(value),
                '"]'
            )
        );
        mine();
    }

    function mine() internal {
        uint256 blockNr = block.number;
        (IMinVM.CallerMode _m, address _s, address _o) = LibVm.clearCallers();

        vm.rpc("evm_mine", "[]");
        vm.createSelectFork("localhost", blockNr + 1);

        LibVm.restore(_m, _s, _o);
    }

    function syncTime(uint256 time) internal {
        uint256 current = time != 0 ? time : LibVm.getTime();
        vm.rpc(
            "evm_setNextBlockTimestamp",
            string.concat("[", vm.toString(current), "]")
        );
        mine();
    }

    function setCLPrice(address _feed, uint256 _price) internal {
        vm.startStateDiffRecording();
        int256 price = IAggregatorV3(_feed).latestAnswer();
        Vm.AccountAccess[] memory acc = vm.stopAndReturnStateDiff();

        for (uint256 i = 0; i < acc.length; i++) {
            for (uint256 j = 0; j < acc[i].storageAccesses.length; j++) {
                bytes32 stored = acc[i].storageAccesses[j].previousValue;
                if (stored == bytes32(0)) {
                    continue;
                }
                (, int256 val) = abi.decode(
                    split(stored, 64),
                    (uint64, int192)
                );

                if (price == val) {
                    _price.clg("setCLPrice.newPrice");
                    Anvil.setStorage(
                        acc[i].storageAccesses[j].account,
                        acc[i].storageAccesses[j].slot,
                        bytes32(
                            abi.encodePacked(
                                uint64(LibVm.getTime()) - 1,
                                int192(int256(_price))
                            )
                        )
                    );
                    IAggregatorV3(_feed).latestAnswer().clg(
                        "setCLPrice.latestAnswer"
                    );
                }
            }
        }
    }
}
