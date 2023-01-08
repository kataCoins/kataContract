pragma solidity ^0.8.17;

import "./Ownable.sol";
import "./erc721.sol";
import "hardhat/console.sol";

contract KataCoins is Ownable, ERC721 {
    string public contractName = "KataCoins";
    uint private nextKataId = 0; // /!\ côté front retourne un objet

    uint private execFee = 0.001 ether;
    uint private minNbTry = 20;

    Kata[] private _katas;
    mapping(uint => address) internal _kataToOwner;
    //Les utilisateurs ayant payé pour executer un kata
    mapping(address => bool) internal _allowed_users;
    mapping(address => uint) internal _userCredits;


    struct Kata {
        uint id;
        string name;
        //Enoncé du kata
        string statement;
        string functionDeclaration;
        //Ne pas les envoyer au front
        string test;
    }

    struct Response {
        Kata kata;
        bool isOwned;
    }

    function changeLevelUpFee(uint newFee) public onlyOwner {
        execFee = newFee;
    }

    function createKata(
        string calldata name,
        string calldata statement,
        string calldata functionDeclaration,
        string calldata test
    ) external onlyOwner returns (uint) {
        _katas.push(Kata(nextKataId, name, statement, functionDeclaration, test));
        nextKataId ++;
        return nextKataId - 1;
    }

    //renvoyer sans test
    function getAllKata() external view returns (Kata[] memory) {
        return _katas;
    }

    function getKata(uint kataId) external view returns (Response memory) {
        for (uint i = 0; i < _katas.length; i++) {
            if (_katas[i].id == kataId) {
                return Response(_katas[i], _kataToOwner[kataId] != address(0));
            }
        }

        revert("Not found");
    }

    //back après execution peut importe le résultat de l'exécution
    function tryKata(address user) external onlyOwner {
        _userCredits[user] -= 1;
    }

    //On vérifie que l'utilisateur a encore du crédit pour faire des essais
    function canExecuteKata(address user) external view onlyOwner returns (bool) {
        return _userCredits[user] > 0;
    }

    function payCredit(uint nbTry) external payable {
        require(nbTry >= minNbTry, "minimun try is 20" );
        require(msg.value == nbTry * execFee, "you need to pay the right amount");
        console.log("payCredit", msg.sender, nbTry);
        _userCredits[msg.sender] += nbTry;
    }

    function getCredit() external view returns (uint) {
        console.log("payCredit", msg.sender, _userCredits[msg.sender]);
        return _userCredits[msg.sender];
    }

    /// ERC 721 ///
    function transfer(address to, uint256 tokenId) public override onlyOwner {
        // Le kata n'est pas déjà possédé par qqun
        require(_kataToOwner[tokenId] == address(0), "kata already owned");
        _kataToOwner[tokenId] = to;
        emit Transfer(msg.sender, to, tokenId);
    }

    function ownerOf(uint256 _tokenId) public view override returns (address _owner){
        return _kataToOwner[_tokenId];
    }


}



