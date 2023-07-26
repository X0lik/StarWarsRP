local host = "localhost"
local username = "root"
local password = ""
local database = "xilius_swrp"

require( "tmysql4" )
local err
XL.DB, err = tmysql.Connect( host, username, password, database, 3306 )

if err then
	XL:Log( "DataBase", "Connection Failed!", redColor )
	XL:Log( "DataBase", "[ERROR]: " .. err, redColor )
end