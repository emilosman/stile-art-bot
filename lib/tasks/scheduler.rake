namespace :tweets do
  desc 'Post artwork to Twitter'
  task :post_random_artwork, [:bot_name]=> [:environment] do |t, args|
    puts args[:bot_name]
    TwitterBot.find_by(name: args[:bot_name]).post_random_artwork
  end
end
