// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IAureusDistributor {
    function claim() external;
    function setAllocations(address[] calldata recipients, uint256[] calldata amounts) external;
}
