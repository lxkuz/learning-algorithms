#!/usr/bin/env ruby
# by Andronik Ordian
require 'byebug'

def optimal_points(segments)
  points = []
  return points if segments.empty?
  segments_description = {}
  segments.each do |segment|
    segments_description = describe_segment(segment, segments_description)
  end
  result = []
  while(segments_description.any?)
    time = segments_description.to_a.sort_by{|(time, segments)| -segments.count}.first.first
    result.push(time)
    segments_description = filter_segments_description(segments_description, time)
  end
  result
end

def filter_segments_description(segments_description, time)
  target_segments = segments_description.delete(time)
  segments_description.to_a.map do |(time, segments)|
    fitlered_segments = segments - target_segments
    if fitlered_segments.any?
      [time, fitlered_segments]
    end
  end.compact.to_h
end

def describe_segment(segment, obj)
  iterator, finish = segment
  while(iterator <= finish)
    obj[iterator] ||= []
    obj[iterator] << segment
    iterator += 1
  end
  obj
end

# if __FILE__ == $0
#   n = gets.to_i
#   segments = []
#   n.times do
#     segments << gets.split(' ').map(&:to_i)
#   enda.map { |e| Segment.new(e[0], e[1]) }
  
#   points = optimal_points(segments)
#   puts "#{points.size}"
#   puts "#{points.join(' ')}"
# end

def test
  raise 'ERROR 1' if optimal_points([
    [4, 7],
    [1, 3],
    [2, 5],
    [5, 6]
  ]) != [3, 6]
end

test