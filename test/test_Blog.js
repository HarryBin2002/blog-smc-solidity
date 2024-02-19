const Blog = artifacts.require("Blog");

contract("Blog", (accounts) => {
    let blog;
    const owner = accounts[0];
    const nonOwner = accounts[1];

    before(async () => {
        blog = await Blog.deployed();
    });

    it("should allow the owner to create a post", async () => {
        await blog.createPost("Test Title", "Test Body", {from: owner});
        const post = await blog.readPost(0);
        assert.equal(post[0].toNumber(), 0, "Post ID should be 0");
        assert.equal(post[1], "Test Title", "Post title should match");
        assert.equal(post[2], "Test Body", "Post body should match");
    });

    it("should not allow a non-owner to create a post", async () => {
        try {
            await blog.createPost("Non-Owner Post", "This should not work", {from: nonOwner});
            assert.fail("The transaction should have thrown an error");
        } catch (err) {
            assert.include(err.message, "Only the owner can perform this action.", "The error message should contain 'Only the owner can perform this action.'");
        }
    });

    it("should allow the owner to update a post", async () => {
        await blog.updatePost(0, "Updated Title", "Updated Body", {from: owner});
        const post = await blog.readPost(0);
        assert.equal(post[1], "Updated Title", "Post title should be updated");
        assert.equal(post[2], "Updated Body", "Post body should be updated");
    });

    it("should allow the owner to delete a post", async () => {
        await blog.deletePost(0, {from: owner});
        try {
            await blog.readPost(0);
            assert.fail("The transaction should have thrown an error");
        } catch (err) {
            assert.include(err.message, "Post does not exist.", "The error message should contain 'Post does not exist.'");
        }
    });

    it("should list all posts correctly", async () => {
        // Assuming deletePost does not shift array indices
        await blog.createPost("Title 1", "Body 1", {from: owner});
        await blog.createPost("Title 2", "Body 2", {from: owner});
        const posts = await blog.listPosts();
        assert.equal(posts.length, 2, "There should be 2 posts in total after deletions and additions");
    });
});
