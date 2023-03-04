local util = {}

local os_name = vim.loop.os_uname().sysname
local is_windows = os_name == 'Windows' or os_name == 'Windows_NT'

function util.sep()
  if is_windows then
    return '\\'
  end
  return '/'
end

function util.os()
  return os_name
end

function util.is_windows()
  return is_windows
end

function util.open_browser()
  vim.fn.jobstart({"xdg-open", "http://localhost:1313"}, {
    stdout_buffered = true,
    on_stderr = function(_, data, _)
      data = utils.handle_job_data(data)
      if not data then
        return
      end
      -- log(job_id, data, event)
      vim.notify(vim.inspect(data) .. ' from stderr', vim.log.levels.ERROR)
    end,
  })
end

util.handle_job_data = function(data)
  if not data then
    return nil
  end
  -- Because the nvim.stdout's data will have an extra empty line at end on some OS (e.g. maxOS), we should remove it.
  if data[#data] == '' then
    table.remove(data, #data)
  end
  if #data < 1 then
    return nil
  end
  return data
end

util.log = function(...)
  --[[ if not _WEBTOOLS_CFG.debug then
    return
  end
  if lprint ~= nil then
    return lprint(...)
  end ]]
  print(...)
end

return util
