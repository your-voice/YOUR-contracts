pragma solidity ^0.5.8;

import "../receiptaccesscontrol/ReceiptAppsRole.sol";

contract Receipt is ReceiptAppsRole {
  mapping (bytes32 => bool) public shortReceipts;
  uint256 public totReceipts;
  //mapping (uint256 => bytes32) public receipts;
  ReceiptPrice  _receiptPrice;
  address private contractOwner;              // Account used to deploy contract
  struct ReceiptPrice{
    uint24 amountFee;   //smart contract fee in % of CC transaction. Resolution is 4 decimals
    uint24 tokenValue;  //smart token value in EUR. Resolution is 4 decimals
  }

  event NewReceipt(bytes32 ticket);

  constructor() public  {
    contractOwner = msg.sender;
    ReceiptPrice memory price;
    price.amountFee = 0;
    price.tokenValue = 1;
    _receiptPrice = price;
    totReceipts = 0;
  }

  /********************************************************************************************/
  /*                                       FUNCTION MODIFIERS                                 */
  /********************************************************************************************/

  /**
  * @dev Modifier that requires the "ContractOwner" account to be the function caller
  */
  modifier requireContractOwner()
  {
    require(msg.sender == contractOwner, "Caller is not contract owner");
    _;
  }

  /********************************************************************************************/
  /*                                       SMART CONTRACT FUNCTIONS                           */
  /********************************************************************************************/
  /**
  * @return the name of the token.
  */
  function amountFee() public view returns (uint24) {
    return _receiptPrice.amountFee;
  }
    /**
  * @return the name of the token.
  */
  function tokenValue() public view returns (uint24) {
    return _receiptPrice.tokenValue;
  }


  function addReceipt(bytes32  ipfs) public onlyReceiptApp {
    shortReceipts[ipfs] = true;
    totReceipts = totReceipts + 1;
    emit NewReceipt(ipfs);
  }

  function setReceiptPrice(uint24 _tokenValue, uint24 _amountFee) public requireContractOwner{
    _receiptPrice.amountFee = _amountFee;
    _receiptPrice.tokenValue = _tokenValue;
  }

  function getReceipt(bytes32 _ipfs ) public view returns(bool){
    //require(shortReceipts[_ipfs], "Receipt not found");
    return shortReceipts[_ipfs];

  }
}