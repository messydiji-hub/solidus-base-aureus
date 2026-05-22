// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

abstract contract AureusBase is Ownable, Pausable {
    uint256 public constant VERSION = 1;

    event ContractUpdated(string indexed name, address indexed newAddress);

    constructor(address initialOwner) Ownable(initialOwner) {}

    modifier nonZero(address addr) {
        require(addr != address(0), "zero address");
        _;
    }

    modifier nonZeroAmount(uint256 amount) {
        require(amount > 0, "zero amount");
        _;
    }

    function pause() external onlyOwner {
        _pause();
    }

    function unpause() external onlyOwner {
        _unpause();
    }

    function _checkPaused() internal view whenNotPaused {}
}
