# Pick the winners of this week's CFB games by cross-referencing a formatted
# list of Sagarin ratings with a slate of games.
#
# Will fail if ratings.txt and slate.txt are not present.
require 'text'
require 'active_support/core_ext'

def load_ratings()
  ratings = open('ratings.txt').readlines
  ratings = ratings.map { |x| x[0..29].rstrip.lstrip.gsub(/(\s)(\d)/, ':\2').split(':') }
  ratings = ratings.each.map { |el| [el.first.lstrip.rstrip, el.second] }
  ratings.pop

  hash = {}
  ratings.each { |el| hash[el.first] = el.second.to_f }

  return hash
end

def load_slate()
  slate = open('slate.txt').readlines
  slate = slate.map.with_index do |line, index|
    line = line.rstrip.lstrip.split(':')
    output = { home: line.first, away: line.second, index: index }
    output[:home_underdog] = true if line.length == 3
    return output
  end
end

def pick(game, ratings)
  game[:spread] = ratings[game[:home]] - ratings[game[:away]] + 3.08
  game[:spread] = game[:spread].round(2)

  game[:home_winner] = game[:spread] > 0 ? true : false

  game[:arrow] = game[:home_winner] ? "<-" : "->"

  return game
end

def print_pick(game, pad_width)
    home  = "#{game[:home].ljust pad_width}"
    away   = "#{game[:away].ljust pad_width}"
    spread  = game[:spread].round(0).to_s.rjust 3
    conf    = game[:confidence].to_s.rjust 2

#    return "#{game[:home]}\t#{game[:arrow]}\t#{game[:away]}"

    return "#{home}\t#{game[:arrow]}\t#{away}\tConf: #{conf}\tSpread: #{spread}"
end


def pick_winners
  ratings      = load_ratings
  slate        = load_slate
  picks        = []

  slate.each { |game| picks.push pick game, ratings }

  picks.sort_by! { |game| game[:spread].abs }

  picks.each.with_index { |pick, index| pick[:confidence] = index + 1 }

  picks.sort_by! { |game| game[:index] }

  return picks
end

def print_winners(picks)
  longest_name = (picks.map { |pick| [pick[:home].length, pick[:away].length].max }).max

  puts "****** PICKS ******".center 80
  picks.each { |game| puts print_pick game, longest_name }
  puts "\n"

  puts "****** BLOWOUTS ******".center 80

  results = picks.sort_by { |game| -game[:spread] }
  results[0..2].each { |game| puts print_pick game, longest_name }
end

picks = pick_winners

print_winners picks
