// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Ownable} from "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

/**
 * @title SkillToken (Soulbound)
 * @author Neti's Intern Team
 * @notice A simple ERC721 token with SBT implementation representing skills.
 */
contract SkillToken is ERC721, Ownable {
    /* Errors */
    error InputArraysLengthMismatch(uint256 skillIdsLength, uint256 ipfsHashesLength);
    error TokenDoesNotExist(uint256 tokenId);
    error SkillDoesNotExist(uint256 skillId);
    error CannotApproveSelf();
    error CannotApproveZeroAddress();
    error AlreadyApprovedByApprover();
    error CannotBeTransferred();
    error CannotBeApproved();

    /* State Variables */

    uint256 private _nextTokenId;
    string private _baseUri = "https://lavender-blank-primate-819.mypinata.cloud/ipfs/";

    /**
     * @notice Maps token IDs to skill IDs
     */
    mapping(uint256 tokenId => uint256 skillId) public tokenToSkill;

    /**
     * @notice Maps skill IDs to their IPFS image hashes
     */
    mapping(uint256 skillId => string imageHash) public skillToImage;

    /**
     * @notice Maps token IDs to their approvers
     */
    mapping(uint256 tokenId => address approver) public tokenToApprover;

    /**
     * @dev Maps skill IDs to user addresses to approver addresses to approval status
     * @notice Does Approver approve the skill for the user?
     */
    mapping(uint256 skillId => mapping(address user => mapping(address approver => bool))) public
        skillToUserToApproverStatus;

    /* Events */

    /**
     * @notice Emitted when a skill is minted
     * @param from The address of the approver
     * @param to The address of the user receiving the skill
     * @param skillId The ID of the skill being minted
     */
    event TokenMinted(address indexed from, address indexed to, uint256 indexed skillId);

    /* Functions */

    /**
     * @notice Constructor to initialize the SkillToken contract
     */
    constructor() ERC721("SkillToken", "SKT") Ownable(msg.sender) {}

    /**
     * @notice Only the owner can add or update skills
     * @param skillId The ID of the skill to add or update
     * @param ipfsHash The IPFS hash of the skill's image
     */
    function addOrUpdateSkill(uint256 skillId, string memory ipfsHash) public onlyOwner {
        skillToImage[skillId] = ipfsHash;
    }

    /**
     * @notice Batch function to add or update multiple skills by owner
     * @param skillIds The IDs of the skills to add or update
     * @param ipfsHashes The IPFS hashes of the skills' images
     */
    function addSkillsBatch(uint256[] memory skillIds, string[] memory ipfsHashes) public onlyOwner {
        if (skillIds.length != ipfsHashes.length) {
            revert InputArraysLengthMismatch(skillIds.length, ipfsHashes.length);
        }
        for (uint256 i = 0; i < skillIds.length; ++i) {
            skillToImage[skillIds[i]] = ipfsHashes[i];
        }
    }

    /**
     * @notice Set the base URI for the token metadata
     * @param newBaseURI The new base URI to be set
     */
    function setBaseURI(string memory newBaseURI) public onlyOwner {
        _baseUri = newBaseURI;
    }

    /**
     * @notice Returns the base URI for the token metadata
     * @return URI as a string
     */
    function _baseURI() internal view override returns (string memory) {
        return _baseUri;
    }

    /**
     * @notice The tokenURI for a given token ID
     * @param tokenId The ID of the token to get the URI for
     * @return URI string for the token metadata
     */
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (tokenToApprover[tokenId] == address(0)) {
            revert TokenDoesNotExist(tokenId);
        }
        uint256 skillId = tokenToSkill[tokenId];
        string memory imageIPFS = skillToImage[skillId];
        return string(abi.encodePacked(_baseURI(), imageIPFS));
    }

    /**
     * @notice Mint a SkillToken for a user, approving them for a specific skill
     * @param userToApprove The address of the user to approve for the skill
     * @param skillId The ID of the skill to mint
     */
    function mintSkill(address userToApprove, uint256 skillId) public {
        if (userToApprove == msg.sender) {
            revert CannotApproveSelf();
        }
        if (userToApprove == address(0)) {
            revert CannotApproveZeroAddress();
        }
        if (bytes(skillToImage[skillId]).length == 0) {
            revert SkillDoesNotExist(skillId);
        }
        if (skillToUserToApproverStatus[skillId][userToApprove][msg.sender] == true) {
            revert AlreadyApprovedByApprover();
        }

        uint256 tokenId = ++_nextTokenId;
        _safeMint(userToApprove, tokenId);

        emit TokenMinted(msg.sender, userToApprove, skillId);

        tokenToSkill[tokenId] = skillId;
        tokenToApprover[tokenId] = msg.sender;
        skillToUserToApproverStatus[skillId][userToApprove][msg.sender] = true;
    }

    /* solhint-disable use-natspec */
    /**
     * @notice Override the transferFrom function to prevent transfers (SBT behavior)
     */
    function transferFrom(address, /*from*/ address, /*to*/ uint256 /*tokenId*/ ) public pure override {
        revert CannotBeTransferred();
    }

    /**
     * @notice Override the safeTransferFrom function to prevent transfers (SBT behavior)
     */
    function safeTransferFrom(address, /*from*/ address, /*to*/ uint256, /*tokenId*/ bytes memory /*data*/ )
        public
        pure
        override
    {
        revert CannotBeTransferred();
    }

    /**
     * @notice Override the approve function to prevent approvals (SBT behavior)
     */
    function approve(address, /*to*/ uint256 /*tokenId*/ ) public pure override {
        revert CannotBeApproved();
    }

    /**
     * @notice Override the setApprovalForAll function to prevent approvals (SBT behavior)
     */
    function setApprovalForAll(address, /*operator*/ bool /*approved*/ ) public pure override {
        revert CannotBeApproved();
    }
    /* solhint-enable use-natspec */
}
