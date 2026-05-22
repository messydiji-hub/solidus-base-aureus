// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IAureusToken {
    function mint(address to, uint256 amount) external;
    function burn(uint256 amount) external;
    function totalMinted() external view returns (uint256);
}
