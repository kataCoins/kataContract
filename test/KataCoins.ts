import {expect} from "chai";
import {ethers} from "hardhat";
import {SignerWithAddress} from "@nomiclabs/hardhat-ethers/src/signers";
import {Contract, ContractFactory} from "ethers";

describe("Kata creation", function () {
    let owner: SignerWithAddress,
        user1: SignerWithAddress;

    let ownerAddress: string;
    let KataCoinsContractFactory: ContractFactory, KataCoinsContract: Contract;

    before(async function () {
        // @ts-ignore
        [owner, user1] = await ethers.getSigners();
        ownerAddress = await owner.getAddress();

        KataCoinsContractFactory = await ethers.getContractFactory("KataCoins");
        KataCoinsContract = await KataCoinsContractFactory.connect(owner).deploy();

    });

    it("Should create a new kata", async function () {
        await KataCoinsContract.connect(owner).createKata("Kata 1", "K1", "test()", "test");
        expect((await KataCoinsContract.getAllKata()).length).to.equal(1);
    });


});
