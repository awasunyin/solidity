/*In lesson 2, we're going to make our app more game-like: 
We're going to make it multi-player, and we'll also be adding 
a more fun way to create zombies instead of just generating 
them randomly. How will we create new zombies? By having our 
zombies "feed" on other lifeforms!*/

pragma solidity ^0.4.19

contract ZombieFactory {
	event NewZombie(uint zombieId, string name, uint dna);

	uint dnaDigits = 16;
	uint dnaModulus = 10 ** dnaDigits;

	struct Zombie {
		string name;
		uint dna;
	}

	Zombie[] public zombies;

	mapping (uint => address) public zombieToOwner;
    mapping (address => uint) ownerZombieCount;

	function _createZombies(string _name, uint _dna) private {
		uint id = zombies.push(Zombie(_name, _dna)) - 1;
		NewZombie(id, _name, _dna);
	}

	function createRandomZombie(string _name) public {
        require(ownerZombiecount[msg.sender] == 0);
		uint randDna = _generateRandomDna(_name);
		_createZombie(_name, randDna);
	}
}