// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ConditionalTx {
    address public owner;
    uint256 public targetBlock;
    address public destination;
    uint256 public amountToSend;
    uint256 public amountToReceive;

    event TransferSent(address indexed _from, address indexed _to, uint256 _amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can execute this");
        _;
    }

    constructor(address _destination, uint256 _amountToSend, uint256 _targetBlock) {
        owner = msg.sender;
        destination = _destination;
        amountToSend = _amountToSend;
        targetBlock = _targetBlock;
    }

    function sendConditionalTransfer() external onlyOwner {
        require(block.number >= targetBlock, "Target block not reached yet");

        // Transfer funds to the specified address
        (bool success, ) = destination.call{value: amountToSend}("");
        require(success, "Transfer failed");

        // Emit an event
        emit TransferSent(address(this), destination, amountToSend);
    }
}
