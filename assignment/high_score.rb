require 'csv'
require_relative "./select_quiz.rb"
require_relative "./take_quiz.rb"
class HighScore
  FILE_NAME = 'highscores.csv'
  def initialize
    @player_scores = load_player_scores_from_file
  end
  def update_score(name, quiz, score, total, attempted)
    @player_scores[name] ||= {}
    @player_scores[name][quiz] = { score: score, total: total, attempted: attempted }
    save_player_scores_to_file
  end
  def display_all_scores
    puts "All Quiz Scores and High Scores:"
    puts "____________________________________________________________________________"
    @player_scores.each do |name, scores|
      scores.each do |quiz, score_info|
        score = score_info[:score] || 'Not Attempted'
        total = score_info[:total] || 'Not Attempted'
        attempted = score_info[:attempted] || 'Not Attempted'
        puts "| #{name.ljust(14)} | #{quiz.ljust(15)} | #{score.to_s.ljust(6)} | #{total.to_s.ljust(7)} | #{attempted.to_s.ljust(8)} |"
      end
    end
    puts "____________________________________________________________________________"
  end
  def display_player_high_score
    print "Enter player name: "
    name = gets.chomp
    scores = get_scores_for_player(name)
    if scores.empty?
      puts "No scores found for player #{name}."
    else
      puts "Player: #{name}"
      scores.each do |quiz, score_info|
        puts "Quiz: #{quiz}"
        if score_info[:score].nil?
          puts "Score: Not Attempted"
        else
          puts "Score: #{score_info[:score]}/#{score_info[:total]}"
          puts "Attempted Questions: #{score_info[:attempted]}"
        end
        puts "******************************************************"
      end
    end
  end


  def get_scores_for_player(name)
    @player_scores[name] || {}#if player not exists so return empty hash
  end


  def save_player_scores_to_file
    CSV.open(FILE_NAME, 'w') do |csv|
      csv << ['Player',  'Quiz' , 'Score', 'Total',  'Attempted']
      @player_scores.each do |name, scores|
        scores.each do |quiz, score_info|
          csv << [name, quiz, score_info[:score], score_info[:total], score_info[:attempted]]
        end
      end
    end
  end
  

  def load_player_scores_from_file
    player_scores = {}
    if File.exist?(FILE_NAME)
      CSV.foreach(FILE_NAME) do |row|
        name, quiz, score, total, attempted = row
        player_scores[name] ||= {}
        player_scores[name][quiz] = { score: score.to_s, total: total.to_s, attempted: attempted.to_s }
      end
    end
    player_scores
  end
end






