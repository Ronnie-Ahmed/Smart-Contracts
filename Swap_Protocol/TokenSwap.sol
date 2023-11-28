// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenSwap is ReentrancyGuard{
    uint256 private tokenPairId=1;

    struct Pool{
        uint256 id;
        address pairholder;
        address x;
        address y;
        uint256 amountX;
        uint256 amountY;
    }
    

    mapping(address=>mapping(address=>bool)) private pairExist;
    mapping(address=>mapping(address=>uint256)) private pairId;
    mapping(uint256 =>Pool) private mapToPools;
    mapping(address=>mapping(address=>mapping(address=>bool))) private isPairHolder;
    mapping(address=>mapping(address=>mapping(address=>uint256))) publicPairHolderId;

    function swap(address x, address y,uint256 amountX)external nonReentrant{
         require(pairExist[x][y],"Pair Doesn't Exist");
        require(pairExist[y][x],"Pair Doesn't Exist");
        require(amountX>0,"Amount Should be Greater than 0");
        require(IERC20(x).balanceOf(msg.sender)>=amountX,"Don't Have That Much Token");

        uint256 Id=pairId[x][y];
        uint256 amountY=estimatedReturn(x,y,amountX);
        Pool storage pool=mapToPools[Id];

        IERC20(x).approve(address(this),amountX);
        IERC20(x).transferFrom(msg.sender,address(this),amountX);
        bool success=IERC20(y).transfer(msg.sender,amountY);
        require(success,"Token Swap Failed");

        pool.amountX+=amountX;
        pool.amountY-=amountY;
        
    }
  
    
    function createPool(address x, address y, uint256 amountX,uint256 amountY)external nonReentrant{
        require(x!=address(0),"Give a Valid Address");
        require(y!=address(0),"Give a Valid Address");
        require(amountX>0,"Amount Should be greater than 0");
        require(amountY>0,"Amount Should be greater than 0");
        

        require(!pairExist[x][y],"Pair Already Exist");
        require(!pairExist[y][x],"Pair Already Exist");
        require(! isPairHolder[msg.sender][x][y],"You are Already A Pair Holder");

        require(IERC20(x).balanceOf(msg.sender)>=amountX,"Don't Have That Much Token");
        require(IERC20(y).balanceOf(msg.sender)>=amountY,"Don't Have That Much Token");

        IERC20(x).approve(address(this),amountX);
        IERC20(y).approve(address(this),amountY);

        IERC20(x).transferFrom(msg.sender,address(this),amountX);
        IERC20(y).transferFrom(msg.sender,address(this),amountY);

        isPairHolder[msg.sender][x][y]=true;
        isPairHolder[msg.sender][y][x]=true;
        

        pairExist[x][y]=true;
        pairExist[y][x]=true;

        pairId[x][y]=tokenPairId;
        pairId[y][x]=tokenPairId;

        mapToPools[tokenPairId]=Pool(tokenPairId,msg.sender,x,y,amountX,amountY);
        tokenPairId++;
    }


    function addLiquidity(address x,address y,uint256 amountX,uint256 amountY)external nonReentrant{
        require(pairExist[x][y],"Pair Doesn't Exist");
        require(pairExist[y][x],"Pair Doesn't Exist");
        require(x!=address(0),"Give a Valid Address");
        require(y!=address(0),"Give a Valid Address");
        uint256 id= pairId[x][y];
        Pool storage pool=mapToPools[id];
        IERC20(x).approve(address(this),amountX);
        IERC20(y).approve(address(this),amountY);

        IERC20(x).transferFrom(msg.sender,address(this),amountX);
        IERC20(y).transferFrom(msg.sender,address(this),amountY);

        pool.amountX+=amountX;
        pool.amountY+=amountY;
    }


    
    function showReserve(address x,address y)public view returns(uint256 amountX,uint256 amountY){
        require(pairExist[x][y],"Pair Doesn't Exist");
        require(pairExist[y][x],"Pair Doesn't Exist");
        uint256 Id=pairId[x][y];
        amountX=mapToPools[Id].amountX;
        amountY=mapToPools[Id].amountY;
    }

    function estimatedReturn(address x,address y,uint256 amount)public view  returns(uint256){
        require(pairExist[x][y],"Pair Doesn't Exist");
        require(pairExist[y][x],"Pair Doesn't Exist");
        require(amount>0,"Amount Should be Greater than 0");
        
        uint256 Id=pairId[x][y];
        require( mapToPools[Id].amountX > amount,"Pool value Exceed");
       
        uint256 newAmountX= mapToPools[Id].amountX + amount;
        uint256 newAmountY=mapToPools[Id].amountY -amount;
        
        uint256 newXPricePerY=(newAmountY*10e5)/newAmountX;
        uint256 returnedValue=(newXPricePerY*amount)/10e5;
        return returnedValue;
         
    }

    function checkPair(address x,address y)public view returns(bool){
       return pairExist[x][y];     
    }

}