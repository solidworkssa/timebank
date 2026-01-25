// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TimeBank {
    mapping(address => uint256) public timeBalance;
    mapping(uint256 => Exchange) public exchanges;
    uint256 public exchangeCounter;

    struct Exchange {
        address provider;
        address receiver;
        uint256 hours;
        string service;
        uint256 timestamp;
        bool completed;
    }

    event TimeEarned(address indexed user, uint256 hours);
    event TimeSpent(address indexed user, uint256 hours);
    event ExchangeCreated(uint256 indexed exchangeId, address provider, address receiver);

    error InsufficientTime();

    function earnTime(uint256 hours) external {
        timeBalance[msg.sender] += hours;
        emit TimeEarned(msg.sender, hours);
    }

    function createExchange(address provider, uint256 hours, string memory service) external returns (uint256) {
        if (timeBalance[msg.sender] < hours) revert InsufficientTime();
        timeBalance[msg.sender] -= hours;

        uint256 exchangeId = exchangeCounter++;
        exchanges[exchangeId] = Exchange(provider, msg.sender, hours, service, block.timestamp, false);
        emit ExchangeCreated(exchangeId, provider, msg.sender);
        return exchangeId;
    }

    function completeExchange(uint256 exchangeId) external {
        Exchange storage exchange = exchanges[exchangeId];
        exchange.completed = true;
        timeBalance[exchange.provider] += exchange.hours;
        emit TimeSpent(exchange.receiver, exchange.hours);
    }

    function getBalance(address user) external view returns (uint256) {
        return timeBalance[user];
    }
}
