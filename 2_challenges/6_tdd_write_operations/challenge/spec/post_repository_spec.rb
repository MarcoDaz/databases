require 'post_repository'

RSpec.describe PostRepository do
  def reset_social_network
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
    connection.exec(seed_sql)
  end
  
  before(:each) do 
    reset_social_network
  end

  describe "#all" do
    it "returns an array of Post objects" do
      repo = PostRepository.new
      all_posts = repo.all
      expect(all_posts.length).to eq 3

      expect(all_posts.first.id).to eq 1
      expect(all_posts.first.title).to eq 'post_1'
      expect(all_posts.first.content).to eq 'content_1'
      expect(all_posts.first.views).to eq 10
      expect(all_posts.first.user_id).to eq 1

      expect(all_posts.last.id).to eq 3
      expect(all_posts.last.title).to eq 'post_3'
      expect(all_posts.last.content).to eq 'content_3'
      expect(all_posts.last.views).to eq 30
      expect(all_posts.last.user_id).to eq 2
    end
  end

  describe "#find" do
    it "returns a single Post object" do
      repo = PostRepository.new
      post = repo.find(2)

      expect(post.title).to eq 'post_2'
      expect(post.content).to eq 'content_2'
      expect(post.views).to eq 20
      expect(post.user_id).to eq 1
    end
  end

  describe "#create" do
    it "can create a single posts record" do
      repo = PostRepository.new

      new_post = Post.new
      new_post.title = 'new_title'
      new_post.content = 'new_content'
      new_post.views = 40
      new_post.user_id = 2

      repo.create(new_post)

      all_posts = repo.all
      latest_post = all_posts.last

      expect(latest_post.title).to eq 'new_title'
      expect(latest_post.content).to eq 'new_content'
      expect(latest_post.views).to eq 40
      expect(latest_post.user_id).to eq 2
    end
  end
  
  describe "#update" do
    it "can update a single posts record" do
      repo = PostRepository.new

      post = repo.find(1) # post Object
      post.title = 'updated_title'
      post.content = 'updated_content'
      post.views = 100
      post.user_id = 2

      repo.update(post)
      updated_post = repo.find(1) # same id

      expect(updated_post.title).to eq 'updated_title'
      expect(updated_post.content).to eq 'updated_content'
      expect(updated_post.views).to eq 100
      expect(updated_post.user_id).to eq 2
    end
  end

  describe "#delete" do
    it "can delete a single posts record" do
      repo = PostRepository.new
      repo.delete(2)

      all_posts = repo.all

      expect(all_posts.length).to eq 2

      expect(all_posts.first.title).to eq 'post_1'
      expect(all_posts.first.content).to eq 'content_1'
      expect(all_posts.first.views).to eq 10
      expect(all_posts.first.user_id).to eq 1

      expect(all_posts.last.title).to eq 'post_3'
      expect(all_posts.last.content).to eq 'content_3'
      expect(all_posts.last.views).to eq 30
      expect(all_posts.last.user_id).to eq 2
    end
  end
end