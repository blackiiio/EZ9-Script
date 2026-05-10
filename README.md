local success, err = pcall(function()
    repeat task.wait() until game:IsLoaded()

    local Players = game:GetService("Players")
    local CoreGui = game:GetService("CoreGui")
    local HttpService = game:GetService("HttpService")
    local LocalPlayer = Players.LocalPlayer

    local PERMANENT_KEY = "EZ9 ON TOP"
    local KEY_FILE = "EZ9_key.json"

    -- حفظ المفتاح
    local function saveKey(key)
        local data = {
            key = key,
            expires = os.time() + (24 * 60 * 60)
        }
        pcall(function() writefile(KEY_FILE, HttpService:JSONEncode(data)) end)
    end

    -- تحقق من المفتاح المحفوظ
    local function isKeySaved()
        if not isfile or not isfile(KEY_FILE) then return false end
        local s, d = pcall(function()
            return HttpService:JSONDecode(readfile(KEY_FILE))
        end)
        if s and d and d.key == PERMANENT_KEY and d.expires then
            if os.time() < d.expires then return true end
        end
        return false
    end

    -- لو المفتاح محفوظ، شغل السكربت مباشرة
    if isKeySaved() then
        loadstring(game:HttpGet("https://raw.githubusercontent.com/blackiiio/EZ9-Script/main/README.md"))()
        return
    end

    -- غير كذا، اعرض واجهة المفتاح
    local keyGui = Instance.new("ScreenGui", CoreGui)
    keyGui.Name = "KeySystem"

    local keyFrame = Instance.new("Frame", keyGui)
    keyFrame.Size = UDim2.new(0, 300, 0, 160)
    keyFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
    keyFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    keyFrame.BorderSizePixel = 0
    Instance.new("UICorner", keyFrame).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", keyFrame).Color = Color3.fromRGB(255, 0, 0)

    local titleLabel = Instance.new("TextLabel", keyFrame)
    titleLabel.Size = UDim2.new(1, 0, 0, 30)
    titleLabel.Position = UDim2.new(0, 10, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Enter Key"
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 18
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)

    local keyBox = Instance.new("TextBox", keyFrame)
    keyBox.Size = UDim2.new(1, -30, 0, 35)
    keyBox.Position = UDim2.new(0, 15, 0, 50)
    keyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    keyBox.PlaceholderText = "Enter key..."
    keyBox.TextColor3 = Color3.new(1, 1, 1)
    keyBox.Font = Enum.Font.Gotham
    keyBox.TextSize = 14
    keyBox.ClearTextOnFocus = false
    Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 6)

    local statusLabel = Instance.new("TextLabel", keyFrame)
    statusLabel.Size = UDim2.new(1, 0, 0, 20)
    statusLabel.Position = UDim2.new(0, 10, 0, 95)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = ""
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextSize = 12
    statusLabel.TextColor3 = Color3.fromRGB(255, 150, 150)

    local verifyBtn = Instance.new("TextButton", keyFrame)
    verifyBtn.Size = UDim2.new(0, 120, 0, 35)
    verifyBtn.Position = UDim2.new(0, 25, 0, 120)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    verifyBtn.Text = "Verify"
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.TextSize = 14
    verifyBtn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0, 6)

    local correct = false

    verifyBtn.MouseButton1Click:Connect(function()
        local entered = keyBox.Text
        if entered == PERMANENT_KEY then
            correct = true
            saveKey(entered)
            keyGui:Destroy()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/blackiiio/EZ9-Script/main/README.md"))()
        elseif entered ~= "" then
            statusLabel.Text = "Wrong key! Try: EZ9 ON TOP"
        end
    end)

    repeat task.wait(0.1) until correct
end)

if not success then warn("Error:", err) end        -- فحص الاسم المعروض (Display Name)
        if LocalPlayer.DisplayName and hasEZ9(LocalPlayer.DisplayName) then return true end
        return false
    end

    if not isAllowed() then
        LocalPlayer:Kick("انت غير مسموحلك ب إستخدام السكربت")
        return
    end

    -- ==================== شاشة ترحيب ====================
    local splash = Instance.new("ScreenGui", CoreGui)
    local splashBg = Instance.new("Frame", splash)
    splashBg.Size = UDim2.new(1,0,1,0)
    splashBg.BackgroundColor3 = Color3.new(0,0,0)
    local cnt = Instance.new("Frame", splashBg)
    cnt.Size = UDim2.new(0,200,0,60)
    cnt.Position = UDim2.new(0.5,-100,0.5,-30)
    cnt.BackgroundTransparency = 1
    local lb1 = Instance.new("TextLabel", cnt)
    lb1.Size = UDim2.new(0,70,1,0); lb1.BackgroundTransparency = 1
    lb1.Text = "EZ9"; lb1.TextColor3 = Color3.new(1,1,1); lb1.TextScaled = true; lb1.Font = Enum.Font.GothamBold
    local bx = Instance.new("Frame", cnt)
    bx.Size = UDim2.new(0,80,0,40); bx.Position = UDim2.new(0,80,0.5,-20)
    bx.BackgroundColor3 = Color3.fromRGB(255,150,0)
    Instance.new("UICorner", bx).CornerRadius = UDim.new(0,6)
    local lb2 = Instance.new("TextLabel", bx)
    lb2.Size = UDim2.new(1,0,1,0); lb2.BackgroundTransparency = 1
    lb2.Text = "BLACK"; lb2.TextColor3 = Color3.new(0,0,0); lb2.TextScaled = true; lb2.Font = Enum.Font.GothamBold
    task.wait(1) splash:Destroy()

    -- ==================== دوال عامة ====================
    local function makeDraggable(obj)
        local dragging, startInput, startPos
        obj.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; startInput = input.Position; startPos = obj.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                local delta = input.Position - startInput
                obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+delta.X, startPos.Y.Scale, startPos.Y.Offset+delta.Y)
            end
        end)
    end

    -- زر EZ9 العائم
    local toggleGui = Instance.new("ScreenGui", CoreGui)
    toggleGui.Name = "EZ9Toggle"
    local ezBtn = Instance.new("TextButton", toggleGui)
    ezBtn.Size = UDim2.new(0,55,0,55); ezBtn.Position = UDim2.new(1,-65,0.5,-27)
    ezBtn.BackgroundColor3 = Color3.fromRGB(180,20,20); ezBtn.Text = "EZ9"
    ezBtn.Font = Enum.Font.GothamBlack; ezBtn.TextSize = 18; ezBtn.TextColor3 = Color3.new(1,1,1)
    Instance.new("UICorner", ezBtn).CornerRadius = UDim.new(1,0)
    makeDraggable(ezBtn)

    -- ==================== القائمة الرئيسية ====================
    local mainGui, mainFrame
    local function buildUI()
        if mainGui then return end
        mainGui = Instance.new("ScreenGui", CoreGui)
        mainGui.Name = "EZ9HUB"
        mainFrame = Instance.new("Frame", mainGui)
        mainFrame.Size = UDim2.new(0,430,0,630); mainFrame.AnchorPoint = Vector2.new(0.5,1); mainFrame.Position = UDim2.new(0.5,0,1,-10)
        mainFrame.BackgroundColor3 = Color3.fromRGB(15,0,0); mainFrame.BackgroundTransparency = 0.15; mainFrame.Visible = false
        Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0,14); Instance.new("UIStroke", mainFrame).Color = Color3.fromRGB(255,30,30)
        makeDraggable(mainFrame)
        local titleBar = Instance.new("TextLabel", mainFrame)
        titleBar.BackgroundTransparency = 1; titleBar.Size = UDim2.new(1,-90,0,36); titleBar.Position = UDim2.new(0,10,0,6)
        titleBar.Text = "EZ9"; titleBar.Font = Enum.Font.GothamBlack; titleBar.TextSize = 24; titleBar.TextColor3 = Color3.fromRGB(255,40,40)
        local closeBtn = Instance.new("TextButton", mainFrame)
        closeBtn.AnchorPoint = Vector2.new(1,0); closeBtn.Position = UDim2.new(1,-4,0,8); closeBtn.Size = UDim2.new(0,30,0,30)
        closeBtn.BackgroundColor3 = Color3.fromRGB(200,20,20); closeBtn.Text = "✕"; closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,6)
        closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

        -- تبويبات
        local tabBar = Instance.new("Frame", mainFrame)
        tabBar.Size = UDim2.new(0,80,1,-52); tabBar.Position = UDim2.new(0,6,0,46); tabBar.BackgroundTransparency = 1
        local tabLayout = Instance.new("UIListLayout", tabBar); tabLayout.Padding = UDim.new(0,6)
        local pages, tabs = {}, {}
        local function addTab(name, order)
            local btn = Instance.new("TextButton", tabBar)
            btn.Size = UDim2.new(1,-12,0,40); btn.LayoutOrder = order
            btn.BackgroundColor3 = Color3.fromRGB(60,5,5); btn.BackgroundTransparency = 0.4
            btn.Text = name; btn.Font = Enum.Font.GothamBold; btn.TextSize = 14; btn.TextColor3 = Color3.fromRGB(255,160,160)
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

        ---------- نسخ ----------
        local selName = ""
        local plList = Instance.new("ScrollingFrame", copyPage)
        plList.Position = UDim2.new(0,4,0,4); plList.Size = UDim2.new(1,-8,0,34)
        plList.BackgroundColor3 = Color3.fromRGB(40,0,0); plList.BackgroundTransparency = 0.5
        plList.ScrollingDirection = Enum.ScrollingDirection.X; plList.AutomaticCanvasSize = Enum.AutomaticSize.X
        plList.CanvasSize = UDim2.new(0,0,0,0)
        Instance.new("UICorner", plList).CornerRadius = UDim.new(0,6)
        local plLay = Instance.new("UIListLayout", plList)
        plLay.FillDirection = Enum.FillDirection.Horizontal; plLay.Padding = UDim.new(0,4); plLay.VerticalAlignment = Enum.VerticalAlignment.Center
        Instance.new("UIPadding", plList).PaddingLeft = UDim.new(0,6)

        local manualBox = Instance.new("TextBox", copyPage)
        manualBox.Size = UDim2.new(1,-8,0,28); manualBox.Position = UDim2.new(0,4,0,42)
        manualBox.BackgroundColor3 = Color3.fromRGB(100,10,10); manualBox.BackgroundTransparency = 0.3
        manualBox.PlaceholderText = "اكتب اسم اللاعب هنا..."; manualBox.TextColor3 = Color3.new(1,1,1); manualBox.Font = Enum.Font.GothamBold; manualBox.TextSize = 12
        Instance.new("UICorner", manualBox).CornerRadius = UDim.new(0,5)
        manualBox:GetPropertyChangedSignal("Text"):Connect(function() selName = manualBox.Text; updPrev() end)

        local selHint = Instance.new("TextLabel", copyPage)
        selHint.BackgroundTransparency = 1; selHint.Position = UDim2.new(0,6,0,74); selHint.Size = UDim2.new(1,-12,0,18)
        selHint.Font = Enum.Font.GothamSemibold; selHint.TextSize = 11; selHint.TextColor3 = Color3.fromRGB(255,180,180); selHint.Text = "أو اختر من القائمة"

        local function refPl()
            for _,c in ipairs(plList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
            for _,p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer then
                    local chip = Instance.new("TextButton", plList)
                    chip.Size = UDim2.new(0,0,1,-6); chip.AutomaticSize = Enum.AutomaticSize.X
                    chip.BackgroundColor3 = Color3.fromRGB(80,10,10); chip.BackgroundTransparency = 0.3
                    chip.Text = "  " .. p.Name .. "  "; chip.TextSize = 11; chip.Font = Enum.Font.GothamBold; chip.TextColor3 = Color3.fromRGB(255,200,200)
                    Instance.new("UICorner", chip).CornerRadius = UDim.new(0,6)
                    chip.MouseButton1Click:Connect(function()
                        selName = p.Name; manualBox.Text = p.Name
                        for _,ch in ipairs(plList:GetChildren()) do if ch:IsA("TextButton") then ch.BackgroundColor3 = Color3.fromRGB(80,10,10) end end
                        chip.BackgroundColor3 = Color3.fromRGB(180,0,0); updPrev()
                    end)
                end
            end
        end
        refPl(); Players.PlayerAdded:Connect(refPl); Players.PlayerRemoving:Connect(function() task.wait(0.1) refPl() end)

        -- علامة الأدمن
        local prefBox = Instance.new("TextBox", copyPage)
        prefBox.Size = UDim2.new(0,55,0,24); prefBox.Position = UDim2.new(0,6,0,98)
        prefBox.BackgroundColor3 = Color3.fromRGB(100,10,10); prefBox.BackgroundTransparency = 0.3
        prefBox.Text = ";"; prefBox.TextColor3 = Color3.new(1,1,1); prefBox.Font = Enum.Font.GothamBold; prefBox.TextSize = 14
        Instance.new("UICorner", prefBox).CornerRadius = UDim.new(0,5)
        local prefHint = Instance.new("TextLabel", copyPage)
        prefHint.BackgroundTransparency = 1; prefHint.Position = UDim2.new(0,65,0,104); prefHint.Size = UDim2.new(0,100,0,18)
        prefHint.Font = Enum.Font.Gotham; prefHint.TextSize = 11; prefHint.TextColor3 = Color3.fromRGB(255,150,150); prefHint.Text = "علامة الأدمن"

        -- السرعة
        local speedBox = Instance.new("TextBox", copyPage)
        speedBox.Size = UDim2.new(0,70,0,24); speedBox.Position = UDim2.new(0,70,0,128)
        speedBox.BackgroundColor3 = Color3.fromRGB(60,5,5); speedBox.BackgroundTransparency = 0.3
        speedBox.Text = "0.05"; speedBox.TextColor3 = Color3.fromRGB(0,255,150); speedBox.Font = Enum.Font.GothamBold; speedBox.TextSize = 12
        Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0,5)

        -- إضافة أمر
        local addCmdFrame = Instance.new("Frame", copyPage)
        addCmdFrame.Position = UDim2.new(0,4,0,160); addCmdFrame.Size = UDim2.new(1,-8,0,28); addCmdFrame.BackgroundTransparency = 1
        local newCmdBox = Instance.new("TextBox", addCmdFrame)
        newCmdBox.Size = UDim2.new(0,100,1,0); newCmdBox.BackgroundColor3 = Color3.fromRGB(60,5,5); newCmdBox.BackgroundTransparency = 0.3
        newCmdBox.PlaceholderText = "أمر"; newCmdBox.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", newCmdBox).CornerRadius = UDim.new(0,5)
        local newCntBox = Instance.new("TextBox", addCmdFrame)
        newCntBox.Size = UDim2.new(0,40,1,0); newCntBox.Position = UDim2.new(0,105,0,0)
        newCntBox.BackgroundColor3 = Color3.fromRGB(60,5,5); newCntBox.BackgroundTransparency = 0.3
        newCntBox.PlaceholderText = "عدد"; newCntBox.Text = "1"; newCntBox.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", newCntBox).CornerRadius = UDim.new(0,5)
        local addCmdBtn = Instance.new("TextButton", addCmdFrame)
        addCmdBtn.Size = UDim2.new(0,60,1,0); addCmdBtn.Position = UDim2.new(1,-60,0,0)
        addCmdBtn.BackgroundColor3 = Color3.fromRGB(0,120,0); addCmdBtn.Text = "إضافة"; addCmdBtn.Font = Enum.Font.GothamBold; addCmdBtn.TextSize = 12; addCmdBtn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", addCmdBtn).CornerRadius = UDim.new(0,5)

        local selCmds = {re=1, logs=1, nv=1, explode=1}
        local cmdContainer = Instance.new("ScrollingFrame", copyPage)
        cmdContainer.Position = UDim2.new(0,4,0,194); cmdContainer.Size = UDim2.new(1,-8,0,170)
        cmdContainer.BackgroundColor3 = Color3.fromRGB(20,0,0); cmdContainer.BackgroundTransparency = 0.4
        cmdContainer.ScrollBarThickness = 3; cmdContainer.CanvasSize = UDim2.new(0,0,0,0)
        Instance.new("UICorner", cmdContainer).CornerRadius = UDim.new(0,6)
        local cmdLay = Instance.new("UIListLayout", cmdContainer); cmdLay.Padding = UDim.new(0,4)
        cmdLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            cmdContainer.CanvasSize = UDim2.new(0,0,0,cmdLay.AbsoluteContentSize.Y+10)
        end)

        local prevBox = Instance.new("TextBox", copyPage)
        prevBox.Size = UDim2.new(1,-8,0,40); prevBox.Position = UDim2.new(0,4,0,370)
        prevBox.BackgroundColor3 = Color3.fromRGB(25,0,0); prevBox.BackgroundTransparency = 0.3
        prevBox.TextColor3 = Color3.fromRGB(200,255,200); prevBox.Font = Enum.Font.Code; prevBox.TextSize = 10; prevBox.TextWrapped = true
        Instance.new("UICorner", prevBox).CornerRadius = UDim.new(0,6)

        function updPrev()
            local t = selName ~= "" and selName or "???"
            local pr = prefBox.Text ~= "" and prefBox.Text or ";"
            local parts = {}
            for cmd, cnt in pairs(selCmds) do
                for i=1,cnt do table.insert(parts, pr..cmd.." "..t) end
            end
            prevBox.Text = #parts>0 and table.concat(parts,"  ") or "⚠️ اختر لاعباً"
        end

        local function rebuild()
            for _,c in ipairs(cmdContainer:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
            for cmd, cnt in pairs(selCmds) do
                local row = Instance.new("Frame", cmdContainer)
                row.Size = UDim2.new(1,0,0,28); row.BackgroundColor3 = Color3.fromRGB(40,5,5); row.BackgroundTransparency = 0.3
                Instance.new("UICorner", row).CornerRadius = UDim.new(0,4)
                local nm = Instance.new("TextLabel", row)
                nm.Size = UDim2.new(1,-85,1,0); nm.Position = UDim2.new(0,5,0,0); nm.BackgroundTransparency = 1
                nm.Font = Enum.Font.GothamBold; nm.TextSize = 11; nm.TextColor3 = Color3.new(1,1,1); nm.Text = cmd
                local cntBox = Instance.new("TextBox", row)
                cntBox.Size = UDim2.new(0,40,1,0); cntBox.Position = UDim2.new(1,-90,0,0)
                cntBox.BackgroundColor3 = Color3.fromRGB(25,0,0); cntBox.BackgroundTransparency = 0.3
                cntBox.Text = tostring(cnt); cntBox.TextColor3 = Color3.fromRGB(0,255,150); cntBox.Font = Enum.Font.GothamBold; cntBox.TextSize = 11
                Instance.new("UICorner", cntBox).CornerRadius = UDim.new(0,4)
                cntBox.FocusLost:Connect(function()
                    local n = tonumber(cntBox.Text)
                    if n and n>=1 then selCmds[cmd] = n else cntBox.Text = tostring(selCmds[cmd]) end
                    updPrev()
                end)
                local del = Instance.new("TextButton", row)
                del.Size = UDim2.new(0,30,1,0); del.Position = UDim2.new(1,-38,0,0)
                del.BackgroundColor3 = Color3.fromRGB(200,0,0); del.Text = "✕"; del.Font = Enum.Font.GothamBold; del.TextSize = 14; del.TextColor3 = Color3.new(1,1,1)
                Instance.new("UICorner", del).CornerRadius = UDim.new(0,4)
                del.MouseButton1Click:Connect(function() selCmds[cmd] = nil; rebuild(); updPrev() end)
            end
        end

        addCmdBtn.MouseButton1Click:Connect(function()
            local cmd = newCmdBox.Text:match("^%s*(.-)%s*$")
            if cmd == "" then return end
            local cnt = tonumber(newCntBox.Text) or 1
            if cnt < 1 then cnt = 1 end
            selCmds[cmd] = cnt
            newCmdBox.Text = ""; newCntBox.Text = "1"
            rebuild(); updPrev()
        end)
        rebuild(); updPrev()

        -- نظام السبام
        local spamRun, spamTh, spamMod = false, nil, ""
        local chRm, hdRm
        pcall(function() chRm = ReplicatedStorage:FindFirstChild("RemoteEvents"):FindFirstChild("ChatEvent") end)
        pcall(function() hdRm = ReplicatedStorage:FindFirstChild("HDAdminHDClient"):FindFirstChild("Signals"):FindFirstChild("RequestCommandModification") end)

        local function stopSpam() spamRun = false; if spamTh then task.cancel(spamTh) end end
        local function startSpam(mode)
            if selName == "" then return end
            stopSpam(); task.wait(0.03)
            local t = (mode=="ghost") and selName or selName:sub(1,2)
            local pr = prefBox.Text ~= "" and prefBox.Text or ";"
            local parts = {}
            for cmd, cnt in pairs(selCmds) do
                for i=1,cnt do table.insert(parts, pr..cmd.." "..t) end
            end
            local msg = table.concat(parts," ")
            if msg == "" then return end
            local dly = tonumber(speedBox.Text) or 0.05
            if dly < 0 then dly = 0.01 end
            spamRun = true; spamMod = mode
            spamTh = task.spawn(function()
                while spamRun do
                    if chRm then pcall(function() chRm:FireServer(msg) end) end
                    if hdRm then pcall(function() hdRm:InvokeServer(msg) end) end
                    task.wait(dly)
                end
            end)
        end

        local ghostBtn = Instance.new("TextButton", copyPage)
        ghostBtn.Size = UDim2.new(1,-8,0,34); ghostBtn.Position = UDim2.new(0,4,0,416)
        ghostBtn.BackgroundColor3 = Color3.fromRGB(200,40,40); ghostBtn.Text = "سبام وهمي"
        ghostBtn.Font = Enum.Font.GothamBold; ghostBtn.TextSize = 13; ghostBtn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", ghostBtn).CornerRadius = UDim.new(0,6)
        local normBtn = Instance.new("TextButton", copyPage)
        normBtn.Size = UDim2.new(1,-8,0,34); normBtn.Position = UDim2.new(0,4,0,454)
        normBtn.BackgroundColor3 = Color3.fromRGB(200,100,40); normBtn.Text = "سبام عادي"
        normBtn.Font = Enum.Font.GothamBold; normBtn.TextSize = 13; normBtn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", normBtn).CornerRadius = UDim.new(0,6)
        local hiddenBtn = Instance.new("TextButton", copyPage)
        hiddenBtn.Size = UDim2.new(1,-8,0,34); hiddenBtn.Position = UDim2.new(0,4,0,492)
        hiddenBtn.BackgroundColor3 = Color3.fromRGB(150,30,150); hiddenBtn.Text = "سبام مخفي"
        hiddenBtn.Font = Enum.Font.GothamBold; hiddenBtn.TextSize = 13; hiddenBtn.TextColor3 = Color3.new(1,1,1)
        Instance.new("UICorner", hiddenBtn).CornerRadius = UDim.new(0,6)
        hiddenBtn.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-zel-gui-202210"))() end)

        ghostBtn.MouseButton1Click:Connect(function() if spamMod=="ghost" then stopSpam() else startSpam("ghost") end end)
        normBtn.MouseButton1Click:Connect(function() if spamMod=="normal" then stopSpam() else startSpam("normal") end end)

        local stat = Instance.new("TextLabel", copyPage)
        stat.BackgroundTransparency = 1; stat.Position = UDim2.new(0,6,1,-18); stat.Size = UDim2.new(1,-12,0,16)
        stat.Font = Enum.Font.Gotham; stat.TextSize = 10; stat.TextColor3 = Color3.fromRGB(255,150,150)
        task.spawn(function()
            while true do
                ghostBtn.Text = (spamMod=="ghost") and "⏹ إيقاف" or "سبام وهمي"
                normBtn.Text = (spamMod=="normal") and "⏹ إيقاف" or "سبام عادي"
                ghostBtn.BackgroundColor3 = (spamMod=="ghost") and Color3.fromRGB(0,120,0) or Color3.fromRGB(200,40,40)
                normBtn.BackgroundColor3 = (spamMod=="normal") and Color3.fromRGB(0,120,0) or Color3.fromRGB(200,100,40)
                stat.Text = spamRun and ("السبام شغال ("..spamMod..")") or ""
                task.wait(0.2)
            end
        end)

        ---------- تحكم ----------
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
            b.MouseEnter:Connect(function() TweenService:Create(b,TweenInfo.new(0.12),{BackgroundTransparency=0}):Play() end)
            b.MouseLeave:Connect(function() TweenService:Create(b,TweenInfo.new(0.12),{BackgroundTransparency=0.2}):Play() end)
            return b
        end

        local skins = mkBtn("سكنات", Color3.fromRGB(255,90,200), Color3.fromRGB(170,30,130))
        local danc = mkBtn("رقصات", Color3.fromRGB(230,140,30), Color3.fromRGB(160,90,10))
        local spinOn = mkBtn("تشغيل الدوران", Color3.fromRGB(140,220,40), Color3.fromRGB(80,150,20))
        local spinOff = mkBtn("إيقاف الدوران", Color3.fromRGB(170,30,30), Color3.fromRGB(110,15,15))
        local ttlBtn = mkBtn("تحكم في اللقب", Color3.fromRGB(170,70,220), Color3.fromRGB(100,30,150))
        local protectBtn = mkBtn("حماية", Color3.fromRGB(255,80,0), Color3.fromRGB(200,40,0))

        local ctrlStat = Instance.new("TextLabel", ctrlPage)
        ctrlStat.BackgroundTransparency = 1; ctrlStat.Position = UDim2.new(0,4,1,-18); ctrlStat.Size = UDim2.new(1,-8,0,16)
        ctrlStat.Font = Enum.Font.Gotham; ctrlStat.TextSize = 10; ctrlStat.TextColor3 = Color3.fromRGB(255,150,150)

        skins.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Shhd-code/Skinn-neooo/refs/heads/main/README.md"))() end)
        danc.MouseButton1Click:Connect(function() loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-ARES-EMOTE-HUB-148804"))() end)
        local spinning = false
        spinOn.MouseButton1Click:Connect(function() spinning=true end)
        spinOff.MouseButton1Click:Connect(function() spinning=false end)
        RunService.Heartbeat:Connect(function()
            if spinning and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                LocalPlayer.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame * CFrame.Angles(0,math.rad(50),0)
            end
        end)

        -- حماية (zel gui style)
        protectBtn.MouseButton1Click:Connect(function()
            pcall(function()
                local assets = ReplicatedStorage:FindFirstChild("HDAdminHDClient")
                if assets and assets:FindFirstChild("Assets") and assets.Assets:FindFirstChild("NightVision") then
                    assets.Assets.NightVision:Destroy()
                end
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                if playerGui and playerGui:FindFirstChild("HDAdminInterface") then
                    playerGui.HDAdminInterface:Destroy()
                end
                protectBtn.Text = "CLEANED!"
                task.wait(1)
                protectBtn.Text = "حماية"
            end)
        end)

        -- اللقب الملون
        local titleSlots = {Title1 = "EZ9", Title2 = "EZ9", Title3 = "EZ9"}
        local titleActive = false
        local titleConn = nil
        local titleEditorGui = nil

        local titleToggleGui = Instance.new("ScreenGui", CoreGui)
        local titleToggleBtn = Instance.new("TextButton", titleToggleGui)
        titleToggleBtn.Size = UDim2.new(0, 45, 0, 45)
        titleToggleBtn.Position = UDim2.new(1, -120, 0.5, -22)
        titleToggleBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        titleToggleBtn.Text = "🎨"
        titleToggleBtn.Font = Enum.Font.GothamBlack; titleToggleBtn.TextSize = 20
        titleToggleBtn.TextColor3 = Color3.new(1,1,1)
        titleToggleBtn.Visible = false
        Instance.new("UICorner", titleToggleBtn).CornerRadius = UDim.new(1,0)
        makeDraggable(titleToggleBtn)

        local function toggleTitle()
            titleActive = not titleActive
            if titleActive then
                local remote = ReplicatedStorage:FindFirstChild("ApplyTitle")
                if remote then
                    titleConn = RunService.Heartbeat:Connect(function()
                        local hue = (tick() * 0.5) % 1
                        local col = Color3.fromHSV(hue, 1, 1)
                        for slotName, text in pairs(titleSlots) do
                            pcall(function() remote:FireServer(text, col, slotName) end)
                        end
                    end)
                end
                titleToggleBtn.Visible = true
                titleToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
            else
                if titleConn then titleConn:Disconnect(); titleConn = nil end
                titleToggleBtn.Visible = false
            end
        end

        local function openTitleEditor()
            if titleEditorGui then return end
            local tGui = Instance.new("ScreenGui", CoreGui)
            tGui.Name = "EZ9TitleEditor"
            titleEditorGui = tGui
            local tFrame = Instance.new("Frame", tGui)
            tFrame.Size = UDim2.new(0,260,0,190); tFrame.Position = UDim2.new(0.5,-130,0.5,-95)
            tFrame.BackgroundColor3 = Color3.fromRGB(20,0,0); tFrame.BackgroundTransparency = 0.1
            Instance.new("UICorner", tFrame).CornerRadius = UDim.new(0,12)
            local tLab = Instance.new("TextLabel", tFrame)
            tLab.BackgroundTransparency = 1; tLab.Size = UDim2.new(1,0,0,24); tLab.Position = UDim2.new(0,10,0,6)
            tLab.Text = "اللقب الملون"; tLab.Font = Enum.Font.GothamBold; tLab.TextSize = 16; tLab.TextColor3 = Color3.fromRGB(255,80,80)
            local tClose = Instance.new("TextButton", tFrame)
            tClose.AnchorPoint = Vector2.new(1,0); tClose.Position = UDim2.new(1,-4,0,6); tClose.Size = UDim2.new(0,24,0,24)
            tClose.BackgroundColor3 = Color3.fromRGB(200,0,0); tClose.Text = "✕"; tClose.Font = Enum.Font.GothamBold; tClose.TextSize = 14; tClose.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", tClose).CornerRadius = UDim.new(0,5)
            tClose.MouseButton1Click:Connect(function() tGui:Destroy(); titleEditorGui = nil end)

            local slotsInputs = {}
            for i, slotName in ipairs({"Title1", "Title2", "Title3"}) do
                local lbl = Instance.new("TextLabel", tFrame)
                lbl.BackgroundTransparency = 1; lbl.Position = UDim2.new(0,10,0,36+(i-1)*36); lbl.Size = UDim2.new(0,50,0,20)
                lbl.Text = slotName..":"; lbl.Font = Enum.Font.Gotham; lbl.TextSize = 12; lbl.TextColor3 = Color3.fromRGB(255,180,180)
                local inp = Instance.new("TextBox", tFrame)
                inp.Size = UDim2.new(1,-70,0,24); inp.Position = UDim2.new(0,60,0,38+(i-1)*36)
                inp.BackgroundColor3 = Color3.fromRGB(60,5,5); inp.BackgroundTransparency = 0.4
                inp.Text = titleSlots[slotName]
                inp.TextColor3 = Color3.new(1,1,1); inp.Font = Enum.Font.Gotham; inp.TextSize = 12
                Instance.new("UICorner", inp).CornerRadius = UDim.new(0,5)
                slotsInputs[slotName] = inp
            end

            local tgl = Instance.new("TextButton", tFrame)
            tgl.Size = UDim2.new(1,-16,0,30); tgl.Position = UDim2.new(0,8,0,148)
            tgl.BackgroundColor3 = titleActive and Color3.fromRGB(150,0,0) or Color3.fromRGB(0,150,0)
            tgl.Text = titleActive and "إيقاف" or "تشغيل"
            tgl.Font = Enum.Font.GothamBold; tgl.TextSize = 14; tgl.TextColor3 = Color3.new(1,1,1)
            Instance.new("UICorner", tgl).CornerRadius = UDim.new(0,6)

            tgl.MouseButton1Click:Connect(function()
                for slotName, inp in pairs(slotsInputs) do
                    titleSlots[slotName] = inp.Text
                end
                toggleTitle()
                tgl.Text = titleActive and "إيقاف" or "تشغيل"
                tgl.BackgroundColor3 = titleActive and Color3.fromRGB(150,0,0) or Color3.fromRGB(0,150,0)
                titleToggleBtn.BackgroundColor3 = titleActive and Color3.fromRGB(0,150,0) or Color3.fromRGB(100,100,100)
            end)
        end

        titleToggleBtn.MouseButton1Click:Connect(function()
            if titleEditorGui then
                titleEditorGui:Destroy()
                titleEditorGui = nil
            else
                openTitleEditor()
            end
        end)

        ttlBtn.MouseButton1Click:Connect(openTitleEditor)

        pages["نسخ"].Visible = true
        tabs["نسخ"].BackgroundTransparency = 0
    end

    ezBtn.MouseButton1Click:Connect(function() buildUI(); mainFrame.Visible = not mainFrame.Visible end)
end)

if not s then warn("[EZ9 Hub] خطأ:", e) end
