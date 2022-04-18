pragma solidity 0.8.13;
// SPDX-License-Identifier: None

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

contract DistributeShares is ERC721, Ownable, ReentrancyGuard{

    using Counters for Counters.Counter;
    using SafeMath for uint256;

    uint256 public constant TWITTER_SHARES = 1000000;
    bool public allSharesDistributed = false;
    Counters.Counter public tokenSupply;

    mapping (address => uint256) public shareholderSharesPreMint;

    constructor() ERC721("Twitter", "TWTR") {}
    event updatedShares(address _address, uint256 totalShares);
    event DistributionComplete();

    function updateShareholderShares(address _address, uint256 additionalShares) public onlyOwner{
        require(tokenSupply.current() + additionalShares <= TWITTER_SHARES, "This amount exceeds the total supply");
        shareholderSharesPreMint[_address].add(additionalShares);
        emit updatedShares(_address, shareholderSharesPreMint[_address]);
    }

    function mintShares() public nonReentrant{
        require(!allSharesDistributed, "All shares have now been distributed.");
        uint256 quantity = shareholderSharesPreMint[msg.sender];
        require(quantity > 0, "This address is not entitled to any shares.");
        require(tokenSupply.current() + quantity <= TWITTER_SHARES, "This amount exceeds the total supply");
        for (uint256 i = 0; i < quantity; i++) {
            uint256 mintIndex = tokenSupply.current();
            if (mintIndex < TWITTER_SHARES) {
                tokenSupply.increment();
                _safeMint(msg.sender, mintIndex);
            }
        }
        shareholderSharesPreMint[msg.sender] = 0;
        if (tokenSupply.current() == TWITTER_SHARES - 1) {
            allSharesDistributed = !allSharesDistributed;
            emit DistributionComplete();
        }
    }

    fucntion getAmountOfTwitterShares(address _address) public view returns(uint256){
        return balanceOf(_address);
    }
}