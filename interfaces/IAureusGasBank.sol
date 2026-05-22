// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IAureusGasBank {
    event GasWithdrawn(address indexed to, uint256 amount);
    event OwnerUpdated(address indexed previous, address indexed current);

    function withdrawGas(address to, uint256 amount) external;
    function updateOwner(address newOwner) external;
    function treasury() external view returns (address);
    function owner() external view returns (address);
    receive() external payable;
}
