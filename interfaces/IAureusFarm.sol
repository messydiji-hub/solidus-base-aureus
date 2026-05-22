// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IAureusFarm {
    function stake(uint256 amount) external;
    function unstake(uint256 amount) external;
    function claimReward() external;
    function earned(address account) external view returns (uint256);
}
