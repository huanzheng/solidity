// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.0 <0.8.0;

contract NotVulnerable {
    uint256 deposited = 0;
    
    constructor () public payable {
        
    }
    
    function deposit() public payable {
        deposited += msg.value;
    }
    
    function withdraw(uint256 amount) public {
        if (amount <= deposited) {
            (bool success, )=msg.sender.call{value:amount}("");
            if (success) {
                deposited -= amount;
                
                revert();
            }
        }
    }
}

contract Exploit {
    NotVulnerable target;
    
    constructor() public payable {
        require(msg.value == 2 ether);
        target = new NotVulnerable{value:1 ether}();
        
    }
    
    function tryIt() public payable {
        target.deposit{value:1 ether}();
        target.withdraw(1 ether);
    }
    
    fallback() external payable {
        if (address(this).balance < 2 ether) {
            target.withdraw(1 ether);
        }
    }
    
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
