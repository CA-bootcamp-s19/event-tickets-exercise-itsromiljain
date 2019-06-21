pragma solidity >=0.4.0 <0.7.0;

contract ThrowProxy {

     address public target;
     bytes data;

     constructor(address _target) public{
         target = _target;
     }

     function() external {
         data = msg.data;
     }

     function execute() public returns(bool){
        (bool res,) = target.call(data);
        return res;
     }

     function execute(uint val) public returns(bool){
         (bool res, ) = target.call.value(val)(data);
         return res;
     }

}