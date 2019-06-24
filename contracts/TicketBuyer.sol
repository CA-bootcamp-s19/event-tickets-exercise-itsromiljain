pragma solidity >=0.4.0 <0.7.0;

import "./EventTickets.sol";

contract TicketBuyer {

    constructor() public payable{}

    function buyTickets(EventTickets _eventTicket, uint ticketPrice, uint ticketNo) public {
        _eventTicket.buyTickets.value(ticketPrice)(ticketNo);
    }

    function() external payable{
    }

}