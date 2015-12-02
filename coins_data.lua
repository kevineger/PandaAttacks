local C = {}  -- Create the local module table (this will hold our functions and data)

C.coins = 0  -- Set the initial coins to 0

function C.init()
   C.filename = "cointfile.txt"
   return C.coins
end

function C.set( value )
   C.coins = value
end

function C.get()
   return C.coins
end

function C.add( amount )
   C.coins = C.coins + amount
end

function C.save()
   local path = system.pathForFile( C.filename, system.DocumentsDirectory )
   local file = io.open(path, "w")
   if ( file ) then
      local contents = tostring( C.coins )
      file:write( contents )
      io.close( file )
      return true
   else
      print( "Error: could not read ", C.filename, "." )
      return false
   end
end

function C.load()
   local path = system.pathForFile( C.filename, system.DocumentsDirectory )
   local contents = ""
   local file = io.open( path, "r" )
   if ( file ) then
      -- Read all contents of file into a string
      local contents = file:read( "*a" )
      local coins = tonumber(contents);
      io.close( file )
      return coins
   else
      print( "Error: could not read coins from ", C.filename, "." )
   end
   return nil
end

return C