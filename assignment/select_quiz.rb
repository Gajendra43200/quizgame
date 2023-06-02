require_relative "./high_score.rb"
require_relative "./quiz_question.rb"
require_relative "./take_quiz.rb"
class SelectQuiz
  def initialize
    @quizzes = load_quizzes#hash of array of all quiz question of array
  end
  def start
    # display_menu

    loop do
      display_menu
      print "Enter your choice: "
      choice = gets.chomp.to_i
      handle_choice(choice)
    end
  end
  def display_menu
    puts "Quiz Game"
    puts "1. Play Existing Quiz"
    puts "2. Add Questions to Quiz"
    puts "3. Create New Quiz"
    puts "4. Exit"
    puts "========================================"
  end
  def handle_choice(choice)
    case choice
    when 1
      play_existing_quiz
    when 2
      add_questions_to_quiz
    when 3
      create_new_quiz
    when 4
      puts "Goodbye!"
      game = QuizGame.new
      game.start
    else
      puts "Invalid choice! Please try again."
    end
  end
  def display_existing_quizzes
    puts "Existing Quizzes:"
    @quizzes.each_with_index { |(name, _), index| puts "#{index + 1}. #{name}" }#quizess is a hash
  end
  def play_existing_quiz
    display_existing_quizzes
    print "Enter the number of the quiz you want to play: "
    quiz_number = gets.chomp.to_i
    play_existing_quiz2(quiz_number)
  end
  # def display_existing_quizzes
  #   puts "Existing Quizzes:"
  #   @quizzes.each_with_index { |(name, _), index| puts "#{index + 1}. #{name}" }#quizess is a hash
  # end
  def play_existing_quiz2(quiz_number)
    if quiz_number.between?(1, @quizzes.length)
      quiz_name = @quizzes.keys[quiz_number - 1]
      take_quiz = TakeQuiz.new(quiz_name, @quizzes[quiz_name])
      take_quiz.ask_user_name
      take_quiz.start_quiz
    else
      puts "Invalid quiz number!"
    end
  end
  def add_questions_to_quiz
    puts "Existing Quizzes:"
    @quizzes.each_with_index { |(name, _), index| puts "#{index + 1}. #{name}" } 
    print "Enter the number of the quiz you want to add questions to: "
    quiz_number = gets.chomp.to_i
    if quiz_number.between?(1, @quizzes.length)
      quiz_name = @quizzes.keys[quiz_number - 1]
      # stionsarr = @quizzes.values[quiz_number - 1]
      add_questions(quiz_name, @quizzes[quiz_name])
    else
      puts "Invalid quiz number!"
    end
  end
  def create_new_quiz
    print "Enter the name for your new quiz: "
    quiz_name = gets.chomp
    questions = []
    loop do
      puts "Add a new question to the '#{quiz_name}' quiz:"
      question = get_question#this is method
      options = get_options
      correct_answer = get_correct_answer
      questions << QuizQuestion.new(question, options, correct_answer)
      break unless add_another_question?(quiz_name)
    end
    @quizzes[quiz_name] = questions
    save_quiz_to_file(quiz_name, questions)
    puts "Quiz '#{quiz_name}' created successfully!"
    end
  end
  def get_question
    print "Question: "
    gets.chomp
  end
  def get_options
    options = []
    4.times do |i|
      print "Option #{i + 1}: "
      options << gets.chomp
    end
    options #returns the optional array
  end
  def get_correct_answer
    print "Enter the correct answer (1-4): "
    gets.chomp.to_i - 1
  end
  def add_another_question?(quiz_name)
    print "Add another question to the '#{quiz_name}' quiz? (Yes/No): "
    gets.chomp.downcase ==  gets.chomp
  end
  private
  def load_quizzes
    quizzes = {}
    Dir.glob("*.txt") do |file|#return array of file path which extention is have .txt
      quiz_name = File.basename(file, ".txt").gsub('_', ' ')
      questions = []
      File.foreach(file) do |line|
        next if line.chomp.empty?
        question, options_str = line.chomp.split('|')
        options_str, correct_answer = options_str.chomp.split('/')
        options = options_str.split(',') if options_str
        questions << QuizQuestion.new(question, options, correct_answer.to_i)
      end
      quizzes[quiz_name] = questions unless questions.empty?#It prevents adding quizzes with no questions to the quizzes hash.
    end
    quizzes
  end
  def add_questions(quiz_name, questions)#array of questions
    loop do
      puts "Add a new question to the '#{quiz_name}' quiz: "#array of exiting question
      print "Question: "
      question = gets.chomp
      options = []
      4.times do |i|
        print "Option #{i + 1}: "
        option = gets.chomp
        options << option
      end
      print "Enter the correct answer (1-4): "
      correct_answer = gets.chomp.to_i - 1
      questions << QuizQuestion.new(question, options, correct_answer)
      print "Add another question to the '#{quiz_name}' quiz? (Yes/No): "
      ui = gets.chomp.downcase
      break if ui == "no"
    end
    save_quiz_to_file(quiz_name, questions)
    puts "Questions added to '#{quiz_name}' quiz successfully!"
  end
  def save_quiz_to_file(quiz_name, questions)#quetion array of object
    file_name = "#{quiz_name.downcase.gsub(' ', '_')}.txt"
    File.open(file_name, "w") do |file|
      questions.each do |question|
        file.puts  question.to_file_format
      end
  end
end