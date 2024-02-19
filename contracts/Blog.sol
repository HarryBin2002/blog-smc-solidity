// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Blog {
    // Define the Post struct with two attributes
    struct Post {
        uint id;
        string title;
        string body;
    }

    // State variable to store posts
    Post[] private posts;

    // Mapping to keep track of post existence
    mapping(uint => bool) private postExists;

    address public owner;

    // this function runs when the contract is deployed
    constructor() {
        // set owner is msg.sender
        owner = msg.sender;
    }

    // Modifier to restrict certain operations to the owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    // Event declarations for frontend interaction
    event PostCreated(uint id, string title, string body);
    event PostUpdated(uint id, string title, string body);
    event PostDeleted(uint id);

    // Function to create a new post
    function createPost(string memory _title, string memory _body) public onlyOwner {
        uint postId = posts.length; // Incrementing ID for each new post
        posts.push(Post(postId, _title, _body));
        postExists[postId] = true;
        emit PostCreated(postId, _title, _body);
    }

    // Function to read a post by ID
    function readPost(uint _id) public view returns (uint, string memory, string memory) {
        require(postExists[_id], "Post does not exist.");
        Post storage post = posts[_id];
        return (post.id, post.title, post.body);
    }

    // Function to list all posts
    function listPosts() public view returns (Post[] memory) {
        return posts;
    }

    // Function to update a post
    function updatePost(uint _id, string memory _title, string memory _body) public onlyOwner {
        require(postExists[_id], "Post does not exist.");
        Post storage post = posts[_id];
        post.title = _title;
        post.body = _body;
        emit PostUpdated(_id, _title, _body);
    }

    // Function to delete a post
    function deletePost(uint _id) public onlyOwner {
        require(_id < posts.length, "Index out of bounds");
        require(postExists[_id], "Post does not exist.");

        // Move the last element to the slot of the one being removed if it's not the same element
        if (_id < posts.length - 1) {
            posts[_id] = posts[posts.length - 1];
        }

        // Remove the last element
        posts.pop();

        // Mark the post as non-existent
        postExists[_id] = false;

        // Emitting an event for deletion
        emit PostDeleted(_id);
    }
}
