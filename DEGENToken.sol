pragma solidity ^0.8.20;

import "@openzeppelin/contracts@5.0.2/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@5.0.2/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts@5.0.2/access/Ownable.sol";

contract DegenToken is ERC20, ERC20Burnable, Ownable {
    // Arrays for storing redeemable items and their token prices
    string[] public items;
    uint256[] public itemPrices;

    // Mapping to store redeemed items by user
    mapping(address => string[]) public redeemedItems;

    constructor(address initialOwner) 
        ERC20("DegenToken", "DGN") 
        Ownable(initialOwner) 
    {
        // Predefined Warzone-style items
        items.push("M4 Assault Rifle");        // Item 1
        items.push("AK-47");                   // Item 2
        items.push("Sniper Rifle");            // Item 3
        items.push("Bulletproof Vest");        // Item 4
        items.push("Grenades");                // Item 5
        items.push("Tactical Helmet");         // Item 6
        items.push("Medkit");                  // Item 7
        items.push("Ammo Pack");               // Item 8
        items.push("Drone");                   // Item 9
        items.push("Armored Vehicle");         // Item 10

        // Corresponding token prices for items
        itemPrices.push(200);  // M4 Assault Rifle
        itemPrices.push(180);  // AK-47
        itemPrices.push(250);  // Sniper Rifle
        itemPrices.push(150);  // Bulletproof Vest
        itemPrices.push(50);   // Grenades
        itemPrices.push(100);  // Tactical Helmet
        itemPrices.push(120);  // Medkit
        itemPrices.push(60);   // Ammo Pack
        itemPrices.push(300);  // Drone
        itemPrices.push(500);  // Armored Vehicle
    }

    
    function redeem(uint256 itemId) public {
        require(itemId < items.length, "Item does not exist");

        // Ensure the sender has enough tokens to redeem the item
        uint256 price = itemPrices[itemId];
        require(balanceOf(msg.sender) >= price, "Insufficient balance");

        // Burn tokens from the user's account
        _burn(msg.sender, price);

        // Add the redeemed item to the user's list
        redeemedItems[msg.sender].push(items[itemId]);

        // Emit an event to log the redemption
        emit Redeemed(msg.sender, items[itemId], price);
    }

    // Event to log item redemption
    event Redeemed(address indexed user, string item, uint256 amount);

    // Function to mint new tokens (Only owner can mint)
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Function to get the list of redeemed items for a specific user
    function getRedeemedItems(address user) public view returns (string[] memory) {
        return redeemedItems[user];
    }

    // Override the decimals function to return 0, ensuring tokens are whole numbers
    function decimals() public pure override returns (uint8) {
        return 0; // 100 tokens will be equal to 100 tokens only
    }

    // Get balance of the caller
    function getBalance() external view returns (uint256) {
        return balanceOf(msg.sender);
    }

    // Custom transfer function with extra balance check
    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(balanceOf(msg.sender) >= amount, "You do not have enough Degen Tokens");
        _transfer(msg.sender, recipient, amount);
        emit Transfer(msg.sender, recipient, amount);
        return true; 
    }
}
