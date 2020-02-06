pragma solidity >=0.4.21 <0.6.0;

import "openzeppelin-solidity/contracts/token/ERC20/ERC20.sol";

contract BombFaucet {
    mapping(address => bool) participants;
    ERC20 tok;
    uint256 amount;

    constructor(address _a) public {
        tok = ERC20(_a);
    }

    function get() public {
        require(participants[msg.sender] == false, "woks only once");
        require(tok.balanceOf(address(this)) > 40000, "No bombs left");
        require(
            tok.transfer(msg.sender, tok.balanceOf(address(this)) / 20000),
            "transfer failed"
        );
        participants[msg.sender] = true;

    }
}
