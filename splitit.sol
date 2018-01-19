//SplitIt 

pragma solidity ^0.4.18;
contract SplitIt {
    
    address[] employees = [0x91060b1Cd731BF2973aab741Aa0D0715c1E3C5a7, 
    0xBdcCE34edb12aA20b823056D34c0b2792b2Ac749, 
    0xaE400830Adf004aE10986Fe63B6Eb312f6FA8314];
    
    uint totalReceived = 0;
    
    mapping(address=>uint) withdrawnAmounts;
    
    function SplitIt() payable public{
       updateTotalReceived(); 
    }
    
    function() payable public{
        updateTotalReceived();
    }
    
    function updateTotalReceived() internal{
        totalReceived += msg.value;
    }
    
    modifier canWithdraw(){
        bool contains = false;
        
        for (uint i =0; i<employees.length; i++){
            if (employees[i]==msg.sender)
            contains = true;
            //no break so all employees pay same gas price
        }
        require(contains);
        _;
    }
    
    function withdraw() canWithdraw public{
        uint amountAllocated = totalReceived/employees.length;
        uint amountWithdrawn = withdrawnAmounts[msg.sender];
        uint amount = amountAllocated - amountWithdrawn;
        withdrawnAmounts[msg.sender] = amountWithdrawn + amount;
        
        if (amount > 0)
        msg.sender.transfer(amount);

    }
}
