pragma solidity ^0.5.0;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/EventTickets.sol";
import "../contracts/EventTicketsV2.sol";
import "../contracts/ThrowProxy.sol";
import "../contracts/TicketBuyer.sol";

contract TestEventTicket {

    EventTickets eventTickets;
    ThrowProxy proxy;
    TicketBuyer buyer;

    uint public initialBalance = 1 ether;

    function beforeAll() public {
        eventTickets = EventTickets(DeployedAddresses.EventTickets());
        proxy = new ThrowProxy(address(eventTickets));
        //address(buyer).send(500 wei);
        buyer = (new TicketBuyer).value(200 wei)();
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
        uint testTicketPrice = 95 wei;
        EventTickets(address(proxy)).buyTickets(1);
        bool r = proxy.execute(testTicketPrice);
        Assert.isFalse(r, "Buy Ticket should throw an error when there is not enough fund!");
    }

    /*function testBuyTicketWithEnoughFunds() public {
        uint testTicketPrice = 110 wei;
        EventTickets(address(proxy)).buyTickets(1);
        bool r = proxy.execute(testTicketPrice);
        Assert.isTrue(r, "Buyer should be able to buy the tickets");
    }*/

    function testBuyTicketWithEnoughFunds() public {
        uint ticketNo = 1;
        uint testTicketPrice = 150;
        buyer.buyTickets(eventTickets, testTicketPrice, ticketNo);
        (, , uint totalTickets, uint sales, ) = eventTickets.readEvent();
        
        Assert.equal(totalTickets, 99, "The total ticket numbers should match");
        Assert.equal(sales, 1, "The sales numbers should match");
        

        //bool r = proxy.execute.gas(200000)();
        //Assert.isTrue(r, "Buyer should be able to buy the tickets");
        /*(bool res, ) = address(eventTickets).call(abi.encodePacked(bytes4(keccak256("buyTickets(uint256)")), ticketNo));
         if(!res) revert();
        /*(bool res, ) = address(eventTickets).call(abi.encodeWithSignature("buyTickets(uint256)", ticketNo));
        Assert.isTrue(res, "");*/
    }

    function() external{
    }

}