// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "../src/BoxV2.sol";

contract UpgradeBox is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address proxyAddress = vm.envAddress("PROXY_ADDRESS");
        address adminAddress = vm.envAddress("ADMIN_ADDRESS");
        
        vm.startBroadcast(deployerPrivateKey);

        // Deploy new implementation
        BoxV2 boxV2 = new BoxV2();
        
        // Upgrade proxy
        ProxyAdmin admin = ProxyAdmin(adminAddress);
        admin.upgrade(
            TransparentUpgradeableProxy(payable(proxyAddress)),
            address(boxV2)
        );

        vm.stopBroadcast();

        console.log("BoxV2 implementation deployed to:", address(boxV2));
        console.log("Proxy upgraded");
    }
} 