// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IAureusPool {
    function addLiquidity(uint256 amountA, uint256 amountB) external;
    function removeLiquidity(uint256 shares) external;
    function swap(address tokenIn, uint256 amountIn) external returns (uint256);
}
