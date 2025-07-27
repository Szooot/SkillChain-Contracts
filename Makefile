-include .env

deploy-sepolia:
	forge script script/SkillChain.s.sol --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast --verify

send-mintSkill:
	cast send $(SEPOLIA_CONTRACT_ADDRESS) "mintSkill(address, uint256)" $(SEPOLIA_TEST_ADDRESS) 3 --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY)

call-tokenURI:
	cast call $(SEPOLIA_CONTRACT_ADDRESS) "tokenURI(uint256)" 1 --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY)

call-transferFrom:
    cast call $(SEPOLIA_CONTRACT_ADDRESS) "transferFrom(address,address,uint256)" $(SEPOLIA_ACCOUNT_ADDRESS) $(SEPOLIA_TEST_ADDRESS) 1 --rpc-url $(SEPOLIA_RPC_URL)

call-safeTransferFrom:
    cast call $(SEPOLIA_CONTRACT_ADDRESS) "safeTransferFrom(address,address,uint256,bytes)" $(SEPOLIA_ACCOUNT_ADDRESS) $(SEPOLIA_TEST_ADDRESS) 1 0x --rpc-url $(SEPOLIA_RPC_URL)

call-approve:
    cast call $(SEPOLIA_CONTRACT_ADDRESS) "approve(address,uint256)" $(SEPOLIA_TEST_ADDRESS) 1 --rpc-url $(SEPOLIA_RPC_URL)

call-setApprovalForAll:
    cast call $(SEPOLIA_CONTRACT_ADDRESS) "setApprovalForAll(address,bool)" $(SEPOLIA_TEST_ADDRESS) true --rpc-url $(SEPOLIA_RPC_URL)
