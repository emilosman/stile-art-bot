namespace :tweets do
  desc 'Post artwork to Twitter'
  task :post_random_artwork, [:bot_name]=> [:environment] do |t, args|
    puts args[:bot_name]
    TwitterBot.find_by(name: args[:bot_name]).post_random_artwork
  end

  desc 'All bots post'
  task post_random_all_bots: :environment do
    TwitterBot.all.map{ |bot| bot.post_random_artwork }
  end
end
