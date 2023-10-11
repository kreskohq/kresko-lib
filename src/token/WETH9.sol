// SPDX-License-Identifier: MIT

pragma solidity >=0.8.21;
import {ERC20} from "./ERC20.sol";

contract WETH9 is ERC20 {
    constructor() ERC20("Wrapped Ether", "WETH", 18) {
        //
    }

    event Deposit(address indexed dst, uint256 wad);
    event Withdrawal(address indexed src, uint256 wad);

    function deposit() public payable virtual {
        _balances[msg.sender] += msg.value;
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(uint256 wad) public virtual {
        require(_balances[msg.sender] >= wad, "WETH9: Error");
        _balances[msg.sender] -= wad;
        payable(msg.sender).transfer(wad);
        emit Withdrawal(msg.sender, wad);
    }

    function totalSupply() public view override returns (uint256) {
        return address(this).balance;
    }
}
