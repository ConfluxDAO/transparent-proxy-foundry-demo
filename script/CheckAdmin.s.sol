// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";

contract CheckAdmin is Script {
    function run() external view {
        address proxyAddress = vm.envAddress("PROXY_ADDRESS");
        address adminAddress = vm.envAddress("ADMIN_ADDRESS");
        address deployer = vm.addr(vm.envUint("PRIVATE_KEY"));
        
        ProxyAdmin proxyAdmin = ProxyAdmin(adminAddress);
        
        console.log("Proxy Address:", proxyAddress);
        console.log("Admin Contract:", adminAddress);
        console.log("Deployer:", deployer);
        console.log("Owner of ProxyAdmin:", proxyAdmin.owner());
    }
}