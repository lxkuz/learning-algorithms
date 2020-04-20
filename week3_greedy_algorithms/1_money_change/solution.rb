#!/usr/bin/env ruby
# by Andronik Ordian

def get_change(n)
  count = 0
  coin1, coin5, coin10 = 1, 5, 10
  while n >= coin10
    n -= coin10
    count += 1
  end
  while n >= coin5
    n -= coin5
    count += 1
  end
  while n >= coin1
    n -= coin1
    count += 1
  end
  count
end

def test
  raise "ERROR: #{get_change(47)} != 7" if get_change(47) != 7
end

if __FILE__ == $0
  n = gets.to_i
  puts "#{get_change(n)}"   
end
