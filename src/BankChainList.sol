// Write a Bank contract to achieve the following functionalities:

// Allow deposit to the Bank contract address directly through wallets like Metamask
// Keep track of the deposit amount for each address in the Bank contract
// Implement a withdraw() method that allows only the administrator to withdraw funds
// Use an array to record the deposit amounts for the top 3 users
// Please submit the completed project code or the GitHub repository address.

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Bank {
    address internal admin;
    mapping(address => uint256) internal amounts;
    mapping(address => address) public top10;
    address constant GUARD = address(uint160(uint256(keccak256("GUARD"))));
    constructor() payable {
        admin = msg.sender;
    }

    modifier OnlyAdmin() {
        require(msg.sender == admin, "Only Admin manipulate.");
        _;
    }

    function amountsOf(address depositer) external view returns (uint256) {
        return amounts[depositer];
    }

    function sortOfTop10() internal {
        if (top10[GUARD] == address(0)) {
            top10[GUARD] = msg.sender;
            return;
        }
        if (msg.value > amounts[top10[GUARD]]) insert(GUARD);
        address prevPos = top10[GUARD];
        address nextPos = top10[prevPos];
        uint256 step = 0;
        address position = findInsertPosition(prevPos, nextPos, step);
        if (position != address(0)) {
            insert(position);
        }
    }

    function insert(address position) internal {
        address temp = top10[position];
        top10[position] = msg.sender;
        top10[msg.sender] = temp;
    }

    function show_amountsOfTop1() external view returns (uint256) {
        return amounts[top10[GUARD]];
    }

    function findInsertPosition(
        address prevPos,
        address nextPos,
        uint256 step
    ) internal returns (address) {
        if (step >= 10) {
            return address(0);
        }
        if (amounts[prevPos] >= msg.value && msg.value >= amounts[nextPos]) {
            return prevPos;
        } else {
            return findInsertPosition(top10[prevPos], top10[nextPos], ++step);
        }
    }

    // users deposit
    function deposit() external payable {
        amounts[msg.sender] += msg.value;
        sortOfTop10();
    }

    // withdraw for administrator
    function withdraw(uint256 _amount) external payable virtual OnlyAdmin {
        require(_amount <= address(this).balance, "Not enough balance");
        payable(admin).transfer(_amount);
    }

    receive() external payable {}
    fallback() external payable {}
}
