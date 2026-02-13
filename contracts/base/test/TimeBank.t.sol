// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/TimeBank.sol";

contract TimeBankTest is Test {
    TimeBank public c;
    
    function setUp() public {
        c = new TimeBank();
    }

    function testDeployment() public {
        assertTrue(address(c) != address(0));
    }
}
