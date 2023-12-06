// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import {logp} from "./Base.sol";

library MinLog {
    function clg(string memory p0) internal pure {
        logp(abi.encodeWithSignature("log(string)", p0));
    }

    function clg(string memory p0, string memory p1) internal pure {
        logp(abi.encodeWithSignature("log(string,string)", p0, p1));
    }

    function clg(address p0) internal pure {
        logp(abi.encodeWithSignature("log(address)", p0));
    }

    function clg(uint256 p0) internal pure {
        logp(abi.encodeWithSignature("log(uint256)", p0));
    }

    function clg(int256 p0) internal pure {
        logp(abi.encodeWithSignature("log(int256)", p0));
    }

    function clg(int256 p0, string memory p1) internal pure {
        logp(abi.encodeWithSignature("log(string,int256)", p1, p0));
    }

    function clg(bool p0) internal pure {
        logp(abi.encodeWithSignature("log(bool)", p0));
    }

    function clg(uint256 p1, string memory p0) internal pure {
        logp(abi.encodeWithSignature("log(string,uint256)", p0, p1));
    }

    function clg(address p0, uint256 p1) internal pure {
        logp(abi.encodeWithSignature("log(address,uint256)", p0, p1));
    }

    function clg(string memory p0, address p1, uint256 p2) internal pure {
        logp(
            abi.encodeWithSignature("log(string,address,uint256)", p0, p1, p2)
        );
    }

    function clg(address p1, string memory p0) internal pure {
        logp(abi.encodeWithSignature("log(string,address)", p0, p1));
    }

    function blg(bytes32 p0) internal pure {
        logp(abi.encodeWithSignature("log(bytes32)", p0));
    }

    function blg(bytes32 p1, string memory p0) internal pure {
        logp(abi.encodeWithSignature("log(string,bytes32)", p0, p1));
    }

    function blg(bytes memory p0) internal pure {
        logp(abi.encodeWithSignature("log(bytes)", p0));
    }

    function blg(bytes memory p1, string memory p0) internal pure {
        logp(abi.encodeWithSignature("log(string,bytes)", p0, p1));
    }
}
