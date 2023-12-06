// solhint-disable
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import {_revert, getPayloadRs} from "../Base.sol";

abstract contract RsPayload {
    string private _rsScript;

    constructor(string memory _script) {
        if (bytes(_script).length != 0) {
            _rsScript = _script;
        } else {
            revert("RedstoneScript: no script");
        }
    }

    function getRsPayload(
        // dataFeedId:value:decimals
        string memory _mockStr
    ) public returns (bytes memory) {
        return getPayloadRs(_rsScript, _mockStr);
    }
}

abstract contract RedstoneScript is RsPayload {
    address _rsKresko;

    constructor(string memory _script) RsPayload(_script) {}

    function rsInit(address _kresko) public {
        _rsKresko = _kresko;
    }

    function rsStatic(
        address _to,
        bytes4 _s,
        string memory _mstr
    ) public returns (uint256) {
        return
            abi.decode(
                rsStatic(_to, abi.encodeWithSelector(_s), _mstr),
                (uint256)
            );
    }

    function rsStatic(bytes4 _s, string memory _mstr) public returns (uint256) {
        return
            abi.decode(
                rsStatic(_rsKresko, abi.encodeWithSelector(_s), _mstr),
                (uint256)
            );
    }

    function rsStatic(
        bytes4 _s,
        address p1,
        address p2,
        string memory _mstr
    ) public returns (uint256) {
        return
            abi.decode(
                rsStatic(_rsKresko, abi.encodeWithSelector(_s, p1, p2), _mstr),
                (uint256)
            );
    }

    function rsStatic(
        bytes4 _s,
        bool p1,
        string memory _mstr
    ) public returns (uint256) {
        return
            abi.decode(
                rsStatic(_rsKresko, abi.encodeWithSelector(_s, p1), _mstr),
                (uint256)
            );
    }

    function rsStatic(
        bytes4 _s,
        address p1,
        bool p2,
        string memory _mstr
    ) public returns (uint256) {
        return
            abi.decode(
                rsStatic(_rsKresko, abi.encodeWithSelector(_s, p1, p2), _mstr),
                (uint256)
            );
    }

    function rsStatic(
        bytes4 _s,
        address p1,
        string memory _mstr
    ) public returns (uint256) {
        return
            abi.decode(
                rsStatic(_rsKresko, abi.encodeWithSelector(_s, p1), _mstr),
                (uint256)
            );
    }

    function rsCall(
        bytes4 _s,
        address p1,
        uint256 p2,
        string memory _mstr
    ) public {
        rsCall(_rsKresko, abi.encodeWithSelector(_s, p1, p2), _mstr);
    }

    function rsCall(
        bytes4 _s,
        address p1,
        uint256 p2,
        address p3,
        string memory _mstr
    ) public {
        rsCall(_rsKresko, abi.encodeWithSelector(_s, p1, p2, p3), _mstr);
    }

    function rsCall(
        bytes4 _s,
        address p1,
        address p2,
        uint256 p3,
        string memory _mstr
    ) public {
        rsCall(_rsKresko, abi.encodeWithSelector(_s, p1, p2, p3), _mstr);
    }

    function rsCall(
        bytes4 _s,
        address p1,
        address p2,
        uint256 p3,
        address p4,
        string memory _mstr
    ) public {
        rsCall(_rsKresko, abi.encodeWithSelector(_s, p1, p2, p3, p4), _mstr);
    }

    function rsCall(
        bytes4 _s,
        address p1,
        address p2,
        address p3,
        uint256 p4,
        uint256 p5,
        string memory _mstr
    ) public {
        rsCall(
            _rsKresko,
            abi.encodeWithSelector(_s, p1, p2, p3, p4, p5),
            _mstr
        );
    }

    function rsCall(
        bytes4 _s,
        address p1,
        address p2,
        uint256 p3,
        uint256 p4,
        address p5,
        string memory _mstr
    ) public {
        rsCall(
            _rsKresko,
            abi.encodeWithSelector(_s, p1, p2, p3, p4, p5),
            _mstr
        );
    }

    function rsCall(
        bytes4 _s,
        address p1,
        address p2,
        uint256 p3,
        uint256 p4,
        string memory _mstr
    ) public {
        rsCall(_rsKresko, abi.encodeWithSelector(_s, p1, p2, p3, p4), _mstr);
    }

    function rsCall(
        address _to,
        bytes memory _f,
        string memory _mstr
    ) internal returns (bytes memory) {
        (bool success, bytes memory data) = address(_to).call(
            abi.encodePacked(_f, getRsPayload(_mstr))
        );
        if (!success) _revert(data);

        return data;
    }

    function rsStatic(
        address _to,
        bytes memory _f,
        string memory _mstr
    ) internal returns (bytes memory) {
        (bool success, bytes memory data) = address(_to).staticcall(
            abi.encodePacked(_f, getRsPayload(_mstr))
        );
        if (!success) _revert(data);

        return data;
    }
}
