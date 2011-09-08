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
  return ratings
end

def load_slate()
  slate = open('slate.txt').readlines
  slate = slate.map.with_index do |line, index|
    line = line.rstrip.lstrip.split('@')
    { home: line.first, away: line.second, index: index }
  end
end

def rating_for_team(team, ratings)
  matches = ratings.map do |line|
    [line.first, line.second, Text::Levenshtein.distance(team, line.first)]
  end
  matches.sort_by! { |e| e.third }
  return [team, matches.first.second.to_f]
end

def pick(game, ratings)
  # 
  game[:home] = rating_for_team(game[:home], ratings)
  game[:away] = rating_for_team(game[:away], ratings)

  spread = game[:home][1] - game[:away][1]
  
  game[:winner], game[:loser] = game[:home], game[:away] if spread > 0
  game[:winner], game[:loser] = game[:away], game[:home] unless spread > 0
  game.delete :home
  game.delete :away

  game[:spread] = spread.abs.round 2

  return game
end

def print_pick(game, pad_width)
    winner  = "#{game[:winner].first.ljust pad_width} (#{game[:winner].last.to_s.rjust 6})"
    loser   = "#{game[:loser].first.ljust pad_width} (#{game[:loser].last.to_s.rjust 6})"
    spread  = game[:spread].round(0).to_s.rjust 2
    conf    = game[:confidence].to_s.rjust 2

    return "#{winner}\tover\t#{loser}\tConf: #{conf}\tSpread: #{spread}"
end


def pick_winners
  ratings      = load_ratings
  slate        = load_slate
  picks        = []

  slate.each { |game| picks.push pick game, ratings }

  picks.sort_by! { |game| game[:spread] }

  picks.each.with_index { |pick, index| pick[:confidence] = index + 1 }

  return { picks: picks.sort_by! { |game| game[:index] },
           ratings: ratings}
end

def print_winners(data)
  ratings = data[:ratings]
  picks   = data[:picks]
  longest_name = (ratings.map { |team| team.first.length }).max

  puts "****** PICKS ******".center 80
  picks.each { |game| puts print_pick game, longest_name }
  puts "\n"

  puts "****** BLOWOUTS ******".center 80

  results = picks.sort_by { |game| -game[:spread] }
  results[0..2].each { |game| puts print_pick game, longest_name }
end

def picks_as_json(picks)
  picks.to_json
end

data = pick_winners

print_winners data

#puts picks_as_json data[:picks]
