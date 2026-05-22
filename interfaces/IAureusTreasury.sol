// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IAureusTreasury {
    function deposit(address token, uint256 amount) external;
    function withdraw(address token, address to, uint256 amount) external;
    function addStrategy(address target, bytes calldata data, uint256 value) external;
}
