XD = XD or {}

--[[

    У кого возникнут вопросы по поводу повторяющихся таблиц, поясняю:
    Некоторые скрипты делают проверки через tbl, value )
    В таких нужно писать например VIPTable

    А некоторые делают проверки через tbl[ value ]
    В таких нужно использовать VIPSTable

    Но, возможно вторые таблицы универсальны для обоих, не ебу, не проверял и не буду
    Переписывайте как удобно и юзайте, если не лень

    Лично мне было лень

]]--

XD.VIPTable = {
    'developer', 'operator', 'curator',
    'superadmin', 'admin', 'dadmin',
    'dmoder', 'dhelper', 'vip'
}

XD.AdminTable = {
    'developer', 'operator', 'curator',
    'superadmin', 'admin', 'dadmin',
    'moder', 'dmoder', 'helper', 'dhelper'
}

XD.HAdminTable = {
    'developer', 'operator', 'curator',
    'superadmin', 'admin'
}

XD.SAdminTable = {
    'developer', 'operator', 'curator',
}

XD.OPTable = {
    'developer', 'operator'
}

XD.RootOnly = {'developer'}

XD.VIPSTable = {
    ['developer'] = true, ['operator'] = true, ['curator'] = true,
    ['superadmin'] = true, ['admin'] = true, ['dadmin'] = true,
    ['dmoder'] = true, ['dhelper'] = true, ['vip'] = true
}

XD.AdminSTable = {
    ['developer'] = true, ['operator'] = true, ['curator'] = true,
    ['superadmin'] = true, ['admin'] = true, ['dadmin'] = true,
    ['moder'] = true, ['eventer']= true, ['dmoder'] = true, ['helper'] = true, ['dhelper'] = true
}

XD.HAdminSTable = {
    ['developer'] = true, ['operator'] = true, ['curator'] = true,
    ['superadmin'] = true, ['admin'] = true
}

XD.SAdminSTable = {
    ['developer'] = true, ['operator'] = true, ['curator'] = true
}

XD.OPSTable = {
    ['developer'] = true, ['operator'] = true
}

XD.SRootOnly = { ['root'] = true }

-------------[[Special Tables]]-------------
--------------------------------------------

XD.SpawnAccess = {
  ['developer'] = true, ['operator'] = true, ['curator'] = true,
  ['eventer'] = true
}

--------------------------------------------
--------------------------------------------

local meta = FindMetaTable( 'Player' )
function meta:IsVIP()
    return XD.VIPTable[ self:GetUserGroup() ]
end

function meta:IsAdmin()
    return XD.AdminSTable[ self:GetUserGroup() ]
end

function meta:IsHighAdmin()
    return XD.HAdminSTable[ self:GetUserGroup() ]
end

function meta:IsSuperAdmin()
    return XD.SAdminSTable[ self:GetUserGroup() ]
end

function meta:IsOP()
    return XD.OPSTable[ self:GetUserGroup() ]
end

function meta:IsRoot()
    return XD.SRootOnly[ self:GetUserGroup() ]
end

-------------[[Special Funcs]]-------------
-------------------------------------------

function meta:CanSpawn()
    return XD.SpawnAccess[ self:GetUserGroup() ]
end

-------------------------------------------
-------------------------------------------
