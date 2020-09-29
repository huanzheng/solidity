// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.2 <0.8.0;
contract Require3 {
        uint state;
    function set(uint a) payable public { 
        require(a<3,"too big a");
        state = a;
    }
    function get() public view returns (uint b) {
        b = state;
    }
    function getBalance() public view returns (uint b) {
        b = address(this).balance;
    }
}


contract Require5 {
    Require3 feed;
    uint state5;
    function setFeed(Require3 addr) payable public { 
        feed = addr; }
    function callFeed(uint b) payable public {
        state5 = b;
        feed.set{value: 10 }(b);
    }
    function callFeedWithCatch(uint b) payable public {
        state5 = b;
        try feed.set{value: 10 }(b) {
            
        } catch Error(string memory /*reason*/) {
            
        } catch (bytes memory /*lowLevelData*/) {
            
        }
    }
    
    function get() public view returns (uint b) {
        b = state5;
    }
    function getBalance() public view returns (uint b) {
        b = address(this).balance;
    }
}
