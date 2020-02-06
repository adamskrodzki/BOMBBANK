const BombBank = artifacts.require("BombBank");
const LBombToken = artifacts.require("LBombToken");
const BOMBv3 = artifacts.require("BOMBv3");
const BombFaucet = artifacts.require("BombFaucet");

module.exports = async function(deployer, network, accounts) {
  console.log("Start", network, accounts);
  var bombAddr = "0x1C95b093d6C236d3EF7c796fE33f9CC6b8606714";
  var lBombAddress = "";
  var bomb;
  if (network != "main") {
    await deployer.deploy(BOMBv3);
    bomb = await BOMBv3.deployed();
    bombAddr = bomb.address;
    console.log("In dev", bombAddr);
  } else {
    bomb = await BOMBv3.at(bombAddr);
  }
  await deployer.deploy(LBombToken);
  var lBomb = await LBombToken.deployed();
  lBombAddress = lBomb.address;
  await deployer.deploy(BombBank, bombAddr, lBombAddress);
  var bank = await BombBank.deployed();
  var bankAddress = bank.address;
  var faucet = undefined;

  await lBomb.setMinter(bankAddress, {
    from: accounts[0]
  });

  var bombBalance = (await bomb.balanceOf.call(accounts[0])).toString();

  if (network != "main") {
    await deployer.deploy(BombFaucet, bombAddr);
    faucet = await BombFaucet.deployed();
    await bomb.transfer(faucet.address, bombBalance);
    console.log("Faucet", faucet.address);
  }

  console.log("Done", bankAddress);
};
