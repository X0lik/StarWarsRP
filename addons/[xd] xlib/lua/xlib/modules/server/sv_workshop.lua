local workshop_files = {

    --========================[[MAP]]========================--
    //{ ['id'] = '2728924254', ['name'] = 'RP Bangclaw Evening' },
    --=======================[[MODEL]]=======================--
    { ['id'] = '1805743920', ['name'] = '501st Legion' },
    { ['id'] = '1809987422', ['name'] = '104th Batallion' },
    { ['id'] = '1815049401', ['name'] = '212th Attack Batallion' },
    { ['id'] = '2083494774', ['name'] = 'ARC Commander' },
    --======================[[CONTENT]]======================--
    //{ ['id'] = '1962912203', ['name'] = 'SlownLS Hitman Sys' },
    --======================[[WEAPONS]]======================--
    //{ ['id'] = '433932042', ['name'] = 'Lockpick System' },
    --=====================[[DISABLED]]======================--

}

for i,v in ipairs( workshop_files ) do

    resource.AddWorkshop(v.id)
    XD:CLog( 'Workshop File Loaded', v.name, v.id, Color( 0, 251, 255 ) )

end
