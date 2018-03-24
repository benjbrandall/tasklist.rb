require 'colorize'

$todolist = []
$completed_list = []
$log_list = []

def menu
  print "> "
  choice = gets.chomp
  case choice
  when "quit"
    quit
  when "log"
    log
  when /(new)/
    add(choice)
  when "debug"
    debug
  when "clear completed"
    clear_completed
  when "list completed"
    list_complete
  when "list"
    list
  when "complete all"
    complete_all
  when /(complete \d)\b/
    complete(choice)
  when /(complete \d..\d)/
    complete_range(choice)
  when /(search)/
    search(choice)
  when "list logs"
    show_logs
  when "backup logs"
    backup_logs
  when "help"
    help
  when /(delete)/
    delete(choice)
  else
    puts ""
  end
  menu
end

def log
  puts "\nKey ~~ to stop input.".yellow
  time = Time.new
  timestamp = time.strftime("%A %d %B, %Y %H:%M:%S")
  puts "\n#{timestamp}\n"
  puts "Log text: "
  puts ""
  print "> "
  log_text = gets "~~" # gets input until user types ~~
  File.open('logs.dat', 'a+') do |file|
    file.puts("\n## #{timestamp}\n\n#{log_text}") # writes log to new paragraph in logs.dat
  end
end

def show_last_log # (choice)
  # log_number = choice[9..-1].to_i
  # puts "LOG NUMBER: #{log_number}"
  logs_titles = Dir.entries("logs").to_a
  file = logs_titles.sort.last
  #selected_logs_titles.each do |file|
    unless file.include? "."
    puts File.read("logs/#{file}\n")
  end
end

def show_logs
  puts File.read("logs.dat")
  puts ""
end

def backup_logs
  time = Time.now
  timestamp = time.strftime("%A %d %B, %Y %H:%M:%S")
  File.rename("logs.dat", "logs/logs-backup-at-#{timestamp}") # moves logs.dat to new backup file
  File.open("logs.dat", 'w') # creates blank logs.dat
end

def add(choice)
  task = choice[4..-1] # chop the 'new' command off and get just task text
  if task.nil? == true
    puts "Empty task"
  else
    $todolist.push(task)
  end
end

def help
  puts "\n* Add a task:" + " new [task name]"
  puts "* List incomplete tasks:" + " list"
  puts "* Complete task: complete" + " [task number]"
  puts "* Complete all tasks:" + " complete all"
  puts "* List complete tasks:" + " list completed"
  puts "* Clear completed task list:" + " clear completed"
  puts "* Add new log:" + " log"
  puts "* List logs:" + " list logs"
  puts "* Move current logs to backup file and clear:" +" backup logs"
  puts "* Display tasks matching query:" + " search [query]"
  puts "* Tip: use @ or # in tasks names to specify tags for search"
  puts "\n~built by @benjbrandall~\n".light_yellow
end

def quit
  File.open("tasks.dat", "w+") do |f|
  $todolist.each { |element| f.puts(element) } # writes array tasks to file
  end
  exit(0)
  #File.open("completed.dat", "w+") do |f|
  #$completed_list.each { |element| f.puts(element) }
end

def load_tasks
  File.open("tasks.dat", "r").each_line do |task|
    $todolist.push(task) # loads from file into array
  end
  File.open("completed.dat", "r").each_line do |task|
    $completed_list.push(task) # loads from file into array
  end
end

def list
  puts ""
  if $todolist.empty? == false
  $todolist.each_with_index do |item,index|
    puts "#{index+1}: #{item}" # list each array item with index+1
  end
  else
    puts "Your list is empty."
  end
  puts ""
end

def list_complete
  puts ""
  if $completed_list.empty? == false
  $completed_list.each_with_index do |item,index|
    puts "#{index+1}: #{item}"
  end
  else
    puts "Your list is empty."
  end
  puts ""
end

def search(query)
  puts ""
  query = query[7..query.length] # cuts search command from query
  if $todolist.empty? == false
  $todolist.each_with_index do |item,index|
    if item.include? query
    puts "#{index+1}: #{item}"
    end
  end

  end
  puts ""
end

def complete(task)
  task.chars.to_a
  num = task[-1].to_i # cuts complete command from variable
  deleted_task = $todolist.delete_at(num-1)
  if deleted_task.nil? == false
    $completed_list.push(deleted_task)
    # puts "#{$completed_list[-1]}"
    File.open("completed.dat", "a+"){|f| f.write("#{$completed_list[-1]}")}
    list
  else
    puts "Task not found"
    list
  end
end

#def complete_range(task)
  #task.chars.to_a
  #num = task[9..-1] # cuts complete command from variable
  #num.split('..').map{|d| Integer(d)}
  #puts num[0]..num[1]

#  deleted_task = $todolist.delete_at(num-1)
#  if deleted_task.nil? == false
#    $completed_list.push(deleted_task)
#    # puts "#{$completed_list[-1]}"
#    File.open("completed.dat", "a+"){|f| f.write("#{$completed_list[-1]}")}
#    list
#  else
#    puts "Task not found"
#    list
#  end
#  end

def delete(task)
  unless task == ""
  task.chars.to_a
  num = task[-1].to_i
  $todolist.delete_at(num)
  end
end

def debug
  puts $todolist.inspect
  puts $completed_list.inspect
end

def complete_all
    $todolist.clear
    File.truncate('tasks.dat', 0) # clears contents of tasks.dat
end

def clear_completed
  $completed_list.clear
  File.truncate('completed.dat', 0) # clears contents of completed.dat
end

begin
  while true == true
    logo ="  dP                     dP       dP oo            dP               dP
  88                     88       88               88               88
d8888P .d8888b. .d8888b. 88  .dP  88 dP .d8888b. d8888P    88d888b. 88d888b.
  88   88'  `88 Y8ooooo. 88888'   88 88 Y8ooooo.   88      88'  `88 88'  `88
  88   88.  .88       88 88  `8b. 88 88       88   88   dP 88       88.  .88
  dP   `88888P8 `88888P' dP   `YP dP dP `88888P'   dP   88 dP       88Y8888' \n".blue
  # thanks to patorjk.com/software/taag/#p=display&f=Nancyj-Fancy for the font
    2.times {puts ""}
  print logo
  2.times {puts ""}
  puts "Type: 'new [title of task]' to add a new todo list item."
  puts "Type: 'list' to show your task list."
  puts "Type: 'quit' to quit. This will save your tasks for next time."
  puts "Type: 'complete [task number]'' to complete a task, or 'complete all' to clear."
  puts "Type: 'help' for a full list of commands"
  puts ""
  load_tasks
  menu
end
rescue Interrupt => e
  quit # forces the file to save even if the user [ctrl+c]s out
end
