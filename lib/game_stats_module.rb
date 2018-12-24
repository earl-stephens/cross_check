require 'pry'
require './lib/game_team'
require './lib/game_team_storage'
require './lib/stat_tracker'

module GameStats

#@teams, use team_id; @game_teams & @games, use game_id
  def search_any_collection_by_id(collection, id)
      collection[id]
  end

  def highest_score	#Highest sum of the winning and losing teams’ scores
    highest = 0
    @game_teams.values.each do |game|
      if game.goals.to_i > highest
        highest = game.goals.to_i
      end
    end
    highest
  end

  def biggest_blowout	#Highest difference between winner and loser
    blowout = 0
    @games.values.each do |game|
      diff = (game.away_goals.to_i - game.home_goals.to_i).abs
      if diff > blowout
        blowout = diff
      end
    end
    blowout
  end

  def best_season(collection = @games, team_id)
    wins = wins_by_season(collection = @games, team_id)
    best = 0
    wins.each do |season, num_wins|
      if num_wins > best
        best = num_wins
      end
    end
    wins.key(best)
  end

  def worst_season(collection = @games, team_id)
    wins = wins_by_season(collection = @games, team_id)
    worst = 100
    wins.each do |season, num_wins|
      if num_wins < worst
        worst = num_wins
      end
    end
    wins.key(worst)
  end

  # def seasons(collection = @games, team_id)
  #   seasons = []
  #   collection.values.each do |item|
  #     seasons << item.season
  #   end
  #   seasons
  # end

  def wins(collection = @games, team_id)
    wins = 0
    collection.values.each do |game|
      if (game.outcome.include?("home win") && game.home_team_id == team_id) || (game.outcome.include?("away win") && game.away_team_id == team_id)
        wins += 1
      end
    end
    wins
  end

  def wins_by_season(collection = @games, team_id)
    wins = 0
    wins_by_season = {}
    collection.values.each do |game|
      if (game.outcome.include?("home win") && game.home_team_id == team_id) || (game.outcome.include?("away win") && game.away_team_id == team_id)
        wins_by_season[game.season] = (wins += 1)
      end
    end
    wins_by_season
  end

  def win_percentage(collection = @games, team_id)
    wins = wins(collection, team_id)
    total_games = collection.values.count do |game|
      game.game_id.to_i
    end
    (wins.to_f / total_games.to_f) * 100
  end

  # def find_home_team_goals_from_games(collection = @games, team_id)
  #   goals = 0
  #   collection.values.find_all do |game|
  #     if game.home_team_id == team_id
  #       goals += game.home_goals.to_i
  #     end
  #   end
  #   goals
  # end
  def get_team_name_from_id(team_id)
    name = ""
    @teams.values.each do |team|
      if team.teamid == team_id
      name = team.teamName
      end
    end
    name
  end
end
