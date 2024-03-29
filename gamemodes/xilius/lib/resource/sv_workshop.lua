local workshopFiles = {

    {
        ['id'] = '2728924254',
        ['name'] = 'RP Bangclaw Evening'
    },

    { 
        ['id'] = '1805743920',
        ['name'] = '501st Legion'
    },

    { 
        ['id'] = '1809987422',
        ['name'] = '104th Batallion'
    },

    {
        ['id'] = '1815049401',
        ['name'] = '212th Attack Batallion'
    },

    {
        ['id'] = '2083494774',
        ['name'] = 'ARC Commander'
    },

}

do
    local workshopColor = Color( 0, 200, 255 )
    for i,v in next, workshopFiles do
        resource.AddWorkshop(v.id)
    end
    XL:Log( "Workshop", "Resources Loaded!", workshopColor )
end