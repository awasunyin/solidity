pragma solidity ^0.4.19;

/* In lesson 1, we created a function that takes a name, uses it 
to generate a random zombie, and adds that zombie to our app's 
zombie database on the blockchain.*/

contract ZombieFactory {

    // creating an event that fires up a notification to the 
    // front end whenever a new zombie is created
    event NewZombie(uint zombieId, string name, uint dna);

    // declaring state variables
    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;

    // creating a zombie struct
    struct Zombie {
        string name;
        uint dna;
    }

    // dynamic array of zombies
    Zombie[] public zombies;

    // function that creates a zombie
    function _createZombie(string _name, uint _dna) private {
        // takes name and dna, generates an ID and pushes it 
        // to the array of zombies
        uint id = zombies.push(Zombie(_name, _dna)) - 1;
        // fires up the event to notify that there is a 
        // new zombie
        NewZombie(id, _name, _dna);
    } 

    // generates a pseudo-random dna using keccak256 hash function (SHA3)
    function _generateRandomDna(string _str) private view returns (uint) {
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    // creates random zombies
    function createRandomZombie(string _name) public {
        uint randDna = _generateRandomDna(_name);
        _createZombie(_name, randDna);
    }
}