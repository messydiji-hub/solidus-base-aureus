// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

interface IAureusAirdrop {
    function setMerkleRoot(bytes32 _root) external;
    function depositTokens(uint256 amount) external;
    function claim(uint256 amount, bytes32[] calldata merkleProof) external;
}
