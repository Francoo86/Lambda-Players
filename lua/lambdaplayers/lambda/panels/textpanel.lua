
file.CreateDir( "lambdaplayers/texttypes")
local function OpenTextPanel( ply )
    if !ply:IsSuperAdmin() then return end
    local ishost = ply:GetNW2Bool( "lambda_serverhost", false )

    local frame = LAMBDAPANELS:CreateFrame( "Text Line Editor", 500, 300 )
    local framescroll = LAMBDAPANELS:CreateScrollPanel( frame, true, FILL )

    local function CreateTextEditingPanel( texttype )
        local pnl = LAMBDAPANELS:CreateBasicPanel( framescroll, LEFT )
        pnl:SetSize( 200, 200 )
        pnl:DockMargin( 10, 0, 0, 0 )
        pnl:Dock( LEFT )
        framescroll:AddPanel( pnl )
        local texttable = {}

        local listview = vgui.Create( "DListView", pnl )
        listview:Dock( FILL )
        listview:AddColumn( texttype .. " text lines", 1 )

        local isrequesting = true

        local textentry = LAMBDAPANELS:CreateTextEntry( pnl, BOTTOM, "Enter text here" )

        local searchbar = LAMBDAPANELS:CreateSearchBar( listview, texttable, pnl )
        searchbar:Dock( TOP )

        function textentry:OnEnter( val )
            if val == "" then return end
            LAMBDAPANELS:UpdateSequentialFile( "lambdaplayers/texttypes/" .. texttype .. ".json", val, "json" ) 
            textentry:SetText( "" )
            chat.AddText( "Added " .. val .. " to " .. texttype .. " lines" )
            surface.PlaySound( "buttons/button15.wav" )

            local line = listview:AddLine( val )
            line:SetSortValue( 1, val )
        end

        function listview:OnRowRightClick( id, line )
            chat.AddText( "Removed " .. line:GetSortValue( 1 ) .. " from " .. texttype .. " lines" )
            surface.PlaySound( "buttons/button15.wav" )
            listview:RemoveLine( id )
            LAMBDAPANELS:RemoveVarFromSQFile( "lambdaplayers/texttypes/" .. texttype .. ".json", line:GetSortValue( 1 ), "json" ) 
        end

        if !ishost then
            chat.AddText( "Requesting Text Lines for " .. texttype .. " from the Server")
            LAMBDAPANELS:RequestDataFromServer( "lambdaplayers/texttypes/" .. texttype .. ".json", "json", function( data )
                isrequesting = false

                if !data then return end

                table.Merge( texttable, data )

                for k, v in ipairs( texttable ) do
                    local line = listview:AddLine( v )
                    line:SetSortValue( 1, v )
                end

            end )
        else
            local data = LAMBDAFS:ReadFile( "lambdaplayers/texttypes/" .. texttype .. ".json", "json" )

            if !data then return end

            table.Merge( texttable, data )

            for k, v in ipairs( texttable ) do
                local line = listview:AddLine( v )
                line:SetSortValue( 1, v )
            end

            isrequesting = false
        end


        while isrequesting do coroutine.yield() end

        coroutine.wait( 0.5 )
    end

    LAMBDAPANELS:RequestVariableFromServer( "LambdaTextTable", function( data )
        if !data then chat.AddText( "No text data was found by Server!" ) return end
        local tbl = data[ 1 ]

        LambdaCreateThread( function()
            for k, v in pairs( tbl ) do
                CreateTextEditingPanel( k )
            end

            chat.AddText( "All text chat lines have been received!" )
        end )

    end )

end

RegisterLambdaPanel( "Text", "Opens a panel that allows you to create custom Text Lines for Lambda Players. You must be a Super Admin to use this Panel", OpenTextPanel )