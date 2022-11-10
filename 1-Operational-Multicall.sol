pragma solidity ^0.4.25;

contract ExerciseC6A {

    /********************************************************************************************/
    /*                                       DATA VARIABLES                                     */
    /********************************************************************************************/


    struct UserProfile {
        bool isRegistered;
        bool isAdmin;
    }
    bool public isOperational;
    address private contractOwner;                  // Account used to deploy contract
    mapping(address => UserProfile) userProfiles;   // Mapping for storing user profiles
    uint8 public votes = 0;
    uint8 necessaryVotes = 3;
    mapping(address => bool) voters;
    address[] votersArray;

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
        isOperational = true;
    }

    /********************************************************************************************/
    /*                                       FUNCTION MODIFIERS                                 */
    /********************************************************************************************/

    // Modifiers help avoid duplication of code. They are typically used to validate something
    // before a function is allowed to be executed.

    /**
    * @dev Modifier that requires the "ContractOwner" account to be the function caller
    */
    modifier requireContractOwner() {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }

    modifier requireOperational() {
        require (isOperational, "Contract is not operational");
        _;
    }

    modifier admin() {
        require(userProfiles[msg.sender].isAdmin, "User is not admin");
        _;
    }

    modifier hasNotVoted() {
        require(!voters[msg.sender], "User has already voted");
        _;
    }

    /********************************************************************************************/
    /*                                       UTILITY FUNCTIONS                                  */
    /********************************************************************************************/

   /**
    * @dev Check if a user is registered
    *
    * @return A bool that indicates if the user is registered
    */  

    function changeOperationalStatus(bool mode) public admin hasNotVoted {
        if (mode != isOperational) {
            voters[msg.sender] = true;
            votes++;
            votersArray.push(msg.sender);
             if (votes == necessaryVotes) {
                isOperational = mode;
                votes = 0;
                for (uint16 i = 0; i<votersArray.length; i++ ) {
                    delete voters[votersArray[i]];
                }
                delete votersArray;
            }
        }
       
        
    }

    function isUserRegistered(address account) external view returns(bool) {
        require(account != address(0), "'account' must be a valid address.");
        return userProfiles[account].isRegistered;
    }

    /********************************************************************************************/
    /*                                     SMART CONTRACT FUNCTIONS                             */
    /********************************************************************************************/

    function registerUser(address account, bool isAdmin) external requireContractOwner requireOperational {
        require(!userProfiles[account].isRegistered, "User is already registered.");
        userProfiles[account] = UserProfile({ isRegistered: true, isAdmin: isAdmin});
    }

    function getOperationalStatus() public view returns (bool) {
        return isOperational;
    }

    function getVotersArray() public view returns (address[]) {
        return votersArray;
    }
}

