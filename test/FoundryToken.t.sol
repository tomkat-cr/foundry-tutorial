// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0 <0.8.16;

import "forge-std/Test.sol";

import {Utilities} from "./utils/Utilities.sol";
import {FoundryToken} from "../src/FoundryToken.sol";

contract FoundryTokenTest is Test {
    Utilities internal utils;
    FoundryToken internal token;

    address payable internal alice;
    address payable internal bob;

    function setUp() public {
        utils = new Utilities();
        token = new FoundryToken(1000);

        // Create a user
        address payable[] memory users = utils.createUsers(2);

        // Assign the user 0 as Alice
        alice = users[0];
        vm.label(alice, "Alice");

        // Assign the user 1 as Bob
        bob = users[1];
        vm.label(bob, "Bob");
    }

    function testName() public {
        assertEq(token.name(), "FoundryToken");
    }

    function testSupply() public {
        assertEq(token.totalSupply(), 1000);
    }

    function testOnlyOwnerCanMint() public {
        // The owner can mint more tokens
        token.mintFor(address(this), 1000);
        assertEq(token.totalSupply(), 2000);

        // Alice can't mint more tokens
        vm.startPrank(alice);
        vm.expectRevert(bytes("Ownable: caller is not the owner"));
        token.mintFor(alice, 1000);
    }

    function testSymbol() public {
        assertEq(token.symbol(), "FTK");
    }

    function testTransferBalances() public {
        // Funds to alice anbd bob
        token.transfer(alice, 30);
        token.transfer(bob, 10);

        // Verify initial balances
        assertEq(token.balanceOf(alice), 30);
        assertEq(token.balanceOf(bob), 10);

        // Alice transfer to bob
        vm.startPrank(alice);
        token.transfer(bob, 10);

        // Verify final balances
        assertEq(token.balanceOf(alice), 20);
        assertEq(token.balanceOf(bob), 20);
    }

}
