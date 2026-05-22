// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IAureusFactory {
    function deploy() external;
    function transferOwnership(address newOwner) external;
    function token() external view returns (address);
    function farm() external view returns (address);
    function pool() external view returns (address);
    function owner() external view returns (address);
    function initialized() external view returns (bool);
}
