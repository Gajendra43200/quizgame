require_relative "./select_quiz.rb"
class TakeQuiz
  def initialize(quiz_name, questions)
    @quiz_name = quiz_name 
    @questions = questions 
    # puts "#{@questions}jhfdf"
    @score = 0
    @attempted_questions = 0
    @correctly_answered = 0
    @user_name = nil
  end
  def ask_user_name
    print "Enter your name: "
    @user_name = gets.chomp
    while @user_name !~ /^[A-Z][A-Za-z\s]+$/
      print "Please enter your name in Valid format=  "
      @user_name = gets.chomp
    end
  end
  
  def start_quiz
    puts "Quiz: #{@quiz_name}"
    puts "******************************************************"
    @questions.each_with_index do |question, index| 
      puts "Question #{index + 1}:"
      # question,correctans=questionw.question.split(/)
      puts "#{question.question}"
      puts "Options:"
      question.options.each_with_index { |option, i| puts "#{i + 1}. #{option}" }
      print "Enter your answer (1-#{question.options.length}): "
      answer = gets.chomp.to_i
      if answer.between?(1, question.options.length)
        @attempted_questions += 1
        if answer-1  == question.correct_answer
          @score += 1
          @correctly_answered += 1
          puts "Correct!"
        else
          puts "Incorrect!"
        end
      else
        puts "Invalid answer! Skipping the question..."
      end
      puts "****************************************************************"
    end
    calculate_score
  end
  def calculate_score
    if @attempted_questions > 0
      percentage = (@score.to_f / @attempted_questions) * 100
      puts "Quiz Completed!"
      puts "Your Score: #{@score} / #{@attempted_questions} (#{percentage}%)."
      high_score = HighScore.new
    high_score.update_score(@user_name, @quiz_name, @score, @questions.length, @attempted_questions)
    else
      puts "No questions attempted. Quiz incomplete."
    end
  end
end
