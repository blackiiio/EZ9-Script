-- =====================================================
-- EZ9 Hub | BLACK_AL7OOB | تمرير محسن + لقب ملون + سحب
-- =====================================================
local s, e = pcall(function()
    repeat task.wait() until game:IsLoaded()
    local plr = game.Players.LocalPlayer
    local rs = game.ReplicatedStorage
    local uis = game.UserInputService
    local plrs = game.Players
    local cg = game.CoreGui
    local ts = game.TweenService
    local run = game.RunService
    local http = game.HttpService
    local guiParent = plr.PlayerGui

    -- شاشة ترحيب
    local sp = Instance.new("ScreenGui", guiParent)
    local bg = Instance.new("Frame", sp)
    bg.Size = UDim2.new(1,0,1,0)
    bg.BackgroundColor3 = Color3.new(0,0,0)
    local cnt = Instance.new("Frame", bg)
    cnt.Size = UDim2.new(0,200,0,60)
    cnt.Position = UDim2.new(0.5,-100,0.5,-30)
    cnt.BackgroundTransparency = 1
    local lb1 = Instance.new("TextLabel", cnt)
    lb1.Size = UDim2.new(0,70,1,0)
    lb1.BackgroundTransparency = 1
    lb1.Text = "EZ9"
    lb1.TextColor3 = Color3.new(1,1,1)
    lb1.TextScaled = true
    lb1.Font = Enum.Font.GothamBold
    local bx = Instance.new("Frame", cnt)
    bx.Size = UDim2.new(0,80,0,40)
    bx.Position = UDim2.new(0,80,0.5,-20)
    bx.BackgroundColor3 = Color3.fromRGB(255,150,0)
    Instance.new("UICorner", bx).CornerRadius = UDim.new(0,6)
    local lb2 = Instance.new("TextLabel", bx)
    lb2.Size = UDim2.new(1,0,1,0)
    lb2.BackgroundTransparency = 1
    lb2.Text = "BLACK"
    lb2.TextColor3 = Color3.new(0,0,0)
    lb2.TextScaled = true
    lb2.Font = Enum.Font.GothamBold
    task.wait(1)
    sp:Destroy()

    -- صلاحيات مختصرة
    local function kick(p)
        pcall(function() p:Kick("EZ9") end)
        local hd; pcall(function() hd = rs:FindFirstChild("HDAdminHDClient").Signals:FindFirstChild("RequestCommandModification") end)
        if hd then pcall(function() hd:InvokeServer(";kick "..p.Name) end) end
    end
    local OWNER = "BLACK_AL7OOB"
    local whitelist = {}
    local violators = {}
    local function loadDF()
        pcall(function()
            if isfile and isfile("EZ9_whitelist.json") then
                local data = http:JSONDecode(readfile("EZ9_whitelist.json"))
                if data and data.users then for _,uid in ipairs(data.users) do whitelist[uid]=true end end
            end
        end)
    end
    local function saveDF()
        local u = {}
        for uid,_ in pairs(whitelist) do table.insert(u,uid) end
        pcall(function() writefile("EZ9_whitelist.json", http:JSONEncode({users=u})) end)
    end
    local function loadLF()
        pcall(function()
            if isfile and isfile("EZ9_log.json") then
                violators = http:JSONDecode(readfile("EZ9_log.json")) or {}
            end
        end)
    end
    local function saveLF()
        pcall(function() writefile("EZ9_log.json", http:JSONEncode(violators)) end)
    end
    loadDF(); loadLF()
    local function authorized(uid)
        if whitelist[uid] then return true end
        local p = plrs:GetPlayerByUserId(uid)
        return p and p.Name:upper() == OWNER
    end
    if not authorized(plr.UserId) then
        violators[plr.UserId] = {name=plr.Name, userId=plr.UserId}
        saveLF()
        kick(plr)
        return
    end

    -- ========== زر القائمة (قابل للسحب) ==========
    local toggleGui = Instance.new("ScreenGui", guiParent)
    toggleGui.Name = "EZ9Toggle"
    local toggleBtn = Instance.new("TextButton", toggleGui)
    toggleBtn.Size = UDim2.new(0,50,0,50)
    toggleBtn.Position = UDim2.new(1,-60,0.5,-25)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(180,20,20)
    toggleBtn.Text = "EZ"
    toggleBtn.Font = Enum.Font.GothamBlack
    toggleBtn.TextSize = 20
    toggleBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

    -- جعل الزر قابلاً للسحب
    local function makeDraggable(obj)
        local dragging, startInput, startPos
        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                startInput = input.Position
                startPos = obj.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        uis.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - startInput
                obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
            end
        end)
    end
    makeDraggable(toggleBtn)

    -- ========== بناء الواجهة (مرة واحدة) ==========
    local mainGui, mainFrame
    local function buildMainUI()
        if mainGui then return end
        mainGui = Instance.new("ScreenGui", guiParent)
        mainGui.Name = "EZ9HUB"
        mainFrame = Instance.new("Frame", mainGui)
        mainFrame.Size = UDim2.new(0,420,0,680)  -- زودنا الطول
        mainFrame.Position = UDim2.new(0.5,-210,0.5,-340)
        mainFrame.BackgroundColor3 = Color3.fromRGB(15,0,0)
        mainFrame.Visible = false
        Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,14)
        local ms = Instance.new("UIStroke", mainFrame)
        ms.Color = Color3.fromRGB(255,30,30); ms.Thickness = 1.2

        -- سحب النافذة
        local titleBar = Instance.new("TextLabel", mainFrame)
        titleBar.BackgroundTransparency = 1
        titleBar.Size = UDim2.new(1,0,0,36)
        titleBar.Position = UDim2.new(0,10,0,6)
        titleBar.Text = "EZ9"
        titleBar.Font = Enum.Font.GothamBlack
        titleBar.TextSize = 24
        titleBar.TextColor3 = Color3.fromRGB(255,40,40)
        titleBar.TextXAlignment = Enum.TextXAlignment.Left
        local closeBtn = Instance.new("TextButton", mainFrame)
        closeBtn.AnchorPoint = Vector2.new(1,0)
        closeBtn.Position = UDim2.new(1,-4,0,8)
        closeBtn.Size = UDim2.new(0,30,0,30)
        closeBtn.BackgroundColor3 = Color3.fromRGB(200,20,20)
        closeBtn.Text = "✕"; closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)
        closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)
        makeDraggable(mainFrame) -- نعيد استخدام نفس الدالة مع تعديل بسيط للهدف

        -- تعديل دالة السحب لتناسب الإطار
        local dragStart, startPos
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragStart = input.Position
                startPos = mainFrame.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragStart = nil end
                end)
            end
        end)
        uis.InputChanged:Connect(function(input)
            if dragStart and (input.UserInputType == Enum.UserInputType.MouseMovement) then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
            end
        end)

        -- تبويبات
        local tabBar = Instance.new("Frame", mainFrame)
        tabBar.Size = UDim2.new(0,80,1,-52)
        tabBar.Position = UDim2.new(0,6,0,46)
        tabBar.BackgroundTransparency = 1
        local tabLayout = Instance.new("UIListLayout", tabBar)
        tabLayout.Padding = UDim.new(0,6); tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
        local pages, tabs = {}, {}
        local function addTab(name, order)
            local btn = Instance.new("TextButton", tabBar)
            btn.Size = UDim2.new(1,-12,0,40); btn.LayoutOrder = order
            btn.BackgroundColor3 = Color3.fromRGB(60,5,5); btn.BackgroundTransparency = 0.4
            btn.Text = name; btn.Font = Enum.Font.GothamBold; btn.TextSize = 14
            btn.TextColor3 = Color3.fromRGB(255,160,160)
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)
            local page = Instance.new("Frame", mainFrame)
            page.Size = UDim2.new(1,-100,1,-52); page.Position = UDim2.new(0,84,0,46)
            page.BackgroundColor3 = Color3.fromRGB(20,0,0); page.BackgroundTransparency = 0.3; page.Visible = false
            Instance.new("UICorner", page).CornerRadius = UDim.new(0,10)
            pages[name] = page; tabs[name] = btn
            btn.MouseButton1Click:Connect(function()
                for n,p in pairs(pages) do p.Visible = (n==name) end
                for n,b in pairs(tabs) do b.BackgroundTransparency = (n==name) and 0 or 0.4 end
            end)
            return page
        end
        local copyPage = addTab("نسخ",1)
        local ctrlPage = addTab("تحكم",2)

        -- نسخ – اختيار لاعب (نفس السابق مع تغيير بسيط في ارتفاعات التمرير)
        local selName = nil
        local plList = Instance.new("ScrollingFrame", copyPage)
        plList.Position = UDim2.new(0,4,0,4); plList.Size = UDim2.new(1,-8,0,34)
        plList.BackgroundColor3 = Color3.fromRGB(40,0,0); plList.BackgroundTransparency = 0.5
        plList.CanvasSize = UDim2.new(0,0,0,0); plList.ScrollingDirection = Enum.ScrollingDirection.X
        plList.AutomaticCanvasSize = Enum.AutomaticSize.X
        Instance.new("UICorner", plList).CornerRadius = UDim.new(0,6)
        local plLay = Instance.new("UIListLayout", plList)
        plLay.FillDirection = Enum.FillDirection.Horizontal; plLay.Padding = UDim.new(0,4)
        local selLabel = Instance.new("TextLabel", copyPage)
        selLabel.BackgroundTransparency = 1; selLabel.Position = UDim2.new(0,6,0,46); selLabel.Size = UDim2.new(1,-12,0,18)
        selLabel.Font = Enum.Font.GothamSemibold; selLabel.TextSize = 11
        selLabel.TextColor3 = Color3.fromRGB(255,180,180); selLabel.Text = "اختر لاعب"
        local chips = {}
        local function refPl()
            for _,c in ipairs(plList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
            chips = {}
            for _,p in ipairs(plrs:GetPlayers()) do
                if p ~= plr then
                    local chip = Instance.new("TextButton", plList)
                    chip.Size = UDim2.new(0,0,1,-4); chip.AutomaticSize = Enum.AutomaticSize.X
                    chip.BackgroundColor3 = Color3.fromRGB(80,10,10); chip.BackgroundTransparency = 0.3
                    chip.Text = p.Name; chip.TextSize = 11; chip.Font = Enum.Font.GothamBold
                    chip.TextColor3 = Color3.fromRGB(255,200,200)
                    Instance.new("UICorner", chip).CornerRadius = UDim.new(0,6)
                    chip.MouseButton1Click:Connect(function()
                        selName = p.Name; selLabel.Text = "تم: " .. p.Name
                        for _,ch in pairs(chips) do ch.BackgroundColor3 = Color3.fromRGB(80,10,10) end
                        chip.BackgroundColor3 = Color3.fromRGB(180,0,0)
                    end)
                    chips[p.Name] = chip
                end
            end
        end
        refPl(); plrs.PlayerAdded:Connect(refPl); plrs.PlayerRemoving:Connect(refPl)

        -- طرد
        local kickBtn = Instance.new("TextButton", copyPage)
        kickBtn.Size = UDim2.new(1,-6,0,28); kickBtn.Position = UDim2.new(0,3,0,64)
        kickBtn.BackgroundColor3 = Color3.fromRGB(180,0,0); kickBtn.Text = "🚫 طرد"
        kickBtn.Font = Enum.Font.GothamBold; kickBtn.TextSize = 14; kickBtn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", kickBtn).CornerRadius = UDim.new(0,6)
        kickBtn.MouseButton1Click:Connect(function() if selName then kick(plrs:FindFirstChild(selName)) end end)

        -- علامة الأدمن
        local prefBox = Instance.new("TextBox", copyPage)
        prefBox.Size = UDim2.new(0,55,0,24); prefBox.Position = UDim2.new(0,6,0,100)
        prefBox.BackgroundColor3 = Color3.fromRGB(100,10,10); prefBox.BackgroundTransparency = 0.3
        prefBox.Text = ";"; prefBox.TextColor3 = Color3.new(1,1,1); prefBox.Font = Enum.Font.GothamBold; prefBox.TextSize = 14
        Instance.new("UICorner", prefBox).CornerRadius = UDim.new(0,5)
        local prefLab = Instance.new("TextLabel", copyPage)
        prefLab.BackgroundTransparency = 1; prefLab.Size = UDim2.new(1,0,0,18); prefLab.Position = UDim2.new(0,60,0,126)
        prefLab.Font = Enum.Font.Gotham; prefLab.TextSize = 11; prefLab.TextColor3 = Color3.fromRGB(255,150,150); prefLab.Text = "علامة الأدمن"

        -- أوامر مع تكرار
        local selectedCmds = {re=1, logs=1, nv=1, explode=1}
        local addCmdFrame = Instance.new("Frame", copyPage)
        addCmdFrame.Position = UDim2.new(0,4,0,146); addCmdFrame.Size = UDim2.new(1,-8,0,28)
        addCmdFrame.BackgroundTransparency = 1
        local newCmdBox = Instance.new("TextBox", addCmdFrame)
        newCmdBox.Size = UDim2.new(0,90,1,0); newCmdBox.Position = UDim2.new(0,0,0,0)
        newCmdBox.BackgroundColor3 = Color3.fromRGB(60,5,5); newCmdBox.BackgroundTransparency = 0.3
        newCmdBox.PlaceholderText = "اكتب هنا"
        newCmdBox.Text = ""; newCmdBox.TextColor3 = Color3.new(1,1,1); newCmdBox.Font = Enum.Font.Gotham; newCmdBox.TextSize = 11
        Instance.new("UICorner", newCmdBox).CornerRadius = UDim.new(0,5)
        local newCountBox = Instance.new("TextBox", addCmdFrame)
        newCountBox.Size = UDim2.new(0,40,1,0); newCountBox.Position = UDim2.new(0,95,0,0)
        newCountBox.BackgroundColor3 = Color3.fromRGB(60,5,5); newCountBox.BackgroundTransparency = 0.3
        newCountBox.PlaceholderText = "عدد"; newCountBox.Text = "1"; newCountBox.TextColor3 = Color3.new(1,1,1); newCountBox.Font = Enum.Font.Gotham; newCountBox.TextSize = 11
        Instance.new("UICorner", newCountBox).CornerRadius = UDim.new(0,5)
        local addCmdBtn = Instance.new("TextButton", addCmdFrame)
        addCmdBtn.Size = UDim2.new(0,60,1,0); addCmdBtn.Position = UDim2.new(1,-60,0,0)
        addCmdBtn.BackgroundColor3 = Color3.fromRGB(0,120,0); addCmdBtn.Text = "إضافة"
        addCmdBtn.Font = Enum.Font.GothamBold; addCmdBtn.TextSize = 12; addCmdBtn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", addCmdBtn).CornerRadius = UDim.new(0,5)

        local cmdContainer = Instance.new("ScrollingFrame", copyPage)
        cmdContainer.Position = UDim2.new(0,4,0,180); cmdContainer.Size = UDim2.new(1,-8,0,220) -- زودنا المساحة
        cmdContainer.BackgroundColor3 = Color3.fromRGB(20,0,0); cmdContainer.BackgroundTransparency = 0.4
        cmdContainer.BorderSizePixel = 0; cmdContainer.ScrollBarThickness = 3; cmdContainer.CanvasSize = UDim2.new(0,0,0,0)
        Instance.new("UICorner", cmdContainer).CornerRadius = UDim.new(0,6)
        local cmdListLayout = Instance.new("UIListLayout", cmdContainer)
        cmdListLayout.Padding = UDim.new(0,4)
        cmdListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            cmdContainer.CanvasSize = UDim2.new(0,0,0,cmdListLayout.AbsoluteContentSize.Y+10)
        end)

        local prevBox = Instance.new("TextBox", copyPage)
        prevBox.Size = UDim2.new(1,-8,0,40); prevBox.Position = UDim2.new(0,4,0,405) -- نزلنا المعاينة
        prevBox.BackgroundColor3 = Color3.fromRGB(25,0,0); prevBox.BackgroundTransparency = 0.3
        prevBox.TextColor3 = Color3.fromRGB(200,255,200); prevBox.Font = Enum.Font.Code; prevBox.TextSize = 10
        prevBox.TextWrapped = true; prevBox.ClearTextOnFocus = false
        Instance.new("UICorner", prevBox).CornerRadius = UDim.new(0,6)

        local function updPrev()
            local t = selName or "???"
            local pr = prefBox.Text ~= "" and prefBox.Text or ";"
            local parts = {}
            for cmd, count in pairs(selectedCmds) do
                for i=1, count do table.insert(parts, pr..cmd.." "..t) end
            end
            prevBox.Text = #parts>0 and table.concat(parts,"  ") or "⚠️ اختر لاعباً"
        end

        local function rebuildCmdList()
            for _,c in ipairs(cmdContainer:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
            for cmd, count in pairs(selectedCmds) do
                local row = Instance.new("Frame", cmdContainer)
                row.Size = UDim2.new(1,0,0,28); row.BackgroundColor3 = Color3.fromRGB(40,5,5); row.BackgroundTransparency = 0.3
                Instance.new("UICorner", row).CornerRadius = UDim.new(0,4)
                local nameLbl = Instance.new("TextLabel", row)
                nameLbl.Size = UDim2.new(1,-80,1,0); nameLbl.Position = UDim2.new(0,5,0,0)
                nameLbl.BackgroundTransparency = 1; nameLbl.Font = Enum.Font.GothamBold; nameLbl.TextSize = 11
                nameLbl.TextColor3 = Color3.new(1,1,1); nameLbl.Text = cmd
                local countBox = Instance.new("TextBox", row)
                countBox.Size = UDim2.new(0,40,1,0); countBox.Position = UDim2.new(1,-85,0,0)
                countBox.BackgroundColor3 = Color3.fromRGB(25,0,0); countBox.BackgroundTransparency = 0.3
                countBox.Text = tostring(count); countBox.TextColor3 = Color3.fromRGB(0,255,150); countBox.Font = Enum.Font.GothamBold; countBox.TextSize = 11
                Instance.new("UICorner", countBox).CornerRadius = UDim.new(0,4)
                countBox.FocusLost:Connect(function()
                    local n = tonumber(countBox.Text)
                    if n and n >= 1 then selectedCmds[cmd] = n else countBox.Text = tostring(selectedCmds[cmd]) end
                    updPrev()
                end)
                local delBtn = Instance.new("TextButton", row)
                delBtn.Size = UDim2.new(0,30,1,0); delBtn.Position = UDim2.new(1,-38,0,0)
                delBtn.BackgroundColor3 = Color3.fromRGB(200,0,0); delBtn.Text = "✕"
                delBtn.Font = Enum.Font.GothamBold; delBtn.TextSize = 14; delBtn.TextColor3 = Color3.new(1,1,1)
                Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0,4)
                delBtn.MouseButton1Click:Connect(function()
                    selectedCmds[cmd] = nil
                    rebuildCmdList()
                    updPrev()
                end)
            end
        end

        addCmdBtn.MouseButton1Click:Connect(function()
            local cmd = newCmdBox.Text:match("^%s*(.-)%s*$")
            if cmd == "" then return end
            local count = tonumber(newCountBox.Text) or 1
            if count < 1 then count = 1 end
            selectedCmds[cmd] = count
            newCmdBox.Text = ""
            newCountBox.Text = "1"
            rebuildCmdList()
            updPrev()
        end)

        rebuildCmdList()
        updPrev()

        -- سبام
        local spamRun, spamTh, spamMod = false, nil, ""
        local chRm, hdRm
        pcall(function() chRm = rs:FindFirstChild("RemoteEvents"):FindFirstChild("ChatEvent") end)
        pcall(function() hdRm = rs:FindFirstChild("HDAdminHDClient").Signals:FindFirstChild("RequestCommandModification") end)

        local function stopSpam() spamRun = false; if spamTh then task.cancel(spamTh) end end
        local function startSpam(mode)
            if not selName then return end
            stopSpam(); task.wait(0.03)
            local t = (mode=="ghost") and selName or selName:sub(1,2)
            local pr = prefBox.Text ~= "" and prefBox.Text or ";"
            local parts = {}
            for cmd, count in pairs(selectedCmds) do
                for i=1, count do table.insert(parts, pr..cmd.." "..t) end
            end
            local msg = table.concat(parts," ")
            if msg == "" then return end
            spamRun = true; spamMod = mode
            spamTh = task.spawn(function()
                while spamRun do
                    if chRm then pcall(function() chRm:FireServer(msg) end) end
                    if hdRm then pcall(function() hdRm:InvokeServer(msg) end) end
                    task.wait(0.05)
                end
            end)
        end

        local ghostBtn = Instance.new("TextButton", copyPage)
        ghostBtn.Size = UDim2.new(1,-8,0,34); ghostBtn.Position = UDim2.new(0,4,0,450)
        ghostBtn.BackgroundColor3 = Color3.fromRGB(200,40,40); ghostBtn.Text = "سبام وهمي (الاسم الكامل)"
        ghostBtn.Font = Enum.Font.GothamBold; ghostBtn.TextSize = 13; ghostBtn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", ghostBtn).CornerRadius = UDim.new(0,6)
        local normBtn = Instance.new("TextButton", copyPage)
        normBtn.Size = UDim2.new(1,-8,0,34); normBtn.Position = UDim2.new(0,4,0,490)
        normBtn.BackgroundColor3 = Color3.fromRGB(200,100,40); normBtn.Text = "سبام عادي (أول حرفين)"
        normBtn.Font = Enum.Font.GothamBold; normBtn.TextSize = 13; normBtn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", normBtn).CornerRadius = UDim.new(0,6)

        ghostBtn.MouseButton1Click:Connect(function()
            if spamMod=="ghost" then stopSpam() return end
            startSpam("ghost")
        end)
        normBtn.MouseButton1Click:Connect(function()
            if spamMod=="normal" then stopSpam() return end
            startSpam("normal")
        end)

        local copyStat = Instance.new("TextLabel", copyPage)
        copyStat.BackgroundTransparency = 1; copyStat.Position = UDim2.new(0,6,1,-18); copyStat.Size = UDim2.new(1,-12,0,16)
        copyStat.Font = Enum.Font.Gotham; copyStat.TextSize = 10; copyStat.TextColor3 = Color3.fromRGB(255,150,150)

        task.spawn(function()
            while true do
                ghostBtn.Text = (spamMod=="ghost") and "⏹ إيقاف" or "سبام وهمي (الاسم الكامل)"
                normBtn.Text = (spamMod=="normal") and "⏹ إيقاف" or "سبام عادي (أول حرفين)"
                ghostBtn.BackgroundColor3 = (spamMod=="ghost") and Color3.fromRGB(0,120,0) or Color3.fromRGB(200,40,40)
                normBtn.BackgroundColor3 = (spamMod=="normal") and Color3.fromRGB(0,120,0) or Color3.fromRGB(200,100,40)
                copyStat.Text = spamMod and ("السبام شغال ("..spamMod..")") or ""
                task.wait(0.2)
            end
        end)

        -- صفحة تحكم
        local ctrlScr = Instance.new("ScrollingFrame", ctrlPage)
        ctrlScr.Position = UDim2.new(0,2,0,4); ctrlScr.Size = UDim2.new(1,-4,1,-8)
        ctrlScr.BackgroundTransparency = 1; ctrlScr.ScrollBarThickness = 4; ctrlScr.ScrollBarImageColor3 = Color3.fromRGB(255,60,60)
        ctrlScr.CanvasSize = UDim2.new(0,0,0,0)
        local ctrlList = Instance.new("UIListLayout", ctrlScr); ctrlList.Padding = UDim.new(0,6)
        ctrlList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            ctrlScr.CanvasSize = UDim2.new(0,0,0,ctrlList.AbsoluteContentSize.Y+10)
        end)

        local function mkBtn(text, c1, c2)
            local b = Instance.new("TextButton", ctrlScr)
            b.Size = UDim2.new(1,-8,0,42); b.BackgroundColor3 = Color3.fromRGB(180,30,30); b.BackgroundTransparency = 0.2
            b.Text = text; b.Font = Enum.Font.GothamBold; b.TextSize = 14; b.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
            local g = Instance.new("UIGradient", b)
            g.Color = ColorSequence.new{ColorSequenceKeypoint.new(0,c1),ColorSequenceKeypoint.new(1,c2)}
            g.Rotation = 90
            b.MouseEnter:Connect(function() ts:Create(b,TweenInfo.new(0.12),{BackgroundTransparency=0}):Play() end)
            b.MouseLeave:Connect(function() ts:Create(b,TweenInfo.new(0.12),{BackgroundTransparency=0.2}):Play() end)
            return b
        end

        local spamEx = mkBtn("سبام (خارجي)", Color3.fromRGB(255,80,80), Color3.fromRGB(170,30,30))
        local skins = mkBtn("سكنات", Color3.fromRGB(255,90,200), Color3.fromRGB(170,30,130))
        local danc = mkBtn("رقصات", Color3.fromRGB(230,140,30), Color3.fromRGB(160,90,10))
        local radio = mkBtn("تحكم الراديو", Color3.fromRGB(0,200,110), Color3.fromRGB(0,130,70))
        local hide = mkBtn("إخفاء رسائل السبام", Color3.fromRGB(30,200,200), Color3.fromRGB(15,130,130))
        local spinOn = mkBtn("تشغيل الدوران", Color3.fromRGB(140,220,40), Color3.fromRGB(80,150,20))
        local spinOff = mkBtn("إيقاف الدوران", Color3.fromRGB(170,30,30), Color3.fromRGB(110,15,15))
        local ttlBtn = mkBtn("تحكم في اللقب (EZ9)", Color3.fromRGB(170,70,220), Color3.fromRGB(100,30,150))
        local nvWipe = mkBtn("حذف NightVision", Color3.fromRGB(255,80,0), Color3.fromRGB(200,40,0))
        local logBtn = mkBtn("📋 سجل المحاولات", Color3.fromRGB(255,200,0), Color3.fromRGB(200,100,0))

        local ctrlStat = Instance.new("TextLabel", ctrlPage)
        ctrlStat.BackgroundTransparency = 1; ctrlStat.Position = UDim2.new(0,4,1,-18); ctrlStat.Size = UDim2.new(1,-8,0,16)
        ctrlStat.Font = Enum.Font.Gotham; ctrlStat.TextSize = 10; ctrlStat.TextColor3 = Color3.fromRGB(255,150,150)

        spamEx.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Shhd-code/SH_spam_neo/refs/heads/main/README.md"))()
        end)
        skins.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Shhd-code/Skinn-neooo/refs/heads/main/README.md"))()
        end)
        danc.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-ARES-EMOTE-HUB-148804"))()
        end)
        radio.MouseButton1Click:Connect(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Shhd-code/Raduooo/refs/heads/main/README.md"))()
        end)
        hide.MouseButton1Click:Connect(function()
            local function hn(obj)
                if obj:IsA("TextLabel") or obj:IsA("TextBox") then
                    if obj.Text:find("Sending commands") or obj.Text:find("CommandLimit") then
                        pcall(function() obj.Parent:Destroy() end)
                    end
                end
            end
            guiParent.DescendantAdded:Connect(hn)
            for _,v in ipairs(guiParent:GetDescendants()) do hn(v) end
        end)
        local spinning = false
        spinOn.MouseButton1Click:Connect(function() spinning=true end)
        spinOff.MouseButton1Click:Connect(function() spinning=false end)
        run.Heartbeat:Connect(function()
            if spinning and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                plr.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(50),0)
            end
        end)

        -- زر تحكم اللقب (نظام قديم ملون)
        ttlBtn.MouseButton1Click:Connect(function()
            local remote = rs:FindFirstChild("ApplyTitle")
            if not remote then ctrlStat.Text="ريموت ApplyTitle غير موجود"; return end
            -- تعيين الخانات الثلاثة بلون أحمر داكن متغير قليلاً (للمسة جمالية)
            local r, g, b = 255, 20, 20
            for _, slot in ipairs({"Title1","Title2","Title3"}) do
                -- تغيير لون بسيط لكل خانة
                local color = Color3.fromRGB(r - (slot == "Title2" and 40 or 0), g, b)
                pcall(function() remote:FireServer("EZ9", color, slot) end)
            end
            ctrlStat.Text="تم تعيين EZ9 على جميع الخانات"
        end)

        nvWipe.MouseButton1Click:Connect(function()
            local cnt=0
            local function sc(p)
                for _,o in ipairs(p:GetChildren()) do
                    local nm = o.Name:lower()
                    if o:IsA("ScreenGui") or o:IsA("Frame") then
                        if nm:find("nightvision") or nm:find("nv_") or nm:find("nv") then pcall(function() o:Destroy() end) cnt=cnt+1 end
                    elseif o:IsA("BillboardGui") or o:IsA("ParticleEmitter") or o:IsA("PostEffect") then
                        if nm:find("nv") or nm:find("night") then pcall(function() o:Destroy() end) cnt=cnt+1 end
                    end
                    pcall(function() sc(o) end)
                end
            end
            sc(guiParent); sc(cg)
            ctrlStat.Text="حذف "..cnt.." عنصر NV"
        end)

        -- سجل المحاولات
        logBtn.MouseButton1Click:Connect(function()
            local lgui = Instance.new("ScreenGui", guiParent)
            lgui.Name="EZ9Log"; lgui.DisplayOrder=9999
            local lframe = Instance.new("Frame", lgui)
            lframe.Size = UDim2.new(0,320,0,300); lframe.Position = UDim2.new(0.5,-160,0.5,-150)
            lframe.BackgroundColor3 = Color3.fromRGB(20,0,0); lframe.BackgroundTransparency = 0.1
            Instance.new("UICorner", lframe).CornerRadius = UDim.new(0,12)
            local ltitle = Instance.new("TextLabel", lframe)
            ltitle.Size = UDim2.new(1,0,0,30); ltitle.Position = UDim2.new(0,10,0,6)
            ltitle.BackgroundTransparency = 1; ltitle.Font = Enum.Font.GothamBold; ltitle.Text = "📋 سجل المحاولات"
            ltitle.TextSize = 16; ltitle.TextColor3 = Color3.fromRGB(255,80,80)
            local lclose = Instance.new("TextButton", lframe)
            lclose.AnchorPoint = Vector2.new(1,0); lclose.Position = UDim2.new(1,-8,0,6)
            lclose.Size = UDim2.new(0,24,0,24); lclose.BackgroundColor3 = Color3.fromRGB(200,0,0)
            lclose.Text = "✕"; lclose.Font = Enum.Font.GothamBold; lclose.TextSize = 14; lclose.TextColor3 = Color3.fromRGB(255,200,200)
            Instance.new("UICorner", lclose).CornerRadius = UDim.new(0,5)
            lclose.MouseButton1Click:Connect(function() lgui:Destroy() end)
            local lscroll = Instance.new("ScrollingFrame", lframe)
            lscroll.Position = UDim2.new(0,6,0,38); lscroll.Size = UDim2.new(1,-12,1,-44)
            lscroll.BackgroundTransparency = 1; lscroll.ScrollBarThickness = 3; lscroll.CanvasSize = UDim2.new(0,0,0,0)
            local llist = Instance.new("UIListLayout", lscroll); llist.Padding = UDim.new(0,6)
            llist:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                lscroll.CanvasSize = UDim2.new(0,0,0,llist.AbsoluteContentSize.Y+10)
            end)
            for uid,data in pairs(violators) do
                local row = Instance.new("Frame", lscroll)
                row.Size = UDim2.new(1,0,0,36); row.BackgroundColor3 = Color3.fromRGB(40,5,5); row.BackgroundTransparency = 0.3
                Instance.new("UICorner", row).CornerRadius = UDim.new(0,6)
                local info = Instance.new("TextLabel", row)
                info.Size = UDim2.new(1,-180,1,0); info.Position = UDim2.new(0,6,0,0)
                info.BackgroundTransparency = 1; info.Font = Enum.Font.Gotham; info.TextSize = 11
                info.TextColor3 = Color3.fromRGB(255,200,200)
                info.Text = data.name .. " (ID: "..tostring(uid)..")"
                local allow = Instance.new("TextButton", row)
                allow.Size = UDim2.new(0,55,0,30); allow.Position = UDim2.new(1,-175,0,3)
                allow.BackgroundColor3 = Color3.fromRGB(0,110,0); allow.Text = "سماح"
                allow.Font = Enum.Font.GothamBold; allow.TextSize = 11; allow.TextColor3 = Color3.new(1,1,1)
                Instance.new("UICorner", allow).CornerRadius = UDim.new(0,5)
                allow.MouseButton1Click:Connect(function()
                    whitelist[uid]=true; saveDF(); violators[uid]=nil; saveLF(); row:Destroy()
                end)
                local rem = Instance.new("TextButton", row)
                rem.Size = UDim2.new(0,55,0,30); rem.Position = UDim2.new(1,-115,0,3)
                rem.BackgroundColor3 = Color3.fromRGB(180,100,0); rem.Text = "حذف سماح"
                rem.Font = Enum.Font.GothamBold; rem.TextSize = 9; rem.TextColor3 = Color3.new(1,1,1)
                rem.Visible = whitelist[uid]==true
                Instance.new("UICorner", rem).CornerRadius = UDim.new(0,5)
                rem.MouseButton1Click:Connect(function()
                    whitelist[uid]=nil; saveDF(); rem.Visible = false
                end)
                local kk = Instance.new("TextButton", row)
                kk.Size = UDim2.new(0,55,0,30); kk.Position = UDim2.new(1,-55,0,3)
                kk.BackgroundColor3 = Color3.fromRGB(140,0,0); kk.Text = "طرد"
                kk.Font = Enum.Font.GothamBold; kk.TextSize = 11; kk.TextColor3 = Color3.new(1,1,1)
                Instance.new("UICorner", kk).CornerRadius = UDim.new(0,5)
                kk.MouseButton1Click:Connect(function()
                    local t = plrs:GetPlayerByUserId(uid)
                    if t then kick(t) end
                    violators[uid]=nil; saveLF(); row:Destroy()
                end)
            end
        end)

        pages["نسخ"].Visible = true
        tabs["نسخ"].BackgroundTransparency = 0
    end

    -- تبديل الواجهة بالزر
    toggleBtn.MouseButton1Click:Connect(function()
        buildMainUI()
        mainFrame.Visible = not mainFrame.Visible
    end)
end)
if not s then warn("[EZ9] خطأ:", e) end
