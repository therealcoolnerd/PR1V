const { expect } = require("chai");

describe("GiftLinkFactory", function () {
  it("creates and claims bundle (mocked)", async () => {
    const [creator, recipient] = await ethers.getSigners();
    const GiftLinkFactory = await ethers.getContractFactory("GiftLinkFactory");
    const factory = await GiftLinkFactory.deploy();
    await factory.deployed();

    const commitment = ethers.utils.keccak256(ethers.utils.randomBytes(32));
    await factory.createBundle(commitment, [], Math.floor(Date.now()/1000)+3600);

    const root = ethers.constants.HashZero; // placeholder root since Merkle calc not wired
    await factory.claim(commitment, root, [], recipient.address, []);
    expect((await factory.bundles(commitment)).claimed).to.be.true;
  });
});
