// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract TokenBank {
    IERC20 public tokenA;
    IERC20 public tokenB;
    address public owner;
    uint256 public swapRate; // Number of TokenB per TokenA

    event Deposit(address indexed user, uint256 amount, address token);
    event Withdraw(address indexed user, uint256 amount, address token);
    event Swap(address indexed user, uint256 amountIn, uint256 amountOut);
    event BulkTransfer(address indexed user, address[] recipients, uint256[] amounts);

    constructor(address _tokenA, address _tokenB, uint256 _swapRate) {
        tokenA = IERC20(_tokenA);
        tokenB = IERC20(_tokenB);
        owner = msg.sender;
        swapRate = _swapRate;
    }

    // Deposit tokens into the contract
    function deposit(uint256 amount, address token) external {
        require(token == address(tokenA) || token == address(tokenB), "Invalid token");
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        emit Deposit(msg.sender, amount, token);
    }

    // Withdraw tokens from the contract
    function withdraw(uint256 amount, address token) external {
        require(token == address(tokenA) || token == address(tokenB), "Invalid token");
        IERC20(token).transfer(msg.sender, amount);
        emit Withdraw(msg.sender, amount, token);
    }

    // Swap TokenA for TokenB
    function swap(uint256 amountA) external {
        require(tokenA.balanceOf(msg.sender) >= amountA, "Insufficient TokenA balance");
        uint256 amountB = amountA * swapRate;
        tokenA.transferFrom(msg.sender, address(this), amountA);
        tokenB.transfer(msg.sender, amountB);
        emit Swap(msg.sender, amountA, amountB);
    }

    // Approve another address to spend tokens on behalf of the user
    function approveSpender(address spender, uint256 amount, address token) external {
        require(token == address(tokenA) || token == address(tokenB), "Invalid token");
        IERC20(token).approve(spender, amount);
    }

    // Bulk transfer tokens to multiple addresses
    function bulkTransfer(address token, address[] calldata recipients, uint256[] calldata amounts) external {
        require(recipients.length == amounts.length, "Mismatched arrays");
        require(token == address(tokenA) || token == address(tokenB), "Invalid token");

        for (uint256 i = 0; i < recipients.length; i++) {
            IERC20(token).transferFrom(msg.sender, recipients[i], amounts[i]);
        }

        emit BulkTransfer(msg.sender, recipients, amounts);
    }

    // Only the owner can change the swap rate
    function setSwapRate(uint256 newRate) external {
        require(msg.sender == owner, "Only the owner can set the swap rate");
        swapRate = newRate;
    }
}