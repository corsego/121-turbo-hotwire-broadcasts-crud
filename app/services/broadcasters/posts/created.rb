class Broadcasters::Posts::Created
  attr_reader :post
  def initialize(post)
    @post = post
  end

  def call
    update_posts_count
    add_post_to_list
  end

  private

  def add_post_to_list
    Turbo::StreamsChannel.broadcast_append_to :posts_list, target: 'all-posts', partial: 'posts/post', locals: { post: @post }
  end

  def update_posts_count
    Turbo::StreamsChannel.broadcast_update_to :posts_list, target: 'posts_count', partial: 'posts/count', locals: { count: Post.count }
  end
end