// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";

import "src/Based.sol";

contract BasedTest is Test {

    address owner = address(uint160(uint256(keccak256("based owner"))));
    address trader = address(uint160(uint256(keccak256("sucker"))));

    Based based;

    function setUp() public {
        based = new Based("Based Coin", "BASED");

        deal(owner, 10_000 ether);
        deal(trader, 10_000 ether);
    }

    function testBuy() public {
        vm.prank(trader);
        uint256 amount = based.buy{ value: 10 ether }();

        assertEq(amount, based.balanceOf(trader));
    }

    function testPress() public {
        vm.prank(trader);
        based.buy{ value: 10 ether }();

        vm.prank(trader);
        based.press();

        assertEq(based.balanceOf(trader), 0);
    }
}
