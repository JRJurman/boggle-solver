#Boggle Solver
# Created by Jesse Jurman

# Object for a single letter object
class Letter
  attr_accessor :pos, :char

  def initialize(char, pos)
    @char = char
    @pos = pos
  end

  def to_s
    "#{@char} : #{@pos}"
  end

end

# A word and the path
class BoggleSolution

  attr_accessor :word, :path

  def initialize(word, pathArr)
    @word = word
    @path = pathArr
    @value = case word.size
      when 0..4
        1
      when 5
        2
      when 6
        3
      when 7
        5
      else
        11
      end
  end

  def addLetter(letter)
    if @path.include?(letter.pos[0])
      return self.class.new(@word, @path)
    end

    word = @word + letter.char
    path = @path + letter.pos

    self.class.new(word, path)
  end

  def to_s
    "#{@word}: #{@path} <#{@value}>"
  end
end

# Dictionary Object
class Dictionary
  attr_accessor :dict
  def initialize(path)
    @dict = Hash.new([])
    f = File.open(path)
    f.each_line do |line|
      @dict[line[0]] += [line.chomp]
    end
  end
  def hasWord?(word)
    @dict[word[0]].include?(word)
  end
  def hasPart?(part)
    glop = @dict[part[0]].join(',')
    glop.include?(part)
  end
end

# Parses sring into a board object
class BoggleBoard

  attr_accessor :board

  def initialize(stringBoard)
    posX = 0; posY = 0;
    @board = {}
    stringBoard.split('').each do |char|
      if char == ','
        posY += 1; posX = 0
      else
        pos = "#{posX}#{posY}"
        @board[pos] = Letter.new(char, [pos])
        posX += 1
      end
    end
  end

  #returns a list of Letters around (and including) the given position
  def posNeighbors(posString)
    resNeighbors = []
    [-1, 0, +1].each do |x|
      [-1, 0, +1].each do |y|
        newPos = "#{posString[0].to_i + x}#{posString[1].to_i + y}"
        if @board[newPos] == nil
          #do nothing
        elsif newPos == posString
          #do nothing
        else
          newNeighbor = Letter.new(@board[newPos].char, [newPos])
          resNeighbors += [newNeighbor]
        end
      end
    end
    resNeighbors
  end

  #returns a list of valid words given a dictionary
  def solve(dict, words=[], solutions=[])
    @board.each_key do |key|
      words += [BoggleSolution.new(@board[key].char, [key])]
    end

    counter = 0
    lc = 0
    loader = ['.       ', ' .      ', '  .     ', '   .    ',
              '    .   ', '     .  ', '      . ', '       .',
              '      . ', '     .  ', '    .   ', '   .    ',
              '  .     ', ' .      ']

    while (words.size != 0)
      puts "#{(counter)}/16.0 passes\t#{words.size} words,\t#{solutions.size} solutions"
      #for every boggle solution
      words.each do |word|
        print "LOADING #{loader[(lc += 1) % loader.size]}\r"
        #remove our current word
        words.delete(word)
        #add it again and all the solutions around it
        posNeighbors(word.path[-1]).each do |neighbor|
          newWord = word.addLetter(neighbor)
          if dict.hasPart?(newWord.word) and newWord.word.size > counter
            words += [newWord]
            if dict.hasWord?(newWord.word)
              solutions += [newWord]
            end
          end
        end

      end
      counter += 1
    end

    solutions

  end #end solve

end
