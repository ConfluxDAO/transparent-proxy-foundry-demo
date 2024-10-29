// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "../src/Box.sol";

contract DeployBox is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);

        // Deploy implementation
        Box box = new Box();
        
        // Deploy ProxyAdmin
        ProxyAdmin admin = new ProxyAdmin();
        
        // Encode initialization data
        bytes memory data = abi.encodeWithSelector(Box.initialize.selector, 42);
        
        // Deploy proxy
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(
            address(box),
            address(admin),
            data
        );

        vm.stopBroadcast();

        console.log("Box implementation deployed to:", address(box));
        console.log("ProxyAdmin deployed to:", address(admin));
        console.log("Proxy deployed to:", address(proxy));
    }
} 