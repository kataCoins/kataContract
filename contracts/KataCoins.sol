pragma solidity ^0.8.17;

import "./Ownable.sol";

contract KataCoins is Ownable {
    uint private nextKataId = 0;

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
    ) external onlyOwner returns (uint) {
        _katas.push(Kata(nextKataId, name, statement, functionDeclaration, test));
        nextKataId ++;
        return nextKataId - 1;
    }

    //renvoyer sans test
    function getAllKata() external view returns (Kata[] memory) {
        return _katas;
    }

    function getKata(uint kataId) external view returns (Kata memory) {
        for (uint i = 0; i < _katas.length; i++) {
            if (_katas[i].id == kataId) {
                return _katas[i];
            }
        }

        revert("Not found");
    }

    function requestExecution() external payable {
        require(msg.value == execFee);
        _allowed_users[msg.sender] = true;
    }





}



