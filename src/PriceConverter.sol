// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {AggregatorV3Interface} from
    "../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice(AggregatorV3Interface priceFeed) internal view returns (uint256) {
        //Get the instance trough address
        //Price of ETH in terms of USD
        (, int256 price,,,) = priceFeed.latestRoundData();

        return (uint256)(price * 1e10);
    }

    function getConversionRate(uint256 eathAmount, AggregatorV3Interface priceFeed) internal view returns (uint256) {
        //Get ETH Price in USD
        uint256 eathPrice = getPrice(priceFeed);
        //Multiply ETH Price In USD * ETH Amount;
        uint256 eathPriceInUsd = (eathAmount * eathPrice) / 1e18;

        return eathPriceInUsd;
    }

    function getVersion() internal view returns (uint256) {
        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }
}
