//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
contract myToken is ERC20("My Token", "MT"),Ownable(0x5B38Da6a701c568545dCfcB03FcB875f56beddC4){
    function mintFy() public onlyOwner {
        _mint(msg.sender, 50 * 10**18);
    }
}