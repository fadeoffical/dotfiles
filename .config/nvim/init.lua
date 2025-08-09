-- Set space as leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- tell vim that nerd font is installed
vim.g.have_nerd_font = true

-- show line numbers
vim.o.number = true

-- sync os and nvim clip
vim.schedule(function() vim.o.clipboard = "unnamedplus" end)

-- keep indentation for broken up lines
vim.o.breakindent = true

-- save undo steps
vim.o.undofile = true

-- case-insensitive search
vim.o.ignorecase = true
vim.o.smartcase = true

-- always show signcolum (warnings, etc. before line numbers)
vim.o.signcolumn = "yes"

-- decrease updatetime (time until nvim deems the cursor to not be moving)
vim.o.updatetime = 300

-- spit to bottom and right (more like tmux)
vim.o.splitright = true
vim.o.splitbelow = true

-- display whitespace at end of line
vim.o.list = true
vim.opt.listchars = { tab = "→ ", trail = ".", nbsp = "_" }

-- substitution previews
vim.o.inccommand = "split"

-- display cursor line
vim.o.cursorline = true

-- number of lines before and above the cursor
vim.o.scrolloff = 8

-- ask whether to save file if command would result in buffer loss
vim.o.confirm = true

-- clear search highlight when pressing <Esc> in normal mode
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- make nvim use spaces instead of tabs
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.smarttab = true
vim.o.expandtab = true

-- install lazy.nvim
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system { "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        error("Error cloning lazy.nvim:\n" .. out)
    end
end

local rtp = vim.opt.rtp
rtp:prepend(lazypath)

require("lazy").setup({
    {
        "nvim-telescope/telescope.nvim",
        event = "VimEnter",
        dependencies = {
            {
                "nvim-lua/plenary.nvim"
            },
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                cond = function() return vim.fn.executable "make" == 1 end
            },
            {
                "nvim-telescope/telescope-ui-select.nvim"
            },
            {
                "nvim-tree/nvim-web-devicons",
                enabled = vim.g.have_nerd_font
            }
        },
        config = function()
            require("telescope").setup {
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown()
                    }
                }
            }

            pcall(require("telescope").load_extension, "fzf")
            pcall(require("telescope").load_extension, "ui-select")

            local builtin = require("telescope.builtin")
            vim.keymap.set('n', '<leader>sh', builtin.help_tags)
            vim.keymap.set('n', '<leader>sk', builtin.keymaps)
            vim.keymap.set('n', '<leader>sf', builtin.find_files)
            vim.keymap.set('n', '<leader>ss', builtin.builtin)
            vim.keymap.set('n', '<leader>sw', builtin.grep_string)
            vim.keymap.set('n', '<leader>sg', builtin.live_grep)
            vim.keymap.set('n', '<leader>sd', builtin.diagnostics)
            vim.keymap.set('n', '<leader>sr', builtin.resume)
            vim.keymap.set('n', '<leader>s.', builtin.oldfiles)
            vim.keymap.set('n', '<leader><leader>', builtin.buffers)
        end
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                {
                    path = "${3rd}/luv/library",
                    words = { "vim%.uv" }
                }
            }
        }
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            {
                "mason-org/mason.nvim",
                opts = {}
            },
            {
                "mason-org/mason-lspconfig.nvim"
            },
            {
                "WhoIsSethDaniel/mason-tool-installer.nvim"
            },
            {
                "j-hui/fidget.nvim",
                opts = {}
            },
            {
                "saghen/blink.cmp"
            }
        },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
                callback = function()
                    vim.keymap.set("n", "lrn", vim.lsp.buf.rename)
                    vim.keymap.set({ "n", "x" }, "l.", vim.lsp.buf.code_action)
                    vim.keymap.set("n", "lrf", require("telescope.builtin").lsp_references)
                    vim.keymap.set("n", "lri", require("telescope.builtin").lsp_implementations)
                    vim.keymap.set("n", "lrd", require("telescope.builtin").lsp_definitions)
                    vim.keymap.set("n", "lrc", vim.lsp.buf.declaration)
                    vim.keymap.set("n", "lS", require("telescope.builtin").lsp_document_symbols)
                    vim.keymap.set("n", "lW", require("telescope.builtin").lsp_dynamic_workspace_symbols)
                    vim.keymap.set("n", "lrt", require("telescope.builtin").lsp_type_definitions)
                end
            })

            vim.diagnostic.config({
                severity_sort = true,
                underline = { severity = vim.diagnostic.severity.WARN },
                signs = vim.g.have_nerd_font and {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '󰅚 ',
                        [vim.diagnostic.severity.WARN] = '󰀪 ',
                        [vim.diagnostic.severity.INFO] = '󰋽 ',
                        [vim.diagnostic.severity.HINT] = '󰌶 ',
                    },
                } or {},
            })
        end
    }
})

