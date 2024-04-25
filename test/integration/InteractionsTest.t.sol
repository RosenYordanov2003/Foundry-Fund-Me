// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeplpyFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";
import {FundMe} from "../../src/FundMe.sol";

contract InteractionTest is Test {
    FundMe fundMe;
    address userAddress = makeAddr('Pesho');
    uint256 constant AMOUNT_TO_FUND = 0.01 ether;
    uint256 constant STARTING_BALANCE = 1e18;

     function setUp() external {
        DeplpyFundMe deployFundMe = new DeplpyFundMe();
        fundMe = deployFundMe.run();
        vm.deal(userAddress, STARTING_BALANCE);
    }
    function testUserCanFundInteractions() public{
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));


        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));
         
        assert(address(fundMe).balance == 0);
    }
}