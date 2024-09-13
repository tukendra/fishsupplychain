const fishsupplychain = artifacts.require("FishSupplyChain");

module.exports = function (deployer) {
    deployer.deploy(fishsupplychain);
};