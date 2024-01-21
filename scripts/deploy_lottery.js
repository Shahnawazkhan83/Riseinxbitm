const Lottery = artifacts.require("Lottery");

module.exports = function (deployer) {
  const ticketPrice = 0.01; // Set the ticket price in Ether
  const lotteryDuration = 7 * 24 * 60 * 60; // Set the lottery duration in seconds

  deployer.deploy(Lottery, web3.utils.toWei(ticketPrice.toString(), "ether"), lotteryDuration);
};