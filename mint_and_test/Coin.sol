// SPDX-License-Identifier: GPL-3.0

pragma solidity >0.5.99 <0.8.0;

contract Coin {
    address public minter;
    mapping (address => uint) public balances;
    
    event Sent(address from, address to, uint amount);
    
    constructor() public {
        minter = msg.sender;
    }
    
    function getOwner() public view returns (address) {
        return minter;
    }
    
    function mint(address receiver, uint amount) public {
        require(msg.sender == minter, "Permission denied");
        require(amount < 1e60);
        balances[receiver]+=amount;
    }
    
    function send(address receiver, uint amount) public {
        require(amount <= balances[msg.sender], "Insufficient balance");
        balances[msg.sender] -= amount;
        balances[receiver] += amount;
        emit Sent(msg.sender, receiver, amount);
    }
}
