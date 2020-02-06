pragma solidity >=0.4.21 <0.6.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract LBombToken is ERC20 {
    string public name = "liquid Bomb";
    string public symbol = "LBOMB";
    uint256 public decimals = 18;

    address public minter;

    function setMinter(address _minter) external {
        require(minter == address(0), "minter cannot change");
        minter = _minter;
    }

    function mint(address receipient, uint256 amount) external {
        require(msg.sender == minter, "only bank can mint");
        _mint(receipient, amount);
    }

    function burn(address owner, uint256 amount) external {
        require(msg.sender == minter, "only bank can mint");
        _burn(owner, amount);
    }

}
