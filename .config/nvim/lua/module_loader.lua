local function load_modules()
  require('plugins')
  require('mappings')
  require('options')
  require('options.autocmd')
  require('options.statusline')
  require('options.winbar')
  require('options.netrw')
  require('options.sholat')
end

return {
  load_modules = load_modules
}

