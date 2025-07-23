// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title SkillToken (Soulbound)
 * @dev A simple ERC721 token representing skills.
 */

contract SkillToken is ERC721, Ownable {
    /* Errors */


    /* State Variables */

    uint256 private s_nextTokenId;

    /** @dev Maps token IDs to skill IDs */
    mapping(uint256 => uint256) public s_tokenToSkill;

    /** @dev Maps skill IDs to their IPFS image hashes */
    mapping(uint256 => string) public s_skillToImage;

    /** @dev Maps token IDs to their approvers */
    mapping(uint256 => address) public s_tokenToApprover;

    /** @dev Maps skill IDs to user addresses to approver addresses to approval status 
     *  @notice Does Approver approve the skill for the user?
    */
    mapping(uint256 => mapping(address => mapping(address => bool))) public s_skillToUserToApproverStatus;


    /* Functions */
    constructor(address owner) ERC721("SkillToken", "SKT") Ownable(owner) {}

    /** @notice Only the owner can add or update skills */
    function addOrUpdateSkill(uint256 _skillId, string memory _ipfsHash) public onlyOwner {
        s_skillToImage[_skillId] = _ipfsHash;
    }

    
    function mintSkill(address _userToApprove, uint256 _skillId) public {
        require(_userToApprove != msg.sender, "Cannot approve self");
        require(bytes(s_skillToImage[_skillId]).length > 0, "Skill does not exist");
        require(s_skillToUserToApproverStatus[_skillId][_userToApprove][msg.sender] == false, "Already approved by this approver");

        uint256 tokenId = s_nextTokenId++;
        _safeMint(_userToApprove, tokenId);

        s_tokenToSkill[tokenId] = _skillId;
        s_tokenToApprover[tokenId] = msg.sender;
        s_skillToUserToApproverStatus[_skillId][_userToApprove][msg.sender] = true;

    }

    function tokenURI(uint256 _tokenId) public view override returns (string memory) {
        uint256 skillId = s_tokenToSkill[_tokenId];
        string memory imageIPFS = s_skillToImage[skillId];
        return imageIPFS;
    }


}
