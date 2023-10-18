// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import "lib/solmate/src/tokens/ERC20.sol";

/// @notice gambling token!
contract Based is ERC20 {

    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol, 18) {
        owner = msg.sender;
    }

    address public owner; // 0x00000000000000000

    uint256 internal priceMultiplier; // 0

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


    function buy() external payable returns (uint256 amount) {
        amount = msg.value / ++priceMultiplier;

        _mint(msg.sender, amount);
    }

    function ownerMint(address to, uint256 amount) external {
        require(msg.sender == owner, "NOT_OWNER");

        _mint(to, amount);
    }
}
