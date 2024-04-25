// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "../lib/foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
   uint256 constant AMOUT_TO_SEND = 0.01 ether;

     function fundFundMe(address mostRecentDeployed)  public {
      vm.startBroadcast();
      FundMe(payable(mostRecentDeployed)).fund{value: AMOUT_TO_SEND}();
      vm.stopBroadcast(); 
   }

   function run() external {
     vm.startBroadcast();
     address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
     fundFundMe(mostRecentDeployed);
     vm.stopBroadcast(); 
   }
}

contract WithdrawFundMe is Script {
  function withdrawFundMe(address mostRecentDeployed)  public {
      vm.startBroadcast();
      FundMe(payable(mostRecentDeployed)).withdraw();
      vm.stopBroadcast(); 
    }

   function run() external {
      address mostRecentDeployed = DevOpsTools.get_most_recent_deployment("FundMe", block.chainid);
       vm.startBroadcast();
      withdrawFundMe(mostRecentDeployed);
      vm.stopBroadcast(); 
   }
}