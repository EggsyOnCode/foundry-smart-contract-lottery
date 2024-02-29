// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {VRFCoordinatorV2Interface} from "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";

/// @title A sample VRF contract
/// @author EggsyOnCode
/// @notice implements a raffle
/// @dev implements chainlink VRFv2

contract Raffle {
    //state vars
    VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
    uint16 private constant REQUEST_CONFIRMATIONS = 3;
    uint32 private immutable i_callbackGasLimit;
    uint32 private constant NUM_WORDS = 1;
    uint256 private immutable i_entranceFee;
    uint256 private immutable i_interval;
    uint256 private s_localTimestamp;
    uint64 private s_subscriptionId;
    bytes32 private immutable i_gasLane;
    /**
     * Custom Erros*
     */

    error InsufficientDeposits();

    /**
     * EVents*
     */
    event PlayerAdded(address indexed playerAddrses);

    //structs
    struct Player {
        string name;
        address _senderAddress;
    }

    //constructor
    constructor(
        uint256 eFee,
        address vrfCoordinatror,
        uint32 _callBackGasLimit,
        uint256 _interval,
        uint64 _subId,
        bytes32 keyHash
    ) {
        i_entranceFee = eFee;
        //we can;t interact with our subscription contract directly; it has to be via an Interface
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatror);
        i_interval = _interval;
        s_localTimestamp = block.timestamp;
        s_subscriptionId = _subId;
        i_gasLane = keyHash;
        i_callbackGasLimit = _callBackGasLimit;
    }

    //data strctures
    address payable[] private s_players;

    function enterRaffle() external payable {
        if (msg.value <= i_entranceFee) {
            revert InsufficientDeposits();
        }

        s_players.push(payable(msg.sender));

        emit PlayerAdded(msg.sender);
    }

    function pickWinner() external {
        if ((block.timestamp - s_localTimestamp) < i_interval) {
            revert();
        }
        uint256 requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane, s_subscriptionId, REQUEST_CONFIRMATIONS, i_callbackGasLimit, NUM_WORDS
        );
    }
}
