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

        // Deploy new implementation contract
        BoxV2 boxV2 = new BoxV2();
        console.log("New implementation:", address(boxV2));

        // Upgrade using ProxyAdmin
        ProxyAdmin proxyAdmin = ProxyAdmin(adminAddress);
        proxyAdmin.upgradeAndCall(
            ITransparentUpgradeableProxy(proxyAddress),
            address(boxV2),
            "" // Empty bytes since we don't need to call initialize
        );
        
        vm.stopBroadcast();

        console.log("Upgrade completed successfully");
    }
}