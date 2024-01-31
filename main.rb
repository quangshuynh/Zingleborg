
# Character
class Character
  attr_reader :name
  attr_accessor :health, :strength  
# If no name is typed
  def name=(name)
    if name.nil? or name.empty?
      raise ArgumentError.new('You silly. You must have a name!')
    end
    @name = name
  end

  def initialize(name, health=90, strength=50)
    self.name = name
    @health   = health
    @strength = strength
  end
# Attack action
  def attack(target, damage)
    target.health -= damage
    return damage
  end
# Checks if character is dead
  def alive?
    self.health > 0
  end
end

# Enemy attack
class Enemy < Character
  def attack(target)
    super(target, 44)
  end
end

# Item
class Item
  attr_accessor :name, :power
# Who is using weapon; Amount of damage weapon does
  def initialize(name, power)
    @name = name
    @power = power
  end
  
  def to_s
    self.name
  end
end

# Add method to list Enumerable objects
Enumerable.module_eval do
  def list(ordered=true)
    if ordered
      self.each_with_index { |obj, i| puts "  #{i+1}. #{obj.to_s}" }
    else
      self.each { |obj| puts "  - #{obj.to_s}" }
    end
  end
end

# Player
# Singleton class
class Player < Character
  attr_accessor :items, :selected_item, :selected_item_index
  
  def initialize(name, health, strength)
    super
    @items = []
  end

  def collect_item(item)
    @items.push item
  end
  
  def select_item(item_index)
    self.selected_item_index = item_index
    self.selected_item = items[item_index]
  end

  def attack(target)
    super(target, self.selected_item.power)
  end
end

Dir["lib/*\.rb"].each { |file| require file }

# Weapons
chimpanzee_items = [
  Item.new('Stick', 30),
  Item.new('Rock', 60),
  Item.new('Apple', 25),
  Item.new('Broken knife', 40),
  Item.new('Worms', 5)
]
zimbleswogle_items = [
  Item.new('Pebble', 7),
  Item.new('Wrench', 30),
  Item.new('Screwdriver', 35),
  Item.new('Shoe', 3)
]
allknowing_items = [
  Item.new('Icerind Hatchet', 345),
  Item.new('Grafted Blade Greatsword', 240),
  Item.new('Nagakiba', 175),
]

# Intro
system("clear")
print "===== Zingleborg =====\n\nWhat's your name?: "
# Initial player stats (pre-chimpanzee)
player = Player.new(gets.chomp, 23, 34)
system("clear")
print "Welcome #{player.name}! Today, you just finished constructing a time machine. You're exhausted from building the time machine all night and your vitals look rough. (Health = #{player.health}%). Since you don't have a healthy diet or workout at the gym, you're quite weak. (Strength = #{player.strength}%)\n\nYou're excited to try it your new project. You know your capabilities and decide to try it out. You set the date to 2019 on your time machine, before the pandemic occured. Prepare youself, and press enter to continue!\n\n(Press enter to continue)"
gets
system("clear")
# Chimpanzee health
player.health = 100
player.strength = 90
# Lion health
enemy = Enemy.new("Leopard", 80, 44)
puts "BOOM!!!!!\n\nYou look around you and notice that you're definitely in the past. No sight of modern technology or civilization and it looks like you're in the savanna. Man, is it hot outside. You're burning in the blistering Sun. You wonder to yourself, what happened? Didn't you set the date to the beginning of 2019? Your movement feels very janky and weird.\n\nYou look down and realize you're a chimpanzee! Your health is now #{player.health}% because of your newfound physical build and durability. Also, your strength is #{player.strength}% because chimpanzees are often swinging from tree to tree, obviously getting the best natural workout.\n\nYou notice yourself leading a gang of chimpanzees, but you suddenly hear strange crackling in the bushes nearby.\n\nIn front of you, there are #{chimpanzee_items.length} items:"
chimpanzee_items.list

# Collecting items loop
  while true
    print "\nEnter the number of the one you want: "
    selected_item_index = gets.to_i-1
    system("clear")
    player.collect_item chimpanzee_items[selected_item_index]
    chimpanzee_items.delete_at selected_item_index
  
    puts "You now have the following items:"
    player.items.list false
    break if chimpanzee_items.length === 0
  
    print "\nWould you like to collect another item? [yes/no]: "
    break unless gets.chomp == "yes"
    system("clear")
  # Counts how many items are left
    puts "There are now #{chimpanzee_items.length} items in front of you:"
    chimpanzee_items.list
  end
# End of collecting items
system("clear")
puts "When you finish gathering the items on the ground, you turn around and see a #{enemy.name}. Instinctively, your body floods with fear because leopards are your main predator. And, although you're a strong chimpanzee, you tend to be docile.\nBut you're the alpha of your group so your duty is to protect the
others. If you run, you'll be a coward and be a letdown. You must attack."

# Battle loop (Version 1 - Leopards)
while true
  puts "\nYou have the following items:"
  player.items.list
  print "\nEnter the number of the item you'd like to use to attack: "
  player.select_item(gets.to_i-1)
  system("clear")
  print "You attack #{enemy.name} with the #{player.selected_item.name} and "
  damage = player.attack enemy
  if enemy.alive?
    puts "take off #{damage} percentage points."
  else
# Leopard gets killed by you (Victory ending)
    puts "kill him.\n\nYou win!\n
The other chimpanzees of your group yelp for joy & pump their chests to celebrate.\n
Enjoy the day as an alpha.\n\n(Press enter to continue)"
    break
  end
  puts "\nHis health is now at #{enemy.health}%."

  print "\nBrace yourself for #{enemy.name}'s attack. Hit enter when ready. "
  gets
  system("clear")
# Leopard kills you (Loss ending)
  print "#{enemy.name} attacks "
  damage = enemy.attack player
  if player.alive?
    puts "you and takes off #{damage} percentage points."
  else
    puts "and kills you.\n\nAww shucks!\n\nYou and your gang get eaten by the #{enemy.name}.\n\n(Press enter to continue)"
    
    break
  end
  puts "\nYour health is now at #{player.health}%."
end

# New enemy stats
enemy2 = Enemy.new("Zimbleswogle", 50, 30)
class Enemy < Character
  def attack(target)
    super(target, 30)
  end
end
player.health = 34
player.strength = 26
gets
system("clear")
puts "You wake up, present day, in your clumsy body. (Health = #{player.health}%, Strength = #{player.strength}%) You look over at your completed time machine, wondering if it was all a dream. Compelled to know, you get up and rush to your time machine.\n\nFilled with deja vu, you set the date to the start of 2019. You think to yourself, didn't you already do this before? Like, you want to experience life before the pandemic again. Whatever. It doesn't matter. You get ready to push the button to go back.\n\n*The time machine powers off*\n\nConfused, you start looking around. In a state of panic, you franticly run around to see what the issue is. Then it hits you.\n\nThe time machine was only good for a one time use.\n\n(Press enter to continue)"
gets
system("clear")
puts "You're out of juice!\n\n(Press enter to continue)"
gets
system("clear")
puts "You sit back in your chair and think hard. How can you power up your time machine?\n\nYou think for a while...\n\nAfter some time, you remember you can find some Californium, the substance used to power up your time machine, at Goltra.\n\nGoltra is about a 15 minute drive and it's a rundown, old castle. There lays Sir Starcourge Ragadon, The All-Knowing. You must defeat him to obtain the Californium to fix your time machine\n\n(Press enter to continue)."
gets
system("clear")
puts "You head over to Goltra. But on the way, you encounter #{enemy2.name}. He challenges you to a duel. Although you're in a hurry to obtain Californium, he offers you $1,000 if you win the duel. You look at your dashboard on your car and realize you're almost out of gas. Gas is super expensive nowadays, so you take the challenge. You go into your pocket and discover the items you had in your previous battle as a chimpanzee. Awesome!\n\nIn front of you, there are #{zimbleswogle_items.length} items:"
zimbleswogle_items.list

# Collecting items loop (Version 2)
  while true
    print "\nEnter the number of the one you want: "
    selected_item_index = gets.to_i-1
    system("clear")
    player.collect_item zimbleswogle_items[selected_item_index]
    zimbleswogle_items.delete_at selected_item_index
  
    puts "You now have the following items:"
    player.items.list false
    break if zimbleswogle_items.length === 0
  
    print "\nWould you like to collect another item? [yes/no]: "
    break unless gets.chomp == "yes"
    system("clear")
    puts "There are now #{zimbleswogle_items.length} items in front of you:"
    zimbleswogle_items.list
  end

# End of collecting items (Version 2)
system("clear")
puts "You finish looting and realize that #{enemy2.name} is very weak but very strong. Thank god you chose the correct items, right?"
# Battle loop (Version 2 - Zimbleswogle)
while true 
  puts "\nYou have the following items:"
  player.items.list
  print "\nEnter the number of the item you'd like to use to attack: "
  player.select_item(gets.to_i-1)
  system("clear")
  print "You attack #{enemy2.name} with the #{player.selected_item.name} and "
  damage = player.attack enemy2
  if enemy2.alive?
    puts "take off #{damage} percentage points."
  else
# Zimbleswogle gets downed by you (Victory ending)
    puts "down him.\n\nYou win!\n
You collect your $1,000 and go to the nearest gas station to fuel up.\n\n(Press enter to continue)"
    break
  end
  puts "\nHis health is now at #{enemy2.health}%."
  print "\nBrace yourself for #{enemy2.name}'s attack. Hit enter when ready. "
  gets
  system("clear")
# Zimbleswogle downs you (Loss ending)
  print "#{enemy2.name} attacks "
  damage = enemy2.attack player
  if player.alive?
    puts "you and takes off #{damage} percentage points."
  else
    puts "and knocks you down.\n\nLuckily, #{enemy2.name} spares you and gives you $80 for gas. What a generous guy. #{enemy2.name} says he just wanted to test his ability to fight and never intended to kill you.\n\n(Press enter to continue)"
    break
  end
  puts "\nYour health is now at #{player.health}%."
end
gets
system("clear")
player.health = 90
player.strength = 45
# New enemy stats (Version 2)
enemy3 = Enemy.new("Crazy lady", 40, 25)
class Enemy < Character
  def attack(target)
    super(target, 25)
  end
end
puts "Before heading to the gas station, you put all your goodies in a bag and you put that bag in the trunk of you car. This way, you don't lose any of your items. You say goodbye to Zimbleswogle and go on with your day.\n\nAt the gas station, you enter the store. You buy a protein shake and drink it. Your health is now #{player.health}% and your strength is #{player.strength}%. Then, as you were filling up your tank, a strange entity walks towards you.\n\n(Press enter to continue)"
gets
system("clear")
player.health = 65
puts "It attacks you and does 25 damage. Your health is now #{player.health}%. You take a closer look and realize it's a #{enemy3.name}. She attacks you again, but this time you dodge it. You have no gas and if you run, the #{enemy3.name} will steal your car and possessions. There's no choice but to attack. You grab your items and engage in a fight."
# Battle loop (Version 3 - Crazy lady)
while true 
  puts "\nYou have the following items:"
  player.items.list
  print "\nEnter the number of the item you'd like to use to attack: "
  player.select_item(gets.to_i-1)
  system("clear")
  print "You attack #{enemy3.name} with the #{player.selected_item.name} and "
  damage = player.attack enemy3
  if enemy3.alive?
    puts "take off #{damage} percentage points."
  else
# Crazy lady gets knocked by you (Victory ending)
    puts "knock her out.\n\nYou win!\n
You feel exhausted after that victory. You stumble a bit and fall to the ground, unconscious.\n\n(Press enter to continue)"
    break
  end
  puts "\Her health is now at #{enemy3.health}%."
  print "\nBrace yourself for #{enemy3.name}'s attack. Hit enter when ready. "
  gets
  system("clear")
# Crazy guy knocks you out (Loss ending)
  print "#{enemy3.name} attacks "
  damage = enemy3.attack player
  if player.alive?
    puts "you and takes off #{damage} percentage points."
  else
    puts "and knocks you down.\n\nShe does a hard blow to your chest and you fall unconscious.\n\n(Press enter to continue)"
    break
  end
  puts "\nYour health is now at #{player.health}%."
end
gets
system("clear")
player.health = 3
player.strength = 5
# New enemy stats (Version 3)
enemy4 = Enemy.new("Your heart", 10, 1)
class Enemy < Character
  def attack(target)
    super(target, 1)
  end
end
puts "You wake up at a hospital. The doctors deliver to you the unfortunate news. They say that you have heart disease and that's the reason why you passed out. Your health is now #{player.health}% and your strength is #{player.strength}%. You assume the reason to your heart disease was the time traveling.\n\n(Press enter to continue)"
gets
system("clear")
puts "You just decide you don't want heart disease anymore and decide to fight it."
# Battle loop (Version 4 - The Heart)
while true 
  puts "\nYou have the following items:"
  player.items.list
  print "\nEnter the number of the item you'd like to use to attack: "
  player.select_item(gets.to_i-1)
  system("clear")
  print "You attack #{enemy4.name} with the #{player.selected_item.name} and "
  damage = player.attack enemy4
  if enemy4.alive?
    puts "take off #{damage} percentage points."
  else
# Heart disease cured (Victory ending)
    puts "your heart disease is cured.\n\nYou win!\n
You instantly feel better and talk to your doctors. It just seemed like your heart disease was magically cured. Amazing. They let you go and you head to Goltra.\n\n(Press enter to continue)"
    break
  end
  puts "\Her health is now at #{enemy4.health}%."
  print "\nBrace yourself for #{enemy4.name}'s attack. Hit enter when ready. "
  gets
  system("clear")
# Heart disease takes over (Surgery ending)
  print "#{enemy4.name} attacks "
  damage = enemy4.attack player
  if player.alive?
    puts "you and takes off #{damage} percentage points."
  else
    puts "your body and now you need a new heart.\n\nYou can barely move anymore. The doctors will have to perform surgery on your heart.\n\nThe surgery on your heart was successful and they let you go. You head to Goltra.\n\n(Press enter to continue)"
    break
  end
  puts "\nYour health is now at #{player.health}%."
end
gets
system("clear")
# New enemy stats (Version 3)
enemy5 = Enemy.new("Sir Starcourge Radagon, the All-Knowing", 700, 120)
class Enemy < Character
  def attack(target)
    super(target, 120)
  end
end
player.health = 250
player.strength = 120
puts "You arrive at Goltra and discover a Flask of Crimson Tears. You decide to drink it and your health is now #{player.health}% and your strength is #{player.strength}%.\n\nYou go inside the castle and greet #{enemy5.name}. You notice the Californium on his body and engage in a fight. He already knows why you are here. On the ground, there are #{allknowing_items.length} items:"
allknowing_items.list
# Collecting items loop (Version 3)
  while true
    print "\nEnter the number of the one you want: "
    selected_item_index = gets.to_i-1
    system("clear")
    player.collect_item allknowing_items[selected_item_index]
    allknowing_items.delete_at selected_item_index
  
    puts "You now have the following items:"
    player.items.list false
    break if allknowing_items.length === 0
  
    print "\nWould you like to collect another item? [yes/no]: "
    break unless gets.chomp == "yes"
    system("clear")
    puts "There are now #{allknowing_items.length} items in front of you:"
    allknowing_items.list
  end
# End of collecting items (Version 3)
system("clear")
puts "When you finish looting the blades, you dash towards #{enemy5.name}. He swings to do an attack and you dodge it. It's your move."

# Battle loop (Version 5 - Radagon)
while true 
  puts "\nYou have the following items:"
  player.items.list
  print "\nEnter the number of the item you'd like to use to attack: "
  player.select_item(gets.to_i-1)
  system("clear")
  print "You attack #{enemy5.name} with the #{player.selected_item.name} and "
  damage = player.attack enemy5
  if enemy5.alive?
    puts "take off #{damage} percentage points."
  else
# Radagon gets defeated by you (Victory ending)
    puts "knock her out.\n\nYou win!\n\nAmazed by your strength, #{enemy5.name} hands you over his Californium.\n\n(Press enter to continue)"
    break
  end
  puts "\Her health is now at #{enemy5.health}%."
  print "\nBrace yourself for #{enemy5.name}'s attack. Hit enter when ready. "
  gets
  system("clear")
# Radagon defeats you (Loss ending)
  print "#{enemy5.name} attacks "
  damage = enemy5.attack player
  if player.alive?
    puts "you and takes off #{damage} percentage points."
  else
    puts "and defeats you.\n\nHe says that was a good fight and decides to give you some Californium as a gesture.\n\n(Press enter to continue)"
    break
  end
  puts "\nYour health is now at #{player.health}%."
end
gets
system("clear")
puts "You get your Californium and head back home. You look at your time machine and realize that it's just not worth it to go back in time anymore. You decide to live in the presetn and just only the present.\n\n(Press enter to continue)"


gets
system("clear")
puts "\nThank you for playing Zingleborg, #{player.name}!\nTry winning all of your battles if you didn't!"


