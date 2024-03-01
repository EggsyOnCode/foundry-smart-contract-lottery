// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {Raffle} from "../../src/Raffle.sol";
import {DeployRaffle} from "../../script/DeployRaffle.s.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
contract RaffleTest is Test{
    Raffle raffle;
    HelperConfig config;
    address public PLAYER = makeAddr("player");
    uint256 public constant STARTING_USER_BALANCE = 10 ether;
    uint64 subscriptionId;
    bytes32 gasLane;
    uint256 automationUpdateInterval;
    uint256 raffleEntranceFee;
    uint32 callbackGasLimit;
    address vrfCoordinatorV2;
    function setUp() external {
        DeployRaffle dScript = new DeployRaffle();
        (raffle, config) = dScript.run();
        (
        subscriptionId,
        gasLane,
        automationUpdateInterval,
        raffleEntranceFee,
        callbackGasLimit,
        vrfCoordinatorV2
        ) = config.activeNetworkConfig();
    }

    function test_ifRaffleStateOpenOnInit() public view {
        assert(raffle.getRaffleState() == Raffle.RaffleState.OPEN);
    }
}