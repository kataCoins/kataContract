pragma solidity ^0.8.9;

import "./Ownable.sol";

contract KataCoins is Ownable{
    Kata[] kata;
    string _runnerUrl = "TODO";


    struct Kata {
        string name;
        //Enoncé du kata
        string statement;
    }

    struct KataRun {
        string language;
        //Enoncé du kata
        string code;
        address kataId;
    }

    function changeRunnerUrl(string calldata newUrl) public onlyOwner{
        _runnerUrl = newUrl;
    }

    //??
    function runKata(string calldata files) public {
        //Zipper fichier et encoder en base64 -> faire côté front

    }

    function execCode() private {


    }

    function createKata() public {

    }

}



