// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {SkillToken} from "../src/SkillToken.sol";

contract SkillScript is Script {
    SkillToken public skillToken;

    function run() public {
        vm.startBroadcast();

        skillToken = new SkillToken();

        uint256[] memory skillIds = new uint256[](8);
        skillIds[0] = 1;
        skillIds[1] = 2;
        skillIds[2] = 3;
        skillIds[3] = 4;
        skillIds[4] = 5;
        skillIds[5] = 6;
        skillIds[6] = 7;
        skillIds[7] = 8;

        string[] memory ipfsHashes = new string[](8);
        ipfsHashes[0] = "bafkreigjdeizt5aeteqmf7azannyuzte6n7uncp43huegttymcl6pcdd6a";
        ipfsHashes[1] = "bafkreicyew3etsgajxwbh3hqduayeqa32dwhc6e5f6qgejegnweczukrl4";
        ipfsHashes[2] = "bafkreihsecsdmjmo2akmkev2j6oa3zvz4xbmjnktggqkfh4mpinbfq3eim";
        ipfsHashes[3] = "bafkreidkmreyzvyzwasoxcqeflbef2hkrgyw2oztta6tag3w36bsvkr3ym";
        ipfsHashes[4] = "bafkreiagk37wl7eo5lg2lr4np6p75epmd24rtw3e6vxaw7oniyfpjo6tnq";
        ipfsHashes[5] = "bafkreibnivmls3j6y4oq3erkmjtizmxkljoyh3l5jsxwwbdzwmtg66k2f4";
        ipfsHashes[6] = "bafkreib73ayou2kdd3l2bogqndgvwnfnh4akdj4bsxkq6e77kzyt6jdc4e";
        ipfsHashes[7] = "bafkreid7ha5p6gmusg74jvc3upkpasdm2hwogbzbnlhbtpzalkdyhlti7u";

        skillToken.addSkillsBatch(skillIds, ipfsHashes);

        vm.stopBroadcast();
    }
}
