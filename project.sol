// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.0/contracts/security/ReentrancyGuard.sol";

/**
 * @title Token for Skill Trading with Peers
 * @notice A decentralized platform where individuals can trade skills and earn tokens as rewards.
 * @dev Includes safety checks and dispute resolution mechanism
 */
contract SkillTradeToken is ERC20, Ownable, ReentrancyGuard {
    struct Trade {
        address requester;
        address provider;
        string skillOffered;
        string skillRequested;
        uint256 tokenAmount;
        bool isCompleted;
        bool isDisputed;
        uint256 deadline;
    }

    mapping(uint256 => Trade) public trades;
    mapping(address => uint256[]) public userTrades;
    uint256 public tradeCounter;

    uint256 public tokenRate = 10 ether; // Tokens rewarded per hour of skill exchange
    uint256 public constant MAX_DURATION = 168 hours; // Maximum trade duration (1 week)
    uint256 public constant DISPUTE_WINDOW = 72 hours; // Time window for raising disputes

    event TradeCreated(
        uint256 indexed tradeId,
        address indexed requester,
        address indexed provider,
        string skillOffered,
        string skillRequested,
        uint256 tokenAmount,
        uint256 deadline
    );

    event TradeCompleted(uint256 indexed tradeId, address indexed requester, address indexed provider);
    event TradeDisputed(uint256 indexed tradeId, address disputeInitiator);
    event TokenRateUpdated(uint256 oldRate, uint256 newRate);

    constructor() ERC20("SkillToken", "SKT") {
        _mint(msg.sender, 1000000 * (10 ** decimals())); // Initial token supply
    }

    /**
     * @dev Create a new skill trade offer.
     * @param provider Address of the peer offering the skill.
     * @param skillOffered The skill being offered by the requester.
     * @param skillRequested The skill being requested from the provider.
     * @param durationHours The number of hours for the skill exchange.
     */
    function createTrade(
        address provider,
        string memory skillOffered,
        string memory skillRequested,
        uint256 durationHours
    ) external nonReentrant {
        require(provider != address(0), "Invalid provider address");
        require(provider != msg.sender, "Cannot trade with yourself");
        require(durationHours > 0, "Trade duration must be greater than zero");
        require(durationHours * 1 hours <= MAX_DURATION, "Duration exceeds maximum allowed");
        require(bytes(skillOffered).length > 0, "Skill offered cannot be empty");
        require(bytes(skillRequested).length > 0, "Skill requested cannot be empty");

        uint256 tokenAmount = durationHours * tokenRate;
        uint256 deadline = block.timestamp + (durationHours * 1 hours);

        trades[tradeCounter] = Trade({
            requester: msg.sender,
            provider: provider,
            skillOffered: skillOffered,
            skillRequested: skillRequested,
            tokenAmount: tokenAmount,
            isCompleted: false,
            isDisputed: false,
            deadline: deadline
        });

        userTrades[msg.sender].push(tradeCounter);
        userTrades[provider].push(tradeCounter);

        emit TradeCreated(
            tradeCounter,
            msg.sender,
            provider,
            skillOffered,
            skillRequested,
            tokenAmount,
            deadline
        );
        tradeCounter++;
    }

    /**
     * @dev Mark a trade as completed and reward tokens to the provider.
     * @param tradeId The ID of the trade to complete.
     */
    function completeTrade(uint256 tradeId) external nonReentrant {
        Trade storage trade = trades[tradeId];
        require(trade.requester == msg.sender, "Only the requester can complete the trade");
        require(!trade.isCompleted, "Trade already completed");
        require(!trade.isDisputed, "Trade is under dispute");
        require(block.timestamp <= trade.deadline + DISPUTE_WINDOW, "Trade completion window expired");

        trade.isCompleted = true;
        _mint(trade.provider, trade.tokenAmount);

        emit TradeCompleted(tradeId, trade.requester, trade.provider);
    }

    /**
     * @dev Raise a dispute for a trade.
     * @param tradeId The ID of the trade to dispute.
     */
    function raiseTrade(uint256 tradeId) external {
        Trade storage trade = trades[tradeId];
        require(
            msg.sender == trade.requester || msg.sender == trade.provider,
            "Only trade participants can raise disputes"
        );
        require(!trade.isCompleted, "Cannot dispute completed trade");
        require(!trade.isDisputed, "Trade already disputed");
        require(block.timestamp <= trade.deadline + DISPUTE_WINDOW, "Dispute window expired");

        trade.isDisputed = true;
        emit TradeDisputed(tradeId, msg.sender);
    }

    /**
     * @dev Get all trades for a user.
     * @param user Address of the user.
     * @return Array of trade IDs.
     */
    function getUserTrades(address user) external view returns (uint256[] memory) {
        return userTrades[user];
    }

    /**
     * @dev Update the token reward rate.
     * @param newRate New token rate per hour.
     */
    function updateTokenRate(uint256 newRate) external onlyOwner {
        require(newRate > 0, "Token rate must be greater than zero");
        uint256 oldRate = tokenRate;
        tokenRate = newRate;
        emit TokenRateUpdated(oldRate, newRate);
    }
}