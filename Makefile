-include .env

deploy-sepolia:
	forge script script/SkillChain.s.sol --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY) --broadcast --verify

send-mintSkill:
	cast send $(SEPOLIA_CONTRACT_ADDRESS) "mintSkill(address, uint256)" $(SEPOLIA_TEST_ADDRESS) 3 --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY)

call-tokenURI:
	cast send $(SEPOLIA_CONTRACT_ADDRESS) "tokenURI(uint256)" 1 --rpc-url $(SEPOLIA_RPC_URL) --private-key $(SEPOLIA_PRIVATE_KEY)


