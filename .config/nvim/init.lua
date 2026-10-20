vim.g.mapleader = " "

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.keymap.set("n", "-", vim.cmd.Ex, { silent = true })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.opt.mouse = ""
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
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.wrap = false
vim.opt.swapfile = true
vim.opt.directory = os.getenv("HOME") .. "/.vim/swap//"
vim.opt.backup = false
vim.opt.undofile = true
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.schedule(function()
    vim.opt.clipboard = 'unnamedplus'
end)
vim.opt.scrolloff = 10
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.timeoutlen = 300
vim.opt.colorcolumn = "80"
vim.opt.termguicolors = true

vim.opt.spelllang = "en_us"
vim.opt.spell = true
vim.opt.spellfile = os.getenv("HOME") .. "/.config/nvim/spell/en.add"

vim.pack.add({
--    {
--        src = "https://github.com/nvim-lua/plenary.nvim",
--        name = "plenary",
--    },
--    {
--        src = "https://github.com/nvim-telescope/telescope.nvim",
--        name = "nvim-telescope",
--    },
    {
        src = "https://github.com/behemothbucket/gruber-darker-theme.nvim",
        name = "gruber-darker",
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
})

-- vim.cmd("packadd plenary")
-- vim.cmd("packadd nvim-telescope")
vim.cmd("packadd gruber-darker")
vim.cmd("packadd oil-nvim")
vim.cmd("packadd undotree")
vim.cmd("packadd zen-mode")

-- ===============  colorscheme  ===================

local palette = require("gruber-darker.palette")

palette.gruber_darker_fg = "#d5d2dc"
palette.gruber_darker_fg_1 = "#e0dde6"
palette.gruber_darker_red = "#d56b70"
palette.gruber_darker_red_p1 = "#e0787c"
palette.gruber_darker_green = "#91b477"
palette.gruber_darker_yellow = "#d9c16b"
palette.gruber_darker_brown = "#bd9b6c"
palette.gruber_darker_quartz = "#9aaa9f"
palette.gruber_darker_niagara = "#8e9db8"
palette.gruber_darker_niagara_m1 = "#626d82"
palette.gruber_darker_wisteria = "#a29abd"

require("gruber-darker").setup()
vim.cmd("colorscheme gruber-darker")

for _, group in ipairs({ "Normal", "MsgArea", "NonText", "SignColumn", "LineNr" }) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    hl.bg = nil

    vim.api.nvim_set_hl(0, group, vim.tbl_extend("force", hl, { bg = "NONE" }))
end

-- ===============  oil  ===================

require("oil").setup({
    columns = {
        "permissions",
        "size",
        -- "mtime",
    },
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

-- ===============  undotree  ===================

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)

-- ===============  zen-mode  ===================

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

-- ===============  lsp  ===================

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

vim.lsp.config["clangd"] = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp" },
    root_markers = { "" },
    settings = {}
}

vim.lsp.enable({ "rust_analyzer", "clangd" })
vim.diagnostic.enable(not vim.diagnostic.is_enabled())

-- ===============  autocmds  ===================

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
            timeout = 50,
        })
    end,
})
