#!/usr/bin/env ruby
# by Andronik Ordian

def pisano_period(m)
  previous, current = 0, 1
  return m if m <= 1
  for i in (0..(m * m)) 
    previous, current = current, (previous + current) % m
    return i + 1 if (previous == 0 and current == 1)
  end
end

def fib_huge(n, m)
  return n % m if n <= 1
  
  res = 0,1
  pisano_period = pisano_period(m)

  i = n % pisano_period

  return i if i <= 1

  while i > 1
    next_step = (res[1] + res[0]) % m
    res[0] = res[1]
    res[1] = next_step
    i -= 1
  end
  res.last
end

def test()
  result = [1, 3, 8, 6, 20, 24, 16, 12, 24, 60, 10,
    24, 28, 48, 40, 24, 36, 24, 18, 60, 16, 30, 48,
    24, 100, 84, 72, 48, 14, 120, 30, 48, 40, 36, 80,
    24, 76, 18, 56, 60, 40, 48, 88, 30, 120, 48, 32,
    24, 112, 300, 72, 84, 108, 72, 20, 48, 72, 42, 58,
    120, 60, 30, 48, 96, 140, 120, 136]
  result.each_with_index do |val,index|
    raise "ERROR! res = #{val}, i = #{index}, function = #{pisano_period(index + 1)}" unless pisano_period(index + 1) == val
  end
end

if __FILE__ == $0
  a, b = gets.split().map(&:to_i)
  puts "#{fib_huge(a, b)}"
end