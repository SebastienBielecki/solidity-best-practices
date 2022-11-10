pragma solidity ^0.4.25;

// It's important to avoid vulnerabilities due to numeric overflow bugs
// OpenZeppelin's SafeMath library, when used correctly, protects agains such bugs
// More info: https://www.nccgroup.trust/us/about-us/newsroom-and-events/blog/2018/november/smart-contract-insecurity-bad-arithmetic/

import "../../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";

// This is the Data contract
// in this contract do the following;
// 1 . Define the interface with the Data Contract (at the end)
// 2. Define a variable that is of the DataContract type which interface has been defined in previous step
// 3. Make any call to DataContract functions by prefixing the contract variable name
// 4. in the constructor, let user initalize the contract variable with the address of the DataContract

contract ExerciseC6CApp {
    using SafeMath for uint256; // Allow SafeMath functions to be called for all uint256 types (similar to "prototype" in Javascript)

    ExerciseC6C exerciseC6C;
    address private contractOwner;              // Account used to deploy contract

    modifier requireContractOwner() {
        require(msg.sender == contractOwner, "Caller is not contract owner");
        _;
    }
    
    constructor(address dataContract) public {
        contractOwner = msg.sender;
        exerciseC6C = ExerciseC6C(dataContract);
    }

     function calculateBonus(uint256 sales) internal view requireContractOwner returns(uint256) {
        if (sales < 100) {
            return sales.mul(5).div(100);
        }
        else if (sales < 500) {
            return sales.mul(7).div(100);
        }
        else {
            return sales.mul(10).div(100);
        }
    }

    function addSale(string id, uint256 amount) external requireContractOwner {
        exerciseC6C.updateEmployee(id, amount, calculateBonus(amount));
    }

}

contract ExerciseC6C {
    function updateEmployee (string id, uint256 sales, uint256 bonus) external;
}

