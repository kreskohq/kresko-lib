// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {LibVm, Help, VM, store, Log} from "./Libs.sol";
import {Vm} from "forge-std/Vm.sol";

library Stash {
    Vm constant vm = VM;
    struct Data {
        mapping(address => uint256) addr_uint256;
        mapping(address => address) addr_addr;
        mapping(address => bool) addr_bool;
        mapping(address => string) addr_str;
        mapping(uint256 => uint256) uint256_uint256;
        mapping(string => address) str_addr;
        address addr;
        bytes32 valBytes32;
        uint256 number;
        uint16 valUint16;
        uint32 valUint32;
        string str;
        bytes valBytes;
        address[] addresses;
        uint256[] numbers;
        bytes[] bytesArr;
    }

    function existUint(address _key) internal view returns (bool) {
        return get().addr_uint256[_key] != 0;
    }

    function exists(address _key) internal view returns (bool) {
        return get().addr_addr[_key] != address(0);
    }

    function exists(uint256 _key) internal view returns (bool) {
        return get().uint256_uint256[_key] != 0;
    }

    function matches(uint256 _key, uint256 _val) internal view returns (bool) {
        return get().uint256_uint256[_key] == _val;
    }

    function existsStr(address _key) internal view returns (bool) {
        return bytes(get().addr_str[_key]).length > 0;
    }

    function exists(string memory _key) internal view returns (bool) {
        return get().str_addr[_key] != address(0);
    }

    function matches(
        string memory _key,
        address _val
    ) internal view returns (bool) {
        return get().str_addr[_key] == _val;
    }

    function matches(
        address _key,
        string memory _val
    ) internal view returns (bool) {
        return
            keccak256(abi.encodePacked(get().addr_str[_key])) ==
            keccak256(abi.encodePacked(_val));
    }

    function matches(address _key, address _val) internal view returns (bool) {
        return get().addr_addr[_key] == _val;
    }

    function matches(address _key, bool _val) internal view returns (bool) {
        return get().addr_bool[_key] == _val;
    }

    function has(
        string memory _key,
        address _val
    ) internal view returns (bool) {
        return get().str_addr[_key] == _val;
    }

    function set(uint256 _key, uint256 _val) internal {
        get().uint256_uint256[_key] = _val;
        emit Log.log_named_uint("Stash.uint256", _val);
    }

    function set(address _key, uint256 _val) internal {
        get().addr_uint256[_key] = _val;
        emit Log.log_named_uint("Stash.uint256", _val);
    }

    function set(address _key, address _val) internal {
        get().addr_addr[_key] = _val;
        emit Log.log_named_address("Stash.address", _val);
    }

    function set(address _key, bool _val) internal {
        get().addr_bool[_key] = _val;
        Log.log_named_bool("Stash.bool", _val);
    }

    function set(string memory _key, address _val) internal {
        get().str_addr[_key] = _val;
        emit Log.log_named_address("Stash.address", _val);
    }

    function set(address _key, string memory _val) internal {
        get().addr_str[_key] = _val;
        emit Log.log_named_string("Stash.string", _val);
    }

    function getUint(address _key) internal view returns (uint256) {
        return get().addr_uint256[_key];
    }

    function get(address _key) internal view returns (address) {
        return get().addr_addr[_key];
    }

    function getBool(address _key) internal view returns (bool) {
        return get().addr_bool[_key];
    }

    function get(string memory _key) internal view returns (address) {
        return get().str_addr[_key];
    }

    function get(uint256 _key) internal view returns (uint256) {
        return get().uint256_uint256[_key];
    }

    function getStr(address _key) internal view returns (string memory) {
        return get().addr_str[_key];
    }

    function stash(address _val) internal {
        get().addr = _val;
        emit Log.log_named_address("Stash.address", _val);
    }

    function stash(address _val1, address _val2) internal {
        get().addresses.push(_val1);
        emit Log.log_named_address("Stash.address", _val1);
        get().addresses.push(_val2);
        emit Log.log_named_address("Stash.address", _val2);
    }

    function stashb32(bytes32 _val) internal {
        get().valBytes32 = _val;
        emit Log.log_named_bytes32("Stash.bytes32", _val);
    }

    function stash(uint256 _val) internal {
        get().number = _val;
        emit Log.log_named_uint("Stash.uint256", _val);
    }

    function stash(uint256 _val1, uint256 _val2) internal {
        get().numbers.push(_val1);
        emit Log.log_named_uint("Stash.uint256", _val1);
        get().numbers.push(_val2);
        emit Log.log_named_uint("Stash.uint256", _val2);
    }

    function stash(uint16 _val) internal {
        get().valUint16 = _val;
        emit Log.log_named_uint("Stash.uint16", _val);
    }

    function stash(uint32 _val) internal {
        get().valUint32 = _val;
        emit Log.log_named_uint("Stash.uint32", _val);
    }

    function stash(string memory _val) internal {
        get().str = _val;
        emit Log.log_named_string("Stash.string", _val);
    }

    function stashb(bytes memory _val) internal {
        get().valBytes = _val;
        emit Log.log_named_bytes("Stash.bytes", _val);
    }

    function stash(uint256[] memory _vals) internal returns (uint256[] memory) {
        Help.write(get().numbers, _vals);
        emit Log.log_named_array("Stash.uint256[]", _vals);
        return get().numbers;
    }

    function stash(address[] memory _vals) internal returns (address[] memory) {
        Help.write(get().addresses, _vals);
        emit Log.log_named_array("Stash.address[]", _vals);
        return get().addresses;
    }

    function stashb(bytes[] memory _vals) internal returns (bytes[] memory) {
        for (uint256 i; i < _vals.length; i++) {
            get().bytesArr.push(_vals[i]);
        }
        emit Log.log_named_uint("Stash.bytes[] len:", _vals.length);
        return get().bytesArr;
    }

    function appendStashb(bytes memory _val) internal returns (bytes[] memory) {
        get().bytesArr.push(_val);
        emit Log.log_named_bytes("Stash.appendBytes", _val);
        emit Log.log_named_uint("LibVm.bytes[] len:", get().bytesArr.length);
        return get().bytesArr;
    }

    function appendStash(address _val) internal returns (address[] memory) {
        get().addresses.push(_val);
        emit Log.log_named_address("Stash.appendAddr", _val);
        emit Log.log_named_array("Stash.address[]", get().addresses);
        return get().addresses;
    }

    function appendStash(uint256 _val) internal returns (uint256[] memory) {
        get().numbers.push(_val);
        emit Log.log_named_uint("Stash.appendUint256", _val);
        emit Log.log_named_array("Stash.uint256[]", get().numbers);
        return get().numbers;
    }

    function appendStash(
        uint256[] memory _vals
    ) internal returns (uint256[] memory) {
        Help.write(get().numbers, _vals);
        emit Log.log_named_array("Stash.appendUint256", _vals);
        emit Log.log_named_array("Stash.uint256[]", get().numbers);
        return get().numbers;
    }

    function appendStash(
        address[] memory _vals
    ) internal returns (address[] memory) {
        Help.write(get().addresses, _vals);
        emit Log.log_named_array("Stash.appendAddr", _vals);
        emit Log.log_named_array("Stash.address[]", get().addresses);
        return get().addresses;
    }

    function replaceStash(
        address[] memory _vals
    ) internal returns (address[] memory) {
        emit Log.log_named_array("Stash.replaced", get().addresses);
        emit Log.log_named_array("Stash.with", _vals);
        delete get().addresses;
        return Help.write(get().addresses, _vals);
    }

    function replaceStash(
        uint256[] memory _vals
    ) internal returns (uint256[] memory) {
        emit Log.log_named_array("Stash.replaced", get().numbers);
        emit Log.log_named_array("Stash.with", _vals);
        delete get().numbers;
        return Help.write(get().numbers, _vals);
    }

    function appendStash(
        address[] memory,
        address _val
    ) internal returns (address[] memory) {
        return appendStash(_val);
    }

    function appendStash(
        address[] storage,
        address _val
    ) internal returns (address[] memory) {
        return appendStash(_val);
    }

    function replaceStash(
        address[] storage,
        address[] memory _vals2
    ) internal returns (address[] memory) {
        return replaceStash(_vals2);
    }

    function appendStash(
        uint256[] memory,
        uint256 _val
    ) internal returns (uint256[] memory) {
        return appendStash(_val);
    }

    function appendStash(
        uint256[] storage,
        uint256 _val
    ) internal returns (uint256[] memory) {
        return appendStash(_val);
    }

    function replaceStash(
        uint256[] memory,
        uint256[] memory _vals
    ) internal returns (uint256[] memory) {
        return replaceStash(_vals);
    }

    function replaceStash(
        uint256[] storage,
        uint256[] memory _vals2
    ) internal returns (uint256[] memory) {
        return replaceStash(_vals2);
    }

    function clearStash() internal {
        delete get().addr;
        delete get().valBytes32;
        delete get().number;
        delete get().valUint16;
        delete get().valUint32;
        delete get().str;
        delete get().valBytes;
        delete get().addresses;
        delete get().numbers;
    }

    function peek() internal {
        Data storage data = get();
        Log.hr();
        emit Log.log_named_address("address", data.addr);
        emit Log.log_named_bytes32("bytes32", data.valBytes32);
        emit Log.log_named_uint("uint16", data.valUint16);
        emit Log.log_named_uint("uint32", data.valUint32);
        emit Log.log_named_uint("uint256", data.number);
        emit Log.log_named_string("string", data.str);
        emit Log.log_named_uint("bytes[] length:", data.bytesArr.length);
        emit Log.log_named_array("address[]", data.addresses);
        emit Log.log_named_array("uint256[]", data.numbers);
        Log.hr();
    }

    function get() internal view returns (Data storage) {
        return store().stash;
    }
}
