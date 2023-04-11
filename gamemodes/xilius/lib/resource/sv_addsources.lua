local fFind = file.Find
local addFile = resource.AddSingleFile

local fontsFiles = fFind( "gamemodes/xilius/content/resource/fonts/*", "GAME" )
for i,v in next, fontsFiles do

	addFile( "resource/fonts/" .. v )
	XL:Log( "Added source file", v, greenColor )

end