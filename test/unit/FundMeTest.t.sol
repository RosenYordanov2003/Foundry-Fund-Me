// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "..//../src/FundMe.sol";
import {DeplpyFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address userAddress = makeAddr('Pesho');
    uint256 constant AMOUNT_TO_FUND = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1; 

    function setUp() external {
        DeplpyFundMe deployFundMe = new DeplpyFundMe();
        fundMe = deployFundMe.run();
        vm.deal(userAddress, STARTING_BALANCE);
    }
    function testMinimumDollar() public{
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }
    function testOwnerSender() public{
        assertEq(fundMe.getOwner(), msg.sender);
    }
    function testPriceFeedVersion() public{
       assertEq(fundMe.getVersion(), 4);
    }
    function testWithInSufficientEthShouldRevert() public{
        vm.expectRevert();
        fundMe.fund();
    }
     modifier funded(){
        vm.prank(userAddress);
        fundMe.fund{value: AMOUNT_TO_FUND}();
        _;
    }
    function testFundMeShouldUpdateDataStructureProperly() public funded{ 
        uint256 amountFuned = fundMe.getAddressToAmountFunded(userAddress);
        assertEq(amountFuned, AMOUNT_TO_FUND);
    }
    function testAddFunderToArrayOfFunders() public funded{
         address expectedAddress = fundMe.getFunder(0);
         assertEq(expectedAddress, userAddress);
    }
    function testWithDrawWithOneFunder() public {
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalance = address(fundMe).balance;
        
        vm.txGasPrice(GAS_PRICE);
        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();

        uint256 endingOwnerBalace = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalance + startingOwnerBalance, endingOwnerBalace);
    }
    function testWithdrawShouldRevert() public funded{
        vm.expectRevert();
        fundMe.withdraw();
    }
    function testWithdrawWithMultipleFunders() public{
        uint160 fundedStartIndex = 1;
        uint160 fundedEndIndex = 10;

        for (uint160 i = fundedEndIndex; i < fundedEndIndex; i++) {
            hoax(address(i), AMOUNT_TO_FUND);
            fundMe.fund{value: AMOUNT_TO_FUND}();
        }
        
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundMeBalace = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();
        vm.stopPrank();

        uint256 endingFundMeBalance = address(fundMe).balance;
        uint256 endingOwnerBalace = fundMe.getOwner().balance;

        assertEq(endingFundMeBalance, 0);
        assertEq(startingFundMeBalace + startingOwnerBalance, endingOwnerBalace);
    }
}