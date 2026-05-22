// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract AureusPool is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    IERC20 public tokenA;
    IERC20 public tokenB;
    uint256 public reserveA;
    uint256 public reserveB;
    uint256 public totalLiquidity;
    mapping(address => uint256) public liquidity;

    event LiquidityAdded(address indexed provider, uint256 amountA, uint256 amountB);
    event LiquidityRemoved(address indexed provider, uint256 amountA, uint256 amountB);
    event Swapped(address indexed user, address tokenIn, address tokenOut, uint256 amountIn, uint256 amountOut);

    constructor(address _tokenA, address _tokenB) Ownable(msg.sender) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
    }

    function addLiquidity(uint256 amountA, uint256 amountB) external nonReentrant {
        tokenA.safeTransferFrom(msg.sender, address(this), amountA);
        tokenB.safeTransferFrom(msg.sender, address(this), amountB);
        uint256 shares;
        if (totalLiquidity == 0) {
            shares = _sqrt(amountA * amountB);
        } else {
            shares = _min(amountA * totalLiquidity / reserveA, amountB * totalLiquidity / reserveB);
        }
        require(shares > 0, "Pool: zero shares");
        reserveA += amountA;
        reserveB += amountB;
        totalLiquidity += shares;
        liquidity[msg.sender] += shares;
        emit LiquidityAdded(msg.sender, amountA, amountB);
    }

    function removeLiquidity(uint256 shares) external nonReentrant {
        require(shares > 0 && liquidity[msg.sender] >= shares, "Pool: insufficient shares");
        uint256 amountA = shares * reserveA / totalLiquidity;
        uint256 amountB = shares * reserveB / totalLiquidity;
        liquidity[msg.sender] -= shares;
        totalLiquidity -= shares;
        reserveA -= amountA;
        reserveB -= amountB;
        tokenA.safeTransfer(msg.sender, amountA);
        tokenB.safeTransfer(msg.sender, amountB);
        emit LiquidityRemoved(msg.sender, amountA, amountB);
    }

    function swap(address tokenIn, uint256 amountIn) external nonReentrant returns (uint256) {
        require(amountIn > 0, "Pool: zero amount");
        bool isTokenA = address(tokenIn) == address(tokenA);
        require(isTokenA || address(tokenIn) == address(tokenB), "Pool: invalid token");
        IERC20(tokenIn).safeTransferFrom(msg.sender, address(this), amountIn);
        (uint256 resIn, uint256 resOut) = isTokenA ? (reserveA, reserveB) : (reserveB, reserveA);
        uint256 amountOut = amountIn * resOut / (resIn + amountIn);
        require(amountOut > 0, "Pool: zero output");
        if (isTokenA) {
            reserveA += amountIn;
            reserveB -= amountOut;
            tokenB.safeTransfer(msg.sender, amountOut);
        } else {
            reserveB += amountIn;
            reserveA -= amountOut;
            tokenA.safeTransfer(msg.sender, amountOut);
        }
        emit Swapped(msg.sender, tokenIn, isTokenA ? address(tokenB) : address(tokenA), amountIn, amountOut);
        return amountOut;
    }

    function _sqrt(uint256 y) internal pure returns (uint256 z) {
        if (y > 3) {
            z = y;
            uint256 x = y / 2 + 1;
            while (x < z) { z = x; x = (y / x + x) / 2; }
        } else if (y != 0) { z = 1; }
    }

    function _min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}
