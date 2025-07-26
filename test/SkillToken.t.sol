// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test} from "../lib/forge-std/src/Test.sol";
import {SkillToken} from "../src/SkillToken.sol";

/**
 * @title SkillTokenTest
 * @author Neti's Intern Team
 * @notice This contract contains tests for the SkillToken contract.
 */
contract SkillTokenTest is Test {
    /**
     * @notice Instance of the SkillToken contract.
     */
    SkillToken public skillToken;

    /**
     * @notice Sets up the SkillToken contract before each test.
     */
    function setUp() public {
        skillToken = new SkillToken();
    }
}
