// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Scripted} from "../Scripted.s.sol";
import {PLog} from "../PLog.s.sol";

abstract contract Based is Scripted {
    string internal _defaultRPC = "RPC_ARBITRUM_ALCHEMY";
    address internal sender;

    modifier fork(string memory _uoa) override {
        createSelectFork(_uoa);
        _;
    }

    function base(string memory _mnemonic, string memory _network) internal {
        PLog.clg(
            "***********************************************************************************"
        );
        base(_mnemonic);
        createSelectFork(_network);
        PLog.clg(
            "***********************************************************************************\n"
        );
    }

    function base(string memory _mnemonic) internal {
        useMnemonic(_mnemonic);
        sender = getAddr(0);
        PLog.clg(sender, "sender:");
    }

    function createSelectFork(string memory _env) internal {
        string memory rpc = getEnv(_env, _defaultRPC);
        vm.createSelectFork(rpc);
        PLog.clg(
            "rpc:",
            string.concat(
                vm.rpcUrl(rpc),
                " (",
                vm.toString(block.chainid),
                ", ",
                vm.toString(((getTime() - block.timestamp) / 60)),
                "m ago)"
            )
        );
    }
}
