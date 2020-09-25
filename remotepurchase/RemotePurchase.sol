// SPDX-License-Identifier: GPL-3.0
pragma solidity >0.6.99 <0.8.0;

contract Purchase {
    uint public value;
    address payable public seller;
    address payable public buyer;
    
    enum State {Created, Locked, Release, Inactive }
    
    State public state;
    
    modifier condition(bool _condition) {
        require(_condition);
        _;
    }
    
    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only buyer can call this");
        _;
    }
    
    modifier onlySeller() {
        require(msg.sender == seller, "Only seller can call this");
        _;
    }
    
    modifier inState(State _state) {
        require(state == _state, "Invalid state");
        _;
    }
    
    event Aborted();
    event PurchaseConfirmed();
    event ItemReceived();
    event SellerRefunded();
    
    constructor() payable {
        seller = msg.sender;
        value = msg.value/2;
        require((2*value) == msg.value, "Value has to be even");
    }
    
    function abort() public onlySeller inState(State.Created) {
        emit Aborted();
        state = State.Inactive;
        seller.transfer(address(this).balance);
    }
    
    function confirmPurchase() payable public inState(State.Created) condition(msg.value == (2*value))  {
        emit PurchaseConfirmed();
        buyer = msg.sender;
        state = State.Locked;
    }
    
    function confirmReceived() public onlyBuyer inState(State.Locked) {
        emit ItemReceived();
        state = State.Release;
        buyer.transfer(value);
    }
    function refundSeller()
        public
        onlySeller
        inState(State.Release)
    {
        emit SellerRefunded();
        // It is important to change the state first because
        // otherwise, the contracts called using `send` below
        // can call in again here.
        state = State.Inactive;

        seller.transfer(3 * value);
    }
}
