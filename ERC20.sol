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
    * @param vale：表示授权给地址的额度，打击可以比作你存到银行里面钱的总量
    * /
    function approve(address spender, uint256 value) external returns(bool);
    /**
    * @dev转账函数：不同于前面的transfer，本函数不仅可以对自己钱包下的地址进行转账，同时可以操作对自己授权了的地址进行转账
    * @param from：转账地址
    * @param to:收款地址
    * @param amount：转账金额
    */
    function transferFrom(address from, address to,uint256 amount) external returns(bool);
}



contract ERC20 is IERC20 {
    /*solidity中的public变量将自动创建一个gettar函数，重写了接口中的类。
    即创建了一个函数balanceOf()，返回值为其余额*/
    mapping(address=>uint256) public override balanceOf;
    mapping(address=>mapping(address=>uint256)) public override allowance;
    address public owner;
    bool public minted=false;
    uint256 public totalAmount;
    string public name;
    string public symbol;
    //只在合约创建的时候执行一次
    constructor(string memory _name, string memory _symbol, uint256 _totalAmount){
        owner = msg.sender;
        name = _name;
        symbol =_symbol;
        totalAmount = _totalAmount;
        
    }
    //修饰器，限制合约调用对象必须为owner，否则报错
    modifier onlyOwner(){
        require(msg.sender==owner);
        _;
    }

    /**
    * @dev 铸造函数 给合约的发布者转账totalAmount数量代币
    */
    function mint() external onlyOwner {
        require(msg.sender==owner,"you do not have the permission");//必须合约创建者才可以铸造
        require(!minted,"you can not ge jiucai");//限定只可以铸造一次，即使合约发布者也无权更改
        balanceOf[msg.sender] += totalAmount;
        minted=true;
        emit Transfer(address(0), msg.sender, totalAmount);//触发转账事件，进行记录
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
