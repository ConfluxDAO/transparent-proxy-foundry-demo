// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "../src/Box.sol";
import "../src/BoxV2.sol";

contract UpgradeBox is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address proxyAddress = vm.envAddress("PROXY_ADDRESS");
        address adminAddress = vm.envAddress("ADMIN_ADDRESS");
        
        // Test before upgrade
        console.log("============ Before Upgrade ============");
        Box box = Box(proxyAddress);
        uint256 valueBefore = box.retrieve();
        console.log("Current value:", valueBefore);
        
        vm.startBroadcast(deployerPrivateKey);

        // Deploy new implementation
        BoxV2 boxV2 = new BoxV2();
        console.log("\n============ Deploying New Implementation ============");
        console.log("New implementation:", address(boxV2));

        // Upgrade using ProxyAdmin
        ProxyAdmin proxyAdmin = ProxyAdmin(adminAddress);
        proxyAdmin.upgradeAndCall(
            ITransparentUpgradeableProxy(proxyAddress),
            address(boxV2),
            ""
        );
        
        vm.stopBroadcast();

        // Test after upgrade
        console.log("\n============ After Upgrade ============");
        BoxV2 upgradedBox = BoxV2(proxyAddress);
        uint256 valueAfter = upgradedBox.retrieve();
        console.log("Value after upgrade:", valueAfter);
        console.log("Testing new increment function...");
        
        vm.startBroadcast(deployerPrivateKey);
        upgradedBox.increment();
        vm.stopBroadcast();
        
        uint256 valueAfterIncrement = upgradedBox.retrieve();
        console.log("Value after increment:", valueAfterIncrement);
        
        // Verify upgrade results
        require(valueAfter == valueBefore, "State verification failed: Value changed during upgrade");
        require(valueAfterIncrement == valueAfter + 1, "Function verification failed: Increment not working");
        
        console.log("\n============ Upgrade Successful ============");
        console.log("1. State preserved: Initial value maintained after upgrade");
        console.log("2. New function working: Increment successfully added");
    }
}