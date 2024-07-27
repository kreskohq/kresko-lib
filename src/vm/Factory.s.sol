// SPDX-License-Identifier: MIT
// solhint-disable

pragma solidity ^0.8.0;
import {Deployment, IDeploymentFactory} from "../core/IDeploymentFactory.sol";
import {mvm} from "./MinVm.s.sol";

library Factory {
    IDeploymentFactory internal constant FACTORY =
        IDeploymentFactory(0x000000000070AB95211e32fdA3B706589D3482D5);

    struct FactoryState {
        IDeploymentFactory factory;
        string id;
        string outputLocation;
        string currentKey;
        string currentJson;
        string outputJson;
        bool disableLog;
    }

    bytes32 internal constant FACTORY_STATE_SLOT = keccak256("FactoryState");

    function initJSON(string memory _configId) internal {
        string memory outDir = string.concat(
            "./temp/",
            mvm.toString(block.chainid),
            "/"
        );
        if (!mvm.exists(outDir)) mvm.createDir(outDir, true);
        data().id = _configId;
        data().outputLocation = outDir;
        data().outputJson = _configId;
    }

    function writeJSON() internal {
        string memory runsDir = string.concat(data().outputLocation, "runs/");
        if (!mvm.exists(runsDir)) mvm.createDir(runsDir, true);
        mvm.writeFile(
            string.concat(
                runsDir,
                data().id,
                "-",
                mvm.toString(mvm.unixTime()),
                ".json"
            ),
            data().outputJson
        );
        mvm.writeFile(
            string.concat(
                data().outputLocation,
                data().id,
                "-",
                "latest",
                ".json"
            ),
            data().outputJson
        );
    }

    function data() internal pure returns (FactoryState storage ds) {
        bytes32 slot = FACTORY_STATE_SLOT;
        assembly {
            ds.slot := slot
        }
    }

    modifier saveOutput(string memory _id) {
        setKey(_id);
        _;
        writeKey();
    }

    function setKey(string memory _id) internal {
        data().currentKey = _id;
        data().currentJson = "";
    }

    function set(address _val, string memory _key) internal {
        data().currentJson = mvm.serializeAddress(
            data().currentKey,
            _key,
            _val
        );
    }

    function set(bool _val, string memory _key) internal {
        data().currentJson = mvm.serializeBool(data().currentKey, _key, _val);
    }

    function set(uint256 _val, string memory _key) internal {
        data().currentJson = mvm.serializeUint(data().currentKey, _key, _val);
    }

    function set(bytes memory _val, string memory _key) internal {
        data().currentJson = mvm.serializeBytes(data().currentKey, _key, _val);
    }

    function writeKey() internal {
        data().outputJson = mvm.serializeString(
            "out",
            data().currentKey,
            data().currentJson
        );
    }

    function pd3(bytes32 _salt) internal view returns (address) {
        return FACTORY.getCreate3Address(_salt);
    }

    function pp3(bytes32 _salt) internal view returns (address, address) {
        return FACTORY.previewCreate3ProxyAndLogic(_salt);
    }

    function ctor(
        bytes memory _contract,
        bytes memory _args
    ) internal returns (bytes memory ccode_) {
        set(_args, "ctor");
        return abi.encodePacked(_contract, _args);
    }

    function d2(
        bytes memory _ccode,
        bytes memory _initCall,
        bytes32 _salt
    ) internal returns (Deployment memory result_) {
        result_ = FACTORY.deployCreate2(_ccode, _initCall, _salt);
        set(result_.implementation, "address");
    }

    function d3(
        bytes memory ccode,
        bytes memory _initCall,
        bytes32 _salt
    ) internal returns (Deployment memory result_) {
        result_ = FACTORY.deployCreate3(ccode, _initCall, _salt);
        set(result_.implementation, "address");
    }

    function p3(
        bytes memory ccode,
        bytes memory _initCall,
        bytes32 _salt
    ) internal returns (Deployment memory result_) {
        result_ = FACTORY.create3ProxyAndLogic(ccode, _initCall, _salt);
        set(address(result_.proxy), "address");
        set(
            abi.encode(result_.implementation, address(FACTORY), _initCall),
            "initializer"
        );
        set(result_.implementation, "implementation");
    }
}
