--
--          ╭─────────────────────────────────────────────────────────╮
--          │   See the kickstart.nvim README for more information    │
--          ╰─────────────────────────────────────────────────────────╯
return {
  -- Seamless navigation between tmux panes and vim splits
  -- https://github.com/christoomey/vim-tmux-navigator
  {
    'christoomey/vim-tmux-navigator',
    cmd = {
      'TmuxNavigateLeft',
      'TmuxNavigateDown',
      'TmuxNavigateUp',
      'TmuxNavigateRight',
      'TmuxNavigatePrevious',
    },
    keys = {
      { '<c-h>', '<cmd><C-U>TmuxNavigateLeft<cr>' },
      { '<c-j>', '<cmd><C-U>TmuxNavigateDown<cr>' },
      { '<c-k>', '<cmd><C-U>TmuxNavigateUp<cr>' },
      { '<c-l>', '<cmd><C-U>TmuxNavigateRight<cr>' },
      { '<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>' },
    },
  },
  -- Describe the regexp under the cursor
  -- https://github.com/bennypowers/nvim-regexplainer
  {
    'bennypowers/nvim-regexplainer',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'MunifTanjim/nui.nvim',
    },
    opts = {
      -- automatically show the explainer when the cursor enters a regexp
      auto = true,
    },
  },
  -- Toggle nvim color theme when macOS color scheme changes
  -- https://github.com/cormacrelf/dark-notify
  {
    'cormacrelf/dark-notify',
    dependencies = {
      'folke/tokyonight.nvim',
    },
    lazy = false,
    enabled = true,
    priority = 1001,
    init = function()
      local wk = require 'which-key'
      wk.add {
        -- <leader>t = Toggle
        { '<leader>tt', '<cmd>:lua require("dark_notify").toggle()<CR>', desc = 'Toggle Dark Notify theme' },
      }

      local dn = require 'dark_notify'
      dn.run {
        schemes = {
          dark = 'tokyonight-storm',
          light = 'tokyonight-day',
        },
      }
      dn.update()
    end,
  },
  -- Clarify and beautify your comments using boxes and lines.
  -- https://github.com/LudoPinelli/comment-box.nvim
  {
    'LudoPinelli/comment-box.nvim',
    opts = {},
    init = function()
      local wk = require 'which-key'

      wk.add {
        { '<leader>cb', group = 'CommentBox' },
        { '<Leader>cbt', '<Cmd>CBccbox<CR>', desc = 'CommentBox: Box Title' },
        { '<Leader>cbd', '<Cmd>CBd<CR>', desc = 'Remove a box' },
        { '<Leader>cbl', '<Cmd>CBline<CR>', desc = 'CommentBox: Simple Line' },
        { '<Leader>cbm', '<Cmd>CBllbox14<CR>', desc = 'CommentBox: Marked' },
        { '<Leader>cbt', '<Cmd>CBllline<CR>', desc = 'CommentBox: Titled Line' },
      }
    end,
  },
  { 'wakatime/vim-wakatime', lazy = false, enabled = true },
  -- Neotree configuration
  {
    'nvim-neo-tree/neo-tree.nvim',
    opts = {
      filesystem = {
        filtered_items = {
          always_show = {
            '.github',
            '.gitignore',
            '.editorconfig',
            '.python-version',
            '.nvmrc',
            '.env',
            '.env.example',
            '.*rc',
            '.*.rc.*',
            '.stylua.*',
          },
        },
      },
    },
  },
  -- Cloak allows you to overlay *'s over defined patterns in defined files.
  -- https://github.com/laytan/cloak.nvim
  {
    'laytan/cloak.nvim',
    enabled = true,
    lazy = false,
    config = function()
      require('cloak').setup {
        enabled = true,
        cloak_character = '*',
        -- The applied highlight group (colors) on the cloaking, see `:h highlight`.
        highlight_group = 'Comment',
        patterns = {
          {
            -- Match any file starting with ".env".
            -- This can be a table to match multiple file patterns.
            file_pattern = {
              '.env*',
              'wrangler.toml',
              '.dev.vars',
            },
            -- Match an equals sign and any character after it.
            -- This can also be a table of patterns to cloak,
            -- example: cloak_pattern = { ":.+", "-.+" } for yaml files.
            cloak_pattern = '=.+',
          },
        },
      }
    end,
    keys = {
      { '<leader>tc', '<cmd>CloakToggle<cr>', desc = '[tc] Toggle Cloak' },
    },
  },
  -- Not UFO in the sky, but an ultra fold in Neovim.
  -- https://github.com/kevinhwang91/nvim-ufo/
  {
    'kevinhwang91/nvim-ufo',
    lazy = false,
    enabled = true,
    dependencies = {
      'kevinhwang91/promise-async',
      { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' },
      {
        'luukvbaal/statuscol.nvim',
        config = function()
          local builtin = require 'statuscol.builtin'
          require('statuscol').setup {
            relculright = true,
            segments = {
              { text = { builtin.foldfunc }, click = 'v:lua.ScFa' },
              { text = { '%s' }, click = 'v:lua.ScSa' },
              { text = { builtin.lnumfunc, ' ' }, click = 'v:lua.ScLa' },
            },
          }
        end,
      },
    },
    init = function()
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    opts = {
      open_fold_hl_timeout = 150,
      close_fold_kinds_for_ft = { 'imports', 'comment' },
      preview = {
        win_config = {
          border = { '', '─', '', '', '', '─', '', '' },
          winhighlight = 'Normal:Folded',
          winblend = 0,
        },
        mappings = {
          scrollU = '<C-u>',
          scrollD = '<C-d>',
          jumpTop = '[',
          jumpBot = ']',
        },
      },
      provider_selector = function(_, _, _) -- bufnr, filetype, buftype
        return { 'treesitter', 'indent' }
      end,
      fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end,
    },
  },
  -- Close buffer without messing up with the window.
  -- https://github.com/famiu/bufdelete.nvim
  { 'famiu/bufdelete.nvim' },
  -- Neovim plugin for locking a buffer to a window
  -- https://github.com/stevearc/stickybuf.nvim
  { 'stevearc/stickybuf.nvim', opts = {} },
  -- Automatically expand width of the current window.
  -- Maximizes and restore it. And all this with nice animations!
  -- https://github.com/anuvyklack/windows.nvim
  {
    'anuvyklack/windows.nvim',
    dependencies = {
      'anuvyklack/middleclass',
      'anuvyklack/animation.nvim',
    },
    config = function()
      vim.o.winwidth = 15
      vim.o.winminwidth = 10
      vim.o.equalalways = false
      require('windows').setup()
    end,
  },
}
