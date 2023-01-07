pragma solidity ^0.8.17;

abstract contract ERC721 {

    event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
    event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);

    function ownerOf(uint256 _tokenId) public view virtual returns (address _owner);

    function transfer(address _to, uint256 _tokenId) public virtual;

}
