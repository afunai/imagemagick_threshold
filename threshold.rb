require 'rmagick'

LINES  = '60'
WIDTH  = 28
HEIGHT = 28

img = Magick::ImageList.new("grade_#{LINES}lines.png").first

t = []
WIDTH.times {|i| t[i] = []}

level = 1

600.times.each do |box|
  increment = false
  HEIGHT.times do |y|
    WIDTH.times do |x|
      p '!!!!!!' if img.pixel_color(x, y + box * HEIGHT).to_color == 'white' && t[x][y]
      if img.pixel_color(x, y + box * HEIGHT).to_color == 'black' && t[x][y].nil? then
        t[x][y] = level
        increment = true
      end
    end
  end
  level += 1 if increment
end

puts <<_EOS
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE thresholds [
<!ELEMENT thresholds (threshold)+>
<!ELEMENT threshold (description , levels)>
<!ELEMENT description (CDATA)>
<!ELEMENT levels (CDATA)>
<!ATTLIST threshold map ID #REQUIRED>
<!ATTLIST levels width CDATA #REQUIRED>
<!ATTLIST levels height CDATA #REQUIRED>
<!ATTLIST levels divisor CDATA #REQUIRED>
]>
<thresholds>
  <threshold map="h#{LINES}lines">
    <description>Halftone #{LINES} lines/inch (angled)</description>
    <levels width="#{WIDTH}" height="#{HEIGHT}" divisor="#{level}">
_EOS

HEIGHT.times do |y|
  print '     '
  WIDTH.times do |x|
    printf ' %3.3s', t[x][y].to_i
  end
  puts
end

puts <<_EOS
    </levels>
  </threshold>
</thresholds>
_EOS
