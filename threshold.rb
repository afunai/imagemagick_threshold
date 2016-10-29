require 'rmagick'

img = Magick::ImageList.new('grade_60lines.png').first

t = []
56.times {|i| t[i] = []}

level = 1

600.times.each do |box|
  increment = false
  28.times do |y|
    56.times do |x|
p '!!!!!!' if img.pixel_color(x, y + box * 28).to_color == 'white' && t[x][y]
      if img.pixel_color(x, y + box * 28).to_color == 'black' && t[x][y].nil? then
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
  <threshold map="h56x28a">
    <description>Halftone 56x28 (angled)</description>
    <levels width="56" height="28" divisor="#{level}">
_EOS

28.times do |y|
  print '     '
  56.times do |x|
    printf ' %3.3s', t[x][y].to_i
  end
  puts
end

puts <<_EOS
    </levels>
  </threshold>
</thresholds>
_EOS
