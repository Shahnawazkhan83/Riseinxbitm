//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Lottery {
    address public manager;
    uint256 public ticketPrice;
    uint public lotteryDuration;
    uint public startTime;
    mapping(uint256 => address) public tickets;
    uint public ticketCount;
    bool public lotteryEnded;
    uint256 public winningTicket;

    event TicketPurchased( address indexed participant, uint256 ticketNumber);
    event LotteryEnded(uint256 winningTicket);

    constructor(uint256 _ticketPrice, uint _lotteryDuration){
        manager = msg.sender;
        ticketPrice = _ticketPrice;
        lotteryDuration = _lotteryDuration;
        startTime = block.timestamp;
    }

    function purchaseTicket() public payable{
        require(!lotteryEnded, "Lottery has ended");
        require(msg.value == ticketPrice, "Ticket price is not correct");

        ticketCount++;
        tickets[ticketCount] = msg.sender;
        emit TicketPurchased(msg.sender, ticketCount);
    }

    function endLottery() public{
        require(msg.sender == manager, "Only the manager can end the lottery");
        require(!lotteryEnded, "Lottery has already ended");
        require(block.timestamp >= startTime + lotteryDuration, "Lottery duration has not ended yet");
        lotteryEnded = true;
        winningTicket = generateRandomNumber()%ticketCount +1;
        payable(tickets[winningTicket]).transfer(address(this).balance);

        emit LotteryEnded(winningTicket);
    }

    function generateRandomNumber() private view returns(uint256){
        return uint256(
            keccak256(
                abi.encodePacked(
                    block.timestamp,
                    block.prevrandao,
                    blockhash(block.number - 1)
                )
            )
        );
    }

    function getTicketCount() public view returns(uint256){
        return ticketCount;
    }

    function getTicketAddress(uint256 ticketNumber) public view returns(address){
        return tickets[ticketNumber];
    }
}