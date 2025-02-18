pragma solidity ^0.8.23;

contract mainToken {

    uint256 private _tokenTotalSupply;
    string private _tokenName;
    string private _tokenSymbol;
    uint8 private _tokenDecimals;
    mapping(address => uint256) private _balances;
    mapping(address => mapping(address => uint256)) private _allowances;

    // Define constants for each category's percentage
    uint256 private constant CO_FOUNDER_PERCENTAGE = 12;
    uint256 private constant DEVELOPER_PERCENTAGE = 8;
    uint256 private constant MARKETING_PERCENTAGE = 10;
    uint256 private constant ICO_PERCENTAGE = 20;
    uint256 private constant RESERVE_FUNDS_PERCENTAGE = 15;
    uint256 private constant LIQUIDITY_PERCENTAGE = 15;
    uint256 private constant COMMUNITY_ECOSYSTEM_PERCENTAGE = 20;

    // Define variables to store the token amounts for each category
    uint256 public coFounderTokens;
    uint256 public developerTokens;
    uint256 public marketingTokens;
    uint256 public icoTokens;
    uint256 public reserveFundsTokens;
    uint256 public liquidityTokens;
    uint256 public communityEcosystemTokens;

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);

    // Token Total supply 1000 * 10 ** 8
    // Token decimal 9

    constructor() {
        _tokenName = "mainToken";
        _tokenSymbol = "main";
        _tokenDecimals = 9;
        _tokenTotalSupply = 100000000000 * 10 ** _tokenDecimals;

        // Calculate and allocate tokens for each category
        coFounderTokens = (_tokenTotalSupply * CO_FOUNDER_PERCENTAGE) / 100;
        developerTokens = (_tokenTotalSupply * DEVELOPER_PERCENTAGE) / 100;
        marketingTokens = (_tokenTotalSupply * MARKETING_PERCENTAGE) / 100;
        icoTokens = (_tokenTotalSupply * ICO_PERCENTAGE) / 100;
        reserveFundsTokens = (_tokenTotalSupply * RESERVE_FUNDS_PERCENTAGE) / 100;
        liquidityTokens = (_tokenTotalSupply * LIQUIDITY_PERCENTAGE) / 100;
        communityEcosystemTokens = (_tokenTotalSupply * COMMUNITY_ECOSYSTEM_PERCENTAGE) / 100;

        // Assign the remaining tokens to the contract deployer
        uint256 remainingTokens = _tokenTotalSupply - (coFounderTokens + developerTokens + marketingTokens + icoTokens + reserveFundsTokens + liquidityTokens + communityEcosystemTokens);
        _balances[msg.sender] = remainingTokens;
        emit Transfer(address(0), msg.sender, remainingTokens);
    }

    function decimals() public view virtual returns (uint8) {
        return _tokenDecimals;
    }

    function symbol() public view returns (string memory) {
        return _tokenSymbol;
    }

    function totalSupply() public view returns (uint256) {
        return _tokenTotalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function name() public view returns (string memory) {
        return _tokenName;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public virtual returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        _transfer(msg.sender, to, amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) internal virtual {
        require(owner != address(0), "Approve from the zero address!");
        require(spender != address(0), "Approve to the zero address!");
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(address from, address to, uint256 amount) internal virtual {
        uint256 balance = _balances[from];
        require(balance >= amount, "Not enough amount!");
        require(from != address(0), "Transfer from the zero address!");
        require(to != address(0), "Transfer to the zero address!");
        _balances[from] = _balances[from] - amount;
        _balances[to] = _balances[to] + amount;
        emit Transfer(from, to, amount);
    }

    function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        require(currentAllowance >= amount, "insufficient allowance!");
        _approve(owner, spender, currentAllowance - amount);
    }

    function _mint(address to, uint256 amount) external {
        require(to != address(0), "mint to the zero address!");

        _tokenTotalSupply += amount;
        _balances[to] += amount;

    }

    function _burn(address from, uint256 amount) external {
        require(from != address(0), "mint from zero address!");

        _tokenTotalSupply -= amount;
        _balances[from] -= amount;
    }

}