
require 'timeout'
class BootAGotchi
	attr_accessor :age,:tired, :hungry, :dead, :full, :symbol, :world, :sleeping
	attr_reader :name
	def initialize(name)
		@name = name
		@age = 0
		@hungry = 0
		@full = 0
		@asleep = false
		@dead = false
		@tired = 0
		@symbol = "☺"
		@world = World.new
		@board = @world.board
		@sleeping = false
		move_to_home!
		clear_screen!
		p self.birth!
		sleep(3)
	end

	def walk!
		old_position = @board.index("☺")
		if @board[-1] != 0
			new_position = @board[0]
		else
			new_position = (old_position + 1)
		end
		@board[old_position] = 0
		@board[new_position] = symbol
		move!
		die!
		dead?
		@world.show_board
	end

	def birth!
		@board[0] = symbol
		"#{name} was born!"
	end

	def feed!
		hungry = 0
		@full += 1
		full?
		"You fed #{name}, he is now #{full} thirds full."
	end

	def tired?
		tired
	end

	def sleep!
		@sleeping = true if tired >= 5
	end

	def sleeping?
		@sleeping
	end

	def dead?
		return "#{name} died!" if dead
		dead
	end

	def full?
		poop! if full == 3
	end

	def hungry?
		hungry
	end

	def grow!
		@age +=1
	end

	def move!
		puts "#{name} is #{hungry} out of 15 hungry!"
		puts "#{name} is #{tired} out of 5 tired!"
		@hungry +=1
		@tired +=1
	end

	def die!
		@dead = true if hungry == 15 || @world.dirty == 3
	end

	def accept_input
		puts "Enter 'feed' to feed #{name}"
        answer = Timeout::timeout(5) do
                gets.chomp!  
        end
    	@hungry = 0 if answer == "feed"
		rescue Timeout::Error
        answer = 0
  
	end

	def poop!
		@full = 0
		@world.dirty+=1
		die!
		dead?
		return "#{name} pooped, his space is now #{self.world.dirty} thirds soiled."
	end
end

class World
	attr_accessor :dirty, :board, :player, :display, :symbol
	def initialize
		@size = 10
		@board = Array.new(@size,0)
		@dirty = 0
		@clean = true
		@symbol = "☺"
	end

	def clean!
		@dirty = 0
		"The space is now clean!"
	end

	def show_board
		display = "|"
		board.each do |space|
			if space == 0
				display << " "
			else
				display << symbol
			end
		end
			display << "|"
			display
	end

	# def move_player!
	# 	old_position = self.board.index("☺")
	# 	if self.board[-1] != 0
	# 		new_position = self.board[0]
	# 	else
	# 		new_position = (old_position + 1)
	# 	end
	# 	board[old_position] = 0
	# 	self.board[new_position] = "☺"
	# 	player.move!
	# 	player.die!
	# 	show_board
	# end
end

def move_to_home!
  print "\e[H"
end

def clear_screen!
  print "\e[2J"
end


jeff = BootAGotchi.new("Jeff")
move_to_home!
clear_screen!
until jeff.dead
jeff.walk! unless jeff.sleeping?
puts jeff.world.show_board
jeff.accept_input
jeff.sleep!
jeff.world.symbol = '☻' if jeff.sleeping?
sleep(2)
move_to_home!
clear_screen!
end 
puts jeff.dead?
puts "RIP #{jeff.name}."
sleep(2.5)












