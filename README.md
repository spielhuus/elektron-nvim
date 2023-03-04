# elektron.nvim

simple plugin for elektron notebooks.

features:

* rebuild notebooks on save
* start/stop hugo server
* nvim-cmp source for symbols

## Setup

### Installation

By default, the source will be available on all lua files. It's suggested that you change it to the filenames (or path) where you install
your Neovim plugins (regular expressions also work).

```lua
use({
  "hrsh7th/nvim-cmp",
  requires = {
    {
      "KadoBOT/cmp-plugins",
      config = function()
        require("cmp-plugins").setup({
          files = { ".*\\.lua" }  -- default
          -- files = { "plugins.lua", "some_path/plugins/" } -- Recommended: use static filenames or partial paths
        })
      end,
    },
  }
})
```
### Configuration
```lua
require('cmp').setup({
  sources = {
    { name = 'elektron' },
  },
})
```
