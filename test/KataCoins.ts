import {expect} from "chai";
import {ethers, web3} from "hardhat";
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
        expect(katas[0].kata.name).to.equal(kataName);
        expect(katas[0].kata.statement).to.equal(kataStatement);
        expect(katas[0].kata.functionDeclaration).to.equal(kataFunctionDeclaration);
        expect(katas[0].kata.test).to.equal(kataTest);
        expect(katas[0].isOwned).to.equal(false);
    });

    it("Should get one kata", async function () {
        const rep = await KataCoinsContract.getKata(kata1ID);
        const kata = rep[0];
        const owned = rep[1];

        expect(kata.name).to.equal(kataName);
        expect(kata.statement).to.equal(kataStatement);
        expect(kata.functionDeclaration).to.equal(kataFunctionDeclaration);
        expect(kata.test).to.equal(kataTest);
    });

    it("Should not allow to try", async function () {
        expect( KataCoinsContract.connect(owner).executeKata(user1.address) ).rejectedWith("kata already owned");
    });

    it("Should pay 20 try and get it", async function () {
        await KataCoinsContract.connect(user1).payCredit(20, {value: web3.utils.toWei("0.020", 'ether')});
        expect(await KataCoinsContract.connect(user1).getCredit()).equal(20);
    });

    it("Should exec 20 kata and not 21", async function () {
        for (let i = 0; i < 20; i++) {
            expect(async function () {
                await KataCoinsContract.connect(owner).executeKata(user1.address, kata1ID);
            }).to.not.throw();
            expect((await KataCoinsContract.connect(user1).getCredit()).toNumber()).equal(19 - i);
        }

        expect( KataCoinsContract.connect(owner).executeKata(user1.address) ).rejectedWith("kata already owned");
    });

    it("Should take ownership", async function () {
        await KataCoinsContract.connect(owner).setHasSolvedKata(user1.address, kata1ID);
        await KataCoinsContract.connect(user1).mintKata(kata1ID);
        expect(await KataCoinsContract.ownerOf(kata1ID)).to.equal(user1.address);
    });

    it("Should not take ownership if already owned", async function () {
        expect( KataCoinsContract.connect(user1).mintKata(kata1ID)).rejectedWith("kata already owned");
    });

});

