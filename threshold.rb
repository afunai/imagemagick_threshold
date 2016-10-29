require 'rmagick'

img = Magick::ImageList.new('grade_85lines.png').first

t = []
20.times {|i| t[i] = []}

level = 1

256.times.each do |box|
  increment = false
  20.times do |y|
    20.times do |x|
p '!!!!!!' if img.pixel_color(x, y + box * 20).to_color == 'white' && t[x][y]
      if img.pixel_color(x, y + box * 20).to_color == 'black' && t[x][y].nil? then
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
  <threshold map="h20x20o">
    <description>Halftone 20x20 (orthogonal)</description>
    <levels width="20" height="20" divisor="#{level}">
_EOS

20.times do |y|
  print '     '
  20.times do |x|
    printf ' %3.3s', t[x][y].to_i
  end
  puts
end

puts <<_EOS
    </levels>
  </threshold>
</thresholds>
_EOS
