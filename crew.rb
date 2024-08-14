require 'json'

class TaskManager
  def initialize(file_name = "tasks.json")
    @file_name = file_name
    @tasks = load_tasks
  end

  def add_task(description)
    @tasks << { description: description, completed: false }
    save_tasks
    puts "Görev eklendi."
  end

  def list_tasks
    @tasks.each_with_index do |task, index|
      status = task[:completed] ? "[X]" : "[ ]"
      puts "#{index + 1}. #{status} #{task[:description]}"
    end
  end

  def complete_task(task_number)
    if valid_task_number?(task_number)
      @tasks[task_number - 1][:completed] = true
      save_tasks
      puts "Görev tamamlandı."
    else
      puts "Geçersiz görev numarası."
    end
  end

  def delete_task(task_number)
    if valid_task_number?(task_number)
      @tasks.delete_at(task_number - 1)
      save_tasks
      puts "Görev silindi."
    else
      puts "Geçersiz görev numarası."
    end
  end

  private

  def load_tasks
    if File.exist?(@file_name)
      JSON.parse(File.read(@file_name), symbolize_names: true)
    else
      []
    end
  end

  def save_tasks
    File.open(@file_name, "w") do |file|
      file.write(JSON.pretty_generate(@tasks))
    end
  end

  def valid_task_number?(task_number)
    task_number > 0 && task_number <= @tasks.length
  end
end

def main
  task_manager = TaskManager.new

  loop do
    puts "\nGörev Yönetimi"
    puts "1. Görev Ekle"
    puts "2. Görevleri Listele"
    puts "3. Görevi Tamamla"
    puts "4. Görevi Sil"
    puts "5. Çıkış"
    print "Seçiminiz: "
    choice = gets.chomp.to_i

    case choice
    when 1
      print "Görev açıklaması: "
      description = gets.chomp
      task_manager.add_task(description)
    when 2
      task_manager.list_tasks
    when 3
      print "Tamamlanacak görev numarası: "
      task_number = gets.chomp.to_i
      task_manager.complete_task(task_number)
    when 4
      print "Silinecek görev numarası: "
      task_number = gets.chomp.to_i
      task_manager.delete_task(task_number)
    when 5
      puts "Çıkış yapılıyor..."
      break
    else
      puts "Geçersiz seçim, lütfen tekrar deneyin."
    end
  end
end

main

# Bu kod Crew Tarafından kodlandı.
