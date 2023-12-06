// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {mAddr, mPk, mvm} from "./MinVm.s.sol";

string constant testMnemonic = "error burger code";

contract Wallet {
    string private __mEnv = "MNEMONIC_DEVNET";

    modifier mnemonic(string memory _mEnv) {
        __mEnv = _mEnv;
        _;
    }

    /// @param _mEnv name of the env variable, default is MNEMONIC_DEVNET
    function useMnemonic(string memory _mEnv) internal {
        __mEnv = _mEnv;
    }

    /// @param _mIdx mnemonic index
    function getPk(uint32 _mIdx) internal returns (uint256) {
        return mPk(__mEnv, _mIdx);
    }

    /// @param _mIdx mnemonic index
    function getAddr(uint32 _mIdx) internal returns (address) {
        return mAddr(__mEnv, _mIdx);
    }

    /// @param _pkEnv name of the env variable
    function getAddr(string memory _pkEnv) internal returns (address) {
        return mvm.rememberKey(mvm.envOr(_pkEnv, 0));
    }
}
