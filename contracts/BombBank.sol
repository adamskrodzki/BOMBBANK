pragma solidity >=0.4.21 <0.6.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "./LBombToken.sol";

contract BombBank {
    ERC20 public BombToken;
    LBombToken public lBombToken;

    constructor(address _bomb, address _lbomb) public {
        BombToken = ERC20(_bomb);
        lBombToken = LBombToken(_lbomb);
    }

    function foo(uint256 amount) public {}

    function wrap(uint256 amount) public returns (uint256 wrappedAmount) {
        uint256 prevBalance = BombToken.balanceOf(address(this));
        BombToken.transferFrom(msg.sender, address(this), amount);
        uint256 balanceAfter = BombToken.balanceOf(address(this));

        lBombToken.mint(msg.sender, getLBombAmount(balanceAfter - prevBalance));

        wrappedAmount = (balanceAfter - prevBalance);

        return wrappedAmount;
    }

    function getLBombAmount(uint256 bombSupplied)
        public
        view
        returns (uint256 amount)
    {
        uint256 totalBomb = BombToken.balanceOf(address(this));
        uint256 totalLBomb = lBombToken.totalSupply();

        if (totalLBomb == 0) {
            amount = bombSupplied * (10**18);
        } else {
            amount = (totalLBomb * bombSupplied) / (totalBomb - bombSupplied);
        }
        return amount;
    }

    function donate(uint256 amount) public {
        BombToken.transferFrom(msg.sender, address(this), amount);
        emit Donated(msg.sender, amount);
    }

    function getBombAmount(uint256 amount)
        public
        view
        returns (uint256 retVal)
    {
        retVal = BombToken.balanceOf(address(this)) * amount;
        retVal = retVal / lBombToken.totalSupply();
        return retVal;
    }

    function backedBy() public view returns (uint256) {
        uint256 retVal = BombToken.balanceOf(address(this));
        return retVal;
    }

    function unwrap(uint256 amount) public returns (uint256 unwrappedAmount) {
        uint256 bombAmount = getBombAmount(amount);
        lBombToken.transferFrom(msg.sender, address(this), amount);
        lBombToken.burn(address(this), amount);
        uint256 balanceBefore = BombToken.balanceOf(msg.sender);
        BombToken.transfer(msg.sender, bombAmount);
        uint256 balanceAfter = BombToken.balanceOf(msg.sender);
        unwrappedAmount = balanceAfter - balanceBefore;
        return unwrappedAmount;
    }

    event Donated(address donor, uint256 amount);

}
