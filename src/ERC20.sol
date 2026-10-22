// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "contracts/Evaluator.sol";

contract MYERC20 is ERC20, IExerciceSolution {
    mapping(address => bool) whitelisted_customers;
    mapping(address => uint256) customer_levels;

    constructor(
        uint256 supply,
        string memory ticker
    ) ERC20("my token", ticker) {
        _mint(msg.sender, supply);
    }

    function symbol()
        public
        view
        override(ERC20, IExerciceSolution)
        returns (string memory)
    {
        return super.symbol();
    }

    function getToken() external override returns (bool) {
        require(whitelisted_customers[msg.sender], "not whitelisted");

        _mint(msg.sender, 1 ether);
        return true;
    }

    uint256 public constant TOKENS_PER_ETH = 100000;
    function buyToken() external payable override returns (bool) {
        require(msg.value > 0, "please send a positive amount of ETH");
        require(whitelisted_customers[msg.sender], "not whitelisted");

        _mint(
            msg.sender,
            customer_levels[msg.sender] * TOKENS_PER_ETH * msg.value
        );
        return true;
    }

    function isCustomerWhiteListed(
        address customerAddress
    ) external view override returns (bool) {
        return whitelisted_customers[customerAddress];
    }

    function SetWhiteListCustomer(address customerAddress) public {
        whitelisted_customers[customerAddress] = true;
    }

    function customerTierLevel(
        address customerAddress
    ) external view override returns (uint256) {
        return customer_levels[customerAddress];
    }

    function SetCustomerTierLevel(
        address customerAddress,
        uint256 level
    ) public {
        customer_levels[customerAddress] = level;
    }
}
