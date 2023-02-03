// SPDX-License-Identifier: BUSINESS
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract StackswapToken is Context, Ownable, ERC20, AccessControl {
    
    address public deployer = address(0);

    // Role
    bytes32 public constant LOGIC_CONTRACT_ROLE = keccak256("UPDATE_BALANCE");

    constructor(uint256 initialSupply) ERC20("Stackswap", "STSW") {
        _mint(msg.sender, initialSupply * 10 ** decimals());
    }

    function mint(address account, uint256 amount) public {
        require(hasRole(LOGIC_CONTRACT_ROLE, _msgSender()), "Only Allowed Contract");
        require(totalSupply() + amount <= 10 ** ( 9 + decimals()), 'Maximum total supply exceeded');
        _mint(account, amount);
    }

    function burn(address account, uint256 amount) public virtual {
        require(hasRole(LOGIC_CONTRACT_ROLE, _msgSender()), "Only Allowed Contract");
        _spendAllowance(account, _msgSender(), amount);
        _burn(account, amount);
    }
    
    function decimals() public pure override returns (uint8) {
        return 6;
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////
    
    function AddAllowedContract(address _target) public onlyOwner{
        require(_target != address(0), "null address is not valid");
        _setupRole(LOGIC_CONTRACT_ROLE, _target);
    }

    function RemoveAllowedContract(address _target) public onlyOwner{
        require(_target != address(0), "null address is not valid");
        _revokeRole(LOGIC_CONTRACT_ROLE, _target);
    }
}