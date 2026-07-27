// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import {Test} from "forge-std/Test.sol";
import {WalletRegistry} from "../src/WalletRegistry.sol";

contract WalletRegistryTest is Test {
    WalletRegistry internal registry;

    address internal user = makeAddr("user");
    address internal secondUser = makeAddr("secondUser");
    address internal unregisteredUser = makeAddr("unregisteredUser");

    function setUp() public {
        registry = new WalletRegistry();
    }

    // registerWallet tests
    function test_RegisterWalletStoresWalletInfo() public {
        vm.prank(user);

        registry.registerWallet(WalletRegistry.Category.Test, "Primary Wallet");

        WalletRegistry.WalletInfo memory info = registry.getWalletInfo(user);

        assertEq(uint256(info.category), uint256(WalletRegistry.Category.Test));
        assertEq(info.label, "Primary Wallet");
        assertTrue(info.exists);
    }

    function test_RegisterWalletCannotOverwriteExistingRegistration() public {
        vm.startPrank(user);

        registry.registerWallet(WalletRegistry.Category.Test, "First Wallet");

        vm.expectRevert("Wallet already registered");

        registry.registerWallet(WalletRegistry.Category.DeFi, "Second Wallet");

        vm.stopPrank();
    }

    function test_RegisterWalletUsesMsgSender() public {
        vm.prank(user);

        registry.registerWallet(WalletRegistry.Category.Test, "User Wallet");

        WalletRegistry.WalletInfo memory userInfo = registry.getWalletInfo(
            user
        );

        WalletRegistry.WalletInfo memory otherInfo = registry.getWalletInfo(
            secondUser
        );

        assertTrue(userInfo.exists);
        assertEq(userInfo.label, "User Wallet");
        assertEq(
            uint256(userInfo.category),
            uint256(WalletRegistry.Category.Test)
        );

        assertFalse(otherInfo.exists);
        assertEq(otherInfo.label, "");
    }

    // getWalletInfo tests
    function test_GetWalletInfoReturnsRegisteredWallet() public {
        vm.prank(user);
        registry.registerWallet(WalletRegistry.Category.Test, "Primary Wallet");
        WalletRegistry.WalletInfo memory info = registry.getWalletInfo(user);
        assertEq(uint256(info.category), uint256(WalletRegistry.Category.Test));
        assertEq(info.label, "Primary Wallet");
        assertTrue(info.exists);
    }

    function test_GetWalletInfoReturnsDefaultsForUnregisteredWallet()
        public
        view
    {
        WalletRegistry.WalletInfo memory info = registry.getWalletInfo(
            unregisteredUser
        );
        assertEq(uint256(info.category), uint256(WalletRegistry.Category.None));
        assertEq(info.label, "");
        assertFalse(info.exists);
    }

    function test_GetWalletInfoKeepsWalletRecordsIndependent() public {
        vm.prank(user);
        registry.registerWallet(WalletRegistry.Category.Test, "User Wallet");
        vm.prank(secondUser);
        registry.registerWallet(WalletRegistry.Category.DeFi, "Second Wallet");
        WalletRegistry.WalletInfo memory userInfo = registry.getWalletInfo(
            user
        );
        WalletRegistry.WalletInfo memory secondUserInfo = registry
            .getWalletInfo(secondUser);
        assertEq(
            uint256(userInfo.category),
            uint256(WalletRegistry.Category.Test)
        );
        assertEq(userInfo.label, "User Wallet");
        assertTrue(userInfo.exists);
        assertEq(
            uint256(secondUserInfo.category),
            uint256(WalletRegistry.Category.DeFi)
        );
        assertEq(secondUserInfo.label, "Second Wallet");
        assertTrue(secondUserInfo.exists);
    }

    // isCategory tests
    function test_IsCategoryReturnsTrueForMatchingCategory() public {
        vm.prank(user);
        registry.registerWallet(WalletRegistry.Category.Test, "Primary Wallet");
        bool result = registry.isCategory(user, WalletRegistry.Category.Test);
        assertTrue(result);
    }

    function test_IsCategoryReturnsFalseForDifferentCategory() public {
        vm.prank(user);
        registry.registerWallet(WalletRegistry.Category.Test, "Primary Wallet");
        bool result = registry.isCategory(user, WalletRegistry.Category.DeFi);
        assertFalse(result);
    }

    function test_IsCategoryReturnsFalseForUnregisteredWallet() public view {
        bool result = registry.isCategory(
            unregisteredUser,
            WalletRegistry.Category.None
        );
        assertFalse(result);
    }
}
