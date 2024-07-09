// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Scripted} from "./s/Scripted.s.sol";
import {PLog} from "./s/PLog.s.sol";
import {PythScript} from "./ffi/PythScript.s.sol";

abstract contract Based is PythScript, Scripted {
    string internal _defaultRPC = "RPC_ARBITRUM_ALCHEMY";
    address internal sender;

    modifier based(string memory _mnemonic, string memory _uoa) {
        base(_mnemonic, _uoa);
        _;
    }

    function base(
        string memory _mnemonic,
        string memory _network,
        uint256 _blockNr
    ) internal returns (uint256 forkId) {
        PLog.clg(
            "***********************************************************************************"
        );
        base(_mnemonic);
        forkId = createSelectFork(_network, _blockNr);
        PLog.clg(
            "***********************************************************************************\n"
        );
    }

    function base(
        string memory _mnemonic,
        string memory _network
    ) internal returns (uint256 forkId) {
        return base(_mnemonic, _network, 0);
    }

    function base(string memory _mnemonic) internal {
        useMnemonic(_mnemonic);
        sender = getAddr(0);
        PLog.clg(sender, "sender:");
    }

    function createSelectFork(string memory _env) internal returns (uint256) {
        return createSelectFork(_env, 0);
    }

    function createSelectFork(
        string memory _env,
        uint256 _blockNr
    ) internal returns (uint256 forkId_) {
        string memory rpc = getEnv(_env, _defaultRPC);
        forkId_ = _blockNr != 0
            ? vm.createSelectFork(rpc, _blockNr)
            : vm.createSelectFork(rpc);
        PLog.clg(
            "rpc:",
            string.concat(
                vm.rpcUrl(rpc),
                " (",
                vm.toString(block.chainid),
                "@",
                vm.toString(block.number),
                ", ",
                vm.toString(((getTime() - block.timestamp) / 60)),
                "m ago)"
            )
        );
    }
}
