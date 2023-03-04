_ELEKTRON_CFG = {
  port = nil,
  navigateToChanged = true,
  openBrowser = true,
  baseURL = "http::localhost:1313",
  destDir = "content/post",
  sourceDir = "src",
  destination = nil,
  environment = nil,
  symbols = {"/usr/share/kicad/symbols"},
  files = { ".*\\.py", ".*\\.rmd"  },
}

local elektron = require('elektron.elektron')

local create_cmd = function(cmd, func, opt)
  opt = vim.tbl_extend('force', { desc = 'elektron ' .. cmd }, opt or {})
  vim.api.nvim_create_user_command(cmd, func, opt)
end

local function setup(cfg)
  cfg = cfg or {}
  _ELEKTRON_CFG = vim.tbl_extend('force', _ELEKTRON_CFG, cfg)

  create_cmd( 'ElektronStartHugo', function(opts) elektron.StartHugo(opts.args) end, { nargs = '*' })
  create_cmd( 'ElektronStopHugo', function(opts) elektron.StopHugo(opts.args) end, { nargs = '*' })
  vim.api.nvim_create_autocmd("BufWritePost", {
    group = vim.api.nvim_create_augroup("elektron", { clear = true }),
    pattern = "*.rmd",
    callback = function(opts)
      elektron.rebuild(opts)
    end,
  })
  vim.cmd [[ autocmd BufRead,BufNewFile *.rmd set filetype=markdown ]]
end

return {
  setup = setup,
}
