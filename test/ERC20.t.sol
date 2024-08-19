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
}