local table_insert = table.insert
local GetConVar = GetConVar
local tostring = tostring
local CreateConVar = CreateConVar
local CreateClientConVar = CreateClientConVar
local defDisplayClr = Color( 255, 136, 0 )

-- Will be used for presets
_LAMBDAPLAYERSCONVARS = {}

if CLIENT then
    _LAMBDAConVarNames = {}
    _LAMBDAConVarSettings = {}
elseif SERVER then
    _LAMBDAEntLimits = {}
end

-- A multi purpose function for both client and server convars
function CreateLambdaConvar( name, val, shouldsave, isclient, userinfo, desc, min, max, settingstbl )
    isclient = isclient or false
    if isclient and SERVER then return end

    local strVar = tostring( val )
    if !_LAMBDAPLAYERSCONVARS[ name ] then _LAMBDAPLAYERSCONVARS[ name ] = strVar end

    local convar = GetConVar( name )
    if !convar then
        shouldsave = shouldsave or true
        if isclient then
            convar = CreateClientConVar( name, strVar, shouldsave, userinfo, desc, min, max )
        else
            convar = CreateConVar( name, strVar, ( shouldsave and ( FCVAR_ARCHIVE + FCVAR_REPLICATED ) or ( FCVAR_NONE + FCVAR_REPLICATED ) ), desc, min, max )
        end
    end

    if CLIENT and settingstbl and !_LAMBDAConVarNames[ name ] then
        settingstbl.convar = name
        settingstbl.min = min
        settingstbl.default = val
        settingstbl.isclient = isclient
        settingstbl.desc = ( isclient and "Client-Side | " or "Server-Side | " ) .. desc .. ( isclient and "" or "\nConVar: " .. name )
        settingstbl.max = max

        _LAMBDAConVarNames[ name ] = true
        table_insert( _LAMBDAConVarSettings, settingstbl )
    end

    return convar
end

local function AddSourceConVarToSettings( cvarname, desc, settingstbl )
    if CLIENT and settingstbl and !_LAMBDAConVarNames[ cvarname ] then
        settingstbl.convar = cvarname
        settingstbl.isclient = false
        settingstbl.desc = "Server-Side | " .. desc .. "\nConVar: " .. cvarname

        _LAMBDAConVarNames[ cvarname ] = true
        table_insert( _LAMBDAConVarSettings, settingstbl )
    end
end

function CreateLambdaColorConvar( name, defaultcolor, isclient, userinfo, desc, settingstbl )
    local nameR = name .. "_r"
    local nameG = name .. "_g"
    local nameB = name .. "_b"

    local redCvar = GetConVar( nameR )
    if !redCvar then redCvar = CreateLambdaConvar( nameR, defaultcolor.r, true, isclient, userinfo, desc, 0, 255, nil ) end

    local greenCvar = GetConVar( nameG )
    if !greenCvar then greenCvar = CreateLambdaConvar( nameG, defaultcolor.r, true, isclient, userinfo, desc, 0, 255, nil ) end

    local blueCvar = GetConVar( nameB )
    if !blueCvar then blueCvar = CreateLambdaConvar( nameB, defaultcolor.r, true, isclient, userinfo, desc, 0, 255, nil ) end

    if CLIENT and !_LAMBDAConVarNames[ name ] then
        settingstbl.red = nameR
        settingstbl.green = nameG
        settingstbl.blue = nameB

        settingstbl.default = "Red = " .. tostring( defaultcolor.r ) .. " | " .. "Green = " .. tostring( defaultcolor.g ) .. " | " .. "Blue = " .. tostring( defaultcolor.b )
        settingstbl.type = "Color"

        settingstbl.isclient = isclient
        settingstbl.desc = ( isclient and "Client-Side | " or "Server-Side | " ) .. desc .. ( isclient and "" or "\nConVar: " .. name )
        settingstbl.max = max

        _LAMBDAConVarNames[ name ] = true
        table_insert( _LAMBDAConVarSettings, settingstbl )
    end

    return redCvar, greenCvar, blueCvar
end

-- These Convar Functions are capable of creating spawnmenu settings automatically.

---------- Valid Table options ----------
-- type | String | Must be one of the following: Slider, Bool, Text, Combo. For Colors, you must use CreateLambdaColorConvar()
-- name | String | Pretty name
-- decimals | Number | Slider only! How much decimals the slider should have
-- category | String | The Lambda Settings category to place the convar into. Will create one if one doesn't exist already
-- options | Table | Combo only! A table with its keys being the text and values being the data

-- Lambda Ragdolls
CreateLambdaConvar( "lambdaplayers_corpsecleanuptime", 15, true, true, false, "The amount of time before a Lambda corpse is removed. Set to zero to disable this.", 0, 180, { type = "Slider", name = "Corpse Cleanup Time", decimals = 0, category = "Ragdoll Settings" } )
CreateLambdaConvar( "lambdaplayers_corpsecleanupeffect", 0, true, true, false, "If Lambda corpses should have a disintegration effect before they are removed.", 0, 1, { type = "Bool", name = "Corpse Disintegration Effect", category = "Ragdoll Settings" } )
CreateLambdaConvar( "lambdaplayers_removecorpseonrespawn", 0, true, true, false, "If Lambda corpses should be removed when their owner respawns.", 0, 1, { type = "Bool", name = "Remove Corpse On Respawn", category = "Ragdoll Settings" } )
--
CreateLambdaConvar( "lambdaplayers_lambda_serversideragdolls", 0, true, false, false, "If Lambda corpses should spawn serverside. This will allow other addons to interact with them, but you may lose some performance because of this!", 0, 1, { type = "Bool", name = "Server-Side Ragdolls", category = "Ragdoll Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_serversideragdollcleanuptime", 15, true, false, false, "The amount of time before a Lambda corpse is removed. Set to zero to disable this.", 0, 180, { type = "Slider", name = "Corpse Cleanup Time", decimals = 0, category = "Ragdoll Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_serversideragdollcleanupeffect", 0, true, false, false, "If Lambda corpses should have a disintegration effect before they are removed.", 0, 1, { type = "Bool", name = "Corpse Disintegration Effect", category = "Ragdoll Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_serversideremovecorpseonrespawn", 0, true, false, false, "If Lambda corpses should be removed when their owner respawns.", 0, 1, { type = "Bool", name = "Remove Corpse On Respawn", category = "Ragdoll Settings" } )
--
CreateLambdaConvar( "lambdaplayers_dropweaponondeath", 1, true, true, false, "If Lambda Player should drop a clientsided prop of their weapon they died with.", 0, 1, { type = "Bool", name = "Drop Weapon On Death", category = "Ragdoll Settings" } )
CreateLambdaConvar( "lambdaplayers_allowweaponentdrop", 0, true, false, false, "If Lambda Players should drop an entity if their weapon has one set.", 0, 1, { type = "Bool", name = "Allow Weapon Entity Drop", category = "Ragdoll Settings" } )

-- View Shots
CreateLambdaConvar( "lambdaplayers_viewshots_enabled", 0, true, false, false, "If Lambda Players are allowed to occasionally take a screenshot of their current eye view and save it as a picture to players. The pictures are saved in 'garrysmod/data/lambdaplayers/viewshots/' folder path", 0, 1, { type = "Bool", name = "Enable View Shots", category = "Utilities" } )
CreateLambdaConvar( "lambdaplayers_viewshots_chance", 50, true, false, false, "The chance of the Lambda Player to request a view shot of their view. Higher the value, bigger the chance of it happening", 1, 100, { type = "Slider", decimals = 0, name = "View Shot Chance", category = "Utilities" } )
CreateLambdaConvar( "lambdaplayers_viewshots_allowforyou", 1, true, true, false, "Disable this if you don't want view shots to happen on your end", 0, 1, { type = "Bool", name = "Allow View Shots For You", category = "Utilities" } )
CreateLambdaConvar( "lambdaplayers_viewshots_viewfov", 90, true, true, false, "The field of view of the view shot", 54, 130, { type = "Slider", decimals = 0, name = "View Shot FOV", category = "Utilities" } )
CreateLambdaConvar( "lambdaplayers_viewshots_saveaspng", 0, true, true, false, "If the view shot should be saved in the .png format, making it better quality but bigger in file size", 0, 1, { type = "Bool", name = "Save View Shots In PNG", category = "Utilities" } )
--

-- Other Convars
CreateLambdaConvar( "lambdaplayers_uiscale", 0, true, true, false, "How much to scale UI such as Voice popups, name pop ups, ect.", ( CLIENT and -ScrW() or 1 ), ( CLIENT and ScrW() or 1 ), { type = "Slider", name = "UI Scale", decimals = 1, category = "Misc" } )
CreateLambdaConvar( "lambdaplayers_useplayermodelcolorasdisplaycolor", 0, true, true, true, "If Lambda Player's Playermodel Color should be its Display Color. This has priority over the Display Color below", 0, 1, { type = "Bool", name = "Playermodel Color As Display Color", category = "Misc" } )
CreateLambdaColorConvar( "lambdaplayers_displaycolor", defDisplayClr, true, true, "The display color to use for Name Display and others", { name = "Display Color", category = "Misc" } )
CreateLambdaConvar( "lambdaplayers_randomizepathingcost", 0, true, false, false, "Randomizes Pathfinding in a way that will make Lambdas try different approaches to reaching their destination rather than finding the fastest and closest route", 0, 1, { type = "Bool", name = "Randomize PathFinding Cost", category = "Misc" } )
CreateLambdaConvar( "lambdaplayers_randomizepathingcost_min", 0.8, true, false, false, "Minimum value to how much Lambdas can scale their pathing cost.", 0.1, 20.0, { type = "Slider", decimals = 1, name = "Min Random Cost Scale", category = "Misc" } )
CreateLambdaConvar( "lambdaplayers_randomizepathingcost_max", 1.2, true, false, false, "Maximum value to how much Lambdas can scale their pathing cost.", 0.1, 20.0, { type = "Slider", decimals = 1, name = "Max Random Cost Scale", category = "Misc" } )
CreateLambdaConvar( "lambdaplayers_animatedpfpsprayframerate", 10, true, true, false, "The frame rate of animated Spray VTFs and animated Profile Picture VTFs", 1, 60, { type = "Slider", decimals = 0, name = "Animated VTF Frame Rate", category = "Misc" } )

CreateLambdaConvar( "lambdaplayers_weapons_bugbait_antlionhealth", 50, true, false, false, "Determines the amount of health the Lambda Antlions will spawn with. Set to zero for invincible", 0, 1000, { type = "Slider", decimals = 0, name = "Bugbait - Antlion Health", category = "Weapon Utilities" } )
CreateLambdaConvar( "lambdaplayers_weapons_bugbait_antliondamage", 15, true, false, false, "Determines the amount of damage the Lambda Antlions deal to their targets", 0, 1000, { type = "Slider", decimals = 0, name = "Bugbait - Antlion Damage", category = "Weapon Utilities" } )
CreateLambdaConvar( "lambdaplayers_weapons_bugbait_antlionlimit", 4, true, false, false, "Determines the amount of Lambda Antlions Lambdas with bugbaits are allowed have. Set to zero for unlimited amount", 0, 15, { type = "Slider", decimals = 0, name = "Bugbait - Antlion Limit", category = "Weapon Utilities" } )
--

-- Playermodel Related
CreateLambdaConvar( "lambdaplayers_lambda_allowrandomaddonsmodels", 0, true, false, false, "If Lambda Players can use random addon playermodels", 0, 1, { type = "Bool", name = "Addon Playermodels", category = "Playermodels" } )
CreateLambdaConvar( "lambdaplayers_lambda_onlyaddonmodels", 0, true, false, false, "If Lambda Players should only use playermodels that are from addons. Addon Playermodels should be enabled to work.", 0, 1, { type = "Bool", name = "Only Addon Playermodels", category = "Playermodels" } )
CreateLambdaConvar( "lambdaplayers_lambda_forceplayermodel", "", true, false, false, "The path of the playermodel the next spawned Lambda Player will use. Make empty to disable", 0, 1, { type = "Text", name = "Force Playermodel", category = "Playermodels" } )
CreateLambdaConvar( "lambdaplayers_lambda_switchplymdlondeath", "0", true, false, false, "The chance that the Lambda Player will change its playermodel after respawning. Doesn't affect Lambda Profiles. Set to 0 to disable", 0, 100, { type = "Slider", decimals = 0, name = "Change Playermodel On Respawn Chance", category = "Playermodels" } )
CreateLambdaConvar( "lambdaplayers_lambda_allowrandomskinsandbodygroups", 1, true, false, false, "If Lambda Players can have their model's skins and bodygroups randomized", 0, 1, { type = "Bool", name = "Random Skins & Bodygroups", category = "Playermodels" } )
CreateLambdaConvar( "lambdaplayers_lambda_enablemdlbodygroupsets", 1, true, false, false, "If Lambda Players that use a playermodel with bodygroup sets be spawned with them instead of randomized ones", 0, 1, { type = "Bool", name = "Enable Model Bodygroup Sets", category = "Playermodels" } )
CreateLambdaConvar( "lambdaplayers_lambda_enablemdlspecificvps", 1, true, false, false, "If Lambda Players that use a playermodel with specific voice profile be forced to use it on spawn", 0, 1, { type = "Bool", name = "Enable Model-Specific VPs", category = "Playermodels" } )

-- Lambda Player Server Convars
CreateLambdaConvar( "lambdaplayers_lambda_respawntime", 3, true, false, false, "The amount of seconds Lambda Player will take before respawning after dying.", 0.1, 30, { type = "Slider", decimals = 1, name = "Respawn Time", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_respawnatplayerspawns", 0, true, false, false, "If Lambda Players should respawn at player spawn points", 0, 1, { type = "Bool", name = "Respawn At Player Spawns", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_dontrespawnifspeaking", 1, true, false, false, "If Lambda Players should wait for their currently spoken voiceline to finish before respawning.", 0, 1, { type = "Bool", name = "Don't Respawn If Speaking", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_realisticfalldamage", 0, true, false, false, "If Lambda Players should take fall damage similar to Realistic Fall Damage", 0, 1, { type = "Bool", name = "Realistic Fall Damage", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_allownoclip", 0, true, false, false, "If Lambda Players are allowed to Noclip", 0, 1, { type = "Bool", name = "Allow Noclip", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_onlynoclipifcantreach", 0, true, false, false, "If Lambda Players should only use Noclip if the place they're going to is unreachable on foot", 0, 1, { type = "Bool", name = "Only Noclip If Unreachable", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_noclipspeed", 500, true, false, false, "The maximum speed Lambda Players are allowed to have noclip with", 100, 2000, { type = "Slider", decimals = 0, name = "Noclip Speed", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_allowkillbind", 0, true, false, false, "If Lambda Players are allowed to randomly use their Killbind", 0, 1, { type = "Bool", name = "Allow Killbind", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_armorfeedback", 0, true, false, false, "If Lambda Players with armor should emit sparks and play sound when getting damaged", 0, 1, { type = "Bool", name = "Armor Damage Feedback", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_ablativearmor", 0, true, false, false, "If Lambda Player's armor should fully absorb the taken damage instead of decreasing it", 0, 1, { type = "Bool", name = "Ablative Armor", category = "Lambda Server Settings" } )

CreateLambdaConvar( "lambdaplayers_lambda_drowntime", 15, true, false, false, "The time Lambda Players can be fully submerged in water before they start drowning. Set to zero to disable drowning", 0, 120, { type = "Slider", decimals = 1, name = "Drown Time", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_lethalwaters", 0, true, false, false, "If Lambda Players should die after few seconds of submerging into any water. Useful for maps with water where players can't get out with normal ways", 0, 1, { type = "Bool", name = "Lethal Waters", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_singleplayerthinkdelay", 0, true, false, false, "The amount of seconds Lambda Players will execute their next Think. 0.1 is a good value. Increasing this will increase performance at the cost of delays and decreasing this may decrease performance but have less delays. This only applies to singleplayer since multiplayer automatically adjusts think time", 0, 0.24, { type = "Slider", decimals = 2, name = "Think Delay", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_physupdatetime", 0.33, true, false, false, "The time it takes for Lambda Player to update its physics object. Lower the value if you have problems with projectiles not colliding with them", 0, 1, { type = "Slider", decimals = 2, name = "Physics Update Time", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_noplycollisions", 0, true, false, false, "If Lambda Players can pass through players (Useful in small corridors/areas)", 0, 1, { type = "Bool", name = "Disable Player Collisions", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_infwanderdistance", 0, true, false, false, "If Lambda Players should be able to walk anywhere on the navmesh instead of only walking within 1500 source units", 0, 1, { type = "Bool", name = "Unlimited Walk Distance", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_avoid", 1, true, false, false, "If enabled, Lambdas will try their best to avoid obstacles. Note: This will decrease performance", 0, 1, { type = "Bool", name = "Obstacle Avoiding", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_obeynavmeshattributes", 1, true, false, false, "If Lambda Players should obey navmesh attributes such as, Avoid, Walk, Run, Jump, and Crouch", 0, 1, { type = "Bool", name = "Obey Navigation Mesh", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_panicanimations", 0, true, false, false, "If panicking Lambda Players should use Panic Animations", 0, 1, { type = "Bool", name = "Use Panic Animations", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_profileusechance", 0, true, false, false, "The chance a Lambda will spawn with a profile that isn't being used. Normally profile Lambda Players only spawn when a Lambda Player has the profile's name. This chance can make profiles appear more often. Do not confuse this with Voice Profiles!", 0, 100, { type = "Slider", decimals = 0, name = "Profile Use Chance", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_voiceprofileusechance", 0, true, false, false, "The chance a Lambda Player will use a random Voice Profile if one exists. Set to 0 to disable", 0, 100, { type = "Slider", decimals = 0, name = "VP Use Chance", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_textprofileusechance", 0, true, false, false, "The chance a Lambda Player will use a random Text Profile if one exists. Set to 0 to disable", 0, 100, { type = "Slider", decimals = 0, name = "TP Use Chance", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_spawnhealth", 100, true, false, false, "The amount of health Lambda Players will spawn with", 1, 10000, { type = "Slider", decimals = 0, name = "Spawning Health", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_maxhealth", 100, true, false, false, "Max Lamda Player Health", 1, 10000, { type = "Slider", decimals = 0, name = "Max Health", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_spawnarmor", 0, true, false, false, "The amount of armor Lambda Players will spawn with", 0, 10000, { type = "Slider", decimals = 0, name = "Spawning Armor", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_maxarmor", 100, true, false, false, "Max Lambda Player Armor", 0, 10000, { type = "Slider", decimals = 0, name = "Max Armor", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_runspeed", 400, true, false, false, "The sprinting speed the next spawned Lambda Player will have", 100, 1500, { type = "Slider", decimals = 0, name = "Sprinting Speed", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_walkspeed", 200, true, false, false, "The running speed the next spawned Lambda Player will have", 100, 1500, { type = "Slider", decimals = 0, name = "Running Speed", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_slowwalkspeed", 100, true, false, false, "The walking speed the next spawned Lambda Player will have", 20, 1000, { type = "Slider", decimals = 0, name = "Walking Speed", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_crouchspeed", 60, true, false, false, "The crouched walking speed the next spawned Lambda Player will have", 20, 1000, { type = "Slider", decimals = 0, name = "Crouch Walking Speed", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_jumpheight", 48, true, false, false, "The jump height the next spawned Lambda Player will have", 0, 500, { type = "Slider", decimals = 0, name = "Jump Height", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_nostepsndspeed", 125, true, false, false, "If Lambda Player's movement speed is below this value, their footsteps will be silent. Set to zero to disable", 0, 500, { type = "Slider", decimals = 0, name = "No Footstep Sound Speed", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_overridegamemodehooks", 1, true, false, false, "If the addon is allowed to override the following GAMEMODE hooks to support Lambda Players: GM:PlayerDeath() GM:PlayerStartVoice() GM:PlayerEndVoice() GM:OnNPCKilled() GM:CreateEntityRagdoll() Default SandBox Scoreboard : Changing this requires you to restart the server/game for the changes to apply!", 0, 1, { type = "Bool", name = "Override Gamemode Hooks", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_callonnpckilledhook", 0, true, false, false, "If killed Lambda Players should call the OnNPCKilled hook. Best used with the Override Gamemode Hooks option!", 0, 1, { type = "Bool", name = "Call OnNPCKilled Hook On Death", category = "Lambda Server Settings" } )
CreateLambdaConvar( "lambdaplayers_lambda_overridedeathnoticehook", 1, true, false, false, "If the addon is allowed to override the death notice hooks to support Lambda Players. This get rid of duplicate death notice appearing after Lambda Player either dies or kills someone : Changing this requires the Override Gamemode Hooks option to be enabled and you to restart the server/game for the changes to apply!", 0, 1, { type = "Bool", name = "Override Death Notice Hooks", category = "Lambda Server Settings" } )
--

-- Combat Convars
CreateLambdaConvar( "lambdaplayers_combat_allowtargetyou", 1, true, true, true, "If Lambda Players are allowed to attack you", 0, 1, { type = "Bool", name = "Target You", category = "Combat" } )
CreateLambdaConvar( "lambdaplayers_combat_ignorefriendlynpcs", 0, true, false, false, "If Lambda Players shouldn't target NPCs and nextbots that are allied with them", 0, 1, { type = "Bool", name = "Ignore Friendly NPCs", category = "Combat" } )
CreateLambdaConvar( "lambdaplayers_combat_retreatonlowhealth", 1, true, false, false, "If Lambda Players should start retreating if they are low on health, or witnessed/committed RDM", 0, 1, { type = "Bool", name = "Retreat On Low Health", category = "Combat" } )
CreateLambdaConvar( "lambdaplayers_combat_spawnmedkits", 1, true, false, false, "If Lambda Players are allowed to spawn medkits to heal themselves when low on health. Make sure that 'Allow Entity Spawning' setting is enabled", 0 , 1, { type = "Bool", name = "Spawn Medkits", category = "Combat" } )
CreateLambdaConvar( "lambdaplayers_combat_spawnbatteries", 1, true, false, false, "If Lambda Players are allowed to spawn armor batteries to themselves when low on armor. Make sure that 'Allow Entity Spawning' setting is enabled", 0 , 1, { type = "Bool", name = "Spawn Armor Batteries", category = "Combat" } )
CreateLambdaConvar( "lambdaplayers_combat_spawnbehavior", 0, true, false, false, "What should the Lambda Player do after spawning. 0 - Do nothing, 1 - Attack a random targetable real player, 2 - Attack a random targetable NPC or nextbot, 3 - Attack a random targetable entity", 0, 3, { type = "Slider", decimals = 0, name = "Spawn Behavior Modifier", category = "Combat" } )
CreateLambdaConvar( "lambdaplayers_combat_spawnbehavior_initialspawnonly", 1, true, false, false, "If the Spawn Behavior Modifier should only apply on Lambda Player's initial spawn", 0, 1, { type = "Bool", name = "Apply Spawn Behavior On Initial Spawn Only", category = "Combat" } )
CreateLambdaConvar( "lambdaplayers_combat_spawnbehavior_usedistance", 0, true, false, false, "If the Spawn Behavior Modifier should pick the closest target instead of random ones", 0, 1, { type = "Bool", name = "Spawn Behavior Uses Distance", category = "Combat" } )
CreateLambdaConvar( "lambdaplayers_combat_dontrdmlambdas", 0, true, false, false, "If Lambda Players shouldn't randomly start attacking other Lambda Players. They'll still get in fights if directly damaged or by other conditions", 0, 1, { type = "Bool", name = "Don't RDM Other Lambdas", category = "Combat" } )
CreateLambdaConvar( "lambdaplayers_combat_usejumpsincombat", 1, true, false, false, "If enabled, Lambda Players that are in combat or are currently retreating will sometimes jump to either boost speed or avoid enemy's attacks", 0, 1, { type = "Bool", name = "Allow Jumping In Combat Or While Retreating", category = "Combat" } )
CreateLambdaConvar( "lambdaplayers_combat_useweapononretreat", 1, true, false, false, "If Lambda Players are allowed to use weapons when they're panicking or retreating from the enemy", 0, 1, { type = "Bool", name = "Use Weapons While Retreating", category = "Combat" } )
CreateLambdaConvar( "lambdaplayers_combat_mightyfootengaged", 1, true, false, false, "If Lambda Players are allowed use the kick feature from the mighty foot engaged addon. Requires the addon to be subscribed to work", 0, 1, { type = "Bool", name = "Allow Mighty Foot Engaging", category = "Combat" } )

CreateLambdaConvar( "lambdaplayers_fear_allowsanics", 1, true, false, false, "If Lambda Players should run away from Sanic-based Nextbots?\nNote that some will require manual addition via a panel due to how they're coded", 0, 1, { type = "Bool", name = "Fear Sanic Nextbots", category = "Combat" } )
CreateLambdaConvar( "lambdaplayers_fear_alldrgnextbots", 0, true, false, false, "If Lambda Players should run away from any DRGBase Nextbots", 0, 1, { type = "Bool", name = "Fear All DRGBase Nextbots", category = "Combat" } )
CreateLambdaConvar( "lambdaplayers_fear_detectrange", 2000, true, false, false, "How close should the target be to be detectable by Lambda Players", 0, 10000, { type = "Slider", decimals = 0, name = "Fear Spot Distance", category = "Combat" } )

-- Weapon Convars
CreateLambdaConvar( "lambdaplayers_combat_weapondmgmultiplier_players", 1, true, false, false, "Multiplies the damage that Lambda Player deals with its weapon to real players", 0, 100, { type = "Slider", decimals = 2, name = "Weapon Damage Scale - Players", category = "Lambda Weapons" } )
CreateLambdaConvar( "lambdaplayers_combat_weapondmgmultiplier_lambdas", 1, true, false, false, "Multiplies the damage that Lambda Player deals with its weapon to other Lambda Players", 0, 100, { type = "Slider", decimals = 2, name = "Weapon Damage Scale - Lambda Players", category = "Lambda Weapons" } )
CreateLambdaConvar( "lambdaplayers_combat_weapondmgmultiplier_misc", 1, true, false, false, "Multiplies the damage that Lambda Player deals with its weapon to NPCs, Nextbots, and other types of entities", 0, 100, { type = "Slider", decimals = 2, name = "Weapon Damage Scale - Misc.", category = "Lambda Weapons" } )
CreateLambdaConvar( "lambdaplayers_combat_allownadeusage", 0, true, false, false, "If Lambda Players are allowed to use and throw quick nades at their enemy.", 0, 1, { type = "Bool", name = "Allow Quick Nade Usage", category = "Lambda Weapons" } )
--

-- Lambda Player Convars
CreateLambdaConvar( "lambdaplayers_lambda_shouldrespawn", 0, true, true, true, "If Lambda Players should respawn when they die. Note: Changing this will only apply to newly spawned Lambda Players", 0, 1, { type = "Bool", name = "Respawn", category = "Lambda Player Settings" } )
CreateLambdaConvar( "lambdaplayers_displayarmor", 0, true, true, false, "If Lambda Player's current armor should be displayed when we're looking at it and it's above zero", 0, 1, { type = "Bool", name = "Display Armor", category = "Lambda Player Settings" } )
CreateLambdaConvar( "lambdaplayers_drawflashlights", 1, true, true, false, "If Lambda Player flashlights should be rendered", 0, 1, { type = "Bool", name = "Draw Flashlights", category = "Lambda Player Settings" } )
---- lambdaplayers_lambda_voiceprofile Located in shared/voiceprofiles.lua
---- lambdaplayers_lambda_spawnweapon  Located in shared/globals.lua due to code order
--

-- Building Convars
CreateLambdaConvar( "lambdaplayers_building_caneditworld", 1, true, false, false, "If the Lambda Players are allowed to use the Physgun and Toolgun on world entities", 0, 1, { type = "Bool", name = "Allow Edit World", category = "Building" } )
CreateLambdaConvar( "lambdaplayers_building_caneditnonworld", 1, true, false, false, "If the Lambda Players are allowed to use the Physgun and Toolgun on non world entities. Typically player spawned entities and addon spawned entities", 0, 1, { type = "Bool", name = "Allow Edit Non World", category = "Building" } )
CreateLambdaConvar( "lambdaplayers_building_canedityourents", 1, true, true, true, "If the Lambda Players are allowed to use the Physgun and Toolgun on your props and entities", 0, 1, { type = "Bool", name = "Allow Edit Your Entities", category = "Building" } )
CreateLambdaConvar( "lambdaplayers_lambda_allowphysgunpickup", 1, true, false, false, "If Lambda Players are able to pickup things with their physgun", 0, 1, { type = "Bool", name = "Allow Physgun Pickup", category = "Building" } )
CreateLambdaConvar( "lambdaplayers_building_freezeprops", 0, true, false, false, "If props spawned by Lambda Players should spawn with either of these effects that lead them to being frozen: Spawn Frozen, Spawn unfrozen and freeze 10 seconds later. This can help with performance", 0, 1, { type = "Bool", name = "Handle Freezing Props", category = "Building" } )
CreateLambdaConvar( "lambdaplayers_building_alwaysfreezelargeprops", 0, true, false, false, "If large props spawned by Lambda Players should always spawn frozen. This can help with performance", 0, 1, { type = "Bool", name = "Freeze Large Props", category = "Building" } )
CreateLambdaConvar( "lambdaplayers_building_cleanupondeath", 0, true, false, false, "If entities spawned by a respawning Lambda Player should be cleaned up after their death. This might help with performance", 0, 1, { type = "Bool", name = "Cleanup On Death", category = "Building" } )
--

-- Voice Related Convars
CreateLambdaConvar( "lambdaplayers_voice_globalvoice", 0, true, true, false, "If the Lambda Player voices should be heard globally", 0, 1, { type = "Bool", name = "Global Voices", category = "Voice Options" } )
CreateLambdaConvar( "lambdaplayers_voice_voicevolume", 1, true, true, false, "The volume of the Lambda Player voices", 0, 10, { type = "Slider", name = "Voice Volume", decimals = 2, category = "Voice Options" } )
CreateLambdaConvar( "lambdaplayers_voice_voicedistance", 300, true, true, false, "The distance the Lambda Player can be clearly heard from", 0, 1000, { type = "Slider", decimals = 0, name = "Voice Distance", category = "Voice Options" } )
CreateLambdaConvar( "lambdaplayers_voice_voicepitchmax", 100, true, false, false, "The highest pitch a Lambda Voice can get", 100, 255, { type = "Slider", decimals = 0, name = "Voice Pitch Max", category = "Voice Options" } )
CreateLambdaConvar( "lambdaplayers_voice_voicepitchmin", 100, true, false, false, "The lowest pitch a Lambda Voice can get", 10, 100, { type = "Slider", decimals = 0, name = "Voice Pitch Min", category = "Voice Options" } )
CreateLambdaConvar( "lambdaplayers_voice_talklimit", 0, true, true, false, "The amount of Lambda Players that can speak at a time. 0 for infinite", 0, 20, { type = "Slider", decimals = 0, name = "Speak Limit", category = "Voice Options" } )
CreateLambdaConvar( "lambdaplayers_voice_slightdelay", 1, true, false, false, "If there should be a slight random delay before the Lambda Player starts speaking to simulate reaction times", 0, 1, { type = "Bool", name = "Slight Delay Before Playing", category = "Voice Options" } )
CreateLambdaConvar( "lambdaplayers_voice_warnvoicestereo", 0, true, true, false, "If console should warn you about voice lines that have stereo channels", 0, 1, { type = "Bool", name = "Warn Stereo Voices", category = "Voice Options" } )
CreateLambdaConvar( "lambdaplayers_voice_alwaysplaydeathsnds", 0, true, false, false, "If Lambda Players should always play their death sounds instead of it being based on their voice chance. Keep in mind that this won't override their death text lines!", 0, 1, { type = "Bool", name = "Always Play Death Voicelines", category = "Voice Options" } )
CreateLambdaConvar( "lambdaplayers_voice_mergeaddonvoicelines", 1, true, false, false, "If custom voice lines added by addons should be included. Make sure you update Lambda Data after you change this!", 0, 1, { type = "Bool", name = "Include Addon Voicelines", category = "Voice Options" } )
CreateLambdaConvar( "lambdaplayers_voice_voiceprofilefallback", 1, true, false, false, "If Lambda Player's voice profile doesn't have a voice type to play, should they fallback to the standart one instead?", 0, 1, { type = "Bool", name = "Voice Profile No Voice Type Fallback", category = "Voice Options" } )
CreateLambdaConvar( "lambdaplayers_voice_voicepopups", 1, true, true, false, "If Lambda Players who are speaking should have a Voice Popup", 0, 1, { type = "Bool", name = "Draw Voice Popups", category = "Voice Options" } )
CreateLambdaConvar( "lambdaplayers_voice_voicepopupoffset_x", 0, true, true, false, "The offset position of the voice popups on the X axis of your screen", ( CLIENT and -ScrW() or -1 ), ( CLIENT and ScrW() or 1 ), { type = "Slider", decimals = 0, name = "Voice Popup X Offset", category = "Voice Options" } )
CreateLambdaConvar( "lambdaplayers_voice_voicepopupoffset_y", 0, true, true, false, "The offset position of the voice popups on the Y axis of your screen", ( CLIENT and -ScrH() or -1 ), ( CLIENT and ScrH() or 1 ), { type = "Slider", decimals = 0, name = "Voice Popup Y Offset", category = "Voice Options" } )
CreateLambdaColorConvar( "lambdaplayers_voice_voicepopupcolor", Color( 0, 255, 0 ), true, true, "The display color of the Lambda voice popup", { name = "Voice Popup Color", category = "Voice Options" } )
--

-- Text Chat Convars --
CreateLambdaConvar( "lambdaplayers_text_enabled", 1, true, false, false, "If Lambda Players are allowed to use text chat to communicate with others.", 0, 1, { type = "Bool", name = "Enable Text Chatting", category = "Text Chat Options" } )
CreateLambdaConvar( "lambdaplayers_text_usedefaultlines", 1, true, false, false, "If Lambda Players are able to use the default text chat lines. Disable this if you only want your custom text lines. Make sure you Update Lambda Data after changing this!", 0, 1, { type = "Bool", name = "Use Default Lines", category = "Text Chat Options" } )
CreateLambdaConvar( "lambdaplayers_text_useaddonlines", 1, true, false, false, "If Lambda Players are able to use text chat lines added by addons. Make sure you Update Lambda Data after changing this!", 0, 1, { type = "Bool", name = "Use Addon Lines", category = "Text Chat Options" } )
CreateLambdaConvar( "lambdaplayers_text_chatlimit", 1, true, false, false, "The amount of Lambda Players that can type a message at a time. Set to 0 for no limit", 0, 60, { type = "Slider", decimals = 0, name = "Chat Limit", category = "Text Chat Options" } )
CreateLambdaConvar( "lambdaplayers_text_markovgenerate", 0, true, false, false, "If Lambda text chat lines should be used to generate random text lines using a Markov Chain Generator", 0, 1, { type = "Bool", name = "Use Markov Chain Generator", category = "Text Chat Options" } )
CreateLambdaConvar( "lambdaplayers_text_saveoninterrupted", 0, true, false, false, "If enabled and Lambda Player is interrupted from texting, they will save it and later send it when problem is resolved", 0, 1, { type = "Bool", name = "Save Text On Interrupt", category = "Text Chat Options" } )
CreateLambdaConvar( "lambdaplayers_text_allowimglinks", 1, true, false, false, "If Lambda Players are allowed to send text lines that contain links to images and GIFs", 0, 1, { type = "Bool", name = "Allow Image Links", category = "Text Chat Options" } )
CreateLambdaConvar( "lambdaplayers_text_typenameonrespond", 1, true, false, false, "If Lambda Players that are responding to someone else's message should include their name before the message", 0, 1, { type = "Bool", name = "Type Name When Responding", category = "Text Chat Options" } )
--

-- Force Related Convars
CreateLambdaConvar( "lambdaplayers_force_radius", 750, true, false, false, "The Distance for which Lambda Players are affected by Force Menu options.", 250, 25000, { type = "Slider", name = "Force Radius", decimals = 0, category = "Force Menu" } )
CreateLambdaConvar( "lambdaplayers_force_spawnradiusply", 3000, true, false, false, "The Distance for which Lambda Players can spawn around the player. Set to 0 to disable.", 0, 25000, { type = "Slider", name = "Spawn Around Player Radius", decimals = 0, category = "Force Menu" } )
CreateLambdaConvar( "lambdaplayers_lambda_spawnatplayerspawns", 0, true, false, false, "If spawned Lambda Players should spawn at player spawn points", 0, 1, { type = "Bool", name = "Spawn at Player Spawns", category = "Force Menu" } )
--

-- DEBUGGING CONVARS. Server-side only
CreateLambdaConvar( "lambdaplayers_debug", 0, false, false, false, "Enables the debugging features", 0, 1, { type = "Bool", name = "Enable Debug", category = "Debugging" } )
CreateLambdaConvar( "lambdaplayers_debughelper_drawscale", 0.1, true, true, false, "The Scale the Debug Helper should size at", 0, 1, { type = "Slider", decimals = 2, name = "Debug Helper Scale", category = "Debugging" } )
CreateLambdaConvar( "lambdaplayers_debug_path", 0, false, false, false, "Draws Lambda Player's current path they're moving through.", 0, 1, { type = "Bool", name = "Enable Path Drawing", category = "Debugging" } )
CreateLambdaConvar( "lambdaplayers_debug_eyetracing", 0, false, false, false, "Draws a line from Lambda Player's eye position to where they're looking at. Developer mode should be enabled.", 0, 1, { type = "Bool", name = "Enable Eyetracing Line", category = "Debugging" } )
-- AddSourceConVarToSettings( "developer", "Enables Source's Developer mode", { type = "Bool", name = "Developer", category = "Debugging" } )
--

-- Note, Weapon allowing convars are located in the shared/globals.lua