pragma solidity ^0.4.24;

// It's important to avoid vulnerabilities due to numeric overflow bugs
// OpenZeppelin's SafeMath library, when used correctly, protects agains such bugs
// More info: https://www.nccgroup.trust/us/about-us/newsroom-and-events/blog/2018/november/smart-contract-insecurity-bad-arithmetic/

import "../../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

// This is an example of Data - App separation, useful for contract upgradability
// This is the Data contract
// in this contract do the following;
// 1. reference as "external" all the functions that will be called from the App contract
// 2. Implement a list of authorized App contract that can call this Data contract:
// 2.1 Define a mapping with the address of the authorized contract
// 2.2 Implement 2 functions, authorizeContract and deauthorizeContract, for the contractOwner to be able to add and remove authorized contracts addresses
// 2.3 Implement a modifier that checks that the external functions are called from an authorized App contract

contract ExerciseC6C {
    using SafeMath for uint256; // Allow SafeMath functions to be called for all uint256 types (similar to "prototype" in Javascript)

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/

    struct Profile {
        string id;
        bool isRegistered;
        bool isAdmin;
        uint256 sales;
        uint256 bonus;
        address wallet;
    }

    address private contractOwner;              // Account used to deploy contract
    mapping(string => Profile) employees;      // Mapping for storing employees
    mapping(address => bool) authorizedAppContracts;

    /********************************************************************************************/
    /*                                       EVENT DEFINITIONS                                  */
    /********************************************************************************************/

    // No events

    /**
    * @dev Constructor
    *      The deploying account becomes contractOwner
    */
    constructor() public {
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

    modifier isCallerAuthorized() {
        require(authorizedAppContracts[msg.sender] == true);
        _;
    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

   /**
    * @dev Check if an employee is registered
    *
    * @return A bool that indicates if the employee is registered
    */   
    function isEmployeeRegistered(string id) external view returns(bool) {
        return employees[id].isRegistered;
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

    function registerEmployee(string id, bool isAdmin, address wallet) external requireContractOwner {
        require(!employees[id].isRegistered, "Employee is already registered.");
        employees[id] = Profile({
                                        id: id,
                                        isRegistered: true,
                                        isAdmin: isAdmin,
                                        sales: 0,
                                        bonus: 0,
                                        wallet: wallet
                                });
    }

    function getEmployeeBonus(string id) external view requireContractOwner returns(uint256) {
        return employees[id].bonus;
    }

    function updateEmployee(string id, uint256 sales, uint256 bonus) isCallerAuthorized external {
        require(employees[id].isRegistered, "Employee is not registered.");
        employees[id].sales = employees[id].sales.add(sales);
        employees[id].bonus = employees[id].bonus.add(bonus);
    }

   function authorizeAppContract(address appContract) public requireContractOwner {
       authorizedAppContracts[appContract] = true;
   }

   function deAuthorizeAppContract(address appContract) public requireContractOwner {
       authorizedAppContracts[appContract] = false;
   }


}