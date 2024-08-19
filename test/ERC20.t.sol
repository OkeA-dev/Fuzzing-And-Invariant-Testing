// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
import "../src/ERC20.sol";
import "forge-std/Test.sol";
import "./Mocks/MockERC20.sol";
contract ERC20Test is Test {
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

    function testFuzz_IncreaseApprove()
}