
pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";

contract DegenToken is ERC20, ERC20Burnable, Ownable {
    // Arrays for storing food items and their prices
    string[] public foodItems;
    uint256[] public foodPrices;

    constructor(address initialOwner)
        ERC20("DegenToken", "DGN")
        Ownable(initialOwner)
    {
        
        foodItems.push("Pizza Hut Pizza");
        foodItems.push("Domino's Pizza");
        foodItems.push("Subway Sandwich");
        foodItems.push("Starbucks Coffee");

        foodPrices.push(50); 
        foodPrices.push(60); 
        foodPrices.push(40); 
        foodPrices.push(30); 
    }

    // Function to redeem a food item based on itemId
    function redeem(uint256 itemId) public {
       
        require(itemId < foodItems.length, "Item does not exist");

        // Ensure the sender has enough tokens to redeem the item
        uint256 price = foodPrices[itemId];
        require(balanceOf(msg.sender) >= price, "Insufficient balance");

        
        _burn(msg.sender, price);

        
        emit Redeemed(msg.sender, foodItems[itemId], price);
    }

    // Event to log the redemption of items
    event Redeemed(address indexed user, string item, uint256 amount);

    // Function to mint new tokens
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    
    function decimals() public pure override returns (uint8) {
        return 0; // 100 tokens will be equal to 100 tokens only
    }

    // Get balance of the caller
    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    // Get a food item by index
    function getFoodItem(uint256 index) public view returns (string memory) {
        require(index < foodItems.length, "Item index out of bounds");
        return foodItems[index];
    }

    
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(balanceOf(msg.sender) >= amount, "You do not have enough Degen Tokens");
        _transfer(msg.sender, recipient, amount);
        emit Transfer(msg.sender, recipient, amount);
        return true; 
    }
}
