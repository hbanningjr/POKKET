// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

contract WalletRegistry {
    enum Category {
        None,
        Voting,
        NFT,
        DeFi,
        RealEstate,
        Test
    }

    struct WalletInfo {
        Category category;
        string label;
        bool exists;
    }

    mapping(address => WalletInfo) private wallets;

    event WalletRegistered(address indexed wallet, Category category, string label);

    function registerWallet(Category category, string calldata label) external {
        require(!wallets[msg.sender].exists, "Wallet already registered");

        wallets[msg.sender] = WalletInfo({category: category, label: label, exists: true});

        emit WalletRegistered(msg.sender, category, label);
    }

    function getWalletInfo(address wallet) external view returns (WalletInfo memory) {
        return wallets[wallet];
    }

    function isCategory(address wallet, Category categoryToCheck) external view returns (bool) {
        WalletInfo memory info = wallets[wallet];
        return info.exists && info.category == categoryToCheck;
    }
}
