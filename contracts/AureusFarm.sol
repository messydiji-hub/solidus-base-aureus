// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

contract AureusFarm is Ownable, ReentrancyGuard {
    using SafeERC20 for IERC20;

    struct Pool {
        IERC20 stakingToken;
        IERC20 rewardToken;
        uint256 rewardRate;
        uint256 lastUpdateTime;
        uint256 rewardPerTokenStored;
        uint256 totalStaked;
    }

    struct Stake {
        uint256 amount;
        uint256 rewards;
        uint256 rewardPerTokenPaid;
    }

    Pool public pool;
    mapping(address => Stake) public stakes;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardClaimed(address indexed user, uint256 amount);

    constructor(address _stakingToken, address _rewardToken) Ownable(msg.sender) {
        pool.stakingToken = IERC20(_stakingToken);
        pool.rewardToken = IERC20(_rewardToken);
        pool.rewardRate = 1e17; // 0.1 tokens per second
    }

    modifier updateReward(address account) {
        pool.rewardPerTokenStored = rewardPerToken();
        pool.lastUpdateTime = block.timestamp;
        if (account != address(0)) {
            stakes[account].rewards = earned(account);
            stakes[account].rewardPerTokenPaid = pool.rewardPerTokenStored;
        }
        _;
    }

    function rewardPerToken() public view returns (uint256) {
        if (pool.totalStaked == 0) return pool.rewardPerTokenStored;
        return pool.rewardPerTokenStored + (block.timestamp - pool.lastUpdateTime) * pool.rewardRate * 1e18 / pool.totalStaked;
    }

    function earned(address account) public view returns (uint256) {
        return stakes[account].amount * (rewardPerToken() - stakes[account].rewardPerTokenPaid) / 1e18 + stakes[account].rewards;
    }

    function stake(uint256 amount) external nonReentrant updateReward(msg.sender) {
        require(amount > 0, "Farm: amount must be > 0");
        pool.stakingToken.safeTransferFrom(msg.sender, address(this), amount);
        stakes[msg.sender].amount += amount;
        pool.totalStaked += amount;
        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external nonReentrant updateReward(msg.sender) {
        require(amount > 0 && stakes[msg.sender].amount >= amount, "Farm: insufficient stake");
        stakes[msg.sender].amount -= amount;
        pool.totalStaked -= amount;
        pool.stakingToken.safeTransfer(msg.sender, amount);
        emit Unstaked(msg.sender, amount);
    }

    function claimReward() external nonReentrant updateReward(msg.sender) {
        uint256 reward = stakes[msg.sender].rewards;
        require(reward > 0, "Farm: no reward");
        stakes[msg.sender].rewards = 0;
        pool.rewardToken.safeTransfer(msg.sender, reward);
        emit RewardClaimed(msg.sender, reward);
    }

    function setRewardRate(uint256 _rate) external onlyOwner {
        pool.rewardRate = _rate;
    }
}
