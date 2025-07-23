// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {SkillToken} from "../src/SkillToken.sol";

contract SkillScript is Script {
    SkillToken public skillToken;

    function run() public {
        vm.startBroadcast();

        skillToken = new SkillToken(msg.sender);

        vm.stopBroadcast();
    }
}
