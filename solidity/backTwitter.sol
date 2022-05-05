pragma solidity 0.8.13;

//SPDX-License-Identifier: None

/* 
 | |          (_) | | |           
 | |___      ___| |_| |_ ___ _ __ 
 | __\ \ /\ / / | __| __/ _ \ '__|
 | |_ \ V  V /| | |_| ||  __/ |   
  \__| \_/\_/ |_|\__|\__\___|_|                           
                    𝕓𝕪 @𝕖𝕧𝕞_𝕝𝕒𝕓𝕤 & @𝕕𝕚𝕞𝕚𝕣𝕖𝕒𝕕𝕤𝕥𝕙𝕚𝕟𝕘𝕤 (𝕋𝕨𝕚𝕥𝕥𝕖𝕣)
*/

/* 
################################################
################   NOT TESTED   ################
################################################
*/



import "./equityDistribution.sol";
import "./IequityDistribution.sol"; // need to implement


contract capitalAllocation is IequityDistribution{

    /*  On chain voting for Capital Allocation DAO
        Voting ability is determined by Token Onwership based on the EquityDistribution file (NFT minting)
        If you have a token, you can:
            1. Cast as many votes as tokens you own (number of tokens owned is restricted)
            2. Introduce a new motion (only if here is at least 1 week passed since previous motion)
            3. Assess the outcome of the motion
                - A motion is considered successful if it holds a strong majority (> 60%) of votes possible
    */

    address payable equityDistributionContractAddress; // temp 0 address
    address[] castedVoteAddress;
    uint32 internal votesInFavor;
    uint32 internal constant TOTAL_VOTES = IequityDistribution(equityDistributionContractAddress).TWITTER_SHARES;
    uint8 internal majorityRequired = 60;
    bool public canBringMotion = true;
    uint256 public timeOfMotion;

    function switchMotionStatus() internal {
        canBringMotion = !canBringMotion;
    }

    function expireMotionStatus() external onlyTokenHolder(msg.sender){
        require(block.timestamp > timestamp + 1 weeks, "Motion expires after 1 week.");
        switchMotionStatus();
    }

    modifier onlyWhenMotionPeriodOpen(){
        require(canBringMotion, "Another motion is active.");
        _;
    }

    modifier onlyTokenHolder(address _address){
        require(isTokenHolder(_address), "You need to be a token holder to participate.");
        _;
    }

    event NewMotionProposed(bytes32 proposal, address _address);

    function newMotion(bytes32 _proposal) external onlyWhenMotionPeriodOpen onlyTokenHolder(msg.sender){
        emit NewMotionProposed(_proposal, msg.sender);
        switchMotionStatus();
        delete castedVoteAddress;
        delete votesInFavor;
        timeOfMotion = block.timestamp;
    }

    function castVoteToMotion() external onlyTokenHolder(msg.sender){
        votesInFavor += TokenBalance(msg.sender);
    }

    function MotionPassed() external view returns(bool){
        return (votesInFavor >= (TOTAL_VOTES * majorityRequired / 100));
    }

    function TokenBalance(address _address) public view returns(uint256){ 
        return IequityDistribution(equityDistributionContractAddress).getAmountOfTwitterShares(_address);
    }

    receive() external payable{}
    fallback() external payable{}

}