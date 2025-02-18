pragma solidity ^0.8.23;

contract mainToken {
    uint256 private tokenTotalSupply;
    string private tokenName;
    string private tokenSymbol;
    uint8 private tokenDecimals;

    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Transfer(address indexed from, address indexed to, uint256 value);
    constructor() {
        tokenName = "mainToken";
        tokenSymbol = "main";
        tokenDecimals = 9;
    }
}