// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../src/tokenbank.sol";

contract DeployTokenBank is Script {
    function run() external {
        // Retrieve private key from environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy TokenA
        ERC20 tokenA = new ERC20("Token A", "TKA");
        // Mint some initial supply for TokenA
        tokenA.mint(msg.sender, 1000000 * 10**18);

        // Deploy TokenB
        ERC20 tokenB = new ERC20("Token B", "TKB");
        // Mint some initial supply for TokenB
        tokenB.mint(msg.sender, 2000000 * 10**18);

        // Initial swap rate: 2 TokenB per 1 TokenA
        uint256 initialSwapRate = 2;

        // Deploy the TokenBank contract
        TokenBank tokenBank = new TokenBank(address(tokenA), address(tokenB), initialSwapRate);

        vm.stopBroadcast();

        // Log the addresses of the deployed contracts
        console.log("TokenA deployed at:", address(tokenA));
        console.log("TokenB deployed at:", address(tokenB));
        console.log("TokenBank deployed at:", address(tokenBank));
    }
}