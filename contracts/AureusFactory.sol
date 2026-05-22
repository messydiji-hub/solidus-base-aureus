// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "./AureusToken.sol";
import "./AureusFarm.sol";
import "./AureusPool.sol";

contract AureusFactory {
    AureusToken public token;
    AureusFarm public farm;
    AureusPool public pool;
    address public owner;
    bool public initialized;

    event ProtocolDeployed(address token, address farm, address pool);
    event OwnershipTransferred(address indexed previous, address indexed next);

    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function deploy() external onlyOwner {
        require(!initialized, "already deployed");
        initialized = true;

        token = new AureusToken();
        farm = new AureusFarm();
        pool = new AureusPool();

        emit ProtocolDeployed(address(token), address(farm), address(pool));
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }
}
