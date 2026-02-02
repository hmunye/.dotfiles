vim.g.mapleader = " "
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.keymap.set("n", "-", vim.cmd.Ex)
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<C-h>", "<C-w><C-h>")
vim.keymap.set("n", "<C-l>", "<C-w><C-l>")
vim.keymap.set("n", "<C-j>", "<C-w><C-j>")
vim.keymap.set("n", "<C-k>", "<C-w><C-k>")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

vim.opt.mouse = "a"
vim.opt.guicursor = ""
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
vim.opt.colorcolumn = "80"
vim.opt.spelllang = "en_us"
vim.opt.spell = true
vim.opt.spellfile = os.getenv("HOME") .. "/.config/nvim/spell/en.add"

vim.pack.add({
    {
        src = "https://github.com/behemothbucket/gruber-darker-theme.nvim",
        name = "gruber-darker",
    },
    {
        src = "https://github.com/nvim-telescope/telescope.nvim",
        name = "nvim-telescope",
    },
    {
        src = "https://github.com/nvim-treesitter/nvim-treesitter",
        name = "nvim-treesitter",
        build = ":TSUpdate",
    },
    {
        src = "https://github.com/stevearc/oil.nvim",
        name = "oil-nvim",
    },
    {
        src = "https://github.com/mbbill/undotree",
        name = "undotree",
    },
    {
        src = "https://github.com/folke/zen-mode.nvim",
        name = "zen-mode",
    },
    -- dependencies
    {
        src = "https://github.com/nvim-lua/plenary.nvim",
        name = "plenary",
    },
})

vim.cmd("packadd gruber-darker")
vim.cmd("packadd nvim-telescope")
vim.cmd("packadd plenary")
vim.cmd("packadd nvim-treesitter")
vim.cmd("packadd oil-nvim")
vim.cmd("packadd undotree")
vim.cmd("packadd zen-mode")

require("gruber-darker").setup()
vim.cmd("colorscheme gruber-darker")
-- vim.api.nvim_set_hl(0, "Normal", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "NONE" })
-- vim.api.nvim_set_hl(0, "NormalNC", { bg = "NONE" })

require("telescope").setup({
    pickers = {
        find_files = {
            hidden = true,
        },
    },
})
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files)
vim.keymap.set("n", "<leader>fg", builtin.git_files)
vim.keymap.set("n", "<leader>fs", function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)


require("nvim-treesitter").setup({
    ensure_installed = {},
    sync_install = false,
    auto_install = true,
    indent = { enable = true },
    highlight = {
        enable = true,
        disable = function(_, buf)
            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
                vim.notify(
                    "File larger than 100KB treesitter disabled for performance",
                    vim.log.levels.WARN,
                    { title = "Treesitter" }
                )
                return true
            end
        end,
        additional_vim_regex_highlighting = { "markdown" },
    },
})

require("oil").setup({
    view_options = {
        show_hidden = true
    },
    float = {
        border = "rounded"
    },
    confirmation = {
        border = "rounded"
    },
})
vim.keymap.set("n", "-", "<CMD>Oil<CR>")

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

vim.keymap.set("n", "<leader>zz", function()
    require("zen-mode").setup {
        window = {
            width = 90,
            options = {}
        },
    }

    require("zen-mode").toggle()
    vim.wo.wrap = false
    vim.wo.number = true
    vim.wo.rnu = true
end)

vim.lsp.config["clangd"] = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    root_markers = { "" },
    settings = {}
}

vim.lsp.config["gopls"] = {
    cmd = { "gopls" },
    filetypes = { "go" },
    root_markers = { "go.mod" },
    settings = {}
}

vim.lsp.config["rust_analyzer"] = {
    cmd = { "rustup", "run", "stable", "rust-analyzer" },
    filetypes = { "rust" },
    root_markers = { "Cargo.toml" },
    settings = {
        ["rust_analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            procMacro = {
                enable = true
            }
        }
    }
}

vim.lsp.config["pyright"] = {
    cmd = { "pyright-langserver", "--stdio" },
    filetypes = { "python" },
    root_markers = { "" },
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true
            }
        }
    }
}

vim.lsp.enable({ "clangd", "gopls", "rust_analyzer", "pyright" })

vim.diagnostic.enable(not vim.diagnostic.is_enabled())

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local hm_group = augroup("HM", {})
local yank_group = augroup("HighlightYank", {})

autocmd("LspAttach", {
    group = hm_group,
    callback = function(e)
        local opts = { buffer = e.buf }

        vim.keymap.set("n", "gd", function()
            vim.lsp.buf.definition()
        end, opts)
        vim.keymap.set("n", "gr", function()
            vim.lsp.buf.references()
        end, opts)
        vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover({ border = "rounded" })
        end, opts)
        vim.keymap.set("n", "<leader>ws", function()
            vim.lsp.buf.workspace_symbol()
        end, opts)
        vim.keymap.set("n", "<leader>ca", function()
            vim.lsp.buf.code_action()
        end, opts)
        vim.keymap.set("n", "<leader>rn", function()
            vim.lsp.buf.rename()
        end, opts)
        vim.keymap.set("i", "<C-h>", function()
            vim.lsp.buf.signature_help({ border = "rounded" })
        end, opts)

        local client = vim.lsp.get_client_by_id(e.data.client_id)

        if not client then
            return
        end

        if client:supports_method("textDocument/formatting") then
            autocmd("BufWritePre", {
                buffer = e.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = e.buf, id = client.id })
                end,
            })
        end
    end,
})

autocmd("TextYankPost", {
    group = yank_group,
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 40,
        })
    end,
})
