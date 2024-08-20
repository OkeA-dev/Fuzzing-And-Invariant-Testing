// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "../src/ERC20.sol";
import "forge-std/Test.sol";
import {MockERC20} from "./Mocks/MockERC20.sol";
import {TestUtils} from "./Utils/TestUtils.sol";

contract ERC20Test is Test, TestUtils {
    MockERC20 internal _token;

    function setUp() public virtual {
        _token = new MockERC20("SPHERE", "SPH", 18);
    }

    function testFuzz_metadata(string memory name_, string memory symbol_, uint8 decimals_) public {
        MockERC20 mockToken = new MockERC20(name_, symbol_, decimals_);

        assertEq(mockToken.name(), name_);
        assertEq(mockToken.symbol(), symbol_);
        assertEq(mockToken.decimals(), decimals_);
    }

    function testFuzz_mint(address recipient_, uint256 amount_) public {
        _token.mint(recipient_, amount_);

        assertEq(_token.totalSupply(), amount_);
        assertEq(_token.balanceOf(recipient_), amount_);
    }

    function testFuzz_burn(address account_, uint256 amount0_, uint256 amount1_) public {
        if (amount1_ > amount0_) return;
        _token.mint(account_, amount0_);
        _token.burn(account_, amount1_);

        assertEq(_token.totalSupply(), amount0_ - amount1_);
        assertEq(_token.balanceOf(account_), amount0_ - amount1_);
    }

    function testFuzz_approve(address account_, uint256 amount_) public {
        assertTrue(_token.approve(account_, amount_));
        assertEq(_token.allowance(address(this), account_), amount_);
    }

    function testFuzz_IncreaseAllowance(address account_, uint256 initialAmount_, uint256 addedAmount_) public {
        initialAmount_ = constrictToRange(initialAmount_, 0, type(uint256).max / 2);
        addedAmount_ = constrictToRange(addedAmount_, 0, type(uint256).max / 2);
        _token.approve(account_, initialAmount_);

        assertEq(_token.allowance(address(this), account_), initialAmount_);
        
        assertTrue(_token.increaseAllowance(account_, addedAmount_));

        assertEq(_token.allowance(address(this), account_), initialAmount_ + addedAmount_);

    }

    function invariant_metadataIsConstant() public view {
        assertEq(_token.name(), "SPHERE");
        assertEq(_token.symbol(), "SPH");
        assertEq(_token.decimals(), 18);
    }

    function testInvariant_mintingAffectsTotalSupplyAndBalance(address to_, uint256 amount_) public {
        vm.assume(to_ != address(0));

        uint256 preSupply = _token.totalSupply();

        _token.mint(to_, amount_);

        uint256 postSupply = _token.totalSupply();
        uint256 toBalance = _token.balanceOf(to_);

        assertEq(
            postSupply,
            preSupply + amount_,
            "Total supply did not increase correctly after minting"
        );

        assertEq(
            toBalance,
            amount_,
            "Recipient balance incorrect after minting"
        );


    }


}
