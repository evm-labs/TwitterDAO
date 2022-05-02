pragma solidity 0.8.13;
// SPDX-License-Identifier: None

// UNFINISHED!!!

/* 
 | |          (_) | | |           
 | |___      ___| |_| |_ ___ _ __ 
 | __\ \ /\ / / | __| __/ _ \ '__|
 | |_ \ V  V /| | |_| ||  __/ |   
  \__| \_/\_/ |_|\__|\__\___|_|                           
                    𝕓𝕪 @𝕖𝕧𝕞_𝕝𝕒𝕓𝕤 & @𝕕𝕚𝕞𝕚𝕣𝕖𝕒𝕕𝕤𝕥𝕙𝕚𝕟𝕘𝕤 (𝕋𝕨𝕚𝕥𝕥𝕖𝕣)
*/

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./equityDistribution.sol"

contract TwitterGovernance is ERC721, Ownable, ReentrancyGuard, Utils, DistributeShares{

    uint internal CONSTANT secondsInAWeek = 604800;
    address public boardMemberAddresses = [address(0), address(0), address[0], address(0), address[0]];
    address public boardChairman = address[0];
    uint boardMemberVoteFactor = TWITTER_SHARES.div(100) // Arbitrary number, can be based on proper formula
    enum VoteType{ BoardChange, MEDIUM, LARGE }
    FreshJuiceSize choice;
    FreshJuiceSize constant defaultChoice = FreshJuiceSize.MEDIUM;
    uint internal votesForMotion;
    uint internal startTimeOfMotion;
    uint internal numberOfVotesToCast;

    mapping (address => bool) internal voted;
    address[] voters;

    event NewMotion(string calldata motion);

    function resetVotes() internal {
        for (uint i=0; i < voters.length ; i++){
            voted[voters[i]] = false;
        }
    }

    function introduceNewMotion(string calldata motion){
        require(block.timestamp > startTimeOfMotion.add(secondsInAWeek), "Previous vote still in motion.");
        // Place additional barrier to avoid spam motions?
        startTimeOfMotion = block.timestamp;
        emit NewMotion(motion);
        resetVotes(); // expensive for users
    }

    function voteForMotion(){
        require(getAmountOfTwitterShares(msg.sender) > 0, "This address is not an equity holder");
        require(!voted[msg.sender], "This address has already casted a vote");
        numberOfVotesToCast = balanceOf[msg.sender];
        if (isBoardMember(msg.sender)){
            numberOfVotesToCast = numberOfVotesToCast.mul(boardMemberVoteFactor);
        }
        votesForMotion.add(numberOfVotesToCast);
        voters.push(msg.sender);
        voted[msg.sender] = true;
    }

    modifier onlyBoardChairman()

    function onlyBoardOrMajority(){

    }


    function replaceBoardMember(address oldMember, address newMember) onlyMajorityApproval{
        removeBoardMember(oldMember)
        addBoardMember(newMember)
    }

    function removeBoardMember(address oldMember) internal {
        removeByValue(oldMember)
    }

    function addBoardMember(address newMember) internal {
        boardMemberAddresses.push(newMember)
    }

    function isBoardMember(address _address) internal view returns(bool){
        for (uint i; i <= boardMemberAddresses.length; i++){
            if (_address == boardMemberAddresses[i]){
                return true;
            }
        }
        return false;
    }

    function updateChairman()

}

contract Utils{

    uint[] public values;

    function find(address _address) returns(uint) {
        uint i = 0;
        while (values[i] != _address) {
            i++;
        }
        return i;
    }

    function removeByValue(address _address) {
        uint i = find(_address);
        removeByIndex(i);
    }

    function getValues() constant returns(uint[]) {
        return values;
    }


}