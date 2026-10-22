// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {AllInOneSolution} from "../src/AllInOneSolution.sol";
import {Evaluator} from "contracts/Evaluator.sol";
import {ERC20_101} from "contracts/ERC20_101.sol";

contract AllInOneSolutionTest is Test {
    address constant EVALUATOR = 0x05A644d6d9BBd85861ff927245aaC13bd56e6d57;
    AllInOneSolution solution;
    Evaluator evaluator;
    ERC20_101 points;

    function setUp() public {
        points = new ERC20_101("Workshop points", "PTS", 0);
        deployCodeTo("Evaluator.sol:Evaluator", abi.encode(points), EVALUATOR);
        evaluator = Evaluator(payable(EVALUATOR));
        points.setTeacher(EVALUATOR, true);
        uint256[20] memory supplies;
        string[20] memory tickers;
        supplies[0] = 1000;
        tickers[0] = "TEST";
        evaluator.setRandomTickersAndSupply(supplies, tickers);
        vm.deal(EVALUATOR, 1 ether);
        solution = new AllInOneSolution();
    }

    function test_complete_workshop() public {
        solution.startWorkshop();

        for (uint256 exercise = 0; exercise <= 10; exercise++) {
            assertTrue(
                evaluator.exerciceProgression(address(solution), exercise)
            );
        }
        assertEq(points.balanceOf(address(solution)), 20 ether);
        assertEq(points.balanceOf(address(this)), 0);
        assertEq(evaluator.studentErc20(address(solution)).symbol(), "TEST");
    }

    function test_callback_requires_evaluator() public {
        vm.expectRevert(bytes("Only evaluator"));
        solution.completeWorkshop();
    }

    function test_cannot_restart_completed_workshop() public {
        solution.startWorkshop();
        vm.expectRevert(bytes("Solution should start with 0 points"));
        solution.startWorkshop();
        assertEq(points.balanceOf(address(solution)), 20 ether);
    }
}
