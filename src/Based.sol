// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "lib/solmate/src/tokens/ERC20.sol";

/// @notice gambling token!
contract Based is ERC20 {

    constructor() ERC20("Based Casino Coin", "BASED", 18) {
        owner = msg.sender;
    }

    address public owner;

    uint256 internal priceMultiplier; 

    uint256 internal lastButtonPress;

    address internal ticketHolder;

    function claim() external {
        require(block.timestamp - lastButtonPress >= 30, "GAME_ACTIVE");

       (bool success, ) = ticketHolder.call{ value : address(this).balance }("");

       require(success, "TRANSFER_FAILED");
    }

    function press() external {
        _burn(msg.sender, 1 ether);

        ticketHolder = msg.sender;

        lastButtonPress = block.timestamp;
    }

    function buy(uint256 amount) external payable {
        uint256 cost = amount * ++priceMultiplier / 1e18;

        require(msg.value >= cost, "INSUFFICIENT_ETH");

        _mint(msg.sender, amount);
    }

    function ownerMint(address to, uint256 amount) external {
        require(msg.sender == owner, "NOT_OWNER");

        _mint(to, amount);
    }
}
