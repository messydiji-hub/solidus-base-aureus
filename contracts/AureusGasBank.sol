// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "../interfaces/IAureusTreasury.sol";

/// @title AureusGasBank
/// @notice Helper contract to cover gas for protocol operations
/// @dev Can be funded and allows authorized callers to withdraw gas stipends
contract AureusGasBank {
    IAureusTreasury public treasury;
    address public owner;

    event GasWithdrawn(address indexed to, uint256 amount);
    event OwnerUpdated(address indexed previous, address indexed current);

    error NotOwner();
    error NotAuthorized();

    modifier onlyOwner() {
        if (msg.sender != owner) revert NotOwner();
        _;
    }

    constructor(address _treasury) {
        treasury = IAureusTreasury(_treasury);
        owner = msg.sender;
    }

    function withdrawGas(address to, uint256 amount) external onlyOwner {
        (bool sent,) = to.call{value: amount}("");
        require(sent, "GasBank: transfer failed");
        emit GasWithdrawn(to, amount);
    }

    function updateOwner(address newOwner) external onlyOwner {
        emit OwnerUpdated(owner, newOwner);
        owner = newOwner;
    }

    receive() external payable {}
}
