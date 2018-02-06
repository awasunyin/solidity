pragma solidity ^0.4.11;

contract simpleAuction {
	address public beneficiary;
	uint public auctionEnd;

	address public highestBidder;
	uint public highestBid; 

	mapping(address => uint) pendingReturns;

	bool ended; 

	event HighestBidIncreased(address bidder, uint amount);
	event auctionEnded(address winner, uint amount);

	function bid() payable {
		require(now <= auctionEnd);
		require(msg.value > highestBid);
		if (highestBidder != 0) {
			pendingReturns[highestBidder] += highestBid;
		}
		highestBidder = msg.sender;
		highestBid = msg.value;
		HighestBidIncreased(msg.sender, msg.value);
	}

	function withdraw() returns (bool) {
		uint amount = pendingReturns[msg.sender];
		if (amount > 0) {
			pendingReturns[msg.sender] = 0;
			if (!msg.sender.send(amount)) {
				pendingReturns[msg.sender] = amount;
				return false;
			}
		}
		return true;
	}

	function auctionEnd() {
		require(now >= auctionEnd);
		require(!ended);
		ended = true;
		AuctionEnded(highestBidder, highestBid);

		beneficiary.transfer(highestBid);
	}
}

