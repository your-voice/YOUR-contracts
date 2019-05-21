pragma solidity ^0.5.8;

import "../utils/BytesToTypes.sol";
import "../utils/SizeOf.sol";
import "../receiptaccesscontrol/PaymentGatewayRole.sol";
import "../receiptcore/Ownable.sol";
import "erc-payable-token/contracts/payment/ERC1363Payable.sol";
import "erc-payable-token/contracts/token/ERC1363/ERC1363.sol";
contract ReceiptApp is Ownable, PaymentGatewayRole,  ERC1363Payable, BytesToTypes, SizeOf {

  ReceiptProxy receiptStore;
  IERC1363 private ERC1363Token;

  constructor(address _receipteStore, IERC1363 _acceptedToken) ERC1363Payable(_acceptedToken) public {
    require(address(0) != address(_acceptedToken), "Accepted token is wrong");
    ERC1363Token = _acceptedToken;
    receiptStore = ReceiptProxy(_receipteStore);
  }
  event IPFS(string);
  // Define a modifier that checks if the paid amount is sufficient to cover the price
  modifier paidEnough(uint paidTokens, uint transactionAmount) {
    require((paidTokens * receiptStore.tokenValue() / 10000 )>= (transactionAmount * receiptStore.amountFee() / (10000 * 100)), "Not enough token given");
    _;
  }

  // Define a function 'kill' if required
  function kill() public {
    if (isOwner()){
      selfdestruct(msg.sender);
    }
  }
/*
  function makeReceipt(address _buyer,address _seller,uint _timestamp,uint _amount,uint8  _currency,bytes32  _reason,bytes32 _orderId) public onlyPaymentGateway // solhint-disable-line max-line-length
  {
    //check if buyer is already in its role
    if (isBuyer(_buyer) == false) {
      addBuyer(_buyer);
    }

    //check if seller is already in its role
    if (isSeller(_seller) == false) {
      addSeller(_seller);
    }

    // Add the new item as part of Harvest
    ReceiptItem memory receipt;
    receipt.buyer = _buyer;
    receipt.seller = _seller;
    receipt.timestamp = _timestamp;
    receipt.amount = _amount;
    receipt.currency = _currency;
    receipt.reason = _reason;
    receipt.orderId = _orderId;
        
    bytes32 key = keccak256(abi.encodePacked(_buyer, _seller, _timestamp));
    receipts[key] = receipt;
    
    // Emit the appropriate event
    emit NewReceipt(key);
  }
  // Define a function 'milkCow' that allows a farmer to mark an item 'Milked'
  function makeShortReceipt(address _buyer,  address _seller, bytes32  ipfs, bool _trackRoles ) public 
  {
    if (_trackRoles){
      //check if buyer is already in its role
      if (isBuyer(_buyer) == false) {
        addBuyer(_buyer);
      }

      //check if seller is already in its role
      if (isSeller(_seller) == false) {
        addSeller(_seller);
      }
    }

    shortReceipts[ipfs] = _buyer;

    emit NewShortReceipt(ipfs);
  }
*/

    /**
     * @dev This method is called after `onTransferReceived`.
     *  Note: remember that the token contract address is always the message sender.
     * @param operator The address which called `transferAndCall` or `transferFromAndCall` function
     * @param from Address performing the token purchase
     * @param value The amount of tokens transferred
     * @param data Additional data with no specified format
     */
  function _transferReceived(address operator, address from, uint256 value, bytes memory data) internal  {
    // Deserializing input data (get receipt and original tx amount)
    uint offset = 40;
    uint64 txAmount;
    txAmount = uint64(bytesToInt64(offset, data));
    offset -= sizeOfInt(64);
    bytes32 ipfsHex;
    ipfsHex = bytesToBytes32(offset, data);
    _addReceipt(value, txAmount, stringToBytes32(data));
    
  }

  function _addReceipt (uint paidTokens, uint _transactionAmount,  bytes32 _transactionreference) internal paidEnough(paidTokens, _transactionAmount) {
    receiptStore.addReceipt(_transactionreference);
  }

  function stringToBytes32(bytes memory source) private pure returns (bytes32 result) {
    bytes memory tempEmptyStringTest = bytes(source);
    if (tempEmptyStringTest.length == 0) {
      return 0x0;
    }

    assembly {
        result := mload(add(source, 32))
    }
  
  }
  function bytes32ToString(bytes32 x) private pure returns (string memory) {
    bytes memory bytesString = new bytes(32);
    uint charCount = 0;
    for (uint j = 0; j < 32; j++) {
      byte char = byte(bytes32(uint(x) * 2 ** (8 * j)));
      if (char != 0) {
        bytesString[charCount] = char;
        charCount++;
      }
    }
    bytes memory bytesStringTrimmed = new bytes(charCount);
    for (uint j = 0; j < charCount; j++) {
      bytesStringTrimmed[j] = bytesString[j];
    }
    return string(bytesStringTrimmed);
  }

  function transferToken(address _tokenAddress, uint _value) public onlyOwner() returns (bool success)  {

    ERC1363 tokenContract = ERC1363(_tokenAddress);
    require(tokenContract.balanceOf(address(this)) >= _value,"Not enough tokens");
    return tokenContract.transfer(msg.sender, _value);
  }

}


contract ReceiptProxy{
  function tokenValue() external returns (uint24);
  function amountFee() external returns (uint24);
  function addReceipt( bytes32  ipfs) external;

}