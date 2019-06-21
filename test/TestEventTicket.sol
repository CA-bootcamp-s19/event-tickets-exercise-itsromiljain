pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EventTickets.sol";
import "../contracts/EventTicketsV2.sol";
import "../contracts/ThrowProxy.sol";

contract TestEventTicket {

    EventTickets eventTickets;
    ThrowProxy proxy;

    function beforeAll() public {
        eventTickets = EventTickets(DeployedAddresses.EventTickets());
        proxy = new ThrowProxy(address(eventTickets));
    }

    function testConstructor() public {
        string memory expectedDescription = "description";
        string memory expectedURL = "URL";
        uint expectedTotalTicket = 100;
        bool expectedSaleOpen = true;
        uint expectedSales = 0;
        (string memory description, string memory website, uint totalTickets, uint sales, bool isOpen) = eventTickets.readEvent();
        Assert.equal(eventTickets.owner(), msg.sender, "The owner of the contract should be initialized.");
        Assert.equal(description, expectedDescription, "The description should match");
        Assert.equal(website, expectedURL, "The website url should match");
        Assert.equal(totalTickets, expectedTotalTicket, "The total ticket numbers should match");
        Assert.equal(sales, expectedSales, "The sales numbers should match");
        Assert.equal(isOpen, expectedSaleOpen, "The event should be open");
    }

  function testBuyTicketWithNotEnoughFunds() public {
        uint testTicketPrice = 99 wei;
        EventTickets(address(proxy)).buyTickets(1);
        bool r = proxy.execute(testTicketPrice);
        Assert.isFalse(r, "Buy Ticket should throw an error when there is not enough fund!");
    }

    /*function testBuyTicketWithEnoughFunds() public {
        uint testTicketPrice = 150;
        uint ticketNo = 1;
        EventTickets(address(proxy)).buyTickets.value(testTicketPrice)(ticketNo);
        //eventTickets.buyTickets.value(testTicketPrice)(1);
        //(bool res, ) = address(eventTickets).call(abi.encodePacked(bytes4(keccak256("buyTickets(uint256)")), ticketNo));
        //if(!res) revert();
        //(, , uint totalTickets, uint sales, ) = eventTickets.readEvent();
        //Assert.equal(totalTickets, 99, "Total ticket remaining should match");
        //Assert.equal(sales, 1, "Total sales should match");
    }*/

    function() external{
    }

}