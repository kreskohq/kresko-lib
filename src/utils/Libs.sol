// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {Vm, VmSafe} from "forge-std/Vm.sol";
import {console2} from "forge-std/Console2.sol";
import {IERC20} from "../token/IERC20.sol";
import {Stash} from "./Stash.s.sol";

Vm constant VM = Vm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

struct Store {
    bool _failed;
    bool logDisabled;
    string logPrefix;
    Stash.Data stash;
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
        address[] storage _elements,
        address _elementToFind
    ) internal pure returns (FindResult memory result) {
        address[] memory elements = _elements;
        for (uint256 i; i < elements.length; ) {
            if (elements[i] == _elementToFind) {
                return FindResult(i, true);
            }
            unchecked {
                ++i;
            }
        }
    }

    function find(
        bytes32[] storage _elements,
        bytes32 _elementToFind
    ) internal pure returns (FindResult memory result) {
        bytes32[] memory elements = _elements;
        for (uint256 i; i < elements.length; ) {
            if (elements[i] == _elementToFind) {
                return FindResult(i, true);
            }
            unchecked {
                ++i;
            }
        }
    }

    function find(
        string[] storage _elements,
        string memory _elementToFind
    ) internal pure returns (FindResult memory result) {
        string[] memory elements = _elements;
        for (uint256 i; i < elements.length; ) {
            if (elements[i].equals(_elementToFind)) {
                return FindResult(i, true);
            }
            unchecked {
                ++i;
            }
        }
    }

    function pushUnique(
        address[] storage _elements,
        address _elementToAdd
    ) internal {
        if (!_elements.find(_elementToAdd).exists) {
            _elements.push(_elementToAdd);
        }
    }

    function pushUnique(
        bytes32[] storage _elements,
        bytes32 _elementToAdd
    ) internal {
        if (!_elements.find(_elementToAdd).exists) {
            _elements.push(_elementToAdd);
        }
    }

    function pushUnique(
        string[] storage _elements,
        string memory _elementToAdd
    ) internal {
        if (!_elements.find(_elementToAdd).exists) {
            _elements.push(_elementToAdd);
        }
    }

    function removeExisting(
        address[] storage _addresses,
        address _elementToRemove
    ) internal {
        FindResult memory result = _addresses.find(_elementToRemove);
        if (result.exists) {
            _addresses.removeAddress(_elementToRemove, result.index);
        }
    }

    /**
     * @dev Removes an element by copying the last element to the element to remove's place and removing
     * the last element.
     * @param _addresses The address array containing the item to be removed.
     * @param _elementToRemove The element to be removed.
     * @param _elementIndex The index of the element to be removed.
     */
    function removeAddress(
        address[] storage _addresses,
        address _elementToRemove,
        uint256 _elementIndex
    ) internal {
        if (_addresses[_elementIndex] != _elementToRemove)
            revert ELEMENT_DOES_NOT_MATCH_PROVIDED_INDEX(
                id(_elementToRemove),
                _elementIndex,
                _addresses
            );

        uint256 lastIndex = _addresses.length - 1;
        // If the index to remove is not the last one, overwrite the element at the index
        // with the last element.
        if (_elementIndex != lastIndex) {
            _addresses[_elementIndex] = _addresses[lastIndex];
        }
        // Remove the last element.
        _addresses.pop();
    }

    function isEmpty(
        address[2] memory _addresses
    ) internal pure returns (bool) {
        return _addresses[0] == address(0) && _addresses[1] == address(0);
    }

    function isEmpty(address[] memory _addresses) internal pure returns (bool) {
        return _addresses.length == 0;
    }

    function isEmpty(bytes32[] memory _bytes32s) internal pure returns (bool) {
        return _bytes32s.length == 0;
    }

    function isEmpty(string[] memory _strings) internal pure returns (bool) {
        return _strings.length == 0;
    }

    function isEmpty(string memory _str) internal pure returns (bool) {
        return bytes(_str).length == 0;
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

    function addr(string memory _val) internal pure returns (address) {
        return vm.parseAddress(_val);
    }

    function num(string memory _val) internal pure returns (uint256) {
        return vm.parseUint(_val);
    }

    function b32(string memory _val) internal pure returns (bytes32) {
        return vm.parseBytes32(_val);
    }

    function toBytes(string memory _val) internal pure returns (bytes memory) {
        return vm.parseBytes(_val);
    }

    function boolean(string memory _val) internal pure returns (bool) {
        return vm.parseBool(_val);
    }

    function and(
        string memory a,
        string memory b
    ) internal pure returns (string memory) {
        return string.concat(a, b);
    }

    function write(
        address[] storage _arr,
        address[] memory _val
    ) internal returns (address[] storage) {
        for (uint256 i; i < _val.length; i++) {
            _arr.push(_val[i]);
        }
        return _arr;
    }

    function write(
        uint256[] storage _arr,
        uint256[] memory _val
    ) internal returns (uint256[] storage) {
        for (uint256 i; i < _val.length; i++) {
            _arr.push(_val[i]);
        }
        return _arr;
    }

    function toArray(
        address _value1
    ) internal pure returns (address[] memory dynamic_) {
        dynamic_ = new address[](1);
        dynamic_[0] = _value1;
    }

    function toArray(
        address _value1,
        address _value2
    ) internal pure returns (address[] memory dynamic_) {
        dynamic_ = new address[](2);
        dynamic_[0] = _value1;
        dynamic_[1] = _value2;
    }

    function toArray(
        address _value1,
        address _value2,
        address _value3
    ) internal pure returns (address[] memory dynamic_) {
        dynamic_ = new address[](3);
        dynamic_[0] = _value1;
        dynamic_[1] = _value2;
        dynamic_[2] = _value3;
    }

    function toArray(
        address _value1,
        address _value2,
        address _value3,
        address _value4
    ) internal pure returns (address[] memory dynamic_) {
        dynamic_ = new address[](4);
        dynamic_[0] = _value1;
        dynamic_[1] = _value2;
        dynamic_[2] = _value3;
        dynamic_[3] = _value4;
    }

    function toArray(
        uint16 _value
    ) internal pure returns (uint16[] memory dynamic_) {
        dynamic_ = new uint16[](1);
        dynamic_[0] = _value;
    }

    function toArray(
        uint16 _value1,
        uint16 _value2
    ) internal pure returns (uint16[] memory dynamic_) {
        dynamic_ = new uint16[](2);
        dynamic_[0] = _value1;
        dynamic_[1] = _value2;
    }

    function toArray(
        uint16 _value1,
        uint16 _value2,
        uint16 _value3
    ) internal pure returns (uint16[] memory dynamic_) {
        dynamic_ = new uint16[](3);
        dynamic_[0] = _value1;
        dynamic_[1] = _value2;
        dynamic_[2] = _value3;
    }

    function toArray(
        uint32 _value
    ) internal pure returns (uint32[] memory dynamic_) {
        dynamic_ = new uint32[](1);
        dynamic_[0] = _value;
    }

    function toArray(
        uint32 _value1,
        uint32 _value2
    ) internal pure returns (uint32[] memory dynamic_) {
        dynamic_ = new uint32[](2);
        dynamic_[0] = _value1;
        dynamic_[1] = _value2;
    }

    function toArray(
        uint32 _value1,
        uint32 _value2,
        uint32 _value3
    ) internal pure returns (uint32[] memory dynamic_) {
        dynamic_ = new uint32[](3);
        dynamic_[0] = _value1;
        dynamic_[1] = _value2;
        dynamic_[2] = _value3;
    }

    function toArray(
        uint256 _value
    ) internal pure returns (uint256[] memory dynamic_) {
        dynamic_ = new uint256[](1);
        dynamic_[0] = _value;
    }

    function toArray(
        uint256 _value1,
        uint256 _value2
    ) internal pure returns (uint256[] memory dynamic_) {
        dynamic_ = new uint256[](2);
        dynamic_[0] = _value1;
        dynamic_[1] = _value2;
    }

    function toArray(
        uint256 _value1,
        uint256 _value2,
        uint256 _value3
    ) internal pure returns (uint256[] memory dynamic_) {
        dynamic_ = new uint256[](3);
        dynamic_[0] = _value1;
        dynamic_[1] = _value2;
        dynamic_[2] = _value3;
    }

    function toArray(
        uint256 _value1,
        uint256 _value2,
        uint256 _value3,
        uint256 _value4
    ) internal pure returns (uint256[] memory dynamic_) {
        dynamic_ = new uint256[](4);
        dynamic_[0] = _value1;
        dynamic_[1] = _value2;
        dynamic_[2] = _value3;
        dynamic_[3] = _value4;
    }

    function toArray(
        uint256 _value1,
        uint256 _value2,
        uint256 _value3,
        uint256 _value4,
        uint256 _value5
    ) internal pure returns (uint256[] memory dynamic_) {
        dynamic_ = new uint256[](5);
        dynamic_[0] = _value1;
        dynamic_[1] = _value2;
        dynamic_[2] = _value3;
        dynamic_[3] = _value4;
        dynamic_[4] = _value5;
    }

    function dyn(
        address[1] memory _fixed
    ) internal pure returns (address[] memory dynamic_) {
        dynamic_ = new address[](1);
        dynamic_[0] = _fixed[0];
        return dynamic_;
    }

    function dyn(
        address[2] memory _fixed
    ) internal pure returns (address[] memory dynamic_) {
        dynamic_ = new address[](2);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        return dynamic_;
    }

    function dyn(
        address[3] memory _fixed
    ) internal pure returns (address[] memory dynamic_) {
        dynamic_ = new address[](3);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        dynamic_[2] = _fixed[2];
        return dynamic_;
    }

    function dyn(
        address[4] memory _fixed
    ) internal pure returns (address[] memory dynamic_) {
        dynamic_ = new address[](4);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        dynamic_[2] = _fixed[2];
        dynamic_[3] = _fixed[3];
        return dynamic_;
    }

    function dyn(
        address[5] memory _fixed
    ) internal pure returns (address[] memory dynamic_) {
        dynamic_ = new address[](5);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        dynamic_[2] = _fixed[2];
        dynamic_[3] = _fixed[3];
        dynamic_[4] = _fixed[4];
        return dynamic_;
    }

    function dyn(
        address[6] memory _fixed
    ) internal pure returns (address[] memory dynamic_) {
        dynamic_ = new address[](6);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        dynamic_[2] = _fixed[2];
        dynamic_[3] = _fixed[3];
        dynamic_[4] = _fixed[4];
        dynamic_[5] = _fixed[5];
        return dynamic_;
    }

    function dyn(
        uint16[1] memory _fixed
    ) internal pure returns (uint16[] memory dynamic_) {
        dynamic_ = new uint16[](1);
        dynamic_[0] = _fixed[0];
        return dynamic_;
    }

    function dyn(
        uint16[2] memory _fixed
    ) internal pure returns (uint16[] memory dynamic_) {
        dynamic_ = new uint16[](2);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        return dynamic_;
    }

    function dyn(
        uint16[3] memory _fixed
    ) internal pure returns (uint16[] memory dynamic_) {
        dynamic_ = new uint16[](3);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        dynamic_[2] = _fixed[2];
        return dynamic_;
    }

    function dyn(
        uint16[4] memory _fixed
    ) internal pure returns (uint16[] memory dynamic_) {
        dynamic_ = new uint16[](4);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        dynamic_[2] = _fixed[2];
        dynamic_[3] = _fixed[3];
        return dynamic_;
    }

    function dyn(
        uint32[1] memory _fixed
    ) internal pure returns (uint32[] memory dynamic_) {
        dynamic_ = new uint32[](1);
        dynamic_[0] = _fixed[0];
        return dynamic_;
    }

    function dyn(
        uint32[2] memory _fixed
    ) internal pure returns (uint32[] memory dynamic_) {
        dynamic_ = new uint32[](2);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        return dynamic_;
    }

    function dyn(
        uint32[3] memory _fixed
    ) internal pure returns (uint32[] memory dynamic_) {
        dynamic_ = new uint32[](3);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        dynamic_[2] = _fixed[2];
        return dynamic_;
    }

    function dyn(
        uint32[4] memory _fixed
    ) internal pure returns (uint32[] memory dynamic_) {
        dynamic_ = new uint32[](4);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        dynamic_[2] = _fixed[2];
        dynamic_[3] = _fixed[3];
        return dynamic_;
    }

    function dyn(
        uint32[5] memory _fixed
    ) internal pure returns (uint32[] memory dynamic_) {
        dynamic_ = new uint32[](5);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        dynamic_[2] = _fixed[2];
        dynamic_[3] = _fixed[3];
        dynamic_[4] = _fixed[4];
        return dynamic_;
    }

    function dyn(
        uint32[6] memory _fixed
    ) internal pure returns (uint32[] memory dynamic_) {
        dynamic_ = new uint32[](6);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        dynamic_[2] = _fixed[2];
        dynamic_[3] = _fixed[3];
        dynamic_[4] = _fixed[4];
        dynamic_[5] = _fixed[5];
        return dynamic_;
    }

    function dyn(
        uint256[1] memory _fixed
    ) internal pure returns (uint256[] memory dynamic_) {
        dynamic_ = new uint256[](1);
        dynamic_[0] = _fixed[0];
        return dynamic_;
    }

    function dyn(
        uint256[2] memory _fixed
    ) internal pure returns (uint256[] memory dynamic_) {
        dynamic_ = new uint256[](2);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        return dynamic_;
    }

    function dyn(
        uint256[3] memory _fixed
    ) internal pure returns (uint256[] memory dynamic_) {
        dynamic_ = new uint256[](3);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        dynamic_[2] = _fixed[2];
        return dynamic_;
    }

    function dyn(
        uint256[4] memory _fixed
    ) internal pure returns (uint256[] memory dynamic_) {
        dynamic_ = new uint256[](4);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        dynamic_[2] = _fixed[2];
        dynamic_[3] = _fixed[3];
        return dynamic_;
    }

    function dyn(
        uint256[5] memory _fixed
    ) internal pure returns (uint256[] memory dynamic_) {
        dynamic_ = new uint256[](5);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        dynamic_[2] = _fixed[2];
        dynamic_[3] = _fixed[3];
        dynamic_[4] = _fixed[4];
        return dynamic_;
    }

    function dyn(
        uint256[6] memory _fixed
    ) internal pure returns (uint256[] memory dynamic_) {
        dynamic_ = new uint256[](6);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        dynamic_[2] = _fixed[2];
        dynamic_[3] = _fixed[3];
        dynamic_[4] = _fixed[4];
        dynamic_[5] = _fixed[5];
        return dynamic_;
    }

    function dyn(
        uint256[7] memory _fixed
    ) internal pure returns (uint256[] memory dynamic_) {
        dynamic_ = new uint256[](7);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        dynamic_[2] = _fixed[2];
        dynamic_[3] = _fixed[3];
        dynamic_[4] = _fixed[4];
        dynamic_[5] = _fixed[5];
        dynamic_[6] = _fixed[6];
        return dynamic_;
    }

    function dyn(
        uint256[8] memory _fixed
    ) internal pure returns (uint256[] memory dynamic_) {
        dynamic_ = new uint256[](8);
        dynamic_[0] = _fixed[0];
        dynamic_[1] = _fixed[1];
        dynamic_[2] = _fixed[2];
        dynamic_[3] = _fixed[3];
        dynamic_[4] = _fixed[4];
        dynamic_[5] = _fixed[5];
        dynamic_[6] = _fixed[6];
        dynamic_[7] = _fixed[7];
        return dynamic_;
    }

    // Maximum percentage factor (100.00%)
    uint256 internal constant PERCENTAGE_FACTOR = 1e4;

    // Half percentage factor (50.00%)
    uint256 internal constant HALF_PERCENTAGE_FACTOR = 0.5e4;

    function pctMul(
        uint256 value,
        uint256 percentage
    ) internal pure returns (uint256 result) {
        // to avoid overflow, value <= (type(uint256).max - HALF_PERCENTAGE_FACTOR) / percentage
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
        // to avoid overflow, value <= (type(uint256).max - halfPercentage) / PERCENTAGE_FACTOR
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

    /**
     * @dev Multiplies two wad, rounding half up to the nearest wad
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Wad
     * @param b Wad
     * @return c = a*b, in wad
     **/
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

    /**
     * @dev Divides two wad, rounding half up to the nearest wad
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Wad
     * @param b Wad
     * @return c = a/b, in wad
     **/
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

    /**
     * @notice Multiplies two ray, rounding half up to the nearest ray
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Ray
     * @param b Ray
     * @return c = a raymul b
     **/
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

    /**
     * @notice Divides two ray, rounding half up to the nearest ray
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Ray
     * @param b Ray
     * @return c = a raydiv b
     **/
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

    /**
     * @dev Casts ray down to wad
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Ray
     * @return b = a converted to wad, rounded half up to the nearest wad
     **/
    function fromRayToWad(uint256 a) internal pure returns (uint256 b) {
        assembly {
            b := div(a, WAD_RAY_RATIO)
            let remainder := mod(a, WAD_RAY_RATIO)
            if iszero(lt(remainder, div(WAD_RAY_RATIO, 2))) {
                b := add(b, 1)
            }
        }
    }

    /**
     * @dev Converts wad up to ray
     * @dev assembly optimized for improved gas savings: https://twitter.com/transmissions11/status/1451131036377571328
     * @param a Wad
     * @return b = a converted in ray
     **/
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

    function log_named_bool(string memory _str, bool _val) internal {
        emit log_named_string(_pre(_str), _val ? "true" : "false");
    }

    function log_pct(uint16 _val) internal {
        emit log_named_decimal_uint(_pre(""), _val, 2);
    }

    function log_pct(uint16 _val, string memory _str) internal {
        emit log_named_decimal_uint(_pre(_str), _val, 2);
    }

    function log_pct(uint32 _val, string memory _str) internal {
        emit log_named_decimal_uint(_pre(_str), _val, 2);
    }

    function log_pct(uint256 _val, string memory _str) internal {
        emit log_named_decimal_uint(_pre(_str), _val, 2);
    }

    function log_bool(bool _val) internal {
        emit log_string(_pre(_val ? "true" : "false"));
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

    function clgBal(address _account, address[] memory _tokens) internal {
        log_decimal_balances(_account, _tokens);
    }

    function clgBal(address _account, address _token) internal {
        log_decimal_balance(_account, _token);
    }

    function clg(bool _val, string memory _str) internal {
        log_named_bool(_pre(_str), _val);
    }

    function clg(bool _val) internal {
        log_bool(_val);
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

    function clog(string memory _val) internal check {
        emit log_string(_pre(_val));
    }

    function clog(string memory _val, string memory _lbl) internal check {
        emit log_named_string(_pre(_lbl), _val);
    }

    function clg2bytes(string memory _val, string memory _lbl) internal check {
        emit log_named_bytes(_pre(_lbl), bytes(_val));
    }

    function clg2str(bytes32 _val, string memory _lbl) internal check {
        emit log_named_string(_pre(_lbl), _val.str());
    }

    function clg2txt(bytes32 _val, string memory _lbl) internal check {
        emit log_named_string(_pre(_lbl), _val.txt());
    }

    function clg2str(address _val, string memory _lbl) internal check {
        emit log_named_string(_pre(_lbl), _val.str());
    }

    function clg2str(bytes memory _val, string memory _lbl) internal check {
        emit log_named_string(_pre(_lbl), _val.str());
    }

    function clg2txt(bytes memory _val, string memory _lbl) internal check {
        emit log_named_string(_pre(_lbl), _val.txt());
    }

    function clg(address[] memory _val, string memory _str) internal check {
        emit log_named_array(_pre(_str), _val);
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

    function clg(address _val) internal check {
        if (!_hasPrefix()) {
            emit log_address(_val);
        } else {
            emit log_named_address(_pre(""), _val);
        }
    }

    function clg(bytes32 _val) internal check {
        if (!_hasPrefix()) {
            emit log_bytes32(_val);
        } else {
            emit log_named_bytes32(_pre(""), _val);
        }
    }

    function clg(address _val, string memory _str) internal check {
        emit log_named_address(_pre(_str), _val);
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

    function clg(bytes memory _val) internal check {
        if (!_hasPrefix()) {
            emit log_bytes(_val);
        } else {
            emit log_named_bytes(_pre(""), _val);
        }
    }

    function clg(uint256[] memory _val, string memory _str) internal check {
        emit log_named_array(_pre(_str), _val);
    }

    function clg(int256[] memory _val, string memory _str) internal check {
        emit log_named_array(_pre(_str), _val);
    }

    function clg(bytes32 _val, string memory _str) internal check {
        emit log_named_bytes32(_pre(_str), _val);
    }

    function clg(bytes memory _val, string memory _str) internal check {
        emit log_named_bytes(_pre(_str), _val);
    }

    function clg(string memory _str, int256 _val) internal check {
        emit log_named_decimal_int(_pre(_str), _val, 18);
    }

    function clg(string memory _str, uint256 _val) internal check {
        emit log_named_decimal_uint(_pre(_str), _val, 18);
    }

    function clg(int256 _val, string memory _str) internal check {
        emit log_named_decimal_int(_pre(_str), _val, 18);
    }

    function clg(int256 _val, string memory _str, uint256 dec) internal check {
        emit log_named_decimal_int(_pre(_str), _val, dec);
    }

    function pct(uint16 _val, string memory _str) internal check {
        emit log_named_decimal_uint(_pre(_str), _val, 2);
    }

    function pct(uint32 _val, string memory _str) internal check {
        emit log_named_decimal_uint(_pre(_str), _val, 2);
    }

    function clg(uint256 _val, string memory _str) internal check {
        emit log_named_decimal_uint(_pre(_str), _val, 18);
    }

    function clg(uint256 _val, string memory _str, uint256 dec) internal check {
        emit log_named_decimal_uint(_pre(_str), _val, dec);
    }

    function clg_callers() internal check {
        LibVm.Callers memory current = LibVm.callers();
        emit log_named_string(
            "isHEVM",
            LibVm.hasHEVMContext() ? "true" : "false"
        );

        emit log_named_address("msg.sender", current.msgSender);
        emit log_named_address("tx.origin", current.txOrigin);
        emit log_named_string("mode", current.mode);
    }
}
