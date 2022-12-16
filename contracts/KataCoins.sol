pragma solidity ^0.8.9;

import "./Ownable.sol";

contract KataCoins is Ownable {
    Kata[] memory private _katas;
    mapping(uint => address) private _kata_to_owner;

    //Les utilisateurs ayant payé pour executer un kata
    address[] _allowed_users;

    struct Kata {
        uint id;
        string name;
        //Enoncé du kata
        string statement;
        string functionDeclaration;
        //Ne pas les envoyer au front
        string test;
    }

    function createKata(
        string calldata name,
        string calldata statement,
        string calldata functionDeclaration,
        string calldata test 
    ) external onlyOwner {
        _kata.push(Kata(name, statement, functionDeclaration, test));
    }

    //renvoyer sans test
    function getAllKata() external view returns (Kata[] memory) {
        //should only return name, statement, functionDeclaration
        return _kata;
    }

    function getKata(address kataAddress) external view returns (Kata memory) {
        return _kata[kataAddress];
    }

    function requestExecution(address kataAddress) external payable {
        require(msg.value == levelUpFee);
        _allowed_users.push(msg.sender);
    }





}



