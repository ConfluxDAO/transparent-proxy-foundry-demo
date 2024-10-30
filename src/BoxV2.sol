// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract BoxV2 is Initializable {
    uint256 private _value;

    event ValueChanged(uint256 value);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function initialize(uint256 initialValue) public initializer {
        _value = initialValue;
    }

    function store(uint256 value) public {
        _value = value;
        emit ValueChanged(value);
    }

    function retrieve() public view returns (uint256) {
        return _value;
    }

    // New added function
    function increment() public {
        _value = _value + 1;
        emit ValueChanged(_value);
    }
}