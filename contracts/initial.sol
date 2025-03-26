// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

contract Will {
    struct Beneficiary {
        address user;
        uint8 percentage; // [0, 100]
        uint index;
    }

    mapping(address => Beneficiary) balances;
    Beneficiary[10000] beneficiaries;
    address willOwner;
    uint8 totalPercentage;
    uint8 private currIndex;
    uint256 willBalance;

    constructor(address owner) {
        willOwner = owner;
        currIndex = 0;
        totalPercentage = 0;
        willBalance = 0;
    }




    function addBeneficiary(
        address user,
        uint8 percentage
    ) public returns (uint8 percent) {
      Beneficiary memory beneficiary = Beneficiary(user, percentage, currIndex);
        balances[user] = beneficiary;
        return percentage;
		
    }


    function getPercentage(address user) public view returns (uint8 percentage) {
        return (balances[user].percentage);
    }
    
}
