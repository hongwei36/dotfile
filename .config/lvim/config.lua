-- ================================== defaults ====================================
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.relativenumber = true

-- general
lvim.log.level = "info"
lvim.format_on_save = {
    enabled = true,
    pattern = "*.lua",
    timeout = 1000,
}

lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"

-- =================================== 基本设置 ===================================
-- 颜色方案
-- kanagawa-wave | kanagawa-dragon | kanagawa-lotus
-- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
lvim.colorscheme = "kanagawa-dragon"

-- 基于treesitter语法折叠
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- 默认不折叠代码
vim.opt.foldenable = false

-- =================================== 基本映射 ===================================
lvim.keys.visual_mode["q"] = "<Esc>"
lvim.keys.insert_mode["jk"] = "<Esc>"

-- 左右切换buffer
lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"

-- keymap ==> <space> + "
lvim.builtin.which_key.setup.plugins.registers = true

-- current filename
lvim.keys.insert_mode["<M-n>"] = "<C-R>=expand('%:t:r')<CR>"

-- ======================== toggleterm and telescope ==============================
-- 修改toggleterm显示位置，默认浮动float，这里改为屏幕正下方
lvim.builtin.terminal.direction = "horizontal"

-- telescope 弹窗鼠标移动
local _, actions = pcall(require, "telescope.actions")
lvim.builtin.telescope.defaults.mappings = {
    -- insert mode
    i = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
    },
    -- normal mode
    n = {
        ["<C-j>"] = actions.move_selection_next,
        ["<C-k>"] = actions.move_selection_previous,
    },
}

-- terminal 键位映射，主要解决命令行无法退出insert mode问题
---@diagnostic disable-next-line: duplicate-set-field
function _G.set_terminal_keymaps()
    vim.keymap.set('t', '<C-q>', [[<C-\><C-n>]], { buffer = 0 })
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://*toggleterm* lua set_terminal_keymaps()')

-- =================================== plugins =====================================
-- Additional Plugins
lvim.plugins = {
    -- colorscheme
    {
        "rebelot/kanagawa.nvim",
        config = function()
            require('kanagawa').setup {
                colors = {
                    palette = {
                        -- change all usages of these colors
                        waveBlue1 = "#2D4F67"
                    }
                }
            }
        end
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000
    },
    -- colorizer
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require('colorizer').setup()
        end
    },

    -- translator
    { "voldikss/vim-translator" },
    -- markdown-preview
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
    -- tmux
    { 'christoomey/vim-tmux-navigator' },

    -- rust-analyzer
    { "simrat39/rust-tools.nvim" },
    {
        'saecki/crates.nvim',
        tag = 'stable',
        config = function()
            require('crates').setup()
        end,
    },
    -- jdtls
    { "mfussenegger/nvim-jdtls" },
    -- Extensible UI for Neovim notifications and LSP progress messages.
    {
        "j-hui/fidget.nvim",
        opts = {},
    },
    {
        "jackMort/ChatGPT.nvim",
        event = "VeryLazy",
        config = function()
            require("chatgpt").setup()
        end,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "folke/trouble.nvim",
            "nvim-telescope/telescope.nvim"
        }
    },
    "ChristianChiarulli/swenv.nvim",
    "stevearc/dressing.nvim",
    "mfussenegger/nvim-dap-python",
    "nvim-neotest/nvim-nio",
    "nvim-neotest/neotest",
    "nvim-neotest/neotest-python",
}

-- ===================================== rust ======================================
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "rust_analyzer" })

-- codellde codelldb调试适配器
local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
local codelldb_adapter = {
    type = "server",
    port = "${port}",
    executable = {
        command = mason_path .. "bin/codelldb",
        args = { "--port", "${port}" },
    },
}

pcall(function()
    require("rust-tools").setup {
        tools = {
            executor = require("rust-tools/executors").termopen, -- can be quickfix or termopen
            reload_workspace_from_cargo_toml = true,
            runnables = {
                use_telescope = true,
            },
            inlay_hints = {
                auto = true,
                only_current_line = false,
                show_parameter_hints = false,
                parameter_hints_prefix = "<-",
                other_hints_prefix = "=>",
                max_len_align = false,
                max_len_align_padding = 1,
                right_align = false,
                right_align_padding = 7,
                highlight = "Comment",
            },
            hover_actions = {
                border = "rounded",
            },
            on_initialized = function()
                -- "CursorHold",
                vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "InsertLeave" }, {
                    pattern = { "*.rs" },
                    callback = function()
                        local _, _ = pcall(vim.lsp.codelens.refresh)
                    end,
                })
            end,
        },
        dap = {
            adapter = codelldb_adapter,
        },
        server = {
            on_attach = function(client, bufnr)
                require("lvim.lsp").common_on_attach(client, bufnr)
                local rt = require "rust-tools"
                vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
            end,

            capabilities = require("lvim.lsp").common_capabilities(),
            settings = {
                ["rust-analyzer"] = {
                    lens = {
                        enable = true,
                    },
                    checkOnSave = {
                        enable = true,
                        command = "clippy",
                    },
                },
            },
        },
    }
end)

-- rust debug配置
lvim.builtin.dap.on_config_done = function(dap)
    dap.adapters.codelldb = codelldb_adapter
    dap.configurations.rust = {
        {
            name = "Launch file",
            type = "codelldb",
            request = "launch",
            program = function()
                ---@diagnostic disable-next-line: redundant-parameter, param-type-mismatch
                return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
            args = { "Cargo.lock" },
        },
    }
end

-- 开启.toml文件代码提示
require("lspconfig").taplo.setup {}

-- ==================================== java =======================================
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "jdtls" })

lvim.builtin.dap.ui.config.layouts = {
    {
        elements = {
            { id = "scopes",      size = 0.33 },
            { id = "breakpoints", size = 0.17 },
            { id = "stacks",      size = 0.25 },
            { id = "watches",     size = 0.25 },
        },
        size = 0.20,
        position = "right",
    },
    {
        elements = {
            { id = "repl",    size = 0.35 },
            { id = "console", size = 0.65 },
        },
        size = 0.27,
        position = "bottom",
    },

}

-- =================================== python ======================================
-- automatically install python syntax highlighting
lvim.builtin.treesitter.ensure_installed = {
    "python",
}

-- setup formatting
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup { { name = "black" }, }
lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = { "*.py" }

-- setup linting
local linters = require "lvim.lsp.null-ls.linters"
linters.setup { { command = "flake8", filetypes = { "python" } } }

-- setup debug adapter
lvim.builtin.dap.active = true
pcall(function()
    require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
end)

-- setup testing
require("neotest").setup({
    adapters = {
        require("neotest-python")({
            -- Extra arguments for nvim-dap configuration
            -- See https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for values
            dap = {
                justMyCode = false,
                console = "integratedTerminal",
            },
            args = { "--log-level", "DEBUG", "--quiet" },
            runner = "pytest",
        })
    }
})

lvim.builtin.which_key.mappings["dm"] = { "<cmd>lua require('neotest').run.run()<cr>",
    "Test Method" }
lvim.builtin.which_key.mappings["dM"] = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>",
    "Test Method DAP" }
lvim.builtin.which_key.mappings["df"] = {
    "<cmd>lua require('neotest').run.run({vim.fn.expand('%')})<cr>", "Test Class" }
lvim.builtin.which_key.mappings["dF"] = {
    "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Test Class DAP" }
lvim.builtin.which_key.mappings["dS"] = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Test Summary" }


-- binding for switching
lvim.builtin.which_key.mappings["C"] = {
    name = "Python",
    c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Choose Env" },
}


-- =================================== autocmd =====================================
-- comment.nvim : json => jsonc
vim.api.nvim_create_autocmd("FileType", {
    pattern = "json",
    callback = function()
        vim.opt.filetype = "jsonc"
    end,
})

-- java
vim.api.nvim_create_autocmd("FileType", {
    pattern = "java",
    callback = function()
        vim.defer_fn(function()
            require('jdtls.dap').setup_dap_main_class_configs()
        end
        , 3000)
    end,
})

vim.api.nvim_create_autocmd("BufNewFile", {
    pattern = "*.java",
    callback = function()
        AppendJavaTemp()
    end
})

local api = require("nvim-tree.api")
api.events.subscribe(api.events.Event.FileCreated, function(file)
    vim.cmd("edit " .. file.fname)
    local fullpath = vim.fn.expand("%")
    local suffix = fullpath:match(".+%.(%w+)$")
    if suffix == 'java' then
        AppendJavaTemp()
    end
end)

function AppendJavaTemp()
    local fullpath = vim.fn.expand("%")
    local dir, filename = string.match(fullpath, ".*src/main/java/(.-)/([^/]+).java$")
    dir = string.gsub(dir, "/", ".")
    local dir_str = "package " .. dir .. ";"
    local class_str = "public class " .. filename .. " {"
    local lines = { dir_str, "", class_str, "    ", "}" }
    for i, line in ipairs(lines) do
        vim.api.nvim_call_function("append", { i - 1, line })
    end
end

-- ================================= translateW ===================================
vim.g['translator_proxy_url'] = 'socks5://127.0.0.1:1080'
lvim.builtin.which_key.mappings["t"] = {
    name = "Vim-translator",
    c = { "<cmd>Translate<cr>", "translate in cmdline" },
    t = { "<cmd>TranslateW<cr>", "translate in popup" },
    r = { "<cmd>TranslateR<cr>", "Replace the text with translation" },
    x = { "<cmd>TranslateX<cr>", "translate in clipboard" },
}
lvim.keys.visual_mode["<leader>c"] = "<Plug>TranslateV<CR>"
lvim.keys.visual_mode["<leader>t"] = "<Plug>TranslateWV<CR>"
lvim.keys.visual_mode["<leader>r"] = "<Plug>TranslateRV<CR>"

local chatgpt_mapping = {
    name = "ChatGPT",
    c = { "<cmd>ChatGPT<CR>", "ChatGPT" },
    e = { "<cmd>ChatGPTEditWithInstruction<CR>", "Edit with instruction" },
    g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction" },
    t = { "<cmd>ChatGPTRun translate<CR>", "Translate" },
    k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords" },
    d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring" },
    a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests" },
    o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code" },
    s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize" },
    f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs" },
    x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code" },
    r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit" },
    l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis" },

}

lvim.builtin.which_key.mappings["C"] = chatgpt_mapping
lvim.builtin.which_key.vmappings["C"] = chatgpt_mapping

-- ==================================== other =====================================
-- lemminx cache location
require('lspconfig').lemminx.setup({
    settings = {
        xml = {
            server = {
                workDir = "~/.cache/lemminx",
            }
        }
    }
})

-- ===================================== bug ======================================
-- nvimtree 修复打开文件对半分bug
lvim.builtin.nvimtree.setup.actions.open_file.resize_window = true

-- https://github.com/LunarVim/LunarVim/issues/4468
lvim.builtin.treesitter.context_commentstring = nil
