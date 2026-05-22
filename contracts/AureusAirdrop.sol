// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

contract AureusAirdrop is Ownable {
    using SafeERC20 for IERC20;

    IERC20 public airdropToken;
    bytes32 public merkleRoot;
    uint256 public totalAllocation;
    uint256 public totalClaimed;
    mapping(address => bool) public hasClaimed;

    event AirdropClaimed(address indexed claimant, uint256 amount);
    event MerkleRootUpdated(bytes32 indexed root);

    constructor(address _token) Ownable(msg.sender) {
        airdropToken = IERC20(_token);
    }

    function setMerkleRoot(bytes32 _root) external onlyOwner {
        merkleRoot = _root;
        emit MerkleRootUpdated(_root);
    }

    function depositTokens(uint256 amount) external onlyOwner {
        airdropToken.safeTransferFrom(msg.sender, address(this), amount);
        totalAllocation += amount;
    }

    function claim(uint256 amount, bytes32[] calldata merkleProof) external {
        require(!hasClaimed[msg.sender], "Airdrop: already claimed");
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(msg.sender, amount))));
        require(MerkleProof.verify(merkleProof, merkleRoot, leaf), "Airdrop: invalid proof");
        hasClaimed[msg.sender] = true;
        totalClaimed += amount;
        airdropToken.safeTransfer(msg.sender, amount);
        emit AirdropClaimed(msg.sender, amount);
    }

    function withdrawRemaining() external onlyOwner {
        uint256 remaining = totalAllocation - totalClaimed;
        if (remaining > 0) {
            airdropToken.safeTransfer(owner(), remaining);
        }
    }
}
