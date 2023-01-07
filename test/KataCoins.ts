import {expect} from "chai";
import {ethers} from "hardhat";
import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/src/signers";
import {Contract, ContractFactory} from "ethers";
import {KataCoins} from "../typechain-types";

describe("Katas", function () {
    let owner: SignerWithAddress,
        user1: SignerWithAddress;

    let ownerAddress: string;
    let KataCoinsContractFactory: ContractFactory, KataCoinsContract: Contract;

    const kataName = "Kata 1";
    const kataStatement = "Statement 1";
    const kataFunctionDeclaration = "functionDeclaration 1";
    const kataTest = "test 1";
    let kata1ID: any;

    before(async function () {
        // @ts-ignore
        [owner, user1] = await ethers.getSigners();
        ownerAddress = await owner.getAddress();

        KataCoinsContractFactory = await ethers.getContractFactory("KataCoins");
        KataCoinsContract = await KataCoinsContractFactory.connect(owner).deploy();



    });

    it("Should create a new kata", async function () {
        kata1ID = (await KataCoinsContract.createKata(kataName, kataStatement, kataFunctionDeclaration, kataTest)).value;
        const katas = await KataCoinsContract.getAllKata();

        expect(katas.length).to.equal(1);
        expect(katas[0].name).to.equal(kataName);
        expect(katas[0].statement).to.equal(kataStatement);
        expect(katas[0].functionDeclaration).to.equal(kataFunctionDeclaration);
        expect(katas[0].test).to.equal(kataTest);
    });

    it("Should get one kata", async function () {
        const rep = await KataCoinsContract.getKata( kata1ID);
        const kata = rep[0];
        const owned = rep[1];

        expect(kata.name).to.equal(kataName);
        expect(kata.statement).to.equal(kataStatement);
        expect(kata.functionDeclaration).to.equal(kataFunctionDeclaration);
        expect(kata.test).to.equal(kataTest);
    });


    it("Should pay 1 try", async function () {
        const rep = await KataCoinsContract.payCredit( 1);

        //console.log(rep);
    });

});
