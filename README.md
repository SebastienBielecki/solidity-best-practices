# SOME SOLIDITY COMMON BEST PRACTICES

This is a non-exhaustive list of some common best practices when implementing smart contracts in Solidity, dealing with Multicall, Security, Upgradability and Oracles.

This list is adapted from the Udacity Blockchain developer nanodegree and serves as a personal reference and checklist when implementing smart contracts. It will be updated 

## FILE 1-Operational-Multicall.sol

Features: pausable contract, multicall

This show the implementation of a pausable contract, by implementing a state variable, that can be changed if a certain threshold of administrators vote for changing the contract status 

## FILE 2-Payments.sol

Features: Safemath, Re-entrancy attack prevention, Rate Limiting, Authorize EAO only

Implementation of 
- SafeMath implementation to prevent overflow/underflow risks
- Ensures a caller is an Externally Owned Account (EOA) and not a Smart Contract
- Re-entrancy attack prevention, with implementation of the CHECK - EFFECTS - INTERACTION pattern, and a safeguard feature avoiding possibility to recursively call a payout
- Rate Limiting, introducing a cooldown period between 2 function calls

## FILE 3-Data.sol and FILE 3-App.sol

Feature: Upgradability

Separation of Data and Logic into 2 smart contracts. The Data contract stores state variables and is intented to be permanent. The App contract implements the business logic and can be potentially replaced in the future, in case of bug correction or changes in the business logic.

The App contract is created by passing the address of the Data Contract,and is able to call methods from the Data Contract.
The Data contract maintains a list of App Contracts addresses that are authorized to access the Data Contract, and enforces it with a modifier that restrict access of Data Cotnract function from authorized contracts only

## FILE 4-Oracles.sol

Feature: implementation of Oracles

This implements some recommended practices when dealing with untrusted Oracles and minimizing attack risks like sybil or cartel attacks, where an Oracle would make a mistake (intentional or not) when submitting an answer:

- implement many Oracles, avoiding to rely on a too small set of sources
- ask pseudo-randomly a subset of Oracles to answer a request
- only accept an answer as valid if it has been confirmed by a sufficient number of Oracles