// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AuctionHouse {
    address public owner;
    string public item;

    uint public auctionEndTime;
    address private highestBidder; 

    uint private highestBid;       
    bool public ended;

    mapping(address => uint) public bids;
    address[] public bidders;

  
    constructor(string memory _item, uint _biddingTime) {//constructor是可以在合约外开始执行，并且只会执行一次
        owner = msg.sender;//谁发起了拍卖
        item = _item;
        auctionEndTime = block.timestamp + _biddingTime;
    }

   //用户开始竞拍
    function bid(uint amount) external {
        require(block.timestamp < auctionEndTime, "Auction has already ended.");//“，”后是前段如果fase了的话，就执行
        require(amount > 0, "Bid amount must be greater than zero.");
        require(amount > bids[msg.sender], "New bid must be higher than your current bid.");

        // Track new bidders
        if (bids[msg.sender] == 0) {//怕会有重复提交
            bidders.push(msg.sender);
        }

        bids[msg.sender] = amount;

        // Update the highest bid and bidder
        if (amount > highestBid) {
            highestBid = amount;
            highestBidder = msg.sender;
        }
    }

   
    function endAuction() external {
        require(block.timestamp >= auctionEndTime, "Auction hasn't ended yet.");
        require(!ended, "Auction end already called.");

        ended = true;
    }

    // Get a list of all bidders
    function getAllBidders() external view returns (address[] memory) {//external是可以在合约外执行
        return bidders;
    }

    // Retrieve winner and their bid after auction ends
    function getWinner() external view returns (address, uint) {
        require(ended, "Auction has not ended yet.");
        return (highestBidder, highestBid);
    }
}