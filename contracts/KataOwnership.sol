pragma solidity ^0.8.17;

import "./erc721.sol";
import "./KataCoins.sol";

contract KataOwnership is ERC721, KataCoins {
    function transfer(address to, uint256 tokenId) public override onlyOwner {
        // Le kata n'est pas déjà possédé par qqun
        require(_allowed_users[msg.sender] && _kataToOwner[tokenId] == address(0));
        _kataToOwner[tokenId] = to;
        emit Transfer(msg.sender, to, tokenId);
    }

    function approve(address _to, uint256 _tokenId) public override {

    }

    function takeOwnership(uint256 _tokenId) public override {

    }

    function balanceOf(address _owner) public view override returns (uint256 _balance){
        return uint256(0);
    }

    function ownerOf(uint256 _tokenId) public view override returns (address _owner){
        return address(0);
    }
}
