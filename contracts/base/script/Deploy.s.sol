// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Script.sol";
import "../src/TimeBank.sol";

contract Deploy is Script {
    function run() external {
        vm.startBroadcast();
        new TimeBank();
        vm.stopBroadcast();
    }
}
