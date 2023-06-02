require_relative "select_quiz"
require_relative "./high_score.rb"
class QuizGame
  def start
    loop do
      puts "Quiz Game"
      puts "1. Select Quiz"
      puts "2. View All Quiz Scores and High Scores"
      puts "3. View Player High Score"
      puts "4. Exit"
      puts "========================================"
      print "Enter your choice: "
      choice = gets.chomp.to_i
      case choice
      when 1
        select_quiz = SelectQuiz.new.start
        # select_quiz.start
      when 2
        high_scores = HighScore.new
        high_scores.display_all_scores
      when 3
        high_scores = HighScore.new
        high_scores.display_player_high_score
      when 4
        puts "Goodbye!"
        # break
        exit
      else
        puts "Invalid choice! Please try again."
      end
    end
  end
end
game = QuizGame.new
game.start
