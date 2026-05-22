// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract AureusDistributor is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    IERC20 public rewardToken;
    uint256 public totalAllocation;
    uint256 public distributed;
    mapping(address => uint256) public allocations;
    mapping(address => uint256) public claimed;

    event AllocationSet(address indexed recipient, uint256 amount);
    event RewardClaimed(address indexed recipient, uint256 amount);
    event TokensRecovered(address indexed token, uint256 amount);

    constructor(address _rewardToken) Ownable(msg.sender) {
        rewardToken = IERC20(_rewardToken);
    }

    function setAllocations(address[] calldata recipients, uint256[] calldata amounts) external onlyOwner {
        require(recipients.length == amounts.length, "Distributor: length mismatch");
        for (uint256 i = 0; i < recipients.length; i++) {
            _setAllocation(recipients[i], amounts[i]);
        }
    }

    function _setAllocation(address recipient, uint256 amount) internal {
        if (allocations[recipient] > 0) {
            totalAllocation -= allocations[recipient];
        }
        allocations[recipient] = amount;
        totalAllocation += amount;
        emit AllocationSet(recipient, amount);
    }

    function claim() external nonReentrant {
        uint256 amount = allocations[msg.sender] - claimed[msg.sender];
        require(amount > 0, "Distributor: nothing to claim");
        claimed[msg.sender] += amount;
        distributed += amount;
        rewardToken.safeTransfer(msg.sender, amount);
        emit RewardClaimed(msg.sender, amount);
    }

    function recoverTokens(address token, uint256 amount) external onlyOwner {
        IERC20(token).safeTransfer(owner(), amount);
        emit TokensRecovered(token, amount);
    }
}
