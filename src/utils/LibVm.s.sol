// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Vm, VmSafe} from "forge-std/Vm.sol";
import {mAddr, vmAddr, mPk} from "./MinVm.s.sol";

Vm constant VM = Vm(vmAddr);

library LibVm {
    struct Callers {
        address msgSender;
        address txOrigin;
        string mode;
    }

    function callmode() internal returns (string memory) {
        (VmSafe.CallerMode _m, , ) = VM.readCallers();
        return callModeStr(_m);
    }

    function clearCallers()
        internal
        returns (VmSafe.CallerMode m_, address s_, address o_)
    {
        (m_, s_, o_) = VM.readCallers();
        if (
            m_ == VmSafe.CallerMode.Broadcast ||
            m_ == VmSafe.CallerMode.RecurrentBroadcast
        ) {
            VM.stopBroadcast();
        } else if (
            m_ == VmSafe.CallerMode.Prank ||
            m_ == VmSafe.CallerMode.RecurrentPrank
        ) {
            VM.stopPrank();
        }
    }

    function restore(VmSafe.CallerMode _m, address _ss, address _so) internal {
        if (_m == VmSafe.CallerMode.Broadcast) {
            _ss == _so ? VM.broadcast(_ss) : VM.broadcast(_ss);
        } else if (_m == VmSafe.CallerMode.RecurrentBroadcast) {
            _ss == _so ? VM.startBroadcast(_ss) : VM.startBroadcast(_ss);
        } else if (_m == VmSafe.CallerMode.Prank) {
            _ss == _so ? VM.prank(_ss, _so) : VM.prank(_ss);
        } else if (_m == VmSafe.CallerMode.RecurrentPrank) {
            _ss == _so ? VM.startPrank(_ss, _so) : VM.startPrank(_ss);
        }
    }

    function unbroadcast()
        internal
        returns (VmSafe.CallerMode m_, address s_, address o_)
    {
        (m_, s_, o_) = VM.readCallers();
        if (
            m_ == VmSafe.CallerMode.Broadcast ||
            m_ == VmSafe.CallerMode.RecurrentBroadcast
        ) {
            VM.stopBroadcast();
        }
    }

    function unprank()
        internal
        returns (VmSafe.CallerMode m_, address s_, address o_)
    {
        (m_, s_, o_) = VM.readCallers();
        if (
            m_ == VmSafe.CallerMode.Prank ||
            m_ == VmSafe.CallerMode.RecurrentPrank
        ) {
            VM.stopPrank();
        }
    }

    function callers() internal returns (Callers memory) {
        (VmSafe.CallerMode m_, address s_, address o_) = VM.readCallers();
        return Callers(s_, o_, callModeStr(m_));
    }

    function sender() internal returns (address s_) {
        (, s_, ) = VM.readCallers();
    }

    function callModeStr(
        VmSafe.CallerMode _mode
    ) internal pure returns (string memory) {
        if (_mode == VmSafe.CallerMode.Broadcast) {
            return "broadcast";
        } else if (_mode == VmSafe.CallerMode.RecurrentBroadcast) {
            return "persistent broadcast";
        } else if (_mode == VmSafe.CallerMode.Prank) {
            return "prank";
        } else if (_mode == VmSafe.CallerMode.RecurrentPrank) {
            return "persistent prank";
        } else if (_mode == VmSafe.CallerMode.None) {
            return "none";
        } else {
            return "unknown mode";
        }
    }

    function getAddr(
        string memory _mEnv,
        uint32 _idx
    ) internal returns (address) {
        return mAddr(_mEnv, _idx);
    }

    function getPk(
        string memory _mEnv,
        uint32 _idx
    ) internal returns (uint256) {
        return mPk(_mEnv, _idx);
    }
}
