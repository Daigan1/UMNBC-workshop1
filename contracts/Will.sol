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

    modifier isOwner(uint8 percentage) {
        require(
            willOwner == msg.sender,
            "Only the will holder can modify this"
        );
        require(
            percentage >= 0 && percentage <= 100,
            "Percentage must be in range [0,100]"
        );
        _;
    }

    function updateUser(address user, uint8 percentage) private {
      
    }

    function percentageToAmount(
        uint8 percentage
    ) private view returns (uint256 newAmount) {
        
    }

    function removeIndex(uint index) private {

        
    }

    function getBalance(address user) public view returns (uint256 balance) {
       
    }

    function addBeneficiary(
        address user,
        uint8 percentage
    ) public isOwner(percentage) returns (uint256 amount) {
      
		
    }

    function removeBeneficiary(address user) public isOwner(0) {
       }

    function updateBeneficiary(
        address user,
        uint8 percentage
    ) public isOwner(percentage) returns (uint256 amount) {
        
    }

  
 
    function fundContract() public payable isOwner(0) {
        willBalance = address(this).balance;
    }

    function payoutBeneficiaries() public isOwner(0) {
        
    }

	function getTotalPercentage() public view returns (uint8) {
	
	}

    function getWillBalance() public view returns (uint256) {
      
    }

    function getAllBalances() public view returns (uint256[] memory values) {
		
    }
}
