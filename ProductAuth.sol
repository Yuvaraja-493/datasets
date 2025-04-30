// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProductAuth {
    address public owner;

    struct Product {
        string name;
        string manufacturer;
        string batchId;
        uint timestamp;
        bool isRegistered;
    }

    mapping(bytes32 => Product) public products;

    constructor() {
        owner = msg.sender;
    }

    function registerProduct(string memory name, string memory manufacturer, string memory batchId) public {
        require(msg.sender == owner, "Only owner can register");

        bytes32 productHash = keccak256(abi.encodePacked(name, manufacturer, batchId));
        require(!products[productHash].isRegistered, "Product already registered");

        products[productHash] = Product(name, manufacturer, batchId, block.timestamp, true);
    }

    function verifyProduct(string memory name, string memory manufacturer, string memory batchId) public view returns (bool, uint) {
        bytes32 productHash = keccak256(abi.encodePacked(name, manufacturer, batchId));
        if (products[productHash].isRegistered) {
            return (true, products[productHash].timestamp);
        }
        return (false, 0);
    }
}
