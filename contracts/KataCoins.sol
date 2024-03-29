pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract KataCoins is Ownable, ERC721 {
    uint private nextKataId = 0; // /!\ côté front retourne un objet

    uint private execFee = 0.001 ether;
    uint private minNbTry = 20;

    Kata[] private _katas;
    mapping(uint => address[]) internal _kataToAllowedUser;

    mapping(address => uint) internal _userCredits;

    struct Kata {
        uint id;
        string name;
        //Enoncé du kata
        string statement;
        string functionDeclaration;
        string test;
    }

    struct Response {
        Kata kata;
        bool isOwned;
    }

    constructor() ERC721("KataCoins", "KTC") {
    }

    function changeLevelUpFee(uint newFee) public onlyOwner {
        execFee = newFee;
    }

    function getExecFee() external view returns (uint) {
        return execFee;
    }

    function payCredit(uint nbTry) external payable {
        require(nbTry >= minNbTry, "minimun try is 20" );
        require(msg.value == nbTry * execFee, "you need to pay the right amount");
        _userCredits[msg.sender] += nbTry;
    }

    function getCredit() external view returns (uint) {
        return _userCredits[msg.sender];
    }

    function createKata(
        string calldata name,
        string calldata statement,
        string calldata functionDeclaration,
        string calldata test
    ) external onlyOwner returns (uint) {
        _katas.push(
            Kata(nextKataId, name, statement, functionDeclaration, test)
        );
        nextKataId ++;

        return nextKataId - 1;
    }

    function getAllKata() external view returns (Response[] memory) {
        Response[] memory res = new Response[](_katas.length);

        for (uint i = 0; i < _katas.length; i++) {
            Kata memory _kata = _katas[i];
            res[i] = Response(_kata, _ownerOf(_kata.id) != address(0));
        }

        return res;
    }

    function getKata(uint kataId) external view returns (Response memory) {
        for (uint i = 0; i < _katas.length; i++) {
            if (_katas[i].id == kataId) {
                return Response(_katas[i], _ownerOf(kataId) != address(0));
            }
        }

        revert("Not found");
    }

    function hasSolvedKata(address user, uint kataID) public view returns(bool) {
        address [] memory allowedUser = _kataToAllowedUser[kataID];

        for (uint i = 0; i < allowedUser.length; i++) {
            if (allowedUser[i] == user) {
                return true;
            }
        }

        return false;
    }

    function setHasSolvedKata(address user, uint kataID) public onlyOwner {
        require(_ownerOf(kataID) == address(0), "Kata already owned");
        _kataToAllowedUser[kataID].push(user);
    }

    function executeKata(address user, uint kataId) external onlyOwner {
        require(_ownerOf(kataId) == address(0) , "Kata already owned");
        require(_userCredits[user] > 0, "Not enough credits");
        _userCredits[user] = _userCredits[user] - 1;
    }

    function mintKata( uint256 tokenId) external {
        require(hasSolvedKata(msg.sender, tokenId), "You need to solve the kata before");
        delete _kataToAllowedUser[tokenId];
        _safeMint(msg.sender, tokenId);
    }


}



