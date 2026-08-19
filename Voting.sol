// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    // 1. Data Structures (Similar to a struct in C)
    struct Topic {
        string name;
        uint256 voteCount;
    }

    // 2. State Variables (Permanent storage, like database tables)
    Topic[] public topics;
    
    // Mappings act as highly efficient key-value lookups
    mapping(address => bool) public hasVoted;
    mapping(address => bool) public isRestricted; 
    
    address public admin;

    // 3. Constructor (Runs exactly once during deployment)
    // Takes an array of topic names and an array of restricted account addresses
    constructor(string[] memory _topicNames, address[] memory _restrictedAccounts) {
        admin = msg.sender; // 'msg.sender' is the account deploying the contract
        
        // Populate the topics array
        for(uint i = 0; i < _topicNames.length; i++) {
            topics.push(Topic({
                name: _topicNames[i],
                voteCount: 0
            }));
        }

        // Set up the restricted accounts list
        for(uint i = 0; i < _restrictedAccounts.length; i++) {
            isRestricted[_restrictedAccounts[i]] = true;
        }
    }

    // 4. The Voting Function (Modifies state, costs gas)
    function vote(uint256 _topicIndex) public {
        // 'require' acts as our security validation. If any check fails, 
        // the transaction instantly reverts and no changes are saved.
        require(!hasVoted[msg.sender], "Security Error: You have already voted.");
        require(!isRestricted[msg.sender], "Security Error: Account is restricted.");
        require(_topicIndex < topics.length, "Error: Invalid topic index.");

        // Record that this account has now voted
        hasVoted[msg.sender] = true;
        
        // Increment the vote count for the chosen topic
        topics[_topicIndex].voteCount++;
    }

    // 5. Read-Only Function (View functions are free to call)
    function getAllTopics() public view returns (Topic[] memory) {
        return topics;
    }
}