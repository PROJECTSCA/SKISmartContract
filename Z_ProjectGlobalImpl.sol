//SPDX-License-Identifier: SimPL-2.0
pragma solidity ^0.8.11;

import "interfaces/IERC20.sol";

/**
 * @title Helps contracts guard agains reentrancy attacks.
 * @author Remco Bloemen <remco@2π.com>
 * @notice If you mark a function `nonReentrant`, you should also
 * mark it `external`.
 */
contract ReentrancyGuard {

    /**
     * @dev We use a single lock for the whole contract.
     */
    bool private reentrancyLock = false;

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * @notice If you mark a function `nonReentrant`, you should also
     * mark it `external`. Calling one nonReentrant function from
     * another is not supported. Instead, you can implement a
     * `private` function doing the actual work, and a `external`
     * wrapper marked as `nonReentrant`.
     */
    modifier nonReentrant() {
        require(!reentrancyLock);
        reentrancyLock = true;
        _;
        reentrancyLock = false;
    }

}

contract ProjectGlobalImpl {

    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner address can call this");
        _;
    }

    function withdrawBNB() public onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    function withdrawBEP20(address bep20TokenAddress) public onlyOwner returns (bool){
        IERC20 erc20 = IERC20(bep20TokenAddress);
        uint256 balance = erc20.balanceOf(address(this));
        return erc20.transfer(owner, balance);
    }


    receive() payable external {}

    fallback() payable external {}

}

