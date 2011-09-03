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
  slate = slate.map { |line| line.rstrip.lstrip.split('@') }
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
  return matches.first[1].to_f
end

def pick(game, ratings)
  ratings = [rating_for_team(game[0], ratings), rating_for_team(game[1], ratings) + 3.08]
  winner  = ratings.each_with_index.max[1]
  loser   = ratings.each_with_index.min[1]

  margin  = ratings[winner] - ratings[loser]

  results = [game[winner], game[loser], margin.round(2)]
end

ratings = load_ratings
slate = load_slate

picks = []

slate.each do |game|
  picks.push(pick game, ratings)
end

picks.sort_by! { |x| 0 - x[2] }

puts "** SAGARIN PICKS AS OF #{Time.now.ctime} **"
picks.each { |x| puts  "#{x[0]} over #{x[1]} by #{x[2]}" }
