// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/security/ReentrancyGuard.sol";
contract CrowdFunding is Ownable,ReentrancyGuard{
    struct ProjectDetails{
        address owner;
        string projectname;
        uint256 projectId;
        bool isFinished;
        uint256 targetAmount;
    }
    event AddtoProjectList(
        address indexed  owner,
        string projectname,
        uint256 projectId,
     
        uint256 targetAmount

    );
    
    uint256 projectNumber=1;
    mapping(uint256 ProjectId=> ProjectDetails ) private mapToProjectDetails;
    mapping(uint256 ProjectId => uint256 fund) public crowdFund;
    function addProjectToList(string memory _projectname,uint256 _targetAmount) external nonReentrant{
        mapToProjectDetails[projectNumber]=ProjectDetails(
            msg.sender,
            _projectname,
            projectNumber,
            false,
            _targetAmount
        );
        emit AddtoProjectList( msg.sender,
            _projectname,
            projectNumber, _targetAmount);
        projectNumber++;
    }


    function fundProject(uint256 projectId,uint256 amount)external payable nonReentrant{
        require(crowdFund[projectId] < mapToProjectDetails[projectId].targetAmount,"Already reached it's goal");
        require(mapToProjectDetails[projectId].isFinished==false,"Already reached it's goal");
        crowdFund[projectId]+=amount;
        if(crowdFund[projectId] >= mapToProjectDetails[projectId].targetAmount){
            mapToProjectDetails[projectId].isFinished=true;
        }
        (bool success,)=mapToProjectDetails[projectId].owner.call{value:msg.value}("");
        require(success,"Transfer Failed");
    }
    function fundLeftToget(uint256 projectId)public view returns(uint256){
        return (mapToProjectDetails[projectId].targetAmount-crowdFund[projectId]);
    }
    function viewListedProject(uint256 projectId)public view returns(ProjectDetails memory){
   
        return  mapToProjectDetails[projectId];
    }
}