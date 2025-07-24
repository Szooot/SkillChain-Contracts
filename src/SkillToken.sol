// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title SkillToken (Soulbound)
 * @dev A simple ERC721 token representing skills.
 */
contract SkillToken is ERC721, Ownable {
    /* State Variables */

    uint256 private s_nextTokenId;

    /**
     * @dev Maps token IDs to skill IDs
     */
    mapping(uint256 => uint256) public s_tokenToSkill;

    /**
     * @dev Maps skill IDs to their IPFS image hashes
     */
    mapping(uint256 => string) public s_skillToImage;

    /**
     * @dev Maps token IDs to their approvers
     */
    mapping(uint256 => address) public s_tokenToApprover;

    /**
     * @dev Maps skill IDs to user addresses to approver addresses to approval status
     * @notice Does Approver approve the skill for the user?
     */
    mapping(uint256 => mapping(address => mapping(address => bool))) public s_skillToUserToApproverStatus;

    /* Functions */

    constructor() ERC721("SkillToken", "SKT") Ownable(msg.sender) {}

    /**
     * @notice Only the owner can add or update skills
     * @param _skillId The ID of the skill to add or update
     * @param _ipfsHash The IPFS hash of the skill's image
     */
    function addOrUpdateSkill(uint256 _skillId, string memory _ipfsHash) public onlyOwner {
        s_skillToImage[_skillId] = _ipfsHash;
    }

    function addSkillsBatch(uint256[] memory skillIds, string[] memory ipfsHashes) public onlyOwner {
        require(skillIds.length == ipfsHashes.length, "Input arrays must match");
        for (uint256 i = 0; i < skillIds.length; i++) {
            s_skillToImage[skillIds[i]] = ipfsHashes[i];
        }
    }

    /**
     * @notice Returns the base URI for the token metadata
     */
    function _baseURI() internal pure override returns (string memory) {
        return "https://lavender-blank-primate-819.mypinata.cloud/ipfs/";
    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        require(s_tokenToApprover[_tokenId] != address(0), "Token does not exist");
        uint256 skillId = s_tokenToSkill[_tokenId];
        string memory imageIPFS = s_skillToImage[skillId];
        return string(abi.encodePacked(_baseURI(), imageIPFS));
    }

    /**
     * @notice Mint a SkillToken for a user, approving them for a specific skill
     * @param _userToApprove The address of the user to approve for the skill
     * @param _skillId The ID of the skill to mint
     */
    function mintSkill(address _userToApprove, uint256 _skillId) public {
        require(_userToApprove != msg.sender, "Cannot approve self");
        require(_userToApprove != address(0), "Cannot approve zero address");
        require(bytes(s_skillToImage[_skillId]).length > 0, "Skill does not exist");
        require(
            s_skillToUserToApproverStatus[_skillId][_userToApprove][msg.sender] == false,
            "Already approved by this approver"
        );

        uint256 tokenId = ++s_nextTokenId;
        _safeMint(_userToApprove, tokenId);

        s_tokenToSkill[tokenId] = _skillId;
        s_tokenToApprover[tokenId] = msg.sender;
        s_skillToUserToApproverStatus[_skillId][_userToApprove][msg.sender] = true;
    }

    /**,o
     * @dev Overrides the transferFrom & approve functions to prevent transfers and approvals - Soulbound Logic
     */
    function transferFrom(address, /*from*/ address to, uint256 /*tokenId*/ ) public pure override {
        if (to != address(0)) revert("SkillToken is soulbound and cannot be transferred");
    }

    function safeTransferFrom(address, /*from*/ address, /*to*/ uint256, /*tokenId*/ bytes memory /*data*/ )
        public
        pure
        override
    {
        revert("SkillToken is soulbound and cannot be transferred");
    }

    function approve(address, /*to*/ uint256 /*tokenId*/ ) public pure override {
        revert("SkillToken is soulbound and cannot be approved");
    }

    function setApprovalForAll(address, /*operator*/ bool /*approved*/ ) public pure override {
        revert("SkillToken is soulbound and cannot be approved");
    }
}
