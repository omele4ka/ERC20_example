// Код основан на примере 0xProject ERC-20

// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;


contract ERC20Token {
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    mapping (address => uint256) internal balances;
    mapping (address => mapping (address => uint256)) internal allowed;

    uint internal __totalSupply;
    string public name;
    string public symbol;
    uint256 public decimals;

    function transfer(address _to, uint256 _value) external returns (bool) {
        require(balances[msg.sender] >= _value, "ERC20_INSUFFICIENT_BALANCE");
        require(balances[_to] + _value >= balances[_to], "UINT256_OVERFLOW");

        balances[msg.sender] -= _value;
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool) {
        require(balances[_from] >= _value, "ERC20_INSUFFICIENT_BALANCE");
        require(allowed[_from][msg.sender] >= _value, "ERC20_INSUFFICIENT_ALLOWANCE");
        require(balances[_to] + _value >= balances[_to], "UINT256_OVERFLOW");

        balances[_to] += _value;
        balances[_from] -= _value;
        allowed[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        
        return true;
    }

    function approve(address _spender, uint256 _value) external returns (bool) {
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function totalSupply() external view returns (uint256) {
        return __totalSupply;
    }

    function balanceOf(address _owner) external view returns (uint256) {
        return balances[_owner];
    }

    function allowance(address _owner, address _spender) external view returns (uint256) {
        return allowed[_owner][_spender];
    }

    constructor (
        string memory _name,
        string memory _symbol,
        uint256 _decimals,
        uint256 _totalSupply
    ) public {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        __totalSupply = _totalSupply;
        balances[msg.sender] = _totalSupply;
    }
}

/*При деплое контракта надо указать параметры конструктора - имя, символ,
десятичные знаки и общую эмиссию (supply). Приведённая выше реализация не
позволяет изменять эмиссию. Вся созданная эмиссия будет присвоена создателю
токена.
Леджер токена хранится в виде отображения balances. Баланс каждого конкретного
адреса можно проверить методом balanceOf(_owner), где owner - проверяемый
адрес.*/ 