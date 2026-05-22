// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AureusErrors
/// @notice Centralized custom errors for the Aureus protocol
library AureusErrors {
    /// @notice Caller is not authorized
    error Unauthorized();

    /// @notice Provided address is zero
    error ZeroAddress();

    /// @notice Amount must be greater than zero
    error ZeroAmount();

    /// @notice Insufficient balance
    error InsufficientBalance(uint256 available, uint256 required);

    /// @notice Contract is paused
    error Paused();

    /// @notice Array length mismatch
    error ArrayLengthMismatch(uint256 a, uint256 b);

    /// @notice Value out of allowed range
    error OutOfRange(uint256 value, uint256 min, uint256 max);
}
