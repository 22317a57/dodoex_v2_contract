/*

    Copyright 2021 DODO ZOO.
    SPDX-License-Identifier: Apache-2.0

*/

pragma solidity 0.6.9;

import {SafeMath} from "../../lib/SafeMath.sol";
import {InitializableOwnable} from "../../lib/InitializableOwnable.sol";

contract CustomERC20 is InitializableOwnable {
    using SafeMath for uint256;

    string public name;
    uint256 public decimals;
    string public symbol;
    uint256 public totalSupply;

    uint256 public tradeBurnRatio;
    uint256 public tradeFeeRatio;
    address public team;
    bool public isMintable;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) internal allowed;

    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    event Mint(address indexed user, uint256 value);
    event Burn(address indexed user, uint256 value);

    event ChangeTeam(address oldTeam, address newTeam);


    function init(
        address _creator,
        uint256 _initSupply,
        string memory _name,
        string memory _symbol,
        uint256 _decimals,
        uint256 _tradeBurnRatio,
        uint256 _tradeFeeRatio,
        address _team,
        bool _isMintable
    ) public {
        initOwner(_creator);
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initSupply;
        balances[_creator] = _initSupply;
        require(_tradeBurnRatio >= 0 && _tradeBurnRatio <= 5000, "TRADE_BURN_RATIO_INVALID");
        require(_tradeFeeRatio >= 0 && _tradeFeeRatio <= 5000, "TRADE_FEE_RATIO_INVALID");
        tradeBurnRatio = _tradeBurnRatio;
        tradeFeeRatio = _tradeFeeRatio;
        team = _team;
        isMintable = _isMintable;
        emit Transfer(address(0), _creator, _initSupply);
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender,to,amount);
        return true;
    }

    function balanceOf(address owner) public view returns (uint256 balance) {
        return balances[owner];
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        require(amount <= allowed[from][msg.sender], "ALLOWANCE_NOT_ENOUGH");
        _transfer(from,to,amount);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(amount);
        return true;
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return allowed[owner][spender];
    }


    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(balances[sender] >= amount, "ERC20: transfer amount exceeds balance");

        balances[sender] = balances[sender].sub(amount);

        uint256 burnAmount;
        uint256 feeAmount;
        if(tradeBurnRatio > 0) {
            burnAmount = amount.mul(tradeBurnRatio).div(10000);
            balances[address(0)] = balances[address(0)].add(burnAmount);
        }

        if(tradeFeeRatio > 0) {
            feeAmount = amount.mul(tradeFeeRatio).div(10000);
            balances[team] = balances[team].add(feeAmount);
        }

        balances[recipient] = balances[recipient].add(amount.sub(burnAmount).sub(feeAmount));

        emit Transfer(sender, recipient, amount);
    }


    //=================== Ownable ======================
    function mint(address user, uint256 value) external onlyOwner {
        require(isMintable, "NOT_MINTABEL_TOKEN");
        balances[user] = balances[user].add(value);
        totalSupply = totalSupply.add(value);
        emit Mint(user, value);
        emit Transfer(address(0), user, value);
    }

    function burn(address user, uint256 value) external onlyOwner {
        require(isMintable, "NOT_MINTABEL_TOKEN");
        balances[user] = balances[user].sub(value);
        totalSupply = totalSupply.sub(value);
        emit Burn(user, value);
        emit Transfer(user, address(0), value);
    }

    function changeTeamAccount(address newTeam) external onlyOwner {
        require(tradeFeeRatio > 0, "NOT_TRADE_FEE_TOKEN");
        emit ChangeTeam(team,newTeam);
        team = newTeam;
    }
}
