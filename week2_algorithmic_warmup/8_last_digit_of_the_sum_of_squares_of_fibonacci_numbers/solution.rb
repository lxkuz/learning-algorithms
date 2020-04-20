#!/usr/bin/env ruby
# by Andronik Ordian

def fib_square(n)
  return 0 if n == 0
  
  return 1 if n == 1
  
  return 2 if n == 2

  res = 0,1
  i = n % 60
  while i > 0
    next_step = res[1] + res[0]
    res[0] = res[1]
    res[1] = next_step % 10
    i -= 1
  end
  (res[0] * res[1]) % 10
end

if __FILE__ == $0
  n = gets.to_i
  puts "#{fib_square(n)}"
end