pragma solidity ^0.5.8;

// Import the library 'Roles'
import "openzeppelin-solidity/contracts/access/Roles.sol";

// Define a contract 'PaymentGatewayRole' to manage this role - add, remove, check
contract PaymentGatewayRole {
  using Roles for Roles.Role;
  // Define 2 events, one for Adding, and other for Removing
  event PaymentGatewayAdded(address indexed account);
  event PaymentGatewayRemoved(address indexed account);

  // Define a struct 'PaymentGateways' by inheriting from 'Roles' library, struct Role
  Roles.Role _paymentGateways;

  // In the constructor make the address that deploys this contract the 1st PaymentGateway
  constructor() public {
    _addPaymentGateway(msg.sender);
  }

  // Define a modifier that checks to see if msg.sender has the appropriate role
  modifier onlyPaymentGateway() {
    require(isPaymentGateway(msg.sender), "Account is not a PaymentGateway");
    _;
  }

  // Define a function 'isPaymentGateway' to check this role
  function isPaymentGateway(address account) public view returns (bool) {
    return _paymentGateways.has(account);
  }

  // Define a function 'addPaymentGateway' that adds this role
  function addPaymentGateway(address account) public onlyPaymentGateway {
    _addPaymentGateway(account);
  }

  // Define a function 'renouncePaymentGateway' to renounce this role
  function renouncePaymentGateway() public {
    _removePaymentGateway(msg.sender);
  }

  // Define an internal function '_addPaymentGateway' to add this role, called by 'addPaymentGateway'
  function _addPaymentGateway(address account) internal {
    _paymentGateways.add(account);
    emit PaymentGatewayAdded(account);
  }

  // Define an internal function '_removePaymentGateway' to remove this role, called by 'removePaymentGateway'
  function _removePaymentGateway(address account) internal {
    _paymentGateways.remove(account);
    emit PaymentGatewayRemoved(account);
  }
}