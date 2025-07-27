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
     * @notice Addresses used in tests.
     */
    address public user = address(0x123);

    /**
     * @notice Recipient address used in tests.
     */
    address public recipient = address(0x456);

    /**
     * @notice Sets up the SkillToken contract before each test.
     */
    function setUp() public {
        skillToken = new SkillToken();
        skillToken.addOrUpdateSkill(1, "Hash1");
        skillToken.addOrUpdateSkill(2, "Hash2");
        skillToken.addOrUpdateSkill(3, "Hash3");
    }

    /**
     * @notice Test for Soulbound token behavior where transfers are not allowed.
     */
    function testTransferFrom() public {
        vm.expectRevert(SkillToken.CannotBeTransferred.selector);
        skillToken.transferFrom(user, recipient, 1);
    }

    /**
     * @notice Test for Soulbound token behavior where transfers are not allowed.
     */
    function testSafeTransferFrom() public {
        vm.expectRevert(SkillToken.CannotBeTransferred.selector);
        skillToken.safeTransferFrom(user, recipient, 1, "");
    }

    /**
     * @notice Test for Soulbound token behavior where approvals are not allowed.
     */
    function testApprove() public {
        vm.expectRevert(SkillToken.CannotBeApproved.selector);
        skillToken.approve(recipient, 1);
    }

    /**
     * @notice Test for Soulbound token behavior where approvals are not allowed.
     */
    function testSetApprovalForAll() public {
        vm.expectRevert(SkillToken.CannotBeApproved.selector);
        skillToken.setApprovalForAll(recipient, true);
    }

    function testMintSkill() public {
        skillToken.mintSkill(recipient, 1);
        assertEq(skillToken.tokenToSkill(1), 1);
        assertEq(skillToken.tokenToApprover(1), address(this));
        assertTrue(skillToken.skillToUserToApproverStatus(1, recipient, address(this)));
    }
}
