require_relative 'post'

class PostRepository
  def all
    sql = 'SELECT * FROM posts;'
    result_set = DatabaseConnection.exec_params(sql, [])

    posts = []
    result_set.each do |record|
      post = Post.new
      post.id = record['id'].to_i
      post.title = record['title']
      post.content = record['content']
      post.views = record['views'].to_i
      post.user_id = record['user_id'].to_i

      posts << post
    end

    return posts
  end

  def find(id)
    sql = 'SELECT * FROM posts WHERE id = $1'
    result_set = DatabaseConnection.exec_params(sql, [id])
    record = result_set[0]

    post = Post.new
    post.id = record['id'].to_i
    post.title = record['title']
    post.content = record['content']
    post.views = record['views'].to_i
    post.user_id = record['user_id'].to_i

    return post
  end

  def create(post)
    sql = 'INSERT INTO
            posts (title, content, views, user_id)
            VALUES ($1, $2, $3, $4);'
    params = [
      post.title,
      post.content,
      post.views,
      post.user_id
    ]
    DatabaseConnection.exec_params(sql, params)
    
    return nil
  end

  def update(post)
    sql = 'UPDATE posts
            SET title = $1,
                content = $2,
                views = $3,
                user_id = $4
            WHERE id = $5;'
    params = [
      post.title,
      post.content,
      post.views,
      post.user_id,
      post.id
    ]
    DatabaseConnection.exec_params(sql, params)

    return nil
  end

  def delete(id)
    sql = 'DELETE FROM posts WHERE id = $1'
    DatabaseConnection.exec_params(sql, [id])
  end
end