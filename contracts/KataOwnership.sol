pragma solidity ^0.8.0;

import "./erc721.sol";
import "./KataCoins.sol";

contract KataOwnership is ERC721, KataCoins {
    function transfer(address to, uint256 tokenId) public override onlyOwner {
        // Le kata n'est pas déjà possédé par qqun
        require(_allowed_users[msg.sender] == true && !_kataToOwner[tokenId]);
        _kataToOwner[tokenId] = to;
        emit Transfer(msg.sender, to, tokenId);
    }
}
