// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Vm, VmSafe} from "forge-std/Vm.sol";
import {IERC20} from "../token/IERC20.sol";

Vm constant VM = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

struct Store {
    bool _failed;
    bool logDisabled;
    string logPrefix;
}

function store() view returns (Store storage ds) {
    if (!LibVm.hasHEVMContext()) revert("no hevm");
    assembly {
        ds.slot := 0x35b9089429a720996a27ffd842a4c293f759fc6856f1c672c8e2b5040a1eddfe
    }
}

library LibVm {
    using Help for address[];
    address constant HEVM_ADDRESS =
        address(bytes20(uint160(uint256(keccak256("hevm cheat code")))));
    Vm constant vm = VM;

    struct Callers {
        address msgSender;
        address txOrigin;
        string mode;
    }

    function hasHEVMContext() internal view returns (bool) {
        uint256 hevmCodeSize = 0;
        assembly {
            hevmCodeSize := extcodesize(
                0x7109709ECfa91a80626fF3989D68f67F5b1DD12D
            )
        }
        return hevmCodeSize > 0;
    }

    function callmode() internal returns (string memory) {
        (VmSafe.CallerMode mode, , ) = vm.readCallers();
        return callModeStr(mode);
    }

    function clearCallers() internal {
        (VmSafe.CallerMode mode, , ) = vm.readCallers();
        if (
            mode == VmSafe.CallerMode.Broadcast ||
            mode == VmSafe.CallerMode.RecurrentBroadcast
        ) {
            vm.stopBroadcast();
        } else if (
            mode == VmSafe.CallerMode.Prank ||
            mode == VmSafe.CallerMode.RecurrentPrank
        ) {
            vm.stopPrank();
        }
    }

    function unbroadcast()
        internal
        returns (VmSafe.CallerMode mode_, address msgSender_, address txOrigin_)
    {
        (mode_, msgSender_, txOrigin_) = vm.readCallers();
        if (
            mode_ == VmSafe.CallerMode.Broadcast ||
            mode_ == VmSafe.CallerMode.RecurrentBroadcast
        ) {
            vm.stopBroadcast();
        }
    }

    function unprank()
        internal
        returns (VmSafe.CallerMode mode_, address msgSender_, address txOrigin_)
    {
        (mode_, msgSender_, txOrigin_) = vm.readCallers();
        if (
            mode_ == VmSafe.CallerMode.Prank ||
            mode_ == VmSafe.CallerMode.RecurrentPrank
        ) {
            vm.stopPrank();
        }
    }

    function callers() internal returns (Callers memory) {
        (VmSafe.CallerMode mode_, address sender_, address origin_) = vm
            .readCallers();
        return Callers(sender_, origin_, callModeStr(mode_));
    }

    function sender() internal returns (address msgSender_) {
        (, msgSender_, ) = vm.readCallers();
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
}

library Help {
    Vm constant vm = VM;
    error ELEMENT_DOES_NOT_MATCH_PROVIDED_INDEX(
        ID element,
        uint256 index,
        address[] elements
    );
    using Help for address[];
    using Help for bytes32[];
    using Help for string[];
    using Help for string;

    struct ID {
        string symbol;
        address addr;
    }

    function id(address _token) internal view returns (ID memory) {
        if (_token.code.length > 0) {
            return ID(IERC20(_token).symbol(), _token);
        }
        return ID("", _token); // not a token
    }

    struct FindResult {
        uint256 index;
        bool exists;
    }

    function find(
        address[] storage _els,
        address _search
    ) internal pure returns (FindResult memory result) {
        address[] memory elements = _els;
        for (uint256 i; i < elements.length; ) {
            if (elements[i] == _search) {
                return FindResult(i, true);
            }
            unchecked {
                ++i;
            }
        }
    }

    function find(
        bytes32[] storage _els,
        bytes32 _search
    ) internal pure returns (FindResult memory result) {
        bytes32[] memory elements = _els;
        for (uint256 i; i < elements.length; ) {
            if (elements[i] == _search) {
                return FindResult(i, true);
            }
            unchecked {
                ++i;
            }
        }
    }

    function find(
        string[] storage _els,
        string memory _search
    ) internal pure returns (FindResult memory result) {
        string[] memory elements = _els;
        for (uint256 i; i < elements.length; ) {
            if (elements[i].equals(_search)) {
                return FindResult(i, true);
            }
            unchecked {
                ++i;
            }
        }
    }

    function pushUnique(address[] storage _els, address _toAdd) internal {
        if (!_els.find(_toAdd).exists) {
            _els.push(_toAdd);
        }
    }

    function pushUnique(bytes32[] storage _els, bytes32 _toAdd) internal {
        if (!_els.find(_toAdd).exists) {
            _els.push(_toAdd);
        }
    }

    function pushUnique(string[] storage _els, string memory _toAdd) internal {
        if (!_els.find(_toAdd).exists) {
            _els.push(_toAdd);
        }
    }

    function removeExisting(address[] storage _arr, address _toR) internal {
        FindResult memory result = _arr.find(_toR);
        if (result.exists) {
            _arr.removeAddress(_toR, result.index);
        }
    }

    function removeAddress(
        address[] storage _arr,
        address _toR,
        uint256 _idx
    ) internal {
        if (_arr[_idx] != _toR)
            revert ELEMENT_DOES_NOT_MATCH_PROVIDED_INDEX(id(_toR), _idx, _arr);

        uint256 lastIndex = _arr.length - 1;
        if (_idx != lastIndex) {
            _arr[_idx] = _arr[lastIndex];
        }

        _arr.pop();
    }

    function isEmpty(address[2] memory _arr) internal pure returns (bool) {
        return _arr[0] == address(0) && _arr[1] == address(0);
    }

    function isEmpty(string memory _val) internal pure returns (bool) {
        return bytes(_val).length == 0;
    }

    function equals(
        string memory _a,
        string memory _b
    ) internal pure returns (bool) {
        return
            keccak256(abi.encodePacked(_a)) == keccak256(abi.encodePacked(_b));
    }

    function str(address _val) internal pure returns (string memory) {
        return vm.toString(_val);
    }

    function str(uint256 _val) internal pure returns (string memory) {
        return vm.toString(_val);
    }

    function str(bytes32 _val) internal pure returns (string memory) {
        return vm.toString(_val);
    }

    function txt(bytes32 _val) internal pure returns (string memory) {
        return string(abi.encodePacked(_val));
    }

    function txt(bytes memory _val) internal pure returns (string memory) {
        return string(abi.encodePacked(_val));
    }

    function str(bytes memory _val) internal pure returns (string memory) {
        return vm.toString(_val);
    }

    function toAddr(string memory _val) internal pure returns (address) {
        return vm.parseAddress(_val);
    }

    function toUint(string memory _val) internal pure returns (uint256) {
        return vm.parseUint(_val);
    }

    function toB32(string memory _val) internal pure returns (bytes32) {
        return vm.parseBytes32(_val);
    }

    function toBytes(string memory _val) internal pure returns (bytes memory) {
        return vm.parseBytes(_val);
    }

    function and(
        string memory a,
        string memory b
    ) internal pure returns (string memory) {
        return string.concat(a, b);
    }

    function arr(address _v1) internal pure returns (address[] memory d_) {
        d_ = new address[](1);
        d_[0] = _v1;
    }

    function arr(
        address _v1,
        address _v2
    ) internal pure returns (address[] memory d_) {
        d_ = new address[](2);
        d_[0] = _v1;
        d_[1] = _v2;
    }

    function arr(
        address _v1,
        address _v2,
        address _v3
    ) internal pure returns (address[] memory d_) {
        d_ = new address[](3);
        d_[0] = _v1;
        d_[1] = _v2;
        d_[2] = _v3;
    }

    function arr(
        address _v1,
        address _v2,
        address _v3,
        address _v4
    ) internal pure returns (address[] memory d_) {
        d_ = new address[](4);
        d_[0] = _v1;
        d_[1] = _v2;
        d_[2] = _v3;
        d_[3] = _v4;
    }

    function arr(uint16 _value) internal pure returns (uint16[] memory d_) {
        d_ = new uint16[](1);
        d_[0] = _value;
    }

    function arr(
        uint16 _v1,
        uint16 _v2
    ) internal pure returns (uint16[] memory d_) {
        d_ = new uint16[](2);
        d_[0] = _v1;
        d_[1] = _v2;
    }

    function arr(
        uint16 _v1,
        uint16 _v2,
        uint16 _v3
    ) internal pure returns (uint16[] memory d_) {
        d_ = new uint16[](3);
        d_[0] = _v1;
        d_[1] = _v2;
        d_[2] = _v3;
    }

    function arr(uint32 _value) internal pure returns (uint32[] memory d_) {
        d_ = new uint32[](1);
        d_[0] = _value;
    }

    function arr(
        uint32 _v1,
        uint32 _v2
    ) internal pure returns (uint32[] memory d_) {
        d_ = new uint32[](2);
        d_[0] = _v1;
        d_[1] = _v2;
    }

    function arr(
        uint32 _v1,
        uint32 _v2,
        uint32 _v3
    ) internal pure returns (uint32[] memory d_) {
        d_ = new uint32[](3);
        d_[0] = _v1;
        d_[1] = _v2;
        d_[2] = _v3;
    }

    function arr(uint256 _value) internal pure returns (uint256[] memory d_) {
        d_ = new uint256[](1);
        d_[0] = _value;
    }

    function arr(
        uint256 _v1,
        uint256 _v2
    ) internal pure returns (uint256[] memory d_) {
        d_ = new uint256[](2);
        d_[0] = _v1;
        d_[1] = _v2;
    }

    function arr(
        uint256 _v1,
        uint256 _v2,
        uint256 _v3
    ) internal pure returns (uint256[] memory d_) {
        d_ = new uint256[](3);
        d_[0] = _v1;
        d_[1] = _v2;
        d_[2] = _v3;
    }

    function arr(
        uint256 _v1,
        uint256 _v2,
        uint256 _v3,
        uint256 _v4
    ) internal pure returns (uint256[] memory d_) {
        d_ = new uint256[](4);
        d_[0] = _v1;
        d_[1] = _v2;
        d_[2] = _v3;
        d_[3] = _v4;
    }

    function arr(
        uint256 _v1,
        uint256 _v2,
        uint256 _v3,
        uint256 _v4,
        uint256 _v5
    ) internal pure returns (uint256[] memory d_) {
        d_ = new uint256[](5);
        d_[0] = _v1;
        d_[1] = _v2;
        d_[2] = _v3;
        d_[3] = _v4;
        d_[4] = _v5;
    }

    function dyn(
        address[1] memory _f
    ) internal pure returns (address[] memory d_) {
        d_ = new address[](1);
        d_[0] = _f[0];
        return d_;
    }

    function dyn(
        address[2] memory _f
    ) internal pure returns (address[] memory d_) {
        d_ = new address[](2);
        d_[0] = _f[0];
        d_[1] = _f[1];
        return d_;
    }

    function dyn(
        address[3] memory _f
    ) internal pure returns (address[] memory d_) {
        d_ = new address[](3);
        d_[0] = _f[0];
        d_[1] = _f[1];
        d_[2] = _f[2];
        return d_;
    }

    function dyn(
        address[4] memory _f
    ) internal pure returns (address[] memory d_) {
        d_ = new address[](4);
        d_[0] = _f[0];
        d_[1] = _f[1];
        d_[2] = _f[2];
        d_[3] = _f[3];
        return d_;
    }

    function dyn(
        address[5] memory _f
    ) internal pure returns (address[] memory d_) {
        d_ = new address[](5);
        d_[0] = _f[0];
        d_[1] = _f[1];
        d_[2] = _f[2];
        d_[3] = _f[3];
        d_[4] = _f[4];
        return d_;
    }

    function dyn(
        address[6] memory _f
    ) internal pure returns (address[] memory d_) {
        d_ = new address[](6);
        d_[0] = _f[0];
        d_[1] = _f[1];
        d_[2] = _f[2];
        d_[3] = _f[3];
        d_[4] = _f[4];
        d_[5] = _f[5];
        return d_;
    }

    function dyn(uint8[1] memory _f) internal pure returns (uint8[] memory d_) {
        d_ = new uint8[](1);
        d_[0] = _f[0];
        return d_;
    }

    function dyn(uint8[2] memory _f) internal pure returns (uint8[] memory d_) {
        d_ = new uint8[](2);
        d_[0] = _f[0];
        d_[1] = _f[1];
        return d_;
    }

    function dyn256(
        uint8[2] memory _f
    ) internal pure returns (uint256[] memory d_) {
        d_ = new uint256[](2);
        d_[0] = _f[0];
        d_[1] = _f[1];
        return d_;
    }

    function arr(
        uint8 _v1,
        uint8 _v2
    ) internal pure returns (uint8[] memory d_) {
        d_ = new uint8[](2);
        d_[0] = _v1;
        d_[1] = _v2;
    }

    function arr256(
        uint8 _v1,
        uint8 _v2
    ) internal pure returns (uint256[] memory d_) {
        d_ = new uint256[](2);
        d_[0] = _v1;
        d_[1] = _v2;
    }

    function fix(uint8[] memory _f) internal pure returns (uint8[2] memory) {
        require(_f.length >= 2, "Invalid length");
        return [_f[0], _f[1]];
    }

    function flip(uint8[2] memory _f) internal pure returns (uint8[2] memory) {
        return [_f[1], _f[0]];
    }

    function dyn(
        uint16[1] memory _f
    ) internal pure returns (uint16[] memory d_) {
        d_ = new uint16[](1);
        d_[0] = _f[0];
        return d_;
    }

    function dyn(
        uint16[2] memory _f
    ) internal pure returns (uint16[] memory d_) {
        d_ = new uint16[](2);
        d_[0] = _f[0];
        d_[1] = _f[1];
        return d_;
    }

    function dyn(
        uint16[3] memory _f
    ) internal pure returns (uint16[] memory d_) {
        d_ = new uint16[](3);
        d_[0] = _f[0];
        d_[1] = _f[1];
        d_[2] = _f[2];
        return d_;
    }

    function dyn(
        uint16[4] memory _f
    ) internal pure returns (uint16[] memory d_) {
        d_ = new uint16[](4);
        d_[0] = _f[0];
        d_[1] = _f[1];
        d_[2] = _f[2];
        d_[3] = _f[3];
        return d_;
    }

    function dyn(
        uint32[1] memory _f
    ) internal pure returns (uint32[] memory d_) {
        d_ = new uint32[](1);
        d_[0] = _f[0];
        return d_;
    }

    function dyn(
        uint32[2] memory _f
    ) internal pure returns (uint32[] memory d_) {
        d_ = new uint32[](2);
        d_[0] = _f[0];
        d_[1] = _f[1];
        return d_;
    }

    function dyn(
        uint32[3] memory _f
    ) internal pure returns (uint32[] memory d_) {
        d_ = new uint32[](3);
        d_[0] = _f[0];
        d_[1] = _f[1];
        d_[2] = _f[2];
        return d_;
    }

    function dyn(
        uint32[4] memory _f
    ) internal pure returns (uint32[] memory d_) {
        d_ = new uint32[](4);
        d_[0] = _f[0];
        d_[1] = _f[1];
        d_[2] = _f[2];
        d_[3] = _f[3];
        return d_;
    }

    function dyn(
        uint32[5] memory _f
    ) internal pure returns (uint32[] memory d_) {
        d_ = new uint32[](5);
        d_[0] = _f[0];
        d_[1] = _f[1];
        d_[2] = _f[2];
        d_[3] = _f[3];
        d_[4] = _f[4];
        return d_;
    }

    function dyn(
        uint32[6] memory _f
    ) internal pure returns (uint32[] memory d_) {
        d_ = new uint32[](6);
        d_[0] = _f[0];
        d_[1] = _f[1];
        d_[2] = _f[2];
        d_[3] = _f[3];
        d_[4] = _f[4];
        d_[5] = _f[5];
        return d_;
    }

    function dyn(
        uint256[1] memory _f
    ) internal pure returns (uint256[] memory d_) {
        d_ = new uint256[](1);
        d_[0] = _f[0];
        return d_;
    }

    function dyn(
        uint256[2] memory _f
    ) internal pure returns (uint256[] memory d_) {
        d_ = new uint256[](2);
        d_[0] = _f[0];
        d_[1] = _f[1];
        return d_;
    }

    function dyn(
        uint256[3] memory _f
    ) internal pure returns (uint256[] memory d_) {
        d_ = new uint256[](3);
        d_[0] = _f[0];
        d_[1] = _f[1];
        d_[2] = _f[2];
        return d_;
    }

    function dyn(
        uint256[4] memory _f
    ) internal pure returns (uint256[] memory d_) {
        d_ = new uint256[](4);
        d_[0] = _f[0];
        d_[1] = _f[1];
        d_[2] = _f[2];
        d_[3] = _f[3];
        return d_;
    }

    function dyn(
        uint256[5] memory _f
    ) internal pure returns (uint256[] memory d_) {
        d_ = new uint256[](5);
        d_[0] = _f[0];
        d_[1] = _f[1];
        d_[2] = _f[2];
        d_[3] = _f[3];
        d_[4] = _f[4];
        return d_;
    }

    function dyn(
        uint256[6] memory _f
    ) internal pure returns (uint256[] memory d_) {
        d_ = new uint256[](6);
        d_[0] = _f[0];
        d_[1] = _f[1];
        d_[2] = _f[2];
        d_[3] = _f[3];
        d_[4] = _f[4];
        d_[5] = _f[5];
        return d_;
    }

    function dyn(
        uint256[7] memory _f
    ) internal pure returns (uint256[] memory d_) {
        d_ = new uint256[](7);
        d_[0] = _f[0];
        d_[1] = _f[1];
        d_[2] = _f[2];
        d_[3] = _f[3];
        d_[4] = _f[4];
        d_[5] = _f[5];
        d_[6] = _f[6];
        return d_;
    }

    uint256 internal constant PERCENTAGE_FACTOR = 1e4;
    uint256 internal constant HALF_PERCENTAGE_FACTOR = 0.5e4;

    function pctMul(
        uint256 value,
        uint256 percentage
    ) internal pure returns (uint256 result) {
        assembly {
            if iszero(
                or(
                    iszero(percentage),
                    iszero(
                        gt(
                            value,
                            div(sub(not(0), HALF_PERCENTAGE_FACTOR), percentage)
                        )
                    )
                )
            ) {
                revert(0, 0)
            }

            result := div(
                add(mul(value, percentage), HALF_PERCENTAGE_FACTOR),
                PERCENTAGE_FACTOR
            )
        }
    }

    function pctDiv(
        uint256 value,
        uint256 percentage
    ) internal pure returns (uint256 result) {
        assembly {
            if or(
                iszero(percentage),
                iszero(
                    iszero(
                        gt(
                            value,
                            div(
                                sub(not(0), div(percentage, 2)),
                                PERCENTAGE_FACTOR
                            )
                        )
                    )
                )
            ) {
                revert(0, 0)
            }

            result := div(
                add(mul(value, PERCENTAGE_FACTOR), div(percentage, 2)),
                percentage
            )
        }
    }

    // HALF_WAD and HALF_RAY expressed with extended notation
    // as constant with operations are not supported in Yul assembly
    uint256 internal constant WAD = 1e18;
    uint256 internal constant HALF_WAD = 0.5e18;

    uint256 internal constant RAY = 1e27;
    uint256 internal constant HALF_RAY = 0.5e27;

    uint256 internal constant WAD_RAY_RATIO = 1e9;

    function mulWad(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // to avoid overflow, a <= (type(uint256).max - HALF_WAD) / b
        assembly {
            if iszero(
                or(iszero(b), iszero(gt(a, div(sub(not(0), HALF_WAD), b))))
            ) {
                revert(0, 0)
            }

            c := div(add(mul(a, b), HALF_WAD), WAD)
        }
    }

    function divWad(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // to avoid overflow, a <= (type(uint256).max - halfB) / WAD
        assembly {
            if or(
                iszero(b),
                iszero(iszero(gt(a, div(sub(not(0), div(b, 2)), WAD))))
            ) {
                revert(0, 0)
            }

            c := div(add(mul(a, WAD), div(b, 2)), b)
        }
    }

    function mulRay(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // to avoid overflow, a <= (type(uint256).max - HALF_RAY) / b
        assembly {
            if iszero(
                or(iszero(b), iszero(gt(a, div(sub(not(0), HALF_RAY), b))))
            ) {
                revert(0, 0)
            }

            c := div(add(mul(a, b), HALF_RAY), RAY)
        }
    }

    function divRay(uint256 a, uint256 b) internal pure returns (uint256 c) {
        // to avoid overflow, a <= (type(uint256).max - halfB) / RAY
        assembly {
            if or(
                iszero(b),
                iszero(iszero(gt(a, div(sub(not(0), div(b, 2)), RAY))))
            ) {
                revert(0, 0)
            }

            c := div(add(mul(a, RAY), div(b, 2)), b)
        }
    }

    function fromRayToWad(uint256 a) internal pure returns (uint256 b) {
        assembly {
            b := div(a, WAD_RAY_RATIO)
            let remainder := mod(a, WAD_RAY_RATIO)
            if iszero(lt(remainder, div(WAD_RAY_RATIO, 2))) {
                b := add(b, 1)
            }
        }
    }

    function fromWadToRay(uint256 a) internal pure returns (uint256 b) {
        // to avoid overflow, b/WAD_RAY_RATIO == a
        assembly {
            b := mul(a, WAD_RAY_RATIO)

            if iszero(eq(div(b, WAD_RAY_RATIO), a)) {
                revert(0, 0)
            }
        }
    }
}

library Log {
    Vm constant vm = VM;
    event log(string);
    event logs(bytes);

    event log_address(address);
    event log_bytes32(bytes32);
    event log_int(int256);
    event log_uint(uint256);
    event log_bytes(bytes);
    event log_string(string);

    event log_named_address(string key, address val);
    event log_named_bytes32(string key, bytes32 val);
    event log_named_decimal_int(string key, int256 val, uint256 decimals);
    event log_named_decimal_uint(string key, uint256 val, uint256 decimals);
    event log_named_int(string key, int256 val);
    event log_named_uint(string key, uint256 val);
    event log_named_bytes(string key, bytes val);
    event log_named_string(string key, string val);

    event log_array(uint256[] val);
    event log_array(int256[] val);
    event log_array(address[] val);
    event log_named_array(string key, uint256[] val);
    event log_named_array(string key, int256[] val);
    event log_named_array(string key, address[] val);
    using Help for bytes32;
    using Help for string;
    using Help for address;
    using Help for bytes;
    using Help for uint256[2];
    using Help for uint8[2];
    using Help for uint32[2];
    using Help for uint16[2];

    function prefix(string memory _prefix) internal {
        store().logPrefix = _prefix;
    }

    function _hasPrefix() internal view returns (bool) {
        return !store().logPrefix.isEmpty();
    }

    function _pre(string memory _str) internal view returns (string memory) {
        if (_hasPrefix()) {
            return store().logPrefix.and(_str);
        } else {
            return _str;
        }
    }

    function hr() internal {
        emit log("--------------------------------------------------");
    }

    function br() internal {
        emit log("");
    }

    function n() internal {
        emit log("\n");
    }

    function sr() internal {
        emit log("**************************************************");
    }

    function log_bool(bool _val) internal {
        emit log_string(_pre(_val ? "true" : "false"));
    }

    function log_named_bool(string memory _str, bool _val) internal {
        emit log_named_string(_pre(_str), _val ? "true" : "false");
    }

    function log_pct(uint256 _val) internal {
        emit log_named_decimal_uint(_pre(""), _val, 2);
    }

    function log_pct(uint256 _val, string memory _str) internal {
        emit log_named_decimal_uint(_pre(_str), _val, 2);
    }

    function log_decimal_balance(address _account, address _token) internal {
        emit log_named_decimal_uint(
            _pre(vm.toString(_account).and(IERC20(_token).symbol())),
            IERC20(_token).balanceOf(_account),
            IERC20(_token).decimals()
        );
    }

    function log_decimal_balances(
        address _account,
        address[] memory _tokens
    ) internal {
        for (uint256 i; i < _tokens.length; i++) {
            emit log_named_decimal_uint(
                _pre(vm.toString(_account).and(IERC20(_tokens[i]).symbol())),
                IERC20(_tokens[i]).balanceOf(_account),
                IERC20(_tokens[i]).decimals()
            );
        }
    }

    function clg(address _val) internal check {
        if (!_hasPrefix()) {
            emit log_address(_val);
        } else {
            emit log_named_address(_pre(""), _val);
        }
    }

    function blg(bytes32 _val) internal check {
        if (!_hasPrefix()) {
            emit log_bytes32(_val);
        } else {
            emit log_named_bytes32(_pre(""), _val);
        }
    }

    function clg(int256 _val) internal check {
        if (!_hasPrefix()) {
            emit log_int(_val);
        } else {
            emit log_named_int(_pre(""), _val);
        }
    }

    function clg(uint256 _val) internal check {
        if (!_hasPrefix()) {
            emit log_uint(_val);
        } else {
            emit log_named_uint(_pre(""), _val);
        }
    }

    function blg(bytes memory _val) internal check {
        if (!_hasPrefix()) {
            emit log_bytes(_val);
        } else {
            emit log_named_bytes(_pre(""), _val);
        }
    }

    function pct(uint256 _val, string memory _str) internal check {
        emit log_named_decimal_uint(_pre(_str), _val, 2);
    }

    function pct(string memory _str, uint256 _val) internal check {
        emit log_named_decimal_uint(_pre(_str), _val, 2);
    }

    function dlg(int256 _val, string memory _str) internal check {
        emit log_named_decimal_int(_pre(_str), _val, 18);
    }

    function dlg(int256 _val, string memory _str, uint256 dec) internal check {
        emit log_named_decimal_int(_pre(_str), _val, dec);
    }

    function dlg(string memory _str, int256 _val) internal check {
        emit log_named_decimal_int(_pre(_str), _val, 18);
    }

    function dlg(string memory _str, uint256 _val) internal check {
        emit log_named_decimal_uint(_pre(_str), _val, 18);
    }

    function dlg(string memory _str, int256 _val, uint256 dec) internal check {
        emit log_named_decimal_int(_pre(_str), _val, dec);
    }

    function dlg(string memory _str, uint256 _val, uint256 dec) internal check {
        emit log_named_decimal_uint(_pre(_str), _val, dec);
    }

    function dlg(uint256 _val, string memory _str) internal check {
        emit log_named_decimal_uint(_pre(_str), _val, 18);
    }

    function dlg(uint256 _val, string memory _str, uint256 dec) internal check {
        emit log_named_decimal_uint(_pre(_str), _val, dec);
    }

    function clg(string memory _str, uint256 _val) internal check {
        emit log_named_uint(_pre(_str), _val);
    }

    function clg(uint256 _val, string memory _str) internal check {
        emit log_named_uint(_pre(_str), _val);
    }

    function clg(string memory _str, int256 _val) internal check {
        emit log_named_int(_pre(_str), _val);
    }

    function clg(int256 _val, string memory _str) internal check {
        emit log_named_int(_pre(_str), _val);
    }

    function clg(string memory _val) internal check {
        emit log_string(_pre(_val));
    }

    function clg(string memory _val, string memory _lbl) internal check {
        emit log_named_string(_pre(_lbl), _val);
    }

    function clg(string memory _lbl, address _val) internal check {
        emit log_named_address(_pre(_lbl), _val);
    }

    function clg(string memory _lbl, uint256[] memory _val) internal check {
        emit log_named_array(_pre(_lbl), _val);
    }

    function clg(string memory _lbl, int256[] memory _val) internal check {
        emit log_named_array(_pre(_lbl), _val);
    }

    function blg(string memory _lbl, bytes memory _val) internal check {
        emit log_named_bytes(_pre(_lbl), _val);
    }

    function clg(string memory _lbl, uint8[2] memory _val) internal check {
        emit log_named_array(_pre(_lbl), _val.dyn256());
    }

    function clg(string memory _lbl, uint8 _val1, uint8 _val2) internal check {
        emit log_named_array(_pre(_lbl), [_val1, _val2].dyn256());
    }

    function clg(string memory _lbl, uint256[2] memory _val) internal check {
        emit log_named_array(_pre(_lbl), _val.dyn());
    }

    function blg(string memory _lbl, bytes32 _val) internal check {
        emit log_named_bytes32(_pre(_lbl), _val);
    }

    function blg2txt(string memory _lbl, bytes32 _val) internal check {
        emit log_named_string(_pre(_lbl), _val.txt());
    }

    function blg2str(string memory _lbl, bytes memory _val) internal check {
        emit log_named_string(_pre(_lbl), _val.str());
    }

    function blg2txt(string memory _lbl, bytes memory _val) internal check {
        emit log_named_string(_pre(_lbl), _val.txt());
    }

    function blg2str(bytes32 _val, string memory _lbl) internal check {
        emit log_named_string(_pre(_lbl), _val.str());
    }

    function blg2txt(bytes32 _val, string memory _lbl) internal check {
        emit log_named_string(_pre(_lbl), _val.txt());
    }

    function blg2str(bytes memory _val, string memory _lbl) internal check {
        emit log_named_string(_pre(_lbl), _val.str());
    }

    function blg2txt(bytes memory _val, string memory _lbl) internal check {
        emit log_named_string(_pre(_lbl), _val.txt());
    }

    function clg2bytes(string memory _val, string memory _lbl) internal check {
        emit log_named_bytes(_pre(_lbl), bytes(_val));
    }

    function clg2str(address _val, string memory _lbl) internal check {
        emit log_named_string(_pre(_lbl), _val.str());
    }

    function clg2str(string memory _lbl, address _val) internal check {
        emit log_named_string(_pre(_lbl), _val.str());
    }

    function clg(address[] memory _val, string memory _str) internal check {
        emit log_named_array(_pre(_str), _val);
    }

    function clg(address _val, string memory _str) internal check {
        emit log_named_address(_pre(_str), _val);
    }

    function clg(bool _val, string memory _str) internal {
        log_named_bool(_pre(_str), _val);
    }

    function clg(bool _val) internal {
        log_bool(_val);
    }

    function clg(address[] memory _val) internal check {
        emit log_array(_val);
    }

    function clg(uint256[] memory _val) internal check {
        if (!_hasPrefix()) {
            emit log_array(_val);
        } else {
            emit log_named_array(_pre(""), _val);
        }
    }

    function clg(int256[] memory _val) internal check {
        if (!_hasPrefix()) {
            emit log_array(_val);
        } else {
            emit log_named_array(_pre(""), _val);
        }
    }

    function clg(uint256[] memory _val, string memory _str) internal check {
        emit log_named_array(_pre(_str), _val);
    }

    function clg(int256[] memory _val, string memory _str) internal check {
        emit log_named_array(_pre(_str), _val);
    }

    function blg(bytes32 _val, string memory _str) internal check {
        emit log_named_bytes32(_pre(_str), _val);
    }

    function blg(bytes memory _val, string memory _str) internal check {
        emit log_named_bytes(_pre(_str), _val);
    }

    function clg(uint256[2] memory _val, string memory _lbl) internal check {
        emit log_named_array(_pre(_lbl), _val.dyn());
    }

    function clg(uint8[2] memory _val, string memory _lbl) internal check {
        emit log_named_array(_pre(_lbl), _val.dyn256());
    }

    function clg(uint8 _val1, uint8 _val2, string memory _lbl) internal check {
        emit log_named_array(_pre(_lbl), [_val1, _val2].dyn256());
    }

    function clg(
        string memory _lbl,
        string memory _mnemonicId,
        uint32[] memory _indexes
    ) internal check {
        address[] memory _tmp = new address[](_indexes.length);
        for (uint256 i; i < _indexes.length; i++) {
            _tmp[i] = vm.rememberKey(
                vm.deriveKey(vm.envString(_mnemonicId), _indexes[i])
            );
        }
        emit log_named_array(_pre(_lbl), _tmp);
    }

    function clg(
        uint32[] memory _indexes,
        string memory _mnemonicId,
        string memory _lbl
    ) internal check {
        address[] memory _tmp = new address[](_indexes.length);
        for (uint256 i; i < _indexes.length; i++) {
            _tmp[i] = vm.rememberKey(
                vm.deriveKey(vm.envString(_mnemonicId), _indexes[i])
            );
        }
        emit log_named_array(_pre(_lbl), _tmp);
    }

    function clgBal(address _account, address[] memory _tokens) internal {
        log_decimal_balances(_account, _tokens);
    }

    function clgBal(address _account, address _token) internal {
        log_decimal_balance(_account, _token);
    }

    function logCallers() internal check {
        LibVm.Callers memory current = LibVm.callers();
        emit log_named_string(
            "isHEVM",
            LibVm.hasHEVMContext() ? "true" : "false"
        );

        emit log_named_address("msg.sender", current.msgSender);
        emit log_named_address("tx.origin", current.txOrigin);
        emit log_named_string("mode", current.mode);
    }

    function disable() internal {
        store().logDisabled = true;
    }

    function enable() internal {
        store().logDisabled = false;
    }

    modifier check() {
        if (store().logDisabled) return;
        _;
    }
}
