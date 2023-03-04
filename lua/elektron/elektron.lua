local utils = require('elektron.utils')
local job

_ELEKTRON_CFG = _ELEKTRON_CFG

local M = {}
function dump(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

function M.rebuild(opts)
  local target = opts['file']:gsub(".rmd", ".md")
  target = target:gsub(_ELEKTRON_CFG.sourceDir, _ELEKTRON_CFG.destDir)
  vim.fn.jobstart({ "elektron", "convert", "--input", opts['file'], "--output", target }, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data then
        -- vim.notify(data)
        -- print(dump(data))
      end
    end,
    on_stderr = function(_, data)
      if data then
        -- vim.notify(data, vim.log.levels.ERROR)
        -- print(dump(data))
      end
    end,
  })
end

M.running = function()
  if not job then
    return false
  end
  return vim.fn.jobwait({ job }, 0)[1] == -1
end

function M.StartHugo(args)
  if vim.fn.executable('hugo') == 0 then
    return vim.notify(
      'hugo not found please install',
      vim.log.levels.ERROR
    )
  end

  if M.running() then
    M.stop()
  end

  local opts = {
    'hugo',
    'serve'
  }

  if _ELEKTRON_CFG.navigateToChanged then
    table.insert(opts, "--navigateToChanged")
  end

  --[[ if _ELEKTRON_CFG.live_reload then
    print("debug")
  end ]]

  if args then
    for i = 1, #args do
      if type(args[i]) == 'string' then
        table.insert(opts, args[i])
      end
    end
  end

  if _ELEKTRON_CFG.openBrowser then
    utils.open_browser()
  end
  job = vim.fn.jobstart(opts, {
    stdout_buffered = true,
    on_stderr = function(job_id, data, event)
      data = utils.handle_job_data(data)
      if not data then
        return
      end
      -- log(job_id, data, event)
      vim.notify(vim.inspect(data) .. ' from stderr', vim.log.levels.ERROR)
    end,
  })
end

function M.StopHugo(args)
  if M.running() then
    if job then
      vim.fn.jobstop(job)
    end
    job = nil
  end
end

return M
