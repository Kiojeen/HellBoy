kj = {
    dataTypes = { A = 127, B = 1, DBL = 64, D = 4, F = 16, Q = 32, W = 2, X = 8},
    removePoint = function(int)
        str = tostring(int)
        if string.find(str, '%.') then
            return tonumber(string.sub(str, 1, string.find(str, '%.') - 1))
        else
            return tonumber(str)
        end
    end,
    splitStrings = function(str)
        local z = 0
        local array = {}
        for i in string.gmatch(str, "[^%s]+") do 
            z = z + 1
            array[z] = i
        end
        return array
    end,
    dT = function(str)
        for i, v in pairs(kj.dataTypes) do
            if str == i then
                return v, true
            end
        end
    end,
    statSwitch = function (bool)
        if bool then
            return "  -〘 ✅ 〙"
        else
            return "  -〘 ❌ 〙"
        end
    end,
    statSwitch_2 = function (str)
        if str == "" then
            return "  -〘 ✅ 〙"
        else
            return ""
        end
    end,
    toggler = function (var)
        if var then
            return false
        else
            return true
        end
    end,
    isFrozen = function(add)
        if type(add) == 'number' then
            local items = gg.getListItems()
            for i, v in ipairs(items) do
                if v.address == add then
                    if v.freeze == true then
                        return true
                    elseif v.freeze == false then
                        return false
                    end
                end
            end
        end
    end,
    setString = function(add, str, range)
        vars = {}
        bytes = gg.bytes(str)
        if #bytes < range then
            for i = 1, range - #bytes do
                table.insert(bytes, 0)
            end
        end
        for i = 1, range do
            table.insert(vars, {
                address = add + i - 1,
                flags = kj.dT('B'),
                value = bytes[i]
            })
        end
        gg.setValues(vars)
    end,
    tableToString = function (array)
        local str = " {\n"
        for i, v in pairs(array) do
            if type(i) == "string" then
                str = str .. "\t\t" .. i .. " ="
            end
            if type(v) == "table" then
                str = str .. kj.tableToString(v)
            elseif type(v) == "boolean" then
                str = str .. " " .. tostring(v)
            elseif type(v) == 'string' then
                str = str .. " " .. "'" .. tostring(v) .. "'"
            elseif type(v) == 'number' then
                str = str .. "\t\t" .. v
            else
                str =  str .. " " .. v
            end
            str = str .. ",\n"
        end
        if str ~= '' then
            str = string.sub(str, 1, string.len(str) - 1)
        end 
        str = str .. "\n}"
        return str
    end,
    getValue = function(add, flag)
        if type(add) == 'number' then
            flag, bool = kj.dT(string.sub(flag, string.len(flag)))
            if bool then
                local var = {
                    {
                        address = add,
                        flags = flag,
                    }
                }
                return gg.getValues(var)[1].value
            end
        end
    end,
    findAddress = function(str, start_point, end_point, times, result)
        if type(str) == 'string' then
            gg.clearResults()
            flag, bool = kj.dT(string.sub(str, string.len(str)))
            if bool then
                str = string.sub(str, 1, string.len(str) - 1)
                if pcall(gg.searchNumber, str, flag, false, 536870912, start_point, end_point, times) then
                    results = gg.getResults(gg.getResultCount())
                    if #results > 0 then
                        address = gg.getResults(gg.getResultCount())[result].address
                        gg.clearResults()
                        return address, true
                    end
                end
            end
        end
    end,
    setValue = function (add, val)
        if type(add) == 'number' then
            if type(val) == 'string' then
                flag, bool = kj.dT(string.sub(val, string.len(val)))
                if bool then
                    val = tonumber(string.sub(val, 1, string.len(val) - 1))
                    local var = {
                        {
                            address = add,
                            flags = flag,
                            value = val,
                        }
                    }
                    gg.setValues(var)
                end
            end
        end
    end,
    switch = function(add, new_value, original_value, toast)
        if type(new_value) == 'string' and type(original_value) == 'string' then
            if type(add) == 'number' then
                flag_1, bool_1 = kj.dT(string.sub(new_value, string.len(new_value)))
                flag_2, bool_2 = kj.dT(string.sub(original_value, string.len(original_value)))
                if bool_1 and bool_2 then
                    current_value = kj.getValue(add, string.sub(new_value, string.len(new_value)))
                    new_value = tonumber(string.sub(new_value, 1, string.len(new_value) - 1))
                    original_value = tonumber(string.sub(original_value, 1, string.len(original_value) - 1))
                    if new_value == current_value then
                        var = {
                            {
                                address = add,
                                flags = flag_1,
                                value = original_value,
                            }
                        }
                        if toast ~= nil then
                            toast = toast .. ": " .. "OFF"
                            gg.toast(toast)
                        end 
                        gg.setValues(var)
                        return ""
                    elseif original_value == current_value then
                        var = {
                            {
                                address = add,
                                flags = flag_2,
                                value = new_value,
                            }
                        }
                        if toast ~= nil then
                            toast = toast .. ": " .. "ON"
                            gg.toast(toast)
                        end 
                        gg.setValues(var)
                        return "  -〘 ✅ 〙"
                    else
                        gg.toast("No Match")
                        return ""
                    end
                end
            end
        end
    end,
    freezeSwitch = function(add, new_value, toast)
        if type(new_value) == 'string' then
            flag, bool = kj.dT(string.sub(new_value, string.len(new_value)))
            if bool then
                new_value = tonumber(string.sub(new_value, 1, string.len(new_value) - 1))
                if type(add) == 'number' then
                    local var = {
                        {
                            address = add,
                            flags = flag,
                            value = new_value,
                            freeze = true
                        }
                    }
                    if kj.isFrozen(add) then
                        gg.removeListItems(var)
                        if toast ~= nil then
                            toast = toast .. ": " .. "OFF"
                            gg.toast(toast)
                        end
                        return ""
                    else
                        gg.setValues(var)
                        gg.addListItems(var)
                        if toast ~= nil then
                            toast = toast .. ": " .. "ON"
                            gg.toast(toast)
                        end
                        return "  -〘 ✅ 〙"
                    end
                end
            end
        end
    end,
    groupFreezeSwitch = function(array, toast, interval)
        if kj.isFrozen(array[1].address) then
            gg.removeListItems(array)
            if toast ~= nil then
                toast = toast .. ": " .. "OFF"
                gg.toast(toast)
            end
            return ""
        else
            for i, v in ipairs(array) do
                v.freeze = true
            end
            if interval == nil then
                gg.setValues(array)
                gg.addListItems(array)
                if toast ~= nil then
                    toast = toast .. ": " .. "ON"
                    gg.toast(toast)
                end
            else
                for i, v in ipairs(array) do
                    gg.setValues(v)
                    gg.addListItems(v)
                    gg.sleep(interval)
                end
                if toast ~= nil then
                    toast = toast .. ": " .. "ON"
                    gg.toast(toast)
                end
            end
            return "  -〘 ✅ 〙"
        end
    end,
}",
        "[🕯]Absorb wax",
        "[💠]Absorb Fragments",
        "[🔥]Burn"  .. signs.burn,
        "[⬆️]Breach Walls",
        "[🌕]Wing Charge" .. signs.wcharge,
        "[🌀]Teleport",
        "[📃]Coordinates List",
        "[⭐]Semi Star Run",
        "[🧭]Out Of Borders",}
        cgoto = #crunMenu + 2
        sign = {}
    end
  end
end
do
  do
    do srunMenu = {}
    srunMenu = {
        "[➡️]Next Location",
        "[⬅️]Previous Location",
        "[⭐]Run",
        "[⬆️]Breach Walls",
        "[🌕]Wing Charge" .. signs.wcharge,
        "[🌀]Teleport",
        "[📃]Coordinates List",
        "[🕯]Semi Candle Run",
        "[🧭]Out Of Borders",}
        sgoto = #srunMenu + 2
        sign = {}
    end
  end
end
  do
    do
     table.insert(crunMenu, back[1])
      table.insert(crunMenu, SPLine)
    end
  end
    do
      do
        table.insert(srunMenu, back[1])
       table.insert(srunMenu, SPLine)
      end
    end
    do
      do
        for i, v in ipairs(scrSoul) do
            if scrSoul[i][1] == SkidLocation then
                for u, d in ipairs(scrSoul[i].Map_Goto.Map_Goto_Name) do
                table.insert(crunMenu, u .. ". " .. stl1 .. scrSoul[i].Map_Goto.Map_Goto_Name[u])
                table.insert(srunMenu, u .. ". " .. stl1 .. scrSoul[i].Map_Goto.Map_Goto_Name[u])
                SkLock = SkidLocation
                end
            end
        end
    if type_ == nil then
        type_ = rtype
    end 
  end fragsLocker()
    end sflag, cflag = false
        for i, v in ipairs(scrSoul) do
            if scrSoul[i][1] == SkidLocation then
                if #scrSoul[i].C_Runner > 0 then
                    cflag = true
                else
                    cflag = false
                    type_ = "s"
                    srunMenu[8] = nil
                end
            end
        end dontRemove = 'By: Kiojeen'
        for i, v in ipairs(scrSoul) do
            if scrSoul[i][1] == SkidLocation then
                if #scrSoul[i].S_Runner > 0 then
                    sflag = true
                else
                    sflag = false
                    type_ = "c"
                    crunMenu[9] = nil
                end
            end
        end dontRemove = 'By: Kiojeen'
          if sflag == false then
              if cflag == false then
                type_ = 'back'
              end
          end
       do
     do
       do
         do
          local rCG = gg
         if type_ == 'back' then yellowTears()
         elseif type_ == "c" and cflag ~= false then
             tear = rCG.choice(crunMenu, nil, header)
             if     tear == eye[1] then
                run("c")
             elseif tear == eye[2] then
                abswaxpro()
             elseif tear == eye[3] then
                absorbFrags()
             elseif tear == eye[4] then
                burner()
             elseif tear == eye[5] then
                bwall(configs.bdis)
             elseif tear == eye[6] then
                wcharge()
             elseif tear == eye[7] then
                tpmortal()
             elseif tear == eye[8] then
                cordlist("c")
             elseif tear == eye[9] then
                type_ = eye[90] runChoice("s")
             elseif tear == eye[10] then
                oobls('runChoice')
             elseif tear == eye[11] then
                type_ = nil yellowTears() 
             elseif tear == eye[12] then
                runChoice("c")
             elseif tear ~= nil then
                 for i, v in ipairs(scrSoul) do
                    if scrSoul[i][1] == SkidLocation then
                        pcall(teleport, scrSoul[i].Map_Goto.Map_Goto_Cord[tear - cgoto])
                        break
                    end
                 end
             end
         elseif type_ == "s" and sflag ~= false then
             tear = rCG.choice(srunMenu, nil, header)
             if     tear == eye[1] then
                srun_add()
             elseif tear == eye[2] then
                srun_sub()
             elseif tear == eye[3] then
                run("s")
             elseif tear == eye[4] then
                bwall(configs.bdis)
             elseif tear == eye[5] then
                wcharge()
             elseif tear == eye[6] then
                tpmortal()
             elseif tear == eye[7] then
                cordlist("s")
             elseif tear == eye[8] then
                type_ = eye[90] runChoice("c")
             elseif tear == eye[9] then
                oobls('runChoice')
             elseif tear == eye[10] then
                type_ = nil yellowTears() 
             elseif tear == eye[11] then
                runChoice("s")
             elseif tear ~= nil then
                 for i, v in ipairs(scrSoul) do
                    if scrSoul[i][1] == SkidLocation then
                        pcall(teleport, scrSoul[i].Map_Goto.Map_Goto_Cord[tear - sgoto])
                        break
                       end
                    end
                 end
              end
           end
        end
     end
  end
end
function yellowTears()
    STAY = 'yellowTears'
    local ytG = gg
    tear = ytG.choice(yellowCry, nil, header)
    if tear == eye[1] then 
        tpmenu()
    elseif tear == eye[2] then 
        runType() 
    elseif tear == eye[3] then 
        burner() 
    elseif tear == eye[4] then 
        gg.toast('Soon...') --Absorb all
    elseif tear == eye[5] then
        wcharge()
    elseif tear == eye[6] then 
        magic()   
    elseif tear == eye[7] then
        wingmode()
    elseif tear == eye[8] then 
        trolls()
    elseif tear == eye[9] then 
        gg.toast('Soon...')      
    elseif tear == eye[10] then 
        modemenu()
    elseif tear == eye[11] then 
        ClosetMenu()
    elseif tear == eye[12] then 
        settings()
    elseif tear == #yellowCry then 
        os.exit()
    end
end
function wingmode()
    STAY = 'wingmode'
    getSkidLocat()
    tear = gg.choice(yellow[7].content, nil, header)
    if tear ~= nil then
        if tear == #yellow[7].content then
            yellowTears()
        elseif tear == eye[1] then
            wings = kj.getValue(anptr + anptroffsets.wings, 'Q')
            tear = gg.prompt({'Set wings count: '}, {wings}, {'number'})
            if tear ~= nil then
                tear[1] = tonumber(tear[1])
                if type(tear[1]) == 'number' then
                    local uu = {
                        {
                            address = anptr + anptroffsets.wings,
                            flags = kj.dT('Q'),
                            value = tear[1],
                        },
                    }
                    gg.setValues(uu)
                else
                    gg.toast('Please put numbers only')
                end
            end
        elseif tear == eye[2] then
            capetrick = kj.toggler(capetrick)
            if not capetrick then
                kj.setValue(anptr + anptroffsets.wvisible, '1 F')
            end
        elseif tear == eye[3] then
            kj.switch(bootloader + liboffsets.fastflap, '506761216 D', '520725538 D', 'Fast Flap')
        end
    end   
end
function settings()
    STAY = 'settings'
    hbstngs = {
        "[💨]Auto Wind Remove in OOBs: " .. kj.statSwitch(configs.awrob),
        "[↕️]Breach distance: " .. configs.bdis,
        "[📮]Dev Mode: " .. kj.statSwitch(configs.devmode),
        "[🏠]Fast Return Home" .. kj.statSwitch(configs.fasthome),
        "[🔁]Mumu User" .. kj.statSwitch(configs.mumu),
        back[1]
    }
    tear = gg.choice(hbstngs, nil, '[☣️]HellBoy' .. ' Settings ' .. hellboy)
    if tear == eye[#hbstngs] then
        yellowTears()
    elseif tear == eye[1] then
        configs.awrob = kj.toggler(configs.awrob)
    elseif tear == eye[2] then
        tear = gg.prompt({"Choose the distance for Breach:"}, {7}, {'number'})
        if tear ~= nil then
            tear[1] = tonumber(tear[1])
            if type(tear[1]) == 'number' then
                configs.bdis = tear[1]
                saveconfigs()
            else
                gg.toast('Please put numbers only')
            end
        end
    elseif tear == eye[3] then
        if configs.devmode then
            configs.devmode = false
            gg.hideUiButton()
            saveconfigs()
            nodemode()
        else 
            configs.devmode = true
            gg.showUiButton()
            saveconfigs()
            demode()
        end
    elseif tear == eye[4] then
        configs.fasthome = kj.toggler(configs.fasthome)
        fasthome(configs.fasthome)
        saveconfigs()
    elseif tear == eye[5] then
        configs.mumu = kj.toggler(configs.mumu)
        saveconfigs()
        if configs.mumu then
            gg.toast('Too bad')
        end
    end
end
function cmdactv()
    if noui ~= true then 
        noui = true gg.toast('Commands: [ON]')
        gg.sleep(1000) 
        gg.toast('Type: \'-kj help\' in the chat for help')
    else 
        noui = false gg.toast('Commands: [OFF]') 
    end
end
function fasthome(bool)
    if bool then
        val = -721215457
    else
        val = 1409289387
    end
    if val ~= nil then
        kj.setValue(bootloader + liboffsets.fasthome, tostring(val) .. 'D')
    end
end
function tpmenu()
    STAY = 'tpmenu'
    local tpmG = gg
    tear = tpmG.choice(yellow[1].content, nil, header)
    if tear == #yellow[1].content then yellowTears()
    elseif tear == eye[1] then 
        tpmortal()
    elseif tear == eye[2] then
        savelocat()
    elseif tear == eye[3] then 
        gotoMap()
    elseif tear == eye[4] then 
        oobls('tpmenu')
    elseif tear == eye[5] then 
        bwall(configs.bdis)
    elseif tear == eye[6] then 
        teleport({getPosition()[1], getPosition()[2] + configs.bdis, getPosition()[3]})
    elseif tear == eye[7] then 
        teleport({getPosition()[1], getPosition()[2] - configs.bdis, getPosition()[3]})
    elseif tear == eye[8] then 
        coordinater('move')
    elseif tear == eye[9] then 
        coordinater('copy')
    elseif tear == eye[10] then 
        coordinater('freeze')
    elseif tear == eye[11] then 
        kj.freezeSwitch(anptr + anptroffsets.ypos, tostring(getPosition()[2]) .. 'F', 'Freezing Y Coordinate')
    end
end
function coordinater(rspType)
    ccor = getPosition()
    cord = {}
    xyz = "{" .. ccor[1] .. '; '.. ccor[2] .. '; ' .. ccor[3] .. "}"
    if rspType == 'copy' then
        gg.copyText(xyz)
    elseif rspType == 'move' then
        tear = gg.prompt({'Specifiy coordinates in form: {X ; Y ; Z}'}, {xyz}, {'number'})
        if tear ~= nil then
            if not pcall(teleport, assert(load("return " .. tear[1]))()) then
                gg.toast("Please type properly")
            end
        end
    elseif rspType == 'freeze' then
        kj.groupFreezeSwitch({
            {
                address = anptr + anptroffsets.xpos,
                flags = kj.dT('F'),
                value = getPosition()[1],
            },
            {
                address = anptr + anptroffsets.ypos,
                flags = kj.dT('F'),
                value = getPosition()[2]
            },
            {
                address = anptr + anptroffsets.zpos,
                flags = kj.dT('F'),
                value = getPosition()[3]
            },
        },'Pin Position')
    end
end
function gotoMap()
    STAY = 'gotoMap'
    local gtG = gg
    gtMenu = {}
    gtMenu.Name = {}
    gtMenu.Cord = {}
    for i, v in ipairs(scrSoul) do
        if SkidLocation == scrSoul[i][1] then
            for d, u in ipairs(scrSoul[i].Map_Goto.Map_Goto_Name) do
                gtMenu.Name[d] = d .. '. ' .. scrSoul[i].Map_Goto.Map_Goto_Name[d]
                gtMenu.Cord[d] = scrSoul[i].Map_Goto.Map_Goto_Cord[d]
            end
            break
        end
    end
    table.insert(gtMenu.Name, back[1])
    tear = gtG.choice(gtMenu.Name, nil, header)
    if tear == #gtMenu.Name then tpmenu()
    elseif tear ~= eye[69] then pcall(teleport, gtMenu.Cord[tear])
    end
end
function ClosetMenu()   
    STAY = 'ClosetMenu'
    local type = nil
    local cMG = gg
    tear = cMG.choice(yellow[11].content, nil, header)
    if tear == eye[6] then yellowTears()
    elseif tear ~= nil then
        opencloset(cltypes[tear][2])
    end
end
function opencloset(closet)
    if closet ~= nil then
        local temp = {
            {
                address = anptr + anptroffsets.closet - 60,
                flags = gg.TYPE_DWORD,
                value = 0,
            },
            {
                address = anptr + anptroffsets.closet - 4,
                flags = gg.TYPE_DWORD,
                value = 0,
            },
        }
        gg.setValues(temp)
        table.insert(temp, {
                address = anptr + anptroffsets.closet,
                flags = gg.TYPE_DWORD,
                value = closet,
            })
        gg.sleep(100)
        if not pcall(gg.setValues, temp) then
            gg.toast("Please type properly")
        else
            local temp = {
                {
                    address = anptr + anptroffsets.closet - 60,
                    flags = gg.TYPE_DWORD,
                    value = 1,
                },
                {
                    address = anptr + anptroffsets.closet + 4,
                    flags = gg.TYPE_DWORD,
                    value = 1,
                },
            }
            gg.setValues(temp)
        end
    end
end                            
shout = {
    {
        'Default Call', 
        'ShoutDefault'
    },
    {
        'LP Call',
        'ShoutPrince'
    },
    {
        'Crow Call',
        'ShoutCrow'
    },
    {
        'Turtle Call',
        'ShoutTurtle'
    },
    {
        'Kizuna Call',
        'ShoutAi'
    },
    {
        'Baby Manta',
        'ShoutMantaBaby'
    },
    {
        'Small Manta',
        'ShoutMantaSmall',
    },
    {
        'Big Manta',
        'ShoutMantaBig'
    },
    {
        'Double Manta',
        'ShoutMantaDouble'
    },
    {
        'Krill Shout',
        'ShoutDuskCreature'
    },
    {
        'Anonymous Call',
        'ShoutShade'
    },
    {
        'Anonymous Call 2',
        'ShoutShadeRemote'
    },
    {
        'Fragment Sound',
        'ShoutFragment'
    },
    {
        'Small Fish Call',
        'ShoutSmallFish'
    },
}
function modemenu()
    STAY = 'modemenu'
    getSkidLocat()
    c_hw = '\t' .. kj.removePoint(kj.getValue(guiptr + gptoffsets.scrres, 'F')) .. '::' .. kj.removePoint(kj.getValue(guiptr + gptoffsets.scrres + 4, 'F'))
    yellow[10].content[3] = "[📸]ScreenShot Resolution" .. c_hw
    tear = gg.choice(yellow[10].content, nil, header)
    if tear ~= nil then
        if tear == #yellow[10].content then 
            yellowTears()
        elseif tear == eye[1] then 
            meshare()
        elseif tear == eye[2] then 
            setIconSize()
        elseif tear == eye[3] then 
            sres()
        elseif tear == eye[4] then 
            setspeed()
        elseif tear == eye[5] then 
            kj.switch(bootloader + liboffsets.rcoulds, '506630144 D', '-46054816 D', "Remove Clouds")
        elseif tear == eye[6] then 
            kj.switch(bootloader + liboffsets.winds, '505873376 D', '1847778369 D', "Removing Wind" )
        elseif tear == eye[7] then
            rwind() gg.toast('Wind Removed')
        elseif tear == eye[8] then
            temp = {}
            for i, v in ipairs(shout) do
                table.insert(temp, i .. '. ' .. '[📣]' .. v[1] )
            end table.insert(temp, back[1])
            tear = gg.choice(temp, nil, 'This replaces the Default Call')
            if tear == #temp then
                modemenu()
            elseif tear ~= nil then 
                kj.setString(bootloader + liboffsets.honksound, '.' .. shout[tear][2], 19)
                gg.toast(shout[tear][1] .. ' is the default call now')
            end
        elseif tear == eye[9] then
            sunsetfilter()
        elseif tear == eye[10] then
            tear = gg.prompt({"Choose Running Speed:"}, {3.5}, {'number'})
            if tear ~= nil then
                tear[1] = tonumber(tear[1])
                if type(tear[1]) == 'number' then
                    local uu = {
                        {
                            address = bootloader + liboffsets.pspeed,
                            flags = kj.dT('F'),
                            value = tear[1],
                        }
                    }
                    gg.setValues(uu)
                else
                    gg.toast('Please put numbers only')
                end
            end
        end
    end
end
function sunsetfilter()
    getSkidLocat()
    local offsets = {}
    for i = 0, 2 do
        table.insert(offsets, guiptr + gptoffsets.sunsetfilter + 16 * i) 
        if kj.getValue(offsets[i + 1], 'D') == 0 then
            signs.veffect[i + 1] = "  -〘 ✅ 〙"
        else
            signs.veffect[i + 1] = ""
        end
    end
    val = kj.getValue(offsets[3] + 16, 'D')
    vfilters = {
        'Dark Effect',
        'Red Effect',
        'White Effect',
    }
    local temp = {}
    for i, v in ipairs(vfilters) do
        table.insert(temp, '[🌁]' .. v .. signs.veffect[i])
    end
    tear = gg.choice(temp, nil, header)
    for i, v in ipairs(vfilters) do
        if tear == i then
            signs.veffect[i] = kj.switch(offsets[i], '0 D', tostring(val) .. 'D', vfilters[i])
        end
    end
end
function meshare()
    local pointer = anptr + 22566976
    if kj.getValue(guiptr + 860 + gptoffsets.meshared, 'Q') == 0 then
        local uu = {
            address = guiptr + 860 + gptoffsets.meshared,
            flags = kj.dT('Q'),
            value = pointer
        }
        gg.setValues({uu})
        gg.sleep(500)
    end
    kj.switch(guiptr + gptoffsets.meshared, '1 D', '0 D')
end
function rwind()
    windlist = {}
    for i = 0, 100 do
        table.insert(windlist, {
            address = guiptr + gptoffsets.winds + (i * 256) - 28,
            flags = gg.TYPE_DWORD,
            value = 0
        })
    end
    gg.setValues(windlist)
end
function setIconSize(size)
    if size == nil then
        tear = gg.prompt({'[🧸]Set icons size: Default is 1'}, {1}, {'number'}) 
        if tear ~= nil then
            size = tear[1]
        end
    end
    if size ~= nil then
        local uu = {
            address = bootloader + liboffsets.iconsize,
            flags = gg.TYPE_FLOAT,
            value = size,
        }
        if not pcall(gg.setValues, {uu}) then
            gg.toast("Please type properly")
        end
    end
end
function setspeed(speed)
    if speed == nil then
        tear = gg.prompt({'[⏲]Set Game Speed'}, {1}, {'number'})
        if tear ~= nil then
            speed = tear[1]
        end
    end
    if speed ~= nil then
        local uu = {
            address = guiptr + gptoffsets.gamespeed,
            flags = gg.TYPE_FLOAT,
            value = speed,
        }
        if not pcall(gg.setValues, {uu}) then
            gg.toast("Please type properly")
        end
    end
end
function cordlist(type)
    STAY = 'runChoice'
    local cordls = {}
    if not (type_ ~= nil) then
        type_ = type
    end
    if type_ == "c" then
        for i, v in ipairs(scrSoul) do
            if scrSoul[i][1] == SkidLocation then
                menu = i 
                for d, u in ipairs(scrSoul[menu].C_Runner) do
                    if d < 10 then b = 0 else b = "" end
                        if sign[d] == eye[900] then sign[d] = "" elseif sign[d] == 1 then sign[d] = "✳️" end
                        cordls[d] = "- Candle Location: " .. "-[ " .. b .. d .. " ]- " .. sign[d]
                        z = d
                    end
                break
            end
        end
        table.insert(cordls, back[1])
        tear = gg.choice(cordls, nil, header)
        if tear == eye[z + 1] then type_ = eye[900] runChoice('c')
        elseif tear ~= eye[900] and (tear ~= z + eye[1]) then
            pcall(teleport, scrSoul[menu].C_Runner[tear])
            sign[tear] = 1
            if gg.isVisible(true) then
            gg.setVisible(false)
            end
            cordlist('s')
        end
    elseif type_ == "s" then
        for i, v in ipairs(scrSoul) do
            if scrSoul[i][1] == SkidLocation then
                menu = i  
                for d, u in ipairs(scrSoul[menu].S_Runner) do
                    if d < 10 then b = 0 else b = "" end
                        if sign[d] == eye[900] then sign[d] = "" elseif sign[d] == 1 then sign[d] = "✳️" end
                        cordls[d] = "- Star Location: " .. "-[ " .. b .. d .. " ]-" .. sign[d]
                        z = d
                    end
                break
            end
        end
        table.insert(cordls, back[1])
        tear = gg.choice(cordls, nil, header)
        if tear == eye[z + 1] then type_ = eye[900] runChoice('s')
        elseif tear ~= eye[900] and (tear ~= z + eye[1]) then
            teleport(scrSoul[menu].S_Runner[tear], true)
            sign[tear] = 1
            if gg.isVisible(true) then
            gg.setVisible(false)
            end
            gg.sleep(3500)
            cordlist('c')
        end
    end
end
function burner()
    signs.burn = kj.switch(bootloader + liboffsets.candles, '-721215457 D', '872415464 D', 'Burning')
    if kj.isFrozen(flowers[32].address) then
        if configs.mumu then
            gg.removeListItems(candles)
        end
        gg.removeListItems(flowers)
    else
        if configs.mumu then
            gg.setValues(candles)
            gg.addListItems(candles)
        end
        gg.setValues(flowers)
        gg.addListItems(flowers)
    end
end
function wcharge()
 do
   do
    signs.wcharge = kj.freezeSwitch(anptr + anptroffsets.wcharge, '14 F', 'Wing Charge')
    kj.switch(bootloader + liboffsets.wcharge, '505729024 D', '505571328 D')
   end
 end
end
function configSign()
    do
      do
        if kj.getValue(bootloader + liboffsets.candles, 'D') == -721215457 then
            signs.burn = "  -〘 ✅ 〙"
            gg.setValues(flowers)
            gg.addListItems(flowers)
            if configs.mumu then
                gg.setValues(candles)
                gg.addListItems(candles)
            end
        end
      end
    end
     do
       do
        if kj.getValue(bootloader + liboffsets.wcharge, 'D') == 505729024 then
            signs.wcharge = "  -〘 ✅ 〙"
            uu = {
                {
                    address = anptr + anptroffsets.wcharge,
                    flags = kj.dT('F'),
                    value = 14,
                    freeze = true,
                }
            }
            gg.setValues(uu)
            gg.addListItems(uu)
        end
      end
    end
 end
function oobls(bto)
    getSkidLocat()
    STAY = 'oobls'
    if configs.awrob then
        rwind()
    end
    if _bto_ == nil then
        _bto_ = bto
    end
    if bto ~= nil then
        _bto_ = bto
    end
    local oBG = gg
    miniOOB = {}
        do
          do
            table.insert(miniOOB, 1, "[💾]Save Current Possition")
            table.insert(miniOOB, 2, "[🏃🏻‍♂️]Goto Saved Possition")
            if SkidLock == nil then
                SkidLock = SkidLocation
            end
          end
        end
          do
            do
             for i, v in pairs(scrSoul) do
                 if v[1] == SkidLocation then
                    for u, d in pairs(v.OOB_Goto.OOB_Goto_Name) do
                        table.insert(miniOOB, u .. ". " .. d)
                    end
                    break
                 end
             end
             table.insert(miniOOB, back[1])
             if SkidLock ~= SkidLocation or svpo == nil then
                SkidLock = SkidLocation
                miniOOB[2] = nil
                svpo = eye[922]
            end
          end
       end
    tear = oBG.choice(miniOOB, nil, header)
    if #miniOOB == 1 then
        bp = 3
    else
        bp = #miniOOB
    end
    if tear == bp then 
    load(_bto_ .. '()')()
    elseif tear == eye[1] then svpo = getPosition()
    zzz = "{" .. svpo[1] .. ', '.. svpo[2] .. ', ' .. svpo[3] .. "},"
    print(zzz)
    elseif tear == eye[2] then 
        pcall(teleport, svpo)
    elseif tear ~= eye[336] then
        getSkidLocat()
        for i, v in pairs(scrSoul) do
            if SkidLocation == v[1] then
                pcall(teleport, v.OOB_Goto.OOB_Goto_Cord[tear - eye[2]])
                break
            end
        end
    end
end
function getPosition()
    coords = {
        kj.getValue(anptr + anptroffsets.xpos, 'F'),
        kj.getValue(anptr + anptroffsets.ypos, 'F'),
        kj.getValue(anptr + anptroffsets.zpos, 'F'),
    }
    return coords
end
function sres()
    local srsG = gg
    def_width = kj.removePoint(kj.getValue(guiptr + gptoffsets.scrres + 1656, 'F'))
    def_height = kj.removePoint(kj.getValue(guiptr + gptoffsets.scrres + 1660, 'F'))
    tear = srsG.prompt({'[📸]Set screenshot resulotion\nChanging the graphics resets it\nWidth:', 'Height:'}, {def_width, def_height}, {'number', 'number'})
    if tear ~= nil then
        local uu = {
            {
                address = guiptr + gptoffsets.scrres,
                flags = gg.TYPE_FLOAT,
                freeze = true,
                value = tear[1],
                name = 'screenshot width',
            },
            {
                address = guiptr + gptoffsets.scrres + 4,
                flags = gg.TYPE_FLOAT,
                freeze = true,
                value = tear[2],
                name = 'screenshot height',
            },
        }
        if not pcall(srsG.setValues, uu) then
            gg.toast("Please type properly")
        end
    end
end
function srun_add()
    if star.trace ~= nil then 
        if star.trace >= star.limit then star.trace = star.limit else star.trace = star.trace + eye[1] end
        pcall(teleport, scrSoul[star.realm].S_Runner[star.trace])
        dontRemove = "By: Kiojeen"
    end
end
function srun_sub()
    if star.trace ~= nil then
        if star.trace <= 1 then star.trace = 1 else star.trace = star.trace - eye[1] end
        pcall(teleport, scrSoul[star.realm].S_Runner[star.trace])
        dontRemove = "By: Kiojeen"
    end 
end
function bwall(bdis)
    local xcord = kj.getValue(anptr + anptroffsets.xpos, 'F')
    local ycord = kj.getValue(anptr + anptroffsets.ypos, 'F')
    local zcord = kj.getValue(anptr + anptroffsets.zpos, 'F')
    local radin = kj.getValue(anptr + anptroffsets.rad, 'F')
    if pcall(teleport, {xcord + bdis * math.sin(radin), ycord, zcord + bdis * math.cos(radin)}) then
        gg.setVisible(false)
    end
  end
function magic()
    sMagics = {}
    sMagics.sign = {}
    sMagics.spell = {}
    sMagics.id = {}
    sMagics.type = {} 
    local gXG = gg 
    STAY = 'magic'
    tear = gg.choice(yellow[6].content, nil, "‍[️🧙]️Magic: Only three are visible at a time")
    if tear == #yellow[6].content then yellowTears()
    elseif tear == #yellow[6].content - 2 then 
        capeauto = kj.toggler(capeauto)
    elseif tear == #yellow[6].content - 1 then
        for d = 1, 3, 1 do
            for i = 1, sockets do
                setspell(0, i)
            end
        end dontRemove = "BY: Kiojeen" 
    elseif tear == 1 or tear == 2 then
        if tear == 1 then spark = 360
        elseif tear == 2 then spark = 0
        end
        msocket = {}
        for i = 1, sockets do
            cs = kj.getValue(anptr + anptroffsets.magic + i * distances.magx - distances.magx, 'D')
            for d, u in ipairs(magics) do
                for a, b in ipairs(magics[d].content) do
                    if magics[d].content[a][2] == cs then
                        sMagics.sign[i] = "   " ..  magics[d][1] .. magics[d].content[a][1]
                    end
                end
            end
            if sMagics.sign[i] == nil then
                sMagics.sign[i] = "   None"
            end
            if i < 10 then o = 0 else o = '' end
            msocket[i] = "[🔮]Spell [" .. o .. i .. "]: " .. sMagics.sign[i]
        end
        table.insert(msocket, "[❌]Remove All")
        table.insert(msocket, back[1])
        tear = gXG.choice(msocket, nil, "‍[️🧙]️Magic: Only three are visible at a time")
        if tear == eye[sockets + eye[1]] then
            for d = 1, 3 do
                for i, v in ipairs(msocket) do
                    setspell(0, i)
                end
            end dontRemove = "BY: Kiojeen" 
        elseif tear == eye[sockets + eye[2]] then magic()
        elseif tear ~= eye[65] then
            socket = tear 
            local fhdr = tear
            for i, v in ipairs(magics) do
                sMagics.type[i] = magics[i][1] .. magics[i][2]
            end
            table.insert(sMagics.type, "[❌]Remove")
            tear = gXG.choice(sMagics.type, nil, "[🔮]Spell [" .. fhdr .. "]:" .. sMagics.sign[fhdr])
            if tear == eye[sockets + eye[1]] then 
                for i = 
