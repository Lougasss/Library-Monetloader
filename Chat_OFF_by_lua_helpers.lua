-- API ��� ���������/���������� ������� ����� Script Manager
local toggled = false
EXPORTS = {
  canToggle = function() return true end,
  getToggle = function() return toggled end,
  toggle = function() toggled = not toggled end
}

-- ���������� �������
local toggled_sm = false -- ���������� ��� Lol: toggled_sm - ��� toggled server message
local check_sampev, sampev = pcall(require, "samp.events")

-- �������� ������� �������
function main()
	if not check_sampev then
		print("[Chat OFF]: Samp Events not found!")
	else
		sampRegisterChatCommand("chatt", function()
			toggled_sm = not toggled_sm
			for i = 1, 15 do sampAddChatMessage("", -1) end
		end)
		wait(-1)
	end
end

-- �������� �� ��, ����������� �� ���������� "Samp Events"
if check_sampev then
	-- ������� �� ������ ������ ��������� � ����
	function sampev.onServerMessage(color, text)
		if toggled_sm then return false end
	end
end

-- �������, ���� ������ �������� - �� ��������������
function onScriptTerminate(script, game_quit)
	if script == thisScript() and not game_quit then script():reload() end
end