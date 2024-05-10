// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Bank} from "../src/BankChainList.sol";

contract BankTest is Test{

    address owner;
    Bank bank;
    function setUp()public {
        owner = vm.addr(1231412152);
        vm.startPrank(owner);
        bank = new Bank();
        vm.stopPrank();
    }

    function test_deposit() public{
        address temp = vm.addr(1);
        deposit(temp, 1);
        assertEq(bank.amountsOf(temp), 1);

    }

    function deposit(address depositer, uint256 price) internal{
        vm.startPrank(depositer);
        vm.deal(depositer, price);
        bank.deposit{value:price}();
        vm.stopPrank();
        assertEq(bank.amountsOf(depositer), price);

    }

    function test_top10()public {
        for (uint256 i = 1; i < 12; i++) {
            address temp = vm.addr(i);
            deposit(temp, i);
        }
        assertEq(bank.show_amountsOfTop1(),11);
    }


}