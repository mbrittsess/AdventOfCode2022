local min, max = { x = math.huge, y = math.huge }, { x = -math.huge, y = -math.huge }
for x, y in io.read("*a"):gmatch("(%d+),(%d+)") do
    min.x = math.min( min.x, x )
    min.y = math.min( min.y, y )
    max.x = math.max( max.x, x )
    max.y = math.max( max.y, y )
end
print( string.format( "X spans %i .. %i", min.x, max.x ) )
print( string.format( "Y spans %i .. %i", min.y, max.y ) )