// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script} from "../lib/forge-std/src/Script.sol";
import {SkillToken} from "../src/SkillToken.sol";

/**
 * @title SkillTokenScript
 * @author Neti's Intern Team
 * @notice Script to deploy the SkillToken contract and add a batch of skills.
 */
contract SkillTokenScript is Script {
    /**
     * @notice Instance of the SkillToken contract.
     */
    SkillToken public skillToken;

    /**
     * @notice Deploys the SkillToken contract and adds a batch of skills.
     */
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
        ipfsHashes[0] = "bafkreie5pyvzuw4aglajyaodavkijvkojlcnakxjwh7cab3svc2b62tivq";
        ipfsHashes[1] = "bafkreia7xavfaxfezptn6g6obgszmzkeixq5afoymyodylrojsqqjdz5pu";
        ipfsHashes[2] = "bafkreidvgdbnynljohj36v4cnuqfxjsc4bzevnqh6emvxsuvei64pureeu";
        ipfsHashes[3] = "bafkreiaz4svlgmh5m4rwduvqxwkmyrcsrhia3gl7mkpn2abo4blrjdugya";
        ipfsHashes[4] = "bafkreiazodxcgrqzjpnbeuxj7tm3y4pu6udfkpcau3gk6tb4pa5qmhggqe";
        ipfsHashes[5] = "bafkreidjtqs4pfzoaozlpla6xon4hjkas436sejjtj6z5dehjingaanzoi";
        ipfsHashes[6] = "bafkreiaq4qfgfr43rhkiien7jp4imgquj2sp2futz6t6jtnqccspz23clm";
        ipfsHashes[7] = "bafkreibiutwsgvkcod5eoktpuf37julklu4st4shddy2rsnopp47lxoe5e";

        skillToken.addSkillsBatch(skillIds, ipfsHashes);

        vm.stopBroadcast();
    }
}
