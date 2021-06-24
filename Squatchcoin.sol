/*
 _____             _       _   _____     _     
|   __|___ _ _ ___| |_ ___| |_|     |___|_|___ 
|__   | . | | | .'|  _|  _|   |   --| . | |   |
|_____|_  |___|__,|_| |___|_|_|_____|___|_|_|_|
        |_|                                       

MMMMMMMMMMMMMMMMMMMMMMMMMMMMWXO0NMMMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMMMNkc'..;kWMMMMM
MMMMMMMMMMMMMMMMMMMMMMMMNO;      .OMMMMM
MMMMMMMMMMMMMMMMMMMMMWKx;.       .xMMMMM
MMMMMMMMMMMMMWX0OOOxdl.          .dWMMMM
MMMMMMMMMMMXd;.                  ,0MMMMM
MMMMMMMMMMNc                     oWMMMMM
MMMMMMMMMXl.                   .:0MMMMMM
MMMMMMMW0;                    ,kNMMMMMMM
MMMMMMMNl                     cXMMMMMMMM
MMMMMMMK;                     .xMMMMMMMM
MMMMMMNl                      .OMMMMMMMM
MMMMMXl.     '.               .kWMMMMMMM
MMMMWd.     ,c.                .oXWMMMMM
MMMMX;    .dx.            '.     .oXMMMM
MMMM0,   .kO,            .lkxl'    :KMMM
MMMNo.   lNx.              'xN0,    :XMM
Xxc,.   .kWk.                cX0cco',KMM
kc;,'';o0WMWx.               .oNWWW0ONMM
MWWWNNWMMMMM0'                .oNMMMMMMM
MMMMMMMMMW0o'         ..       .OMMMMMMM
MMMMMMMMNo.          .kKl.     .xMMMMMMM
MMMMMMMXl.        .:x0WMNd.     cNMMMMMM
MMMMW0l,       .;d0NMMMMMNx.    cNMMMMMM
MMMXd.      .cxKWMMMMMMMMMWx.   oNWWWXKX
MMXc      .oKWMMMMMMMMMMMMMX:   .,,;,',x
MMXl'.     .;oONMMMMMMMMMMMNc       .:OW
MMMWNXOl;',;;;oKMMMMMMMMMMMXl...';coOWMM
MMMMMMMMNNNWWWMMMMMMMMMMMMMMN00KNWMMMMMM

 _____ _____ _____ 
|   __|     |     |
|__   |  |  |   --|
|_____|__  _|_____|
         |__|      
*/

pragma solidity ^0.8.4;
// SPDX-License-Identifier: Unlicensed

interface IERC20 {

    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint256);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(address indexed owner, address indexed spender, uint256 value);
}

library SafeMath {
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

abstract contract Context {
    function _msgSender() internal view virtual returns (address payable) {
        return payable(msg.sender);
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

library Address {
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly { codehash := extcodehash(account) }
        return (codehash != accountHash && codehash != 0x0);
    }

    function sendValue(address payable recipient, uint256 amount) internal {
        require(address(this).balance >= amount, "Address: insufficient balance");

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{ value: amount }("");
        require(success, "Address: unable to send value, recipient may have reverted");
    }

    function functionCall(address target, bytes memory data) internal returns (bytes memory) {
      return functionCall(target, data, "Address: low-level call failed");
    }

    function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
        return _functionCallWithValue(target, data, 0, errorMessage);
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
        return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
    }

    function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
        require(address(this).balance >= value, "Address: insufficient balance for call");
        return _functionCallWithValue(target, data, value, errorMessage);
    }

    function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
        require(isContract(target), "Address: call to non-contract");

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly

                // solhint-disable-next-line no-inline-assembly
                assembly {
                    let returndata_size := mload(returndata)
                    revert(add(32, returndata), returndata_size)
                }
            } else {
                revert(errorMessage);
            }
        }
    }
}

contract Ownable is Context {
    address private _owner;
    address private _previousOwner;
    uint256 private _lockTime;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor () {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(newOwner != address(0), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    function getUnlockTime() public view returns (uint256) {
        return _lockTime;
    }

    //Locks the contract for owner for the amount of time provided
    function lock(uint256 time) public virtual onlyOwner {
        _previousOwner = _owner;
        _owner = address(0);
        _lockTime = block.timestamp + time;
        emit OwnershipTransferred(_owner, address(0));
    }
    
    //Unlocks the contract for owner when _lockTime is exceeds
    function unlock() public virtual {
        require(_previousOwner == msg.sender, "You don't have permission to unlock");
        require(block.timestamp > _lockTime , "Contract is locked until 7 days");
        emit OwnershipTransferred(_owner, _previousOwner);
        _owner = _previousOwner;
    }
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

contract Squatchcoin is Context, IERC20, Ownable {
    using SafeMath for uint256;
    using Address for address;

    mapping (address => uint256) private _reflectionsOwned;
    mapping (address => uint256) private _tokensOwned;
    mapping (address => mapping (address => uint256)) private _allowances;

    mapping (address => bool) private _isExcludedFromFee;

    mapping (address => bool) private _isExcluded;
    mapping (address => bool) private _isCharity;
    
    address[] private _excluded;
    address[] private _charity;
   
    uint256 private constant MAX = ~uint256(0);
    uint256 private _tokenTotalSupply = 4200000000 * 10**7;
    uint256 private _reflectionsTotalSupply = (MAX - (MAX % _tokenTotalSupply));
    uint256 private _tokenFeeTotal;
    uint256 private _tokenCharityTotal;

    string private _name = "Squatchcoin";
    string private _symbol = "SQC";
    uint8 private _decimals = 7;
    uint8 private constant _GRANULARITY = 100;
    
    uint256 public _taxFee = 200;
    uint256 private _previousTaxFee = _taxFee;
    
    uint256 public _liquidityFee = 200;
    uint256 private _previousLiquidityFee = _liquidityFee;

    uint256 public _charityFee = 50;
    uint256 private _previousCharityFee = _charityFee;

    IUniswapV2Router02 private uniswapV2Router;
    address private uniswapV2Pair;
    address public _routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;

    bool inSwapAndLiquify;
    bool public swapAndLiquifyEnabled = false;
    
    uint256 public _maxTxAmount = 210000000 * 10**7;
    uint256 private numTokensSellToAddToLiquidity = 42000 * 10**7;
    
    bool private _taxOff = true;

    event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiquidity
    );
    
    modifier lockTheSwap {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }
    
    constructor () {
        _reflectionsOwned[_msgSender()] = _reflectionsTotalSupply;
        
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_routerAddress);
        // Create a uniswap pair for this new token
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());

        // set the rest of the contract variables
        uniswapV2Router = _uniswapV2Router;
        
        _isExcludedFromFee[owner()] = true;
        _isExcludedFromFee[address(this)] = true;
        
        emit Transfer(address(0), _msgSender(), _tokenTotalSupply);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _tokenTotalSupply;
    }

    function balanceOf(address account) public view override returns (uint256) {
        if (_isExcluded[account]) return _tokensOwned[account];
        return tokenFromReflection(_reflectionsOwned[account]);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
        _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function isExcludedFromReward(address account) public view returns (bool) {
        return _isExcluded[account];
    }

    function setAsCharityAccount(address account) external onlyOwner() {
        require(account != 0x10ED43C718714eb63d5aA57B78B54704E256024E, 'The Swap router can not be the charity account.');
        require(!_isCharity[account], "Account is already charity account");
        _isCharity[account] = true;
        _charity.push(account);
    }

    function isCharity(address account) public view returns (bool) {
        return _isCharity[account];
    }

    function totalFees() public view returns (uint256) {
        return _tokenFeeTotal;
    }

    function totalCharity() public view returns (uint256) {
        return _tokenCharityTotal;
    }

    function taxIsOff() public view returns (bool) {
        return _taxOff;
    }

    function toggleFee() external onlyOwner() {
        if (_taxOff) {
            _taxOff = false;
        }
    }

    function deliver(uint256 tokenAmount) public {
        address sender = _msgSender();
        require(!_isExcluded[sender], "Excluded addresses cannot call this function");
        (uint256 reflectionAmount,,,,,,) = _getValues(tokenAmount);
        _reflectionsOwned[sender] = _reflectionsOwned[sender].sub(reflectionAmount);
        _reflectionsTotalSupply = _reflectionsTotalSupply.sub(reflectionAmount);
        _tokenFeeTotal = _tokenFeeTotal.add(tokenAmount);
    }

    function reflectionFromToken(uint256 tokenAmount, bool deductTransferFee) public view returns(uint256) {
        require(tokenAmount <= _tokenTotalSupply, "Amount must be less than supply");
        if (!deductTransferFee) {
            (uint256 reflectionAmount,,,,,,) = _getValues(tokenAmount);
            return reflectionAmount;
        } else {
            (,uint256 reflectionTransferAmount,,,,,) = _getValues(tokenAmount);
            return reflectionTransferAmount;
        }
    }

    function tokenFromReflection(uint256 reflectionAmount) public view returns(uint256) {
        require(reflectionAmount <= _reflectionsTotalSupply, "Amount must be less than total reflections");
        uint256 currentRate =  _getRate();
        return reflectionAmount.div(currentRate);
    }

    function excludeAccount(address account) public onlyOwner() {
        require(!_isExcluded[account], "Account is already excluded");
        if(_reflectionsOwned[account] > 0) {
            _tokensOwned[account] = tokenFromReflection(_reflectionsOwned[account]);
        }
        _isExcluded[account] = true;
        _excluded.push(account);
    }

    function includeAccount(address account) external onlyOwner() {
        require(_isExcluded[account], "Account is already excluded");
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_excluded[i] == account) {
                _excluded[i] = _excluded[_excluded.length - 1];
                _tokensOwned[account] = 0;
                _isExcluded[account] = false;
                _excluded.pop();
                break;
            }
        }
    }
    
    function _transferBothExcluded(address sender, address recipient, uint256 tokenAmount) private {
        (uint256 reflectionAmount, uint256 reflectionTransferAmount, uint256 reflectionFee, uint256 tokenTransferAmount, uint256 tokenFee, uint256 tokenCharity, uint256 tokenLiquidity) = _getValues(tokenAmount);
        _tokensOwned[sender] = _tokensOwned[sender].sub(tokenAmount);
        _reflectionsOwned[sender] = _reflectionsOwned[sender].sub(reflectionAmount);
        _tokensOwned[recipient] = _tokensOwned[recipient].add(tokenTransferAmount);
        _reflectionsOwned[recipient] = _reflectionsOwned[recipient].add(reflectionTransferAmount);        
        _takeLiquidity(tokenLiquidity);
        _sendToCharity(tokenCharity, sender);
        _reflectFee(reflectionFee, tokenFee);
        emit Transfer(sender, recipient, tokenTransferAmount);
    }
    
    function excludeFromFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = true;
    }
    
    function includeInFee(address account) public onlyOwner {
        _isExcludedFromFee[account] = false;
    }
    
    function setTaxFee(uint256 taxFee) external onlyOwner() {
        _taxFee = taxFee;
    }
    
    function setLiquidityFee(uint256 liquidityFee) external onlyOwner() {
        _liquidityFee = liquidityFee;
    }
   
    function setCharityFee(uint256 charityFee) external onlyOwner() {
        _charityFee = charityFee;
    }

    function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
        _maxTxAmount = maxTxAmount;
    }

    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }
    
    receive() external payable {}

    function _reflectFee(uint256 reflectionFee, uint256 tokenFee) private {
        _reflectionsTotalSupply = _reflectionsTotalSupply.sub(reflectionFee);
        _tokenFeeTotal = _tokenFeeTotal.add(tokenFee);
    }

    function _getValues(uint256 tokenAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
        (uint256 tokenTransferAmount, uint256 tokenFee, uint256 tokenCharity, uint256 tokenLiquidity) = _getTValues(tokenAmount);
        (uint256 reflectionAmount, uint256 reflectionTransferAmount, uint256 reflectionFee) = _getRValues(tokenAmount, tokenFee, tokenLiquidity, _getRate());
        return (reflectionAmount, reflectionTransferAmount, reflectionFee, tokenTransferAmount, tokenFee, tokenCharity, tokenLiquidity);
    }

    function _getTValues(uint256 tokenAmount) private view returns (uint256, uint256, uint256, uint256) {
        uint256 tokenFee = calculateTaxFee(tokenAmount);
        uint256 tokenLiquidity = calculateLiquidityFee(tokenAmount);
        uint256 tokenCharity = calculateCharityFee(tokenAmount);
        uint256 tokenTransferAmount = tokenAmount.sub(tokenFee).sub(tokenCharity).sub(tokenLiquidity);
        return (tokenTransferAmount, tokenFee, tokenCharity, tokenLiquidity);
    }

    function _getRValues(uint256 tokenAmount, uint256 tokenFee, uint256 tokenLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
        uint256 reflectionAmount = tokenAmount.mul(currentRate);
        uint256 reflectionFee = tokenFee.mul(currentRate);
        uint256 reflectionsLiquidity = tokenLiquidity.mul(currentRate);
        uint256 reflectionTransferAmount = reflectionAmount.sub(reflectionFee).sub(reflectionsLiquidity);
        return (reflectionAmount, reflectionTransferAmount, reflectionFee);
    }

    function _getRate() private view returns(uint256) {
        (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
        return rSupply.div(tSupply);
    }

    function _getCurrentSupply() private view returns(uint256, uint256) {
        uint256 rSupply = _reflectionsTotalSupply;
        uint256 tSupply = _tokenTotalSupply;      
        for (uint256 i = 0; i < _excluded.length; i++) {
            if (_reflectionsOwned[_excluded[i]] > rSupply || _tokensOwned[_excluded[i]] > tSupply) return (_reflectionsTotalSupply, _tokenTotalSupply);
            rSupply = rSupply.sub(_reflectionsOwned[_excluded[i]]);
            tSupply = tSupply.sub(_tokensOwned[_excluded[i]]);
        }
        if (rSupply < _reflectionsTotalSupply.div(_tokenTotalSupply)) return (_reflectionsTotalSupply, _tokenTotalSupply);
        return (rSupply, tSupply);
    }
    
    function _takeLiquidity(uint256 tokenLiquidity) private {
        uint256 currentRate =  _getRate();
        uint256 reflectionsLiquidity = tokenLiquidity.mul(currentRate);
        _reflectionsOwned[address(this)] = _reflectionsOwned[address(this)].add(reflectionsLiquidity);
        if(_isExcluded[address(this)])
            _tokensOwned[address(this)] = _tokensOwned[address(this)].add(tokenLiquidity);
    }
    
    function calculateTaxFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_taxFee).div(_GRANULARITY).div(100);
    }

    function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_liquidityFee).div(_GRANULARITY).div(100);
    }

    function calculateCharityFee(uint256 _amount) private view returns (uint256) {
        return _amount.mul(_charityFee).div(_GRANULARITY).div(100);
    }

    function _sendToCharity(uint256 tokenCharity, address sender) private {
        uint256 currentRate = _getRate();
        uint256 rCharity = tokenCharity.mul(currentRate);
        address currentCharity = _charity[0];
        _reflectionsOwned[currentCharity] = _reflectionsOwned[currentCharity].add(rCharity);
        _tokensOwned[currentCharity] = _tokensOwned[currentCharity].add(tokenCharity);
        emit Transfer(sender, currentCharity, tokenCharity);
    }
    
    function removeAllFee() private {
        if(_taxFee == 0 && _liquidityFee == 0 && _charityFee == 0) return;
        
        _previousTaxFee = _taxFee;
        _previousLiquidityFee = _liquidityFee;
        _previousCharityFee = _charityFee;
        
        _taxFee = 0;
        _liquidityFee = 0;
        _charityFee = 0;
    }
    
    function restoreAllFee() private {
        _taxFee = _previousTaxFee;
        _liquidityFee = _previousLiquidityFee;
        _charityFee = _previousCharityFee;
    }
    
    function isExcludedFromFee(address account) public view returns(bool) {
        return _isExcludedFromFee[account];
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) private {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(amount > 0, "Transfer amount must be greater than zero");
        if(from != owner() && to != owner())
            require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");

        uint256 contractTokenBalance = balanceOf(address(this));
        
        if(contractTokenBalance >= _maxTxAmount)
        {
            contractTokenBalance = _maxTxAmount;
        }
        
        bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
        if (
            overMinTokenBalance &&
            !inSwapAndLiquify &&
            from != uniswapV2Pair &&
            swapAndLiquifyEnabled
        ) {
            contractTokenBalance = numTokensSellToAddToLiquidity;
            swapAndLiquify(contractTokenBalance);
        }
        
        bool takeFee = true;
        
        if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
            takeFee = false;
        }
        
        _tokenTransfer(from,to,amount,takeFee);
    }

    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        uint256 half = contractTokenBalance.div(2);
        uint256 otherHalf = contractTokenBalance.sub(half);
        uint256 initialBalance = address(this).balance;

        swapTokensForEth(half); 

        uint256 newBalance = address(this).balance.sub(initialBalance);

        addLiquidity(otherHalf, newBalance);
        
        emit SwapAndLiquify(half, newBalance, otherHalf);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, 
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, 
            0, 
            owner(),
            block.timestamp
        );
    }

    function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
        if(!takeFee)
            removeAllFee();
        
        if (_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferFromExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
            _transferToExcluded(sender, recipient, amount);
        } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
            _transferStandard(sender, recipient, amount);
        } else if (_isExcluded[sender] && _isExcluded[recipient]) {
            _transferBothExcluded(sender, recipient, amount);
        } else {
            _transferStandard(sender, recipient, amount);
        }
        
        if(!takeFee)
            restoreAllFee();
    }

    function _transferStandard(address sender, address recipient, uint256 tokenAmount) private {
        (uint256 reflectionAmount, uint256 reflectionTransferAmount, uint256 reflectionFee, uint256 tokenTransferAmount, uint256 tokenFee, uint256 tokenCharity, uint256 tokenLiquidity) = _getValues(tokenAmount);
        _reflectionsOwned[sender] = _reflectionsOwned[sender].sub(reflectionAmount);
        _reflectionsOwned[recipient] = _reflectionsOwned[recipient].add(reflectionTransferAmount);
        _takeLiquidity(tokenLiquidity);
        _reflectFee(reflectionFee, tokenFee);
        _sendToCharity(tokenCharity, sender);    
        emit Transfer(sender, recipient, tokenTransferAmount);
    }

    function _transferToExcluded(address sender, address recipient, uint256 tokenAmount) private {
        (uint256 reflectionAmount, uint256 reflectionTransferAmount, uint256 reflectionFee, uint256 tokenTransferAmount, uint256 tokenFee, uint256 tokenCharity, uint256 tokenLiquidity) = _getValues(tokenAmount);
        _reflectionsOwned[sender] = _reflectionsOwned[sender].sub(reflectionAmount);
        _tokensOwned[recipient] = _tokensOwned[recipient].add(tokenTransferAmount);
        _reflectionsOwned[recipient] = _reflectionsOwned[recipient].add(reflectionTransferAmount);           
        _takeLiquidity(tokenLiquidity);
        _reflectFee(reflectionFee, tokenFee);
        _sendToCharity(tokenCharity, sender);
        emit Transfer(sender, recipient, tokenTransferAmount);
    }

    function _transferFromExcluded(address sender, address recipient, uint256 tokenAmount) private {
        (uint256 reflectionAmount, uint256 reflectionTransferAmount, uint256 reflectionFee, uint256 tokenTransferAmount, uint256 tokenFee, uint256 tokenCharity, uint256 tokenLiquidity) = _getValues(tokenAmount);
        _tokensOwned[sender] = _tokensOwned[sender].sub(tokenAmount);
        _reflectionsOwned[sender] = _reflectionsOwned[sender].sub(reflectionAmount);
        _reflectionsOwned[recipient] = _reflectionsOwned[recipient].add(reflectionTransferAmount);   
        _takeLiquidity(tokenLiquidity);
        _reflectFee(reflectionFee, tokenFee);
        _sendToCharity(tokenCharity, sender);
        emit Transfer(sender, recipient, tokenTransferAmount);
    }
    
    function updateRouterAddress(address newRouterAddress) external onlyOwner() {
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_routerAddress);
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
        
        _routerAddress = newRouterAddress;
    }  
}
