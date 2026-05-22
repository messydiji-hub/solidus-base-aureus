// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IAureusVesting {
    function createSchedule(address beneficiary, uint256 totalAmount, uint256 cliffDuration, uint256 duration, bool revocable) external;
    function release() external;
    function releasable(address beneficiary) external view returns (uint256);
}
