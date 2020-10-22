// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/SafeERC20.sol";

contract ZB is ERC20 {
    constructor (string memory name, string memory symbol) ERC20(name, symbol)
        public {
            _mint(msg.sender, 1000000);
        }
}

contract ZBControl {
    ZB _zb;
    
    using SafeERC20 for ZB;
    
    constructor () public {
        _zb = new ZB("Name","symbol");
    }
    
    function transfer(address to, uint256 value) public {
        _zb.safeTransfer(to, value);
    }
    
    function getBalance() public view returns(uint256 balance) {
        balance = _zb.balanceOf(msg.sender);
    }
}
