// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract AureusTreasury is AccessControl, ReentrancyGuard {
    using SafeERC20 for IERC20;

    bytes32 public constant STRATEGIST_ROLE = keccak256("STRATEGIST_ROLE");
    bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");

    struct Strategy {
        address target;
        bytes callData;
        uint256 value;
        bool active;
    }

    uint256 public strategyCount;
    mapping(uint256 => Strategy) public strategies;
    mapping(address => uint256) public tokenBalances;

    event AssetDeposited(address indexed token, uint256 amount);
    event AssetWithdrawn(address indexed token, address indexed to, uint256 amount);
    event StrategyExecuted(uint256 indexed strategyId);
    event StrategyAdded(uint256 indexed strategyId, address target);

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(ADMIN_ROLE, msg.sender);
    }

    function deposit(address token, uint256 amount) external nonReentrant {
        IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
        tokenBalances[token] += amount;
        emit AssetDeposited(token, amount);
    }

    function withdraw(address token, address to, uint256 amount) external onlyRole(ADMIN_ROLE) nonReentrant {
        require(tokenBalances[token] >= amount, "Treasury: insufficient balance");
        tokenBalances[token] -= amount;
        IERC20(token).safeTransfer(to, amount);
        emit AssetWithdrawn(token, to, amount);
    }

    function addStrategy(address target, bytes calldata data, uint256 value) external onlyRole(STRATEGIST_ROLE) {
        strategyCount++;
        strategies[strategyCount] = Strategy(target, data, value, true);
        emit StrategyAdded(strategyCount, target);
    }

    function executeStrategy(uint256 strategyId) external onlyRole(STRATEGIST_ROLE) nonReentrant {
        Strategy storage s = strategies[strategyId];
        require(s.active, "Treasury: strategy not active");
        (bool success,) = s.target.call{value: s.value}(s.callData);
        require(success, "Treasury: strategy failed");
        emit StrategyExecuted(strategyId);
    }

    function toggleStrategy(uint256 strategyId) external onlyRole(ADMIN_ROLE) {
        strategies[strategyId].active = !strategies[strategyId].active;
    }
}
