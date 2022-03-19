pragma solidity ^0.5.0;

import "./KaseiCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";

// Have the KaseiCoinCrowdsale contract inherit the following OpenZeppelin:
// * Crowdsale
// * MintedCrowdsale
contract KaseiCoinCrowdsale is Crowdsale, MintedCrowdsale { 
    
    // Provide parameters for all of the features of your crowdsale, such as the `rate`, `wallet` for fundraising, and `token`.
    constructor(
        uint256 rate,
        address payable wallet,
        KaseiCoin token
    ) public Crowdsale(rate, wallet, token) {
        // Remainder of constructor will stay empty
    }
}

contract KaseiCoinCrowdsaleDeployer {
    address public kasei_token_address;
    address public kasei_crowdsale_address;

    constructor(
       string memory name,
       string memory symbol,
       address payable wallet
    ) public {
        // Create a new instance of the KaseiCoin contract. Set the initial supply to 0.
        KaseiCoin token = new KaseiCoin(name, symbol, 0);
        // Assign the token contract’s address to the `kasei_token_address` variable.
        kasei_token_address = address(token); 
        // Create a new instance of the `KaseiCoinCrowdsale` contract, with a rate of 1 ETH = 1 KAI, wallet as the main wallet from this constructor to get paid the ETH
        // that is sent to the contract, and the new token instance variable from this constructor to store the KAI 
        KaseiCoinCrowdsale kasei_crowdsale = new KaseiCoinCrowdsale(1, wallet, token);                
        // Assign the `KaseiCoinCrowdsale` contract’s address to the `kasei_crowdsale_address` variable.
        kasei_crowdsale_address = address(kasei_crowdsale);
        // Set the `KaseiCoinCrowdsale` contract as a minter using its crowdsale address for the new token (i.e., Kasei)
        token.addMinter(kasei_crowdsale_address);     
        // Have the `KaseiCoinCrowdsaleDeployer` renounce its minter role.
        token.renounceMinter();
    }
}