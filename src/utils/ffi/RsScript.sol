// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {__revert, getPayloadRs} from "../Base.s.sol";

abstract contract RsPayload {
    string private _rsScript;

    constructor(string memory _script) {
        if (bytes(_script).length != 0) {
            _rsScript = _script;
        } else {
            revert("RsScript: no script");
        }
    }

    function getRsPayload(
        // dataFeedId:value:decimals
        string memory _mstr
    ) public returns (bytes memory) {
        if (bytes(_mstr).length == 0) revert("RsScript: no mock");
        return getPayloadRs(_rsScript, _mstr);
    }
}

abstract contract RsScript is RsPayload {
    address _rsKresko;
    bytes rsPayload;
    string rsPrices;

    constructor(string memory _script) RsPayload(_script) {}

    function rsInit(address _kresko, string memory _mstr) public {
        _rsKresko = _kresko;
        rsPrices = _mstr;
        rsPayload = getRsPayload(rsPrices);
    }

    function rsInit(address _kresko) public {
        _rsKresko = _kresko;
    }

    function rsInit(string memory _mstr) public {
        rsPrices = _mstr;
        rsPayload = getRsPayload(rsPrices);
    }

    function rsStatic(address _to, bytes4 _s) public view returns (uint256) {
        return abi.decode(rsStatic(_to, abi.encodeWithSelector(_s)), (uint256));
    }

    function rsStatic(bytes4 _s) public view returns (uint256) {
        return
            abi.decode(
                rsStatic(_rsKresko, abi.encodeWithSelector(_s)),
                (uint256)
            );
    }

    function rsStatic(
        bytes4 _s,
        address p1,
        address p2
    ) public view returns (uint256) {
        return
            abi.decode(
                rsStatic(_rsKresko, abi.encodeWithSelector(_s, p1, p2)),
                (uint256)
            );
    }

    function rsStatic(bytes4 _s, bool p1) public view returns (uint256) {
        return
            abi.decode(
                rsStatic(_rsKresko, abi.encodeWithSelector(_s, p1)),
                (uint256)
            );
    }

    function rsStatic(
        bytes4 _s,
        address p1,
        bool p2
    ) public view returns (uint256) {
        return
            abi.decode(
                rsStatic(_rsKresko, abi.encodeWithSelector(_s, p1, p2)),
                (uint256)
            );
    }

    function rsStatic(bytes4 _s, address p1) public view returns (uint256) {
        return
            abi.decode(
                rsStatic(_rsKresko, abi.encodeWithSelector(_s, p1)),
                (uint256)
            );
    }

    function rsStatic(
        bytes4 _s,
        address p1,
        address p2,
        uint256 p3,
        uint256 p4
    ) public view returns (uint256) {
        return
            abi.decode(
                rsStatic(_rsKresko, abi.encodeWithSelector(_s, p1, p2, p3, p4)),
                (uint256)
            );
    }

    function rsCall(bytes4 _s, address p1, uint256 p2) public {
        rsCall(_rsKresko, abi.encodeWithSelector(_s, p1, p2));
    }

    function rsCall(bytes4 _s, address p1, uint256 p2, address p3) public {
        rsCall(_rsKresko, abi.encodeWithSelector(_s, p1, p2, p3));
    }

    function rsCall(bytes4 _s, address p1, address p2, uint256 p3) public {
        rsCall(_rsKresko, abi.encodeWithSelector(_s, p1, p2, p3));
    }

    function rsCall(
        bytes4 _s,
        address p1,
        address p2,
        uint256 p3,
        address p4
    ) public {
        rsCall(_rsKresko, abi.encodeWithSelector(_s, p1, p2, p3, p4));
    }

    function rsCall(
        bytes4 _s,
        address p1,
        address p2,
        address p3,
        uint256 p4,
        uint256 p5
    ) public {
        rsCall(_rsKresko, abi.encodeWithSelector(_s, p1, p2, p3, p4, p5));
    }

    function rsCall(
        bytes4 _s,
        address p1,
        address p2,
        uint256 p3,
        uint256 p4,
        address p5
    ) public {
        rsCall(_rsKresko, abi.encodeWithSelector(_s, p1, p2, p3, p4, p5));
    }

    function rsCall(
        bytes4 _s,
        address p1,
        address p2,
        uint256 p3,
        uint256 p4
    ) public {
        rsCall(_rsKresko, abi.encodeWithSelector(_s, p1, p2, p3, p4));
    }

    function rsCall(
        address _to,
        bytes memory _f
    ) internal returns (bytes memory) {
        (bool success, bytes memory data) = address(_to).call(
            abi.encodePacked(_f, rsPayload)
        );
        if (!success) __revert(data);

        return data;
    }

    function rsStatic(
        address _to,
        bytes memory _f
    ) internal view returns (bytes memory) {
        (bool success, bytes memory data) = address(_to).staticcall(
            abi.encodePacked(_f, rsPayload)
        );
        if (!success) __revert(data);

        return data;
    }
}
