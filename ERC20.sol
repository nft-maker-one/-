// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);//转账事件
    event Approval(address indexed owner, address indexed spender, uint256 value);//授权事件
    function totalSupply() external view returns (uint256);//查询代币总量函数
    function balanceOf(address account) external view returns(uint256);//查询余额函数
    function transfer(address to,uint256 amount) external returns(bool);//从当前地址发起转账函数
    function allowance(address owner, address spender) external view returns(uint256);//授权额度查询函数
    /**
    * @dev授权函数
    * @param spender：授权地址，大家其实可以把授权地址比作银行，加密货币总资产比作你所有的钱，你把钱授权给spender相当于把钱存入银行，spender有权对你的钱进行处置
    function approve(address spender, uint256 value) external returns(bool);
    
    function transferFrom(address from, address to,uint256 amount) external returns(bool);
}



contract ERC20 is IERC20 {
    mapping(address=>uint256) public override balanceOf;
    mapping(address=>mapping(address=>uint256)) public override allowance;
    address public owner;
    bool public minted=false;
    uint256 public totalAmount;
    string public name;
    string public symbol;

    constructor(string memory _name, string memory _symbol, uint256 _totalAmount){
        owner = msg.sender;
        name = _name;
        symbol =_symbol;
        totalAmount = _totalAmount;
        
    }
    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }

    function mint() external onlyOwner {
        require(msg.sender==owner,"you do not have the permission");
        require(!minted,"you can not ge jiucai");
        balanceOf[msg.sender] += totalAmount;
        minted=true;
        emit Transfer(address(0), msg.sender, totalAmount);
    }

    function totalSupply() external view override returns(uint256){
        return minted? totalAmount:0;
    }


    function transfer(address to,uint256 amount) external override returns(bool) {
        require(to!=address(0),"you can not transfer to address 0");
        require(balanceOf[msg.sender]>=amount,"you do not have enough token");
        balanceOf[msg.sender]-=amount;
        balanceOf[to]+=amount;
        emit Transfer(msg.sender,to,amount);
        return true;
    }

    function approve(address spender, uint256 amount) external override returns(bool){
        require(spender!=address(0),"you can not set approval for address 0");
        allowance[msg.sender][spender]+=amount;
        return true;
    }

    function transferFrom(address from, address to,uint256 amount) external override returns (bool){
        require((allowance[from][to]>=amount)||(from==msg.sender),"you can not transfer so much money");
        allowance[from][to]-=amount;
        balanceOf[from]-=amount;
        balanceOf[to]+=amount;
        emit Transfer(from, to, amount);
        return true;
    }


}
