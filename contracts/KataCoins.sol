pragma solidity ^0.8.17;

import "./Ownable.sol";

contract KataCoins is Ownable {
    uint execFee = 0.001 ether;
    Kata[] private _katas;
    mapping(uint => address) internal _kataToOwner;

    //Les utilisateurs ayant payé pour executer un kata
    mapping(address => bool) _allowed_users;

    struct Kata {
        uint id;
        string name;
        //Enoncé du kata
        string statement;
        string functionDeclaration;
        //Ne pas les envoyer au front
        string test;
    }

    function changeLevelUpFee(uint newFee) public onlyOwner {
        execFee = newFee;
    }

    function createKata(
        string calldata name,
        string calldata statement,
        string calldata functionDeclaration,
        string calldata test 
    ) external onlyOwner {
        _katas.push(Kata(0, name, statement, functionDeclaration, test));
    }

    //renvoyer sans test
    function getAllKata() external view returns (Kata[] memory) {
        return _katas;
    }

    function getKata(uint kataId) external view returns (Kata memory) {
        return _katas[kataId];
    }

    function requestExecution() external payable {
        require(msg.value == execFee);
        _allowed_users[msg.sender] = true;
    }





}



