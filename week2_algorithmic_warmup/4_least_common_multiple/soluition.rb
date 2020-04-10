#!/usr/bin/env ruby
# by Andronik Ordian

def gcd(a, b)
  return a if b == 0
  a_new = a % b
  gcd(b,a_new)
end

def lcm(a, b)
  return (a * b) / gcd(a, b)
end

if __FILE__ == $0
  a, b = gets.split().map(&:to_i)
  puts "#{lcm(a, b)}"
end
