local Data={} 

local pages = math.random(10,100)
local instructions = math.random(3, pages) 

function Data.getQuestion(q)
	if ( q == 0 ) then
		return "Help Gladys loop through " .. pages .. " pages of results."
	end
end

function Data.getAnswer(a)
	if ( a==1 ) then
		-- return "for(int i=0; i<"..pages.."; i++){\n  EvaluatePage(i);\n}"
		return "Correct answer"
	elseif ( a==2 ) then
		return "for(int i=0; i<="..pages.."; i++){\n  EvaluatePage(i);\n}"
	elseif ( a==3 ) then
		return "for(int i=0; i<"..pages.."; i--){\n  EvaluatePage(i);\n}"
	elseif ( a==4 ) then
		return "for(int i="..pages.."; i>0; i++){\n  EvaluatePage(i);\n}"
	end
end

return Data