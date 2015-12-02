local json = require( "json" ) 

local I = {}  -- Create the local module table (this will hold our functions and data)

I.items = {}  -- Set the user to initally have no items

function I.init()
   I.filename = "items24.txt"
   local load = I.load()
   if load ~= nil then
      I.items = load
   else
      I.items = {}
   end

   return I.items
end

function I.purchase( item )
   I.items[item] = true
end

function I.get()
   return I.items
end

function I.spend( item )
   I.items[item] = false
end

function I.save()
   local path = system.pathForFile( I.filename, system.DocumentsDirectory )
   local file = io.open(path, "w")

   if ( file ) then
      local contents = json.encode( I.items )
      print(contents)
      file:write( contents )
      io.close( file )
      return true
   else
      print( "Error: could not read ", I.filename, "." )
      return false
   end
end

function I.load()
   local path = system.pathForFile( I.filename, system.DocumentsDirectory )
   local contents = ""
   local file = io.open( path, "r" )
   if ( file ) then
      local contents = file:read( "*a" )
      local table = json.decode( contents )
      io.close( file )
      return table
   else
      print( "Error: could not read items from ", I.filename, "." )
   end
   return nil
end

return I