// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {IAllInOneSolution} from "contracts/IAllInOneSolution.sol";
import {MYERC20} from "../src/ERC20.sol";
import {Evaluator} from "contracts/Evaluator.sol";
import {IExerciceSolution} from "contracts/IExerciceSolution.sol";

contract AllInOneSolution is IAllInOneSolution {
    Evaluator public evaluator;
    MYERC20 erc20;

    constructor() {
        evaluator = Evaluator(
            payable(0x05A644d6d9BBd85861ff927245aaC13bd56e6d57)
        );
    }

    function startWorkshop() external {
        evaluator.ex10_allInOne();
    }

    function completeWorkshop() public override {
        require(msg.sender == address(evaluator), "Only evaluator");

        evaluator.ex0_setupProject();
        evaluator.ex1_getTickerAndSupply();

        string memory ticker = evaluator.assignedTicker(address(this));
        uint256 supply = evaluator.assignedSupply(address(this));
        erc20 = new MYERC20(supply, ticker);

        evaluator.submitExercice(IExerciceSolution(address(erc20)));
        evaluator.ex2_testErc20TickerAndSupply();

        evaluator.ex5_testDenyListing();
        evaluator.ex7_testDenyListing();

        erc20.SetWhiteListCustomer(address(evaluator));
        evaluator.ex3_testGetToken();
        evaluator.ex6_testAllowListing();

        erc20.SetCustomerTierLevel(address(evaluator), 1);
        evaluator.ex4_testBuyToken();
        evaluator.ex8_testTier1Listing();

        erc20.SetCustomerTierLevel(address(evaluator), 2);
        evaluator.ex9_testTier2Listing();
    }
}
