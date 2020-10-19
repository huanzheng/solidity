// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.8.0;

contract Fund {
    mapping(address => uint) shares;
    
    function getBalance() public view returns (uint balance) {
        balance = (address)(this).balance;
    }
    
    function getClientBalance() public view returns (uint balance) {
        balance = shares[msg.sender];
    }
    
    function deposit() public payable {
        shares[msg.sender] += msg.value;
    }
    
    // reentry issue may happen; however during simple test, it did not happen, maybe it's not that busy to trigger
    function withdraw() public {
        msg.sender.transfer(shares[msg.sender]);
        shares[msg.sender] = 0;
    }
}

contract Reentry {
    
    Fund fund;
    
    function getBalance() public view returns (uint balance) {
        balance = (address)(this).balance;
    }
    
    function getFundBalance() public view returns (uint balance) {
        balance = fund.getClientBalance();
    }
    
    function setFund(Fund addr) public payable {
        fund = addr;
    }
    
    function depositOnce(uint value) public {
        fund.deposit{value: value}();
    }
    
    function withdrawTwice() public {
        fund.withdraw();
        fund.withdraw();
    }
    
    receive() external payable {}
}
