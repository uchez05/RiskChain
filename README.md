# RiskChain - Decentralized Insurance Smart Contract

## Overview

RiskChain is a decentralized insurance contract that allows users to purchase policies, pay premiums, and file claims. It ensures transparent policy management, claim handling, and secure fund tracking directly on-chain.

## Key Features

* **Policy Creation**: Admin can create insurance policies with defined coverage, premium, and duration.
* **Policy Purchase**: Users can purchase insurance policies by paying premiums calculated from coverage and duration.
* **Claims Management**: Users with active policies can file claims up to their coverage limit.
* **Fund Management**: Premiums contribute to an insurance fund used to pay claims.
* **Validation**: Enforces maximum coverage, maximum duration, and minimum premium requirements.

## Contract Components

* **Error Codes**: Prevent unauthorized actions, invalid claims, insufficient payments, and invalid parameters.
* **Data Maps**:

  * `insurance-policies`: Stores active policy details per user.
  * `insurance-claims`: Records claim amounts and status per user.
* **Variables**:

  * `insurance-fund`: Tracks the contract’s balance for paying claims.

## Functions

* **Admin Functions**:

  * `create-policy`: Owner creates a new policy template with coverage, premium, and duration.
* **User Functions**:

  * `purchase-policy`: Users purchase policies by paying calculated premiums.
  * `file-claim`: Users with active policies can claim compensation from the fund.
* **Read-only Functions**:

  * `get-policy-details`: Retrieve details of a user’s policy.
  * `get-claim-details`: Retrieve details of a user’s claim.
  * `get-fund-balance`: Check total insurance fund balance.

## Usage Flow

1. Admin creates available policy parameters.
2. Users purchase policies by paying the premium.
3. Policy details are stored with coverage, premium, and expiration block.
4. Users can file claims within their coverage amount.
5. Approved claims reduce the insurance fund and are recorded on-chain.
