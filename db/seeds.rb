# Apagar dados existentes para evitar duplicatas
User.destroy_all
Post.destroy_all
Comment.destroy_all

# Criar usuários
user1 = User.create!(email: 'kaique@kaique.com', password: 'kaique94', password_confirmation: 'password', confirmed_at: Time.now) # Adiciona confirmed_at para Devise confirmable
user2 = User.create!(email: 'user2@example.com', password: 'password', password_confirmation: 'password', confirmed_at: Time.now)

# Criar posts
post1 = user1.posts.create!(title: 'First Post', body: 'This is the first post.')
post2 = user1.posts.create!(title: 'Second Post', body: 'This is the second post.')
post3 = user2.posts.create!(title: 'Another User Post', body: 'This is a post from another user.')

# Criar comentários
comment1 = post1.comments.create!(body: 'Great post!', user: user2)
comment2 = post1.comments.create!(body: 'Thanks for sharing!', user: user2)
comment3 = post2.comments.create!(body: 'Interesting perspective.', user: user1)
comment4 = post3.comments.create!(body: 'I like this post.', user: user1)
