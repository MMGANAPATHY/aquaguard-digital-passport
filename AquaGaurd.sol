// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AquaGuard {

    address public owner;
    uint public waterCredits;

    struct Batch {
        uint batchId;
        uint bottleCount;
        uint purificationTime;
        uint bottlingTime;
        address plant;
        bool exists;
    }

    mapping(uint => Batch) public batches;

    constructor() {
        owner = msg.sender;
    }

    // STEP 1: Treatment plant records purified water
    function addPurifiedWater(uint litres) public {
        require(litres > 0, "Invalid amount");
        waterCredits += litres;
    }

    // STEP 2: Factory creates bottle batch
    function createBottleBatch(uint _batchId, uint _bottleCount) public {
        require(!batches[_batchId].exists, "Batch already exists");
        require(_bottleCount > 0, "Invalid bottle count");
        require(waterCredits >= _bottleCount, "Not enough purified water");

        // consume water
        waterCredits -= _bottleCount;

        batches[_batchId] = Batch({
            batchId: _batchId,
            bottleCount: _bottleCount,
            purificationTime: block.timestamp,
            bottlingTime: block.timestamp,
            plant: msg.sender,
            exists: true
        });
    }

    // STEP 3: Verify batch
    function verifyBatch(uint _batchId) public view returns (
        uint bottleCount,
        uint purificationTime,
        uint bottlingTime,
        address plant
    ) {
        require(batches[_batchId].exists, "Batch not found");
        Batch memory b = batches[_batchId];

        return (
            b.bottleCount,
            b.purificationTime,
            b.bottlingTime,
            b.plant
        );
    }
}