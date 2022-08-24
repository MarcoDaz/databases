require 'user_repository'

RSpec.describe UserRepository do
  def reset_social_network
    seed_sql = File.read('spec/seeds.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
    connection.exec(seed_sql)
  end
  
  before(:each) do 
    reset_social_network
  end

  describe "#all" do
    it "returns an array User objects" do
      repo = UserRepository.new
      all_users = repo.all

      expect(all_users.length).to eq 2

      expect(all_users.first.id).to eq 1
      expect(all_users.first.email_address).to eq 'user_1@email.com'
      expect(all_users.first.username).to eq 'user_1'

      expect(all_users.last.id).to eq 2
      expect(all_users.last.email_address).to eq 'user_2@email.com'
      expect(all_users.last.username).to eq 'user_2'
    end
  end

  describe "#find" do
    it "it returns a single User object" do
      repo = UserRepository.new
      user = repo.find(2)

      expect(user.email_address).to eq 'user_2@email.com'
      expect(user.username).to eq 'user_2'
    end
  end

  describe "#create" do
    it "it can create a single user record" do
      repo = UserRepository.new

      new_user = User.new
      new_user.email_address = 'new_user@email.com'
      new_user.username = 'new_user'

      repo.create(new_user)

      all_users = repo.all
      latest_user = all_users.last

      expect(latest_user.email_address).to eq 'new_user@email.com'
      expect(latest_user.username).to eq 'new_user'
    end
  end

  describe "#update" do
    it "it can create a single user record" do
      repo = UserRepository.new

      user = repo.find(1) # User Object
      user.email_address = 'new@email.com'
      user.username = 'new'
    
      repo.update(user)
      updated_user = repo.find(1) # same id
    
      expect(updated_user.email_address).to eq 'new@email.com'
      expect(updated_user.username).to eq 'new'
    end
  end

  describe "#delete" do
    it "it can delete a single user record" do
      repo = UserRepository.new
      repo.delete(1)

      all_users = repo.all

      expect(all_users.length).to eq 1

      expect(all_users.first.email_address).to eq 'user_2@email.com'
      expect(all_users.first.username).to eq 'user_2'
    end
  end
end