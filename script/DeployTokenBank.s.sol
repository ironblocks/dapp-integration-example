// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/token/ERC20/presets/ERC20PresetFixedSupply.sol";
import "../src/tokenbank.sol";

contract DeployTokenBank is Script {
    function run() external {
        // Retrieve private key from environment variable
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // Deploy TokenA with fixed supply
        ERC20PresetFixedSupply tokenA = new ERC20PresetFixedSupply(
            "Token A",
            "TKA",
            1000000 * 10**18,
            msg.sender
        );

        // Deploy TokenB with fixed supply
        ERC20PresetFixedSupply tokenB = new ERC20PresetFixedSupply(
            "Token B",
            "TKB",
            2000000 * 10**18,
            msg.sender
        );

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
