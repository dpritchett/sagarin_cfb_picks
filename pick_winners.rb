# Pick the winners of this week's CFB games by cross-referencing a formatted
# list of Sagarin ratings with a slate of games.
#
# Will fail if ratings.txt and slate.txt are not present.
require 'text'

def load_ratings()
  ratings = open('ratings.txt').readlines
  ratings = ratings.map { |x| x[0..29].rstrip.lstrip.gsub(/(\s)(\d)/, ':\2').split(':') }
  ratings = ratings.each.map { |el| [el[0].lstrip.rstrip, el[1]] }
end

def load_slate()
  slate = open('slate.txt').readlines
  slate = slate.map.with_index do |line, index|
    line = line.rstrip.lstrip.split('@')
    { home: line[0], away: line[1], index: index }
  end
end

def print_slate(slate)
  slate.each { |game| puts "#{game[0]} at #{game[1]}" }
end

def print_ratings(ratings)
  ratings.each { |team| puts "#{team[0]}\t#{team[1]}" }
end

def rating_for_team(team, ratings)
  matches = ratings.map do |line|
    [line[0], line[1], Text::Levenshtein.distance(team, line[0])]
  end
  matches.sort_by! { |e| e[2] }
  return [team, matches.first[1].to_f]
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

def main
  ratings = load_ratings
  slate   = load_slate

  picks   = []
  slate.each { |game| picks.push pick game, ratings }

  picks.sort_by! { |game| game[:spread] }

  picks.each.with_index { |pick, index| pick[:confidence] = index + 1 }

  picks.sort_by! { |game| game[:index] }

  picks.each do |game|
    puts "#{game[:winner]} over #{game[:loser]} [Conf: #{game[:confidence]}]"
  end

end

main
