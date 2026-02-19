// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TimeBank Contract
/// @author solidworkssa
/// @notice Time-based skill exchange platform.
contract TimeBank {
    string public constant VERSION = "1.0.0";


    mapping(address => uint256) public credits;
    
    function mint(address _to, uint256 _hours) external {
        // Only admin normally
        credits[_to] += _hours;
    }
    
    function transfer(address _to, uint256 _hours) external {
        require(credits[msg.sender] >= _hours, "Insufficient credits");
        credits[msg.sender] -= _hours;
        credits[_to] += _hours;
    }

}
