// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AureusGovernor
/// @notice Simple on-chain governor for protocol parameter changes
/// @dev Uses a simple approval mechanism (multisig-style) before timelock execution
import "./AureusTimelock.sol";

contract AureusGovernor {
    address[] public guardians;
    mapping(bytes32 => uint256) public approvals;
    mapping(bytes32 => bool) public executed;
    AureusTimelock public timelock;

    uint256 public constant APPROVAL_THRESHOLD = 2;
    uint256 public constant DELAY = 2 days;

    event ProposalCreated(bytes32 indexed id, address target, bytes data);
    event Approved(bytes32 indexed id, address indexed guardian);
    event Executed(bytes32 indexed id);

    error NotGuardian();
    error AlreadyApproved();
    error AlreadyExecuted();
    error InsufficientApprovals();
    error TooEarly();

    modifier onlyGuardian() {
        bool isGuardian;
        for (uint256 i; i < guardians.length; i++) {
            if (guardians[i] == msg.sender) { isGuardian = true; break; }
        }
        if (!isGuardian) revert NotGuardian();
        _;
    }

    constructor(address[] memory _guardians, address _timelock) {
        guardians = _guardians;
        timelock = AureusTimelock(_timelock);
    }

    function propose(address target, bytes calldata data) external returns (bytes32) {
        bytes32 id = keccak256(abi.encodePacked(target, data, block.timestamp));
        emit ProposalCreated(id, target, data);
        return id;
    }

    function approve(bytes32 id) external onlyGuardian {
        if (executed[id]) revert AlreadyExecuted();
        approvals[id]++;
        emit Approved(id, msg.sender);
    }

    function execute(bytes32 id, address target, bytes calldata data) external {
        if (executed[id]) revert AlreadyExecuted();
        if (approvals[id] < APPROVAL_THRESHOLD) revert InsufficientApprovals();
        executed[id] = true;
        emit Executed(id);
    }
}
