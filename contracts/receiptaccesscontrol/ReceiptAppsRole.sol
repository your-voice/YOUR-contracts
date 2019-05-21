pragma solidity ^0.5.8;

// Import the library 'Roles'
import "openzeppelin-solidity/contracts/access/Roles.sol";

// Define a contract 'ReceiptAppRole' to manage this role - add, remove, check
contract ReceiptAppsRole {
  using Roles for Roles.Role;

  // Define 2 events, one for Adding, and other for Removing
  event ReceiptAppAdded(address indexed account);
  event ReceiptAppRemoved(address indexed account);

  // Define a struct 'ReceiptApps' by inheriting from 'Roles' library, struct Role
  Roles.Role private _receiptApps;

  // In the constructor make the address that deploys this contract the 1st ReceiptApp
  constructor() public {
    //be sure that contract owner 
    _addReceiptApp(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyReceiptApp() {
    require(isReceiptApp(msg.sender), "Caller is not a ReceiptApp.");
    _;
  }

  // Define a function 'isReceiptApp' to check this role
  function isReceiptApp(address account) public view returns (bool) {
    return _receiptApps.has(account);
  }

  // Define a function 'addReceiptApp' that adds this role
  function addReceiptApp(address account) public onlyReceiptApp {
    _addReceiptApp(account);
  }

  // Define a function 'renounceReceiptApp' to renounce this role
  function renounceReceiptApp() public  {
    _removeReceiptApp(msg.sender);
  }

  // Define an internal function '_addReceiptApp' to add this role, called by 'addReceiptApp'
  function _addReceiptApp(address account) internal {
    _receiptApps.add(account);
    emit ReceiptAppAdded(account);
  }

  // Define an internal function '_removeReceiptApp' to remove this role, called by 'removeReceiptApp'
  function _removeReceiptApp(address account) internal {
    _receiptApps.remove(account);
    emit ReceiptAppRemoved(account);
  }
}