// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AureusVesting is Ownable {
    using SafeERC20 for IERC20;

    struct VestingSchedule {
        uint256 totalAmount;
        uint256 released;
        uint256 startTime;
        uint256 cliffDuration;
        uint256 duration;
        bool revocable;
    }

    IERC20 public vestingToken;
    mapping(address => VestingSchedule) public schedules;
    address[] public beneficiaries;

    event ScheduleCreated(address indexed beneficiary, uint256 totalAmount, uint256 duration);
    event TokensReleased(address indexed beneficiary, uint256 amount);
    event ScheduleRevoked(address indexed beneficiary);

    constructor(address _token) Ownable(msg.sender) {
        vestingToken = IERC20(_token);
    }

    function createSchedule(
        address beneficiary,
        uint256 totalAmount,
        uint256 cliffDuration,
        uint256 duration,
        bool revocable
    ) external onlyOwner {
        require(beneficiary != address(0), "Vesting: zero address");
        require(schedules[beneficiary].totalAmount == 0, "Vesting: already exists");
        require(totalAmount > 0, "Vesting: zero amount");
        require(duration > 0, "Vesting: zero duration");
        vestingToken.safeTransferFrom(msg.sender, address(this), totalAmount);
        schedules[beneficiary] = VestingSchedule(totalAmount, 0, block.timestamp, cliffDuration, duration, revocable);
        beneficiaries.push(beneficiary);
        emit ScheduleCreated(beneficiary, totalAmount, duration);
    }

    function releasable(address beneficiary) public view returns (uint256) {
        VestingSchedule storage s = schedules[beneficiary];
        if (block.timestamp < s.startTime + s.cliffDuration) return 0;
        if (block.timestamp >= s.startTime + s.duration) return s.totalAmount - s.released;
        return s.totalAmount * (block.timestamp - s.startTime) / s.duration - s.released;
    }

    function release() external {
        uint256 amount = releasable(msg.sender);
        require(amount > 0, "Vesting: nothing to release");
        schedules[msg.sender].released += amount;
        vestingToken.safeTransfer(msg.sender, amount);
        emit TokensReleased(msg.sender, amount);
    }

    function revoke(address beneficiary) external onlyOwner {
        require(schedules[beneficiary].revocable, "Vesting: not revocable");
        uint256 remaining = schedules[beneficiary].totalAmount - schedules[beneficiary].released;
        schedules[beneficiary].totalAmount = schedules[beneficiary].released;
        if (remaining > 0) {
            vestingToken.safeTransfer(owner(), remaining);
        }
        emit ScheduleRevoked(beneficiary);
    }
}
