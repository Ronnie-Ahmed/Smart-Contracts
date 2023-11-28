// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.21;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract FaceBook is ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private postId;
    uint256 roomId;
    mapping(uint256 => MessageRoom) private messageRoom;
    mapping(address => mapping(address => bool)) isRoom;
    mapping(address => mapping(address => bool)) isRoom2;
    mapping(uint256 => string[]) private messages;
    address[] private userList;
    mapping(uint256 => PostInfo) private posts;
    mapping(uint256 => bool) private isPostExist;
    mapping(address => uint256[]) private myPosts;
    mapping(address => UserInfo) private users;
    mapping(address => address[]) private friendList;
    mapping(address => mapping(address => bool)) private isFriend;

    event CreateUserEvent(
        address indexed _userAddress,
        string _userName,
        string _userPhoto
    );

    event CreatePostEvent(address indexed _userAddress, uint256 _postId);
    event DeletePostEvent(address indexed _userAddress, uint256 _postId);
    event AddFriendEvent(address indexed _user1, address indexed _user2);
    event RemoveFriendEvent(address indexed _user1, address indexed _user2);
    event MessageEvent(uint256 _roomId, string _message);

    constructor() ERC721("FaceBook", "FB") {}

    struct UserInfo {
        address userAddress;
        string userName;
        string userPhoto;
        string userBio;
        bool isRegistered;
    }
    struct PostInfo {
        uint256 Id;
        address useraddress;
        string postPhoto;
        string postBio;
    }
    struct MessageRoom {
        uint256 roomId;
        address user1;
        address user2;
        bool isRoomAvailable;
    }

    ////////////////
    ////External////
    ////////////////

    function createUser(
        string memory _userName,
        string memory _userPhoto,
        string memory _userBio
    ) external {
        require(!users[msg.sender].isRegistered, "User already registered");
        require(bytes(_userName).length > 0, "User name cannot be empty");
        users[msg.sender] = UserInfo(
            msg.sender,
            _userName,
            _userPhoto,
            _userBio,
            true
        );

        userList.push(msg.sender);
        emit CreateUserEvent(msg.sender, _userName, _userPhoto);
    }

    function editUserNamee(string memory _userName) external {
        require(users[msg.sender].isRegistered, "You are not registered");
        require(bytes(_userName).length > 0, "User name cannot be empty");
        users[msg.sender].userName = _userName;
    }

    function editUserPhoto(string memory _userPhoto) external {
        require(users[msg.sender].isRegistered, "You are not registered");
        require(bytes(_userPhoto).length > 0, "User photo cannot be empty");
        users[msg.sender].userPhoto = _userPhoto;
    }

    function editUserBio(string memory _userBio) external {
        require(users[msg.sender].isRegistered, "You are not registered");
        require(bytes(_userBio).length > 0, "User bio cannot be empty");
        users[msg.sender].userBio = _userBio;
    }

    function createPost(
        string memory _postPhoto,
        string memory _postBio
    ) external {
        require(users[msg.sender].isRegistered, "You are not registered");

        uint256 id = postId.current();
        postId.increment();
        isPostExist[id] = true;
        posts[id] = PostInfo(id, msg.sender, _postPhoto, _postBio);
        myPosts[msg.sender].push(id);
        _safeMint(msg.sender, id);
        emit CreatePostEvent(msg.sender, id);
    }

    function deletePost(uint256 _id) external {
        require(isPostExist[_id], "Post id Does not Exist");
        require(users[msg.sender].isRegistered, "You are not registered");
        require(
            posts[_id].useraddress == msg.sender,
            "You are not owner of the post"
        );

        _burn(_id);
        uint[] storage tempArray = myPosts[msg.sender];
        for (uint256 i = 0; i < tempArray.length; i++) {
            if (tempArray[i] == _id) {
                tempArray[i] = tempArray[tempArray.length - 1];
                tempArray.pop();
                break;
            }
        }
        isPostExist[_id] = false;
        emit DeletePostEvent(msg.sender, _id);
    }

    function editPost(
        uint256 _id,
        string memory _postPhoto,
        string memory _postBio
    ) external {
        require(isPostExist[_id], "Post id Does not Exist");
        require(users[msg.sender].isRegistered, "You are not registered");
        require(posts[_id].useraddress == msg.sender, "This is not Your Post");
        PostInfo storage temp = posts[_id];
        temp.postPhoto = _postPhoto;
        temp.postBio = _postBio;
    }

    function addFriends(address _address) external {
        require(_address != msg.sender);
        require(users[_address].isRegistered);
        require(users[msg.sender].isRegistered);
        require(!isFriend[msg.sender][_address]);
        isFriend[msg.sender][_address] = true;
        friendList[msg.sender].push(_address);
        emit AddFriendEvent(msg.sender, _address);
    }

    function removeFriend(address _address) external {
        require(users[_address].isRegistered);
        require(users[msg.sender].isRegistered);
        require(isFriend[msg.sender][_address] == true);
        address[] storage temp = friendList[msg.sender];
        for (uint256 i = 0; i < temp.length; i++) {
            if (temp[i] == _address) {
                temp[i] = temp[temp.length - 1];
                temp.pop();
                break;
            }
        }
        emit RemoveFriendEvent(msg.sender, _address);
    }

    function create_messageRoom(address _sendAddress) external {
        require(isFriend[msg.sender][_sendAddress]);
        require(!isRoom[msg.sender][_sendAddress]);
        require(!isRoom2[_sendAddress][msg.sender]);
        isRoom[msg.sender][_sendAddress] = true;
        isRoom2[_sendAddress][msg.sender] = true;
        messageRoom[roomId] = MessageRoom(
            roomId,
            msg.sender,
            _sendAddress,
            true
        );
        roomId += 1;
    }

    function sendMessage(uint256 _roomId, string memory _message) external {
        require(messageRoom[_roomId].isRoomAvailable, "First Create the Room");
        require(
            msg.sender == messageRoom[_roomId].user1 ||
                msg.sender == messageRoom[_roomId].user2
        );
        messages[_roomId].push(_message);
        emit MessageEvent(_roomId, _message);
    }

    ///////////////
    ////View///////
    ///////////////

    function viewMessages(
        uint256 _roomId
    ) public view returns (string[] memory) {
        require(messageRoom[_roomId].isRoomAvailable, "First Create the Room");
        require(
            msg.sender == messageRoom[_roomId].user1 ||
                msg.sender == messageRoom[_roomId].user2
        );
        return messages[_roomId];
    }

    function getMyFriends(
        address _address
    ) public view returns (address[] memory) {
        require(users[_address].isRegistered, "User is not registered");
        return friendList[_address];
    }

    function viewUserInfo(
        address UserAddress
    ) public view returns (UserInfo memory) {
        return users[UserAddress];
    }

    function viewMyPostId(
        address _address
    ) public view returns (uint256[] memory) {
        return myPosts[_address];
    }

    function viewPost(
        address _address
    ) public view returns (PostInfo[] memory) {
        uint256[] memory tempPostArray = myPosts[_address];
        PostInfo[] memory temp = new PostInfo[](tempPostArray.length);
        for (uint256 i = 0; i < tempPostArray.length; i++) {
            temp[i] = posts[tempPostArray[i]];
        }
        return temp;
    }

    function userLists() public view returns (address[] memory) {
        return userList;
    }

    function viewPostById(uint256 _id) public view returns (PostInfo memory) {
        require(isPostExist[_id], "Post id Does not Exist");
        return posts[_id];
    }

    function chectIffriend(address _frinedAddress) public view returns (bool) {
        return isFriend[msg.sender][_frinedAddress];
    }

    function CheckIfPostExist(uint256 _postId) public view returns (bool) {
        return isPostExist[_postId];
    }
}