// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

/* 

Author : Md Raisul Islam Ronnie
Email : rksraisul@gmail.com
Github :  https://github.com/Ronnie-Ahmed

*/

contract TokenStaking is ReentrancyGuard, Ownable {
    using SafeMath for uint256;

    uint256 private MAX_STAKE_VALUE = 10000000000000000000000;
    uint256 private MIN_STAKE_VALUE = 100000000000;
    uint256 private totalValue;
    uint256 private unStakeFee = 3;
    uint256 extraPression = uint256(10e5);
    uint256[] stakingDays;

    address owner;

    uint[] private ApyingRate;
    IERC20 public StakeToken;

    /* Notice
    
    Staker Struct
    user : address of the user
    stakedValue : amount of token staked
    startingStake : time when staking started
    endingStake : time when staking will end
    totalLockedDays : total days of staking
    isLocked : is staking locked or not
    stakerApyrate : apy rate of the staker

    */

    struct Staker {
        address user;
        uint256 stakedValue;
        uint256 startingStake;
        uint256 endingStake;
        uint256 totalLockedDays;
        bool isLocked;
        uint256 stakerApyrate;
    }

    mapping(address => Staker) public stakers;

    mapping(uint256 => uint256) public stakeToapyRate;

    address[] private StakedUsed;

    constructor(
        address TokenAddress,
        uint256[] memory s_stakedays,
        uint256[] memory perApyRate
    ) {
        StakeToken = IERC20(TokenAddress);

        for (uint256 i = 0; i < perApyRate.length; i++) {
            stakeToapyRate[s_stakedays[i]] = perApyRate[i];
            stakingDays.push(s_stakedays[i]);
            ApyingRate.push(perApyRate[i]);
        }
    }

    /////////////////
    //Owner Function//
    /////////////////

    /* Notice
    
    ChangeStakeTokenAddress : change the stake token address
    
    */

    function ChangeStakeTokenAddress(
        address _newTokenAddress
    ) external onlyOwner {
        StakeToken = IERC20(_newTokenAddress);
    }

    /* Notice

    changeStakeDays : change the stake days and apy rate

    */

    function changeStakeDays(
        uint256[] memory _stakeDays,
        uint256[] memory _apy
    ) external onlyOwner {
        popStakeDays();
        for (uint256 i = 0; i < _stakeDays.length; i++) {
            stakeToapyRate[_stakeDays[i]] = _apy[i];
            stakingDays.push(_stakeDays[i]);
            ApyingRate.push(_apy[i]);
        }
    }

    /* Notice

    popStakeDays : pop the stake days and apy rate

    */

    function popStakeDays() internal onlyOwner {
        for (uint256 i = 0; i < stakingDays.length; i++) {
            stakingDays.pop();
            ApyingRate.pop();
        }
    }

    /* Notice

    changeMaxStakeValue : change the max stake value

    */

    function changeMaxStakeValue(uint256 _newMaxValue) external onlyOwner {
        MAX_STAKE_VALUE = _newMaxValue;
    }

    /* Notice

    changeMinStakeValue : change the min stake value

    */

    function changeMinStakeValue(uint256 _newMinValue) external onlyOwner {
        MIN_STAKE_VALUE = _newMinValue;
    }

    /* Notice

    changeUnstakeFee : change the unstake fee

    */

    function changeUnstakeFee(uint256 _newFee) external onlyOwner {
        unStakeFee = _newFee;
    }

    /////////////////////
    //External Function//
    /////////////////////

    /* Notice

    stake : stake the token
    amount: amount of token to stake
    _stakeDays : days of staking

    */

    function stake(uint256 amount, uint256 _stakeDays) external nonReentrant {
        require(
            StakeToken.balanceOf(msg.sender) >= amount,
            "Don't have Enough Token"
        );

        require(
            stakers[msg.sender].isLocked == false,
            "Already Locked the token Value"
        );
        require(amount > MIN_STAKE_VALUE, "Amount Must be greater than this");
        require(amount <= MAX_STAKE_VALUE, "Amount Must be greater than this");

        uint256 endAt;
        uint256 stakeDays;

        if (_stakeDays == 7) {
            stakeDays = 7 days;
            endAt = getCurrentTime() + stakeDays;
        } else if (_stakeDays == 10) {
            stakeDays = 7 days;
            endAt = getCurrentTime() + stakeDays;
        } else if (_stakeDays == 30) {
            stakeDays = 7 days;
            endAt = getCurrentTime() + stakeDays;
        } else if (_stakeDays == 45) {
            stakeDays = 7 days;
            endAt = getCurrentTime() + stakeDays;
        } else if (_stakeDays == 90) {
            stakeDays = 7 days;
            endAt = getCurrentTime() + stakeDays;
        }

        require(
            StakeToken.balanceOf(msg.sender) >= amount,
            "You don't have enough Token"
        );

        stakers[msg.sender] = Staker(
            msg.sender,
            amount,
            getCurrentTime(),
            endAt,
            stakeDays,
            true,
            stakeToapyRate[_stakeDays]
        );
        StakeToken.transferFrom(msg.sender, address(this), amount);
        totalValue += amount;
        StakedUsed.push(msg.sender);
    }

    /* Notice

    claimReward : claim the reward

    */

    function claimReward() external nonReentrant {
        require(
            getCurrentTime() >= stakers[msg.sender].endingStake,
            "Still Haven't Ended the Staking Period"
        );
        require(
            stakers[msg.sender].isLocked == true,
            "Haven't locked the staking reward"
        );

        uint256 reward = calculateMyReward(msg.sender);

        uint256 myreward = reward + stakers[msg.sender].stakedValue;

        totalValue -= myreward;

        StakeToken.transfer(msg.sender, myreward);

        stakers[msg.sender].isLocked = false;

        stakers[msg.sender].stakedValue = 0;

        stakers[msg.sender].startingStake = 0;

        stakers[msg.sender].endingStake = 0;

        stakers[msg.sender].stakerApyrate = 0;

        for (uint i = 0; i < StakedUsed.length; i++) {
            if (StakedUsed[i] == msg.sender) {
                for (uint j = i; j < StakedUsed.length - 1; j++) {
                    StakedUsed[j] = StakedUsed[j + 1];
                }
                StakedUsed.pop();
            }
        }
    }

    /* Notice

    unStakeMyStake : unstake the staked token

    */

    function unStakeMyStake() external nonReentrant {
        require(
            getCurrentTime() < stakers[msg.sender].endingStake,
            "Stake Time Ended"
        );

        require(
            stakers[msg.sender].isLocked == true,
            "Haven't locked the staking reward"
        );

        uint256 fine = calculateUnstakeFine(msg.sender);

        uint256 myreward = stakers[msg.sender].stakedValue - fine;

        totalValue -= myreward;

        StakeToken.transfer(msg.sender, myreward);

        stakers[msg.sender].isLocked = false;

        stakers[msg.sender].stakedValue = 0;

        stakers[msg.sender].startingStake = 0;

        stakers[msg.sender].endingStake = 0;

        stakers[msg.sender].stakerApyrate = 0;

        for (uint i = 0; i < StakedUsed.length; i++) {
            if (StakedUsed[i] == msg.sender) {
                for (uint j = i; j < StakedUsed.length - 1; j++) {
                    StakedUsed[j] = StakedUsed[j + 1];
                }
                StakedUsed.pop();
            }
        }
    }

    /////////////////
    //View Function//
    /////////////////

    function getStakeTokenAddress() public view returns (address) {
        return address(StakeToken);
    }

    function getStakeDays() public view returns (uint256[] memory) {
        return stakingDays;
    }

    function getApyRate() public view returns (uint256[] memory) {
        return ApyingRate;
    }

    function getStakedUsers() public view returns (address[] memory) {
        return StakedUsed;
    }

    function getTotalStakedValue() public view returns (uint256) {
        return totalValue;
    }

    function getCurrentTime() public view returns (uint256) {
        return block.timestamp;
    }

    function getMyStakedInfo(
        address _user
    ) public view returns (Staker memory) {
        return stakers[_user];
    }

    function calculateMyReward(address _user) public view returns (uint256) {
        require(
            stakers[_user].isLocked == true,
            "Haven't locked stake token yet"
        );

        uint256 stakedToken = stakers[_user].stakedValue;

        uint256 totalLockedDays = stakers[_user].totalLockedDays;

        uint256 userApyRate = stakers[_user].stakerApyrate;

        uint256 apyPerYear = (userApyRate * (extraPression)) / 100;

        uint256 rewardPerYear = (apyPerYear * stakedToken) / (extraPression);

        uint256 rewardPerDay = rewardPerYear / 365;

        uint256 actualReward = rewardPerDay * totalLockedDays;

        return actualReward;
    }

    function calculateUnstakeFine(address _user) public view returns (uint256) {
        require(
            stakers[_user].isLocked == true,
            "Haven't locked stake token yet"
        );

        uint256 stakedToken = stakers[_user].stakedValue;

        uint256 totalLockedDays = stakers[_user].totalLockedDays;

        uint256 unstakeRate = (unStakeFee * (extraPression)) / 100;

        uint256 totalFine = (stakedToken * unstakeRate) / (extraPression);

        uint256 actualFine = totalFine / totalLockedDays;

        return actualFine;
    }

    function getMyStakedTokenValue() public view returns (uint256) {
        return stakers[msg.sender].stakedValue;
    }
}
