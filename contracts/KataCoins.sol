pragma solidity ^0.8.9;

import "./Ownable.sol";

contract KataCoins is Ownable {
    mapping(address => Kata) private _kata;

    struct Kata {
        string name;
        //Enoncé du kata
        string statement;
        string functionDeclaration;
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

    function getAllKata() external view returns (Kata[] memory) {
        return _kata;
    }

    function getKata(address kataAddress) external view returns (Kata memory) {
        return _kata[kataAddress];
    }



}



