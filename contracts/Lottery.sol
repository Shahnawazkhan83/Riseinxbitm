// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Lottery {
    address public manager;        // Address of the manager who initiated the lottery
    uint256 public ticketPrice;    // Price of a single lottery ticket
    uint public lotteryDuration;    // Duration of the lottery in seconds
    uint public startTime;          // Start time of the lottery
    mapping(uint256 => address) public tickets;   // Mapping to store ticket numbers and their respective owners
    uint public ticketCount;        // Total count of purchased tickets
    bool public lotteryEnded;       // Flag indicating whether the lottery has ended
    uint256 public winningTicket;   // The winning ticket number

    // Event emitted when a ticket is purchased
    event TicketPurchased(address indexed participant, uint256 ticketNumber);

    // Event emitted when the lottery ends with the winning ticket
    event LotteryEnded(uint256 winningTicket);

    // Constructor to initialize the contract with the ticket price and lottery duration
    constructor(uint256 _ticketPrice, uint _lotteryDuration) {
        manager = msg.sender;
        ticketPrice = _ticketPrice;
        lotteryDuration = _lotteryDuration;
        startTime = block.timestamp;
    }

    // Function to allow participants to purchase lottery tickets
    function purchaseTicket() public payable {
        // Ensure the lottery is ongoing
        require(!lotteryEnded, "Lottery has ended");

        // Ensure the sent value matches the ticket price
        require(msg.value == ticketPrice, "Ticket price is not correct");

        // Increment ticket count
        ticketCount++;

        // Record the participant and emit an event
        tickets[ticketCount] = msg.sender;
        emit TicketPurchased(msg.sender, ticketCount);
    }

    // Function to allow the manager to end the lottery
    function endLottery() public {
        // Only the manager can end the lottery
        require(msg.sender == manager, "Only the manager can end the lottery");

        // Ensure the lottery hasn't ended already
        require(!lotteryEnded, "Lottery has already ended");

        // Ensure the lottery duration has passed
        require(block.timestamp >= startTime + lotteryDuration, "Lottery duration has not ended yet");

        // Mark the lottery as ended
        lotteryEnded = true;

        // Generate a random winning ticket and transfer funds to the winner
        winningTicket = generateRandomNumber() % ticketCount + 1;
        payable(tickets[winningTicket]).transfer(address(this).balance);

        // Emit an event indicating the winning ticket
        emit LotteryEnded(winningTicket);
    }

    // Function to generate a random number for picking the winning ticket
    function generateRandomNumber() private view returns(uint256) {
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

    // Function to get the total count of purchased tickets
    function getTicketCount() public view returns(uint256) {
        return ticketCount;
    }

    // Function to get the address of the participant owning a specific ticket
    function getTicketAddress(uint256 ticketNumber) public view returns(address) {
        return tickets[ticketNumber];
    }
}
