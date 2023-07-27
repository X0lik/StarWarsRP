local fFind = file.Find
local addFile = resource.AddSingleFile

do
	local workshopColor = Color( 0, 200, 255 )
	local fontsFiles = fFind( "gamemodes/xilius/content/resource/fonts/*", "GAME" )
	for i,v in next, fontsFiles do
		addFile( "resource/fonts/" .. v )
	end
	XL:Log( "Content", "Resources Loaded!", workshopColor )
end