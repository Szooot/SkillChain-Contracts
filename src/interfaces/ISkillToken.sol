// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ISkillToken
 * @author Neti's Intern Team
 * @notice Interface for the SkillToken contract
 */
interface ISkillToken {
    /**
     * @notice Emitted when a skill is added or updated by the owner
     * @param skillId The ID of the skill
     * @param ipfsHash The IPFS hash of the skill's image
     */
    function addOrUpdateSkill(uint256 skillId, string calldata ipfsHash) external;

    /**
     * @notice Emitted when a skill is removed by the owner
     * @param skillIds The array of IDs of the skills being added or updated
     * @param ipfsHashes The array of IPFS hashes of the skills' images being added or updated
     */
    function addSkillsBatch(uint256[] calldata skillIds, string[] calldata ipfsHashes) external;

    /**
     * @notice Emitted when the base URI is set or updated by the owner
     * @param newBaseURI The new base URI for the token metadata
     */
    function setBaseURI(string calldata newBaseURI) external;

    /**
     * @notice Mints a new skill token to the specified user
     * @param userToApprove The address of the user to approve
     * @param skillId The ID of the skill to mint
     */
    function mintSkill(address userToApprove, uint256 skillId) external;

    /**
     * @notice Returns the URI for the token metadata
     * @param tokenId The ID of the token
     * @return The URI string for the token metadata
     */
    function tokenURI(uint256 tokenId) external view returns (string memory);
}
