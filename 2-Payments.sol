pragma solidity ^0.5.0;

// It's important to avoid vulnerabilities due to numeric overflow bugs
// OpenZeppelin's SafeMath library, when used correctly, protects agains such bugs
// More info: https://www.nccgroup.trust/us/about-us/newsroom-and-events/blog/2018/november/smart-contract-insecurity-bad-arithmetic/
// This contract implements the following security patterns
// 1. Check the caller of the Withdrawal function is an Externally Owned Account and not a Smart Contract
// 2. Implement the Check - Effect - interacion pattern to avoid re-entrancy attack
// 3. Uses SafeMath for arithmetical operations, to avoid overflow / underflow risks
// 4. implement Rate Limiting (cool down) so that Withdrawal function cannot be called by the same user if a cool down time has not elapsed
// 5. implement a SafeGuard to protect against re-entrancy attacks




import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";


contract ExerciseC6B {
    using SafeMath for uint256; // Allow SafeMath functions to be called for all uint256 types (similar to "prototype" in Javascript)

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/


    address private contractOwner;                  // Account used to deploy contract
    mapping(address => uint256) balances;
    mapping(address => uint256) nextWithdrawalEnabledTime;
    uint256 private guardCounter = 1;

    constructor
                (
                )
                public 
    {
        contractOwner = msg.sender;
    }
   
    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "ContractOwner" account to be the function caller
    */
    modifier requireContractOwner()
    {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    modifier hasEnoughFunds(uint256 requestedAmount) {
        require(balances[msg.sender] >= requestedAmount, "Not enough funds");
        _;
    }
    // Ensures the caller is an Externally Owned Account, and not a Smart Contract
    modifier isEOA() {
        require(tx.origin == msg.sender, "Caller must be an EOA");
        _;
    }

    // Ensures the caller only can call the same function after a defined cooldown period
    modifier rateLimit(uint256 time) {
        require(block.timestamp > nextWithdrawalEnabledTime[msg.sender], "Wait for cooldown time");
        nextWithdrawalEnabledTime[msg.sender] = block.timestamp.add(time);
        _;
    }

    modifier entrancyGuard() {
        guardCounter = guardCounter.add(1);
        uint256 localCounter = guardCounter;
        _;
        require(guardCounter == localCounter, "Re-entrancy detected");
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

    function safeWithdraw(uint256 amount) hasEnoughFunds(amount) isEOA rateLimit(30 seconds) entrancyGuard public {
        // CHECK IN MODIFIER
        // EFFECT
        balances[msg.sender] = balances[msg.sender].sub(amount);
        // INTERACTION - Always use SafeMath
        msg.sender.transfer(amount);
    }
    
    function fundContract() public payable {
        balances[msg.sender] = msg.value;
    }

    function getMyBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

}


