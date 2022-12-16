pragma solidity ^0.8.0;

import "./erc721.sol";
import "./KataCoins.sol";

contract KataOwnership is ERC721, KataCoins {
    function transfer(address to, uint256 tokenId) public override onlyOwner {
        super.transfer(to, tokenId);
    }
}
