// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract AureusRewardsDistributor is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public rewardsToken;
    uint256 public periodFinish;
    uint256 public rewardRate;
    uint256 public lastUpdateTime;
    uint256 public rewardPerTokenStored;

    mapping(address => uint256) public userRewardPerTokenPaid;
    mapping(address => uint256) public rewards;

    event RewardAdded(uint256 reward);
    event RewardPaid(address indexed user, uint256 reward);

    constructor(address _rewardsToken) Ownable(msg.sender) {
        rewardsToken = IERC20(_rewardsToken);
    }

    function notifyRewardAmount(uint256 reward) external onlyOwner {
        if (block.timestamp >= periodFinish) {
            rewardRate = reward / 30 days;
        } else {
            uint256 remaining = periodFinish - block.timestamp;
            uint256 leftover = remaining * rewardRate;
            rewardRate = (reward + leftover) / 30 days;
        }
        lastUpdateTime = block.timestamp;
        periodFinish = block.timestamp + 30 days;
        emit RewardAdded(reward);
    }

    function getReward(address account) public {
        uint256 reward = rewards[account];
        if (reward > 0) {
            rewards[account] = 0;
            rewardsToken.safeTransfer(account, reward);
            emit RewardPaid(account, reward);
        }
    }
}
