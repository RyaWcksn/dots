local success, module_loader = pcall(require, 'module_loader')
if not success then
	vim.notify('Failed to load module_loader', vim.log.levels.ERROR)
	return
end

local success, err = pcall(module_loader.load_modules)
if not success then
	vim.notify('Failed to load modules: ' .. err, vim.log.levels.ERROR)
end
