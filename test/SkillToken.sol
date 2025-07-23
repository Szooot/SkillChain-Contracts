// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {SkillToken} from "../src/SkillToken.sol";

contract SkillTokenTest is Test {
    SkillToken public skillToken;

    function setUp() public {
        skillToken = new SkillToken(msg.sender);
    }
}
