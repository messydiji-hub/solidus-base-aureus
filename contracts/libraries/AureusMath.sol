// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

library AureusMath {
    uint256 public constant PRECISION = 1e18;

    function mulDiv(
        uint256 x,
        uint256 y,
        uint256 d
    ) internal pure returns (uint256) {
        return (x * y) / d;
    }

    function min(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }

    function max(uint256 a, uint256 b) internal pure returns (uint256) {
        return a > b ? a : b;
    }

    function clamp(
        uint256 value,
        uint256 lower,
        uint256 upper
    ) internal pure returns (uint256) {
        return min(max(value, lower), upper);
    }

    function wad(uint256 amount) internal pure returns (uint256) {
        return amount * PRECISION;
    }

    function unwad(uint256 amount) internal pure returns (uint256) {
        return amount / PRECISION;
    }
}
