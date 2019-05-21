pragma solidity ^0.5.0;

/**
 * @title BytesToTypes
 * @dev The BytesToTypes contract converts the memory byte arrays to the standard solidity types
 * @author pouladzade@gmail.com
 */

contract BytesToTypes {


    function bytesToBytes32(uint _offst, bytes memory  _input) internal pure  returns ( bytes32 _output){
        
        assembly {
            mstore(_output , add(_input, _offst))
            mstore(add(_output,32) , add(add(_input, _offst),32))
            
        }
    }
    
    function bytesToInt64(uint _offst, bytes memory _input) internal pure returns (int64 _output) {
        
        assembly {
            _output := mload(add(_input, _offst))
        }
    }

}