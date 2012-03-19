require 'column'
class MyHash
end

hash = {}

9.times do |i|
  hash[i+1]="valie #{i}"
end

9.times do |i|
  puts "#{i+1} = #{hash[i+1]}"
end
