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


      function addBeneficiary(
        address user,
        uint8 percentage
    ) public isOwner(percentage) returns (uint256 amount) {
        require(
            (totalPercentage + percentage) <= 100,
            "You cannot payout over 100%"
        );
		require(percentage != 0, "You cannot add someone who has no stake");
        Beneficiary memory newBeneficiary = Beneficiary(
            user,
            percentage,
            currIndex
        );
        if (balances[user].percentage != 0) {
            updateBeneficiary(user, percentage);
        } else {
            balances[user] = newBeneficiary;
            beneficiaries[currIndex] = newBeneficiary;
            totalPercentage += percentage;
            currIndex += 1;
        }
        return percentageToAmount(percentage);
    }

    function removeBeneficiary(address user) public isOwner(0) {
        Beneficiary memory beneficiary = balances[user];
		    require(
                beneficiary.percentage != 0,
                "User was not found"
            );
        totalPercentage -= beneficiary.percentage;
        updateUser(user, 0);
        removeIndex(beneficiary.index);
    }

    function updateBeneficiary(
        address user,
        uint8 percentage
    ) public isOwner(percentage) returns (uint256 amount) {
        Beneficiary memory beneficiary = balances[user];
        if (percentage == 0) {
            removeBeneficiary(user);
            return 0;
        } else {
            int8 netChange = int8(beneficiary.percentage) - int8(percentage);
            int8 newPercentage = int8(totalPercentage) - (netChange);
            require(
                newPercentage <= 100,
                "You cannot make total amount over 100%"
            );

            updateUser(user, percentage);

            totalPercentage = uint8(newPercentage);
            return percentageToAmount(percentage);
        }
    }

    
    function fundContract() public payable isOwner(0) {
        willBalance = address(this).balance;
    }

        function getBalance(address user) public view returns (uint256 balance) {
        uint8 percent = balances[user].percentage;
        return percentageToAmount(percent);
    }

       function getAllBalances() public view returns (uint256[] memory values) {
		uint256[] memory moneyValues = new uint256[](currIndex);
        for (uint256 i = 0; i < currIndex; i++) {
            Beneficiary memory beneficiary = beneficiaries[i];
            moneyValues[i] = getBalance(beneficiary.user);
        }
		return moneyValues;
    }

    

    function payoutBeneficiaries() public isOwner(0) {
        require(
            totalPercentage == 100,
            "Not all the money in your will will be paid out. Ensure total percent is 100%"
        );
        uint256 length = currIndex; // curr index is changed in the loop
        for (uint256 i = 0; i < length; i++) {
            Beneficiary memory beneficiary = beneficiaries[i];
            payable(beneficiary.user).transfer(
                percentageToAmount(beneficiary.percentage)
            );
                updateUser(beneficiary.user, 0);
                removeIndex(beneficiary.index);
        }

        totalPercentage = 0;
        willBalance = 0;
    }


    // helper functions
    function updateUser(address user, uint8 percentage) private {
        balances[user].percentage = percentage;
        beneficiaries[balances[user].index].percentage = percentage;
    }

    function percentageToAmount(
        uint8 percentage
    ) private view returns (uint256 newAmount) {
        return (willBalance * percentage) / 100;
    }

    function removeIndex(uint index) private {

        for (uint i = index; i < (currIndex - 1); i++) {
            beneficiaries[i] = beneficiaries[i + 1];
            beneficiaries[i].index -= 1;
        }

        currIndex-=1;
    }


	function getTotalPercentage() public view returns (uint8) {
		return totalPercentage;
	}

    function getWillBalance() public view returns (uint256) {
        return address(this).balance;
    }

 
}
