require './BoggleSolver.rb'

grid = "EPOD,LTIR,ZWGR,EJRF"
dictionary = Dictionary.new("./dictionary.txt")

bb = BoggleBoard.new(grid)

sol = bb.solve(dictionary)

#remove duplicated instances
uSol = {}
sol.each do |vs|
  uSol[vs.word] = vs
end

#write solutions to res.txt
f = File.open("./res.txt", "w")
uSol.each_value do |line|
  f.write(line.to_s+"\n")
end
