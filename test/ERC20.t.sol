// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {MYERC20} from "../src/ERC20.sol";
import {Evaluator} from "contracts/Evaluator.sol";
import {ERC20_101} from "contracts/ERC20_101.sol";
import {IExerciceSolution} from "contracts/IExerciceSolution.sol";
import {console} from "forge-std/console.sol";

contract EvaluatorTest is Test {
    Evaluator public evaluator;
    MYERC20 erc20;

    function setUp() public {
        vm.createSelectFork("https://ethereum-sepolia.publicnode.com");

        evaluator = Evaluator(
            payable(0x05A644d6d9BBd85861ff927245aaC13bd56e6d57)
        );

        evaluator.ex0_setupProject();
        evaluator.ex1_getTickerAndSupply();

        string memory ticker = evaluator.assignedTicker(address(this));
        uint256 supply = evaluator.assignedSupply(address(this));
        erc20 = new MYERC20(supply, ticker);

        evaluator.submitExercice(IExerciceSolution(address(erc20)));
    }

    function test_ex2() public {
        evaluator.ex2_testErc20TickerAndSupply();
    }

    function test_ex3_get_token() public {
        erc20.SetWhiteListCustomer(address(evaluator));
        evaluator.ex3_testGetToken();
    }

    function test_ex4_buy_token() public {
        erc20.SetWhiteListCustomer(address(evaluator));
        erc20.SetCustomerTierLevel(address(evaluator), 1);
        evaluator.ex4_testBuyToken();
    }

    function test_ex5_buy_token_blocked() public {
        evaluator.ex5_testDenyListing();
    }

    function test_ex6_buy_token_whitelisted() public {
        evaluator.ex5_testDenyListing();
        erc20.SetWhiteListCustomer(address(evaluator));
        evaluator.ex6_testAllowListing();
    }

    function test_ex7() public {
        evaluator.ex7_testDenyListing();
    }

    function test_ex8() public {
        evaluator.ex7_testDenyListing();

        erc20.SetWhiteListCustomer(address(evaluator));
        erc20.SetCustomerTierLevel(address(evaluator), 1);
        evaluator.ex8_testTier1Listing();
    }

    function test_ex9() public {
        evaluator.ex7_testDenyListing();

        erc20.SetWhiteListCustomer(address(evaluator));
        erc20.SetCustomerTierLevel(address(evaluator), 1);
        evaluator.ex8_testTier1Listing();

        erc20.SetWhiteListCustomer(address(evaluator));
        erc20.SetCustomerTierLevel(address(evaluator), 2);
        evaluator.ex9_testTier2Listing();
    }
}
