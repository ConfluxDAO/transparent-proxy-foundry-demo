// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Test.sol";
import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts/proxy/transparent/ProxyAdmin.sol";
import "../src/Box.sol";
import "../src/BoxV2.sol";

contract BoxTest is Test {
    uint256 internal deployerPrivateKey = 123;
    Box box;
    BoxV2 boxV2;
    ProxyAdmin admin;
    TransparentUpgradeableProxy proxy;

    function setUp() public {
        // Deploy implementation
        box = new Box();
        
        // Deploy ProxyAdmin
        admin = new ProxyAdmin(vm.addr(deployerPrivateKey));
        
        // Encode initialization data
        bytes memory data = abi.encodeWithSelector(Box.initialize.selector, 42);
        
        // Deploy proxy
        proxy = new TransparentUpgradeableProxy(
            address(box),
            address(admin),
            data
        );
    }

    function testBoxV1() public {
        Box proxiedBox = Box(address(proxy));
        assertEq(proxiedBox.retrieve(), 42);
        
        proxiedBox.store(100);
        assertEq(proxiedBox.retrieve(), 100);
    }

    function testUpgrade() public {
        // Deploy new implementation
        boxV2 = new BoxV2();
        
        // Upgrade
        admin.upgradeAndCall(ITransparentUpgradeableProxy(address(proxy)), address(boxV2), "");
        
        BoxV2 proxiedBoxV2 = BoxV2(address(proxy));
        
        // Test existing functionality
        assertEq(proxiedBoxV2.retrieve(), 100);
        
        // Test new functionality
        proxiedBoxV2.increment();
        assertEq(proxiedBoxV2.retrieve(), 101);
    }
} 