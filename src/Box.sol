// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract Box is Initializable {
    uint256 private _value;

    event ValueChanged(uint256 value);

    function initialize(uint256 initialValue) public initializer {
        _value = initialValue;
        emit ValueChanged(initialValue);
    }

    function store(uint256 value) public {
        _value = value;
        emit ValueChanged(value);
    }

    function retrieve() public view returns (uint256) {
        return _value;
    }
} 