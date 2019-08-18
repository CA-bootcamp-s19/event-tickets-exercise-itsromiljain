pragma solidity >=0.4.0 <0.7.0;

import "../contracts/EventTickets.sol";

contract Proxy {

    EventTickets public _eventTicket;

    constructor(EventTickets eventTicket) public {
        _eventTicket = eventTicket;
    }

    function buyTickets(uint256 ticketPrice, uint256 ticketNo) public returns(bool){
        (bool success, ) = address(_eventTicket).call.value(ticketPrice)(abi.encodeWithSignature("buyTickets(uint256)",ticketNo));
        return success;
    }

    function getRefund() public {
        _eventTicket.getRefund();
    }

    function() external payable{}

}  

