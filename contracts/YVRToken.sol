pragma solidity ^0.5.2;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol";
import "erc-payable-token/contracts/token/ERC1363/ERC1363.sol";

contract YVRToken is ERC20Detailed, ERC1363 {
  uint256 private INITIAL_SUPPLY = uint256(uint256(300000000) * uint256(1000000000000000000));

  constructor(string memory name,  string memory symbol,  uint8 decimals)
    ERC20Detailed(name, symbol, decimals)
    ERC1363()
  public
  {
    _mint(msg.sender, INITIAL_SUPPLY);
  }
}