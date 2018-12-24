require "csv"
require 'pry'
require './lib/team'
require './lib/game'
require './lib/game_team'
require './lib/team_storage'
require './lib/game_storage'
require './lib/game_team_storage'
require './lib/game_stats_module'

class StatTracker

  include GameStats

  attr_accessor :teams,
                :games,
                :game_teams,
                :team_storage,
                :game_storage,
                :game_team_storage

  def initialize
    @team_storage = {}
    @game_storage = {}
    @game_team_storage = {}
  end

  def parse_teams(file_path)
    @team_storage = TeamStorage.new
    CSV.foreach(file_path, {headers: true, header_converters: :symbol}) do |team_info|
    @teams = @team_storage.add_team(Team.new({:team_id => team_info[0], :franchiseid => team_info[1], :shortname => (team_info[2]),
          :teamname => team_info[3], :abbreviation => team_info[4], :link => team_info[5]}))
    end
    @teams
  end

  def parse_game_teams(file_path)
  @game_team_storage = GameTeamStorage.new
  CSV.foreach(file_path, {headers: true, header_converters: :symbol}) do |gt_info|
        @game_teams = @game_team_storage.add_game_team(GameTeam.new({
          :game_id => gt_info[0],# + "_" + gt_info[1]),
          :team_id => gt_info[1],
          :HoA => gt_info[2],
          :won => gt_info[3],
          :settled_in => gt_info[4],
          :head_coach => gt_info[5],
          :goals => gt_info[6],
          :shots => gt_info[7],
          :hits => gt_info[8],
          :pim => gt_info[9],
          :powerPlayOpportunities => gt_info[10],
          :powerPlayGoals => gt_info[11],
          :faceOffWinPercentage => gt_info[12],
          :giveaways => gt_info[13],
          :takeaways => gt_info[14]}))
    end
    @game_teams
  end

    def parse_games(file_path)
      @game_storage = GameStorage.new
      CSV.foreach(file_path, {headers: true, header_converters: :symbol}) do |game_info|
      @games = @game_storage.add_game(Game.new({
                      :game_id => game_info[0],
                      :season => game_info[1],
                      :type => game_info[2],
                      :date_time => game_info[3],
                      :away_team_id => game_info[4],
                      :home_team_id => game_info[5],
                      :away_goals => game_info[6],
                      :home_goals => game_info[7],
                      :outcome => game_info[8],
                      :home_rink_side_start => game_info[9],
                      :venue_time_zone_id => game_info[12],
                      :venue => game_info[10],
                      :venue_link => game_info[11],
                      :venue_time_zone_offset => game_info[13],
                      :venue_time_zone_tz => game_info[14]}))
      end
      @games
    end

    def highest_scoring_visitor	#Name of the team with the highest average score per game across all seasons when they are away.
      highest = 0
      name = "name"
      high_score_team_id = ""
      @games.values.each do |game|
        if game.away_goals.to_i > highest
          highest = game.away_goals.to_i
          high_score_team_id = game.away_team_id
        end
      name = get_team_name_from_id(high_score_team_id)
      end
      name
    end

    def highest_scoring_home_team	#Name of the team with the highest average score per game across all seasons when they are away.
      highest = 0
      high_score_team_id = ""
      name = "name"
      @games.values.each do |game|
        if game.home_goals.to_i > highest
          highest = game.home_goals.to_i
          high_score_team_id = game.home_team_id
        end
      name = get_team_name_from_id(high_score_team_id)
      end
      name
    end

    def lowest_scoring_visitor	#Name of the team with the lowest average score per game across all seasons when they are away.
      lowest = 100
      name = "name"
      low_score_team_id = ""
      @games.values.each do |game|
        if game.away_goals.to_i < lowest
          lowest = game.away_goals.to_i
          low_score_team_id = game.away_team_id
        end
      name = get_team_name_from_id(low_score_team_id)
      end
      name
    end

    def lowest_scoring_home_team	#Name of the team with the lowest average score per game across all seasons when they are away.
      lowest = 100
      low_score_team_id = ""
      name = "name"
      @games.values.each do |game|
        if game.home_goals.to_i < lowest
          lowest = game.home_goals.to_i
          low_score_team_id = game.home_team_id
        end
      name = get_team_name_from_id(low_score_team_id)
      end
      name
    end
end
