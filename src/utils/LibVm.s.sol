// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {IMinVM, mvm, mAddr, mPk, vmAddr} from "./MinVm.s.sol";

library LibVm {
    struct Callers {
        address msgSender;
        address txOrigin;
        string mode;
    }

    function callmode() internal returns (string memory) {
        (IMinVM.CallerMode _m, , ) = mvm.readCallers();
        return callModeStr(_m);
    }

    function clearCallers()
        internal
        returns (IMinVM.CallerMode m_, address s_, address o_)
    {
        (m_, s_, o_) = mvm.readCallers();
        if (
            m_ == IMinVM.CallerMode.Broadcast ||
            m_ == IMinVM.CallerMode.RecurrentBroadcast
        ) {
            mvm.stopBroadcast();
        } else if (
            m_ == IMinVM.CallerMode.Prank ||
            m_ == IMinVM.CallerMode.RecurrentPrank
        ) {
            mvm.stopPrank();
        }
    }

    function getTime() internal returns (uint256) {
        return uint256((mvm.unixTime() / 1000));
    }

    function restore(IMinVM.CallerMode _m, address _ss, address _so) internal {
        if (_m == IMinVM.CallerMode.Broadcast) {
            _ss == _so ? mvm.broadcast(_ss) : mvm.broadcast(_ss);
        } else if (_m == IMinVM.CallerMode.RecurrentBroadcast) {
            _ss == _so ? mvm.startBroadcast(_ss) : mvm.startBroadcast(_ss);
        } else if (_m == IMinVM.CallerMode.Prank) {
            _ss == _so ? mvm.prank(_ss, _so) : mvm.prank(_ss);
        } else if (_m == IMinVM.CallerMode.RecurrentPrank) {
            _ss == _so ? mvm.startPrank(_ss, _so) : mvm.startPrank(_ss);
        }
    }

    function unbroadcast()
        internal
        returns (IMinVM.CallerMode m_, address s_, address o_)
    {
        (m_, s_, o_) = mvm.readCallers();
        if (
            m_ == IMinVM.CallerMode.Broadcast ||
            m_ == IMinVM.CallerMode.RecurrentBroadcast
        ) {
            mvm.stopBroadcast();
        }
    }

    function unprank()
        internal
        returns (IMinVM.CallerMode m_, address s_, address o_)
    {
        (m_, s_, o_) = mvm.readCallers();
        if (
            m_ == IMinVM.CallerMode.Prank ||
            m_ == IMinVM.CallerMode.RecurrentPrank
        ) {
            mvm.stopPrank();
        }
    }

    function callers() internal returns (Callers memory) {
        (IMinVM.CallerMode m_, address s_, address o_) = mvm.readCallers();
        return Callers(s_, o_, callModeStr(m_));
    }

    function sender() internal returns (address s_) {
        (, s_, ) = mvm.readCallers();
    }

    function callModeStr(
        IMinVM.CallerMode _mode
    ) internal pure returns (string memory) {
        if (_mode == IMinVM.CallerMode.Broadcast) {
            return "broadcast";
        } else if (_mode == IMinVM.CallerMode.RecurrentBroadcast) {
            return "persistent broadcast";
        } else if (_mode == IMinVM.CallerMode.Prank) {
            return "prank";
        } else if (_mode == IMinVM.CallerMode.RecurrentPrank) {
            return "persistent prank";
        } else if (_mode == IMinVM.CallerMode.None) {
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
