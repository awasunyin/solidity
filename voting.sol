pragma solidity ^0.4.11;

// vote counting is automatic and completely transparent at the same time
/// @title Voting with delegation.
contract Ballot {

	struct Voter {
		uint weight;
		bool voted;
		address delegate;
		uint vote;
	}

	struct Proposal {
		bytes32 name; //name of proposal 
		uint voteCount; //accumulated votes
	}

	address public chairperson; 

	mapping(address => Voter) public voters;

	Proposal[] public proposals;

	function Ballot(bytes32[] proposalNames) {
		chairperson = msg.sender;
		voters[chairperson].weight = 1;

		for (uint i = 0; i < proposalNames.length; i++) {
			// `Proposal({...})` creates a temporary
            // Proposal object and `proposals.push(...)`
            // appends it to the end of `proposals`.
			proposals.push(Proposal({	
				name: proposalNames[i],
				voteCount: 0
			}));
		}
	}

	function giveRightToVote(address voter)  {
		require((msg.sender == chairperson) && !voters[voter].voted  && (voters[voter].weight == 0));
		voters[voter].weight = 1;
	}

    /// Delegate your vote to the voter `to`.
	function delegate(address to) {
		Voter storage sender = voters[msg.sender]; 
		require(!sender.voted);

		require(to != msg.sender);

		while (voters[to].delegate != address(0)) {
			to = voters[to].delegate;
			require(to != msg.sender);
		}

		sender.voted = true;
		sender.delegate = to;
		Voter storage delegate = voters[to];
		if (delegate.voted) {
			proposals[delegate.vote].voteCount += sender.weight;
		} else {
			delegate.weight += sender.weight;
		}
	}

	function vote(uint proposal) {
		Voter storage sender = voters[msg.sender];
		require(!sender.voted);
		render.voted = true;
		sender.vote = proposal;

		proposals[proposal].voteCount += sender.weight; 
	}

	function winningProposal() constant 
		returns (uint winningProposal) {
			uint winningVoteCount = 0; 
			for (uint p = 0; p < proposals.length; p++) {
				if (proposals[p].voteCount > winningVoteCount) {
					winningVoteCount = proposals[p].voteCount;
					winningProposal = p;
				}
			}
		}

	function winnerName() constant
		returns (bytes32 winnerName) {
			winnerName = proposals[winningProposal()].name;
		}
}
