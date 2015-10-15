-- used for handling if the user gave consent or not
local M = {}
M.consent = false; -- set the inital consent to be false

function M.init()
	 M.filename = "consent.txt"

	return M.scoreText
end

function M.set( value )
   M.consent = value
end

function M.get()
   return M.consent
end

function M.save()
   local path = system.pathForFile( M.filename, system.DocumentsDirectory )
   local file = io.open(path, "w")
   if ( file ) then
      local contents = tostring( M.consent )
      file:write( contents )
      io.close( file )
      return true
   else
      print( "Error: could not read ", M.filename, "." )
      return false
   end
end

function M.load()
   local path = system.pathForFile( M.filename, system.DocumentsDirectory )
   local contents = ""
   local file = io.open( path, "r" )
   if ( file ) then
      -- Read all contents of file into a string
      local contents = file:read( "*a" )
      local consent = contents;
      io.close( file )
      return consent
   else
      print( "Error: could not read consent value from ", M.filename, "." )
   end
   return nil
end

return M