local wezterm = require("wezterm")
local module = {}

local path_sep = wezterm.target_triple:find("windows") and "\\" or "/"

function module.join_path(...)
	return table.concat({ ... }, path_sep)
end

function module.notify(scope, window, message, level)
	local full_message = scope .. ": " .. message

	if level == "error" then
		wezterm.log_error(full_message)
	elseif level == "warn" then
		wezterm.log_warn(full_message)
	else
		wezterm.log_info(full_message)
	end

	if window then
		window:toast_notification(scope, message, nil, 4000)
	end
end

function module.cwd_to_path(cwd)
	if not cwd then
		return nil
	end

	if type(cwd) == "string" then
		if cwd:match("^%a[%w+.-]*://") then
			local parsed = wezterm.url.parse(cwd)
			return parsed and parsed.file_path or nil
		end

		return cwd
	end

	return cwd.file_path
end

function module.current_path(pane)
	return module.cwd_to_path(pane:get_current_working_dir())
end

function module.basename(path)
	if not path or path == "" then
		return nil
	end

	return path:match("([^/\\]+)$")
end

function module.dirname(path)
	if not path or path == "" then
		return nil
	end

	return path:match("^(.*)[/\\][^/\\]+$")
end

return module
