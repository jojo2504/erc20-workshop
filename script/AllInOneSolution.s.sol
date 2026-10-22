// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {AllInOneSolution} from "../src/AllInOneSolution.sol";

contract AllInOneSolutionScript is Script {
    function run() public {
        uint256 deployerKey = vm.deriveKey(vm.envString("MNEMONIC"), 0);
        vm.startBroadcast(deployerKey);
        AllInOneSolution solution = new AllInOneSolution();
        solution.startWorkshop();
        vm.stopBroadcast();
    }
}
