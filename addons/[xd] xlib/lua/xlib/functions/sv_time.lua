XD = XD or {}

function XD.Time()

	if os.time() == 0 then
		return true
	else
		return false
	end

end

function XD.GetTime()
	return os.time()
end

function XD.GetDate()
	return os.date( '%d.%m.%Y' , os.time() )
end
