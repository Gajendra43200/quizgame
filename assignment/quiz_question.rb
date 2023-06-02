class QuizQuestion
    attr_reader :question, :options, :correct_answer
    def initialize(question, options, correct_answer)
      @question = question
      @options = options
      @correct_answer = correct_answer
    end
    def to_file_format
      "#{question}|#{options.join(',')}/#{correct_answer}"
    end 
  end