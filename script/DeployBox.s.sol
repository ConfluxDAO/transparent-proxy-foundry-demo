// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "../src/Box.sol";

contract DeployBox is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        vm.startBroadcast(deployerPrivateKey);

        // Deploy implementation contract
        Box box = new Box();
        
        // Encode initialization data
        bytes memory data = abi.encodeWithSelector(Box.initialize.selector, 42);
        
        // Deploy proxy contract
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(
            address(box),
            deployer,
            data
        );

        // Get actual ProxyAdmin address
        address proxyAdminAddress = address(uint160(uint256(vm.load(
            address(proxy),
            bytes32(uint256(keccak256("eip1967.proxy.admin")) - 1)
        ))));

        vm.stopBroadcast();

        console.log("Box implementation deployed to:", address(box));
        console.log("Proxy deployed to:", address(proxy));
        console.log("ProxyAdmin deployed to:", proxyAdminAddress);
    }
}