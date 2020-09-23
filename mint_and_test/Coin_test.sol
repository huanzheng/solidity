pragma solidity >=0.4.22 <0.7.0;
import "remix_tests.sol"; // this import is automatically injected by Remix.
import "remix_accounts.sol";
import "../Coin.sol";

// File name has to end with '_test.sol', this file can contain more than one testSuite contracts
contract testSuite is Coin {
    Coin coin;
    address acc0;
    address acc1;
    address acc2;
    /// 'beforeAll' runs before all other tests
    /// More special functions are: 'beforeEach', 'beforeAll', 'afterEach' & 'afterAll'
    function beforeAll() public {
        // Here should instantiate tested contract
        //coin = new Coin();
        //coinowner = 
        acc0 = TestsAccounts.getAccount(0); 
        acc1 = TestsAccounts.getAccount(1);
        acc2 = TestsAccounts.getAccount(2);
    }

    /// Test if initial owner is set correctly
    /// #sender: account-0
    function testInitialOwner() public {
        // account at zero index (account-0) is default account, so current owner should be acc0
        Assert.equal(getOwner(), msg.sender, 'owner should be acc0');
    }
    
    /// #sender: account-0
    function testMintRightOwner() public {
        // Use 'Assert' to test the contract, 
        // See documentation: https://remix-ide.readthedocs.io/en/latest/assert_library.html
        mint(acc1, 200); //if use this.mint somehow the owner check inside mint is not right
        Assert.ok(balances[acc1] == 200, 'mint error');
    }
    
    /// #sender: account-1
    function testMintWrongOwner() public {
        /* change to this.mint can pass compile error, but it's not right
        try mint(acc1, 200) {
            
        } catch Error(string memory reason) {
            Assert.equal(reason, 'Permission denied', 'failed with unexpected reason');
        } catch (bytes memory) {
            Assert.ok(false, 'failed unexpected');
        }*/
    }

    /// #sender: account-1
    function testSend() public {
        // Use the return value (true or false) to test the contract
        send(acc2, 10);
        Assert.ok(balances[acc1] == 190, 'send error');
        Assert.ok(balances[acc2] == 10, 'send error');
    }
}

