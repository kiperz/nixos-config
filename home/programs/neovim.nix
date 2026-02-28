{ config, pkgs, ... }:

{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # General settings
    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      tabstop = 2;
      expandtab = true;
      smartindent = true;
      wrap = false;
      termguicolors = true;
      signcolumn = "yes";
      scrolloff = 8;
      sidescrolloff = 8;
      cursorline = true;
      splitbelow = true;
      splitright = true;
      ignorecase = true;
      smartcase = true;
      updatetime = 250;
      timeoutlen = 300;
      undofile = true;
      clipboard = "unnamedplus";
      mouse = "a";
      showmode = false; # Lualine shows it
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # Keymaps
    keymaps = [
      # Better window navigation
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; options.desc = "Focus left window"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; options.desc = "Focus below window"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; options.desc = "Focus above window"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; options.desc = "Focus right window"; }

      # Buffer navigation
      { mode = "n"; key = "<S-l>"; action = ":bnext<CR>"; options.desc = "Next buffer"; }
      { mode = "n"; key = "<S-h>"; action = ":bprevious<CR>"; options.desc = "Previous buffer"; }
      { mode = "n"; key = "<leader>bd"; action = ":bdelete<CR>"; options.desc = "Delete buffer"; }

      # Clear search highlight
      { mode = "n"; key = "<Esc>"; action = ":noh<CR>"; options.desc = "Clear highlights"; }

      # Better indenting
      { mode = "v"; key = "<"; action = "<gv"; }
      { mode = "v"; key = ">"; action = ">gv"; }

      # Move lines
      { mode = "v"; key = "J"; action = ":m '>+1<CR>gv=gv"; options.desc = "Move line down"; }
      { mode = "v"; key = "K"; action = ":m '<-2<CR>gv=gv"; options.desc = "Move line up"; }

      # Neo-tree
      { mode = "n"; key = "<leader>e"; action = ":Neotree toggle<CR>"; options.desc = "Toggle file tree"; }

      # Telescope
      { mode = "n"; key = "<leader>ff"; action = "<cmd>Telescope find_files<CR>"; options.desc = "Find files"; }
      { mode = "n"; key = "<leader>fg"; action = "<cmd>Telescope live_grep<CR>"; options.desc = "Live grep"; }
      { mode = "n"; key = "<leader>fb"; action = "<cmd>Telescope buffers<CR>"; options.desc = "Find buffers"; }
      { mode = "n"; key = "<leader>fh"; action = "<cmd>Telescope help_tags<CR>"; options.desc = "Help tags"; }
      { mode = "n"; key = "<leader>fr"; action = "<cmd>Telescope oldfiles<CR>"; options.desc = "Recent files"; }
      { mode = "n"; key = "<leader>fd"; action = "<cmd>Telescope diagnostics<CR>"; options.desc = "Diagnostics"; }

      # Trouble
      { mode = "n"; key = "<leader>xx"; action = "<cmd>Trouble diagnostics toggle<CR>"; options.desc = "Diagnostics"; }
      { mode = "n"; key = "<leader>xl"; action = "<cmd>Trouble loclist toggle<CR>"; options.desc = "Location list"; }
      { mode = "n"; key = "<leader>xq"; action = "<cmd>Trouble quickfix toggle<CR>"; options.desc = "Quickfix"; }

      # LSP
      { mode = "n"; key = "gd"; action = "<cmd>lua vim.lsp.buf.definition()<CR>"; options.desc = "Go to definition"; }
      { mode = "n"; key = "gr"; action = "<cmd>lua vim.lsp.buf.references()<CR>"; options.desc = "References"; }
      { mode = "n"; key = "gi"; action = "<cmd>lua vim.lsp.buf.implementation()<CR>"; options.desc = "Implementation"; }
      { mode = "n"; key = "K"; action = "<cmd>lua vim.lsp.buf.hover()<CR>"; options.desc = "Hover"; }
      { mode = "n"; key = "<leader>ca"; action = "<cmd>lua vim.lsp.buf.code_action()<CR>"; options.desc = "Code action"; }
      { mode = "n"; key = "<leader>rn"; action = "<cmd>lua vim.lsp.buf.rename()<CR>"; options.desc = "Rename"; }
      { mode = "n"; key = "[d"; action = "<cmd>lua vim.diagnostic.goto_prev()<CR>"; options.desc = "Previous diagnostic"; }
      { mode = "n"; key = "]d"; action = "<cmd>lua vim.diagnostic.goto_next()<CR>"; options.desc = "Next diagnostic"; }
    ];

    # ── Plugins ───────────────────────────────────────────────

    # Treesitter
    plugins.treesitter = {
      enable = true;
      settings.ensure_installed = [
        "nix" "lua" "go" "rust" "typescript" "javascript" "kotlin" "python"
        "bash" "fish" "json" "yaml" "toml" "markdown" "html" "css" "sql"
        "dockerfile" "gitcommit" "diff" "vim" "vimdoc" "regex"
      ];
      settings.highlight.enable = true;
      settings.indent.enable = true;
    };

    # Telescope
    plugins.telescope = {
      enable = true;
      extensions.fzf-native.enable = true;
    };

    # LSP
    plugins.lsp = {
      enable = true;
      servers = {
        nil_ls.enable = true; # Nix
        lua_ls.enable = true; # Lua
        gopls.enable = true; # Go
        rust_analyzer = {
          enable = true;
          installCargo = true;
          installRustc = true;
        };
        ts_ls.enable = true; # TypeScript
        kotlin_language_server.enable = true; # Kotlin
        pyright.enable = true; # Python
      };
    };

    # Completion
    plugins.cmp = {
      enable = true;
      settings = {
        sources = [
          { name = "nvim_lsp"; }
          { name = "luasnip"; }
          { name = "path"; }
          { name = "buffer"; }
        ];
        mapping = {
          "<C-n>" = "cmp.mapping.select_next_item()";
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-Space>" = "cmp.mapping.complete()";
          "<C-e>" = "cmp.mapping.close()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
        };
      };
    };
    plugins.cmp-nvim-lsp.enable = true;
    plugins.cmp-buffer.enable = true;
    plugins.cmp-path.enable = true;
    plugins.luasnip.enable = true;
    plugins.cmp_luasnip.enable = true;

    # Conform (formatting)
    plugins.conform-nvim = {
      enable = true;
      settings = {
        format_on_save = {
          timeout_ms = 500;
          lsp_format = "fallback";
        };
        formatters_by_ft = {
          nix = [ "nixfmt" ];
          go = [ "gofmt" "goimports" ];
          rust = [ "rustfmt" ];
          typescript = [ "prettier" ];
          javascript = [ "prettier" ];
          python = [ "ruff_format" ];
          lua = [ "stylua" ];
          json = [ "prettier" ];
          yaml = [ "prettier" ];
          markdown = [ "prettier" ];
          "_" = [ "trim_whitespace" ];
        };
      };
    };

    # Git signs
    plugins.gitsigns = {
      enable = true;
      settings.current_line_blame = true;
    };

    # Which-key
    plugins.which-key = {
      enable = true;
      settings.spec = [
        { __unkeyed-1 = "<leader>f"; group = "Find"; }
        { __unkeyed-1 = "<leader>b"; group = "Buffer"; }
        { __unkeyed-1 = "<leader>x"; group = "Trouble"; }
        { __unkeyed-1 = "<leader>c"; group = "Code"; }
        { __unkeyed-1 = "<leader>r"; group = "Rename"; }
      ];
    };

    # Lualine (status line)
    plugins.lualine = {
      enable = true;
      settings.options = {
        theme = "auto";
        component_separators = { left = "│"; right = "│"; };
        section_separators = { left = ""; right = ""; };
      };
    };

    # Neo-tree (file explorer)
    plugins.neo-tree = {
      enable = true;
      settings = {
        close_if_last_window = true;
        filesystem = {
          follow_current_file.enabled = true;
          hijack_netrw_behavior = "open_current";
          filtered_items = {
            visible = true;
            hide_dotfiles = false;
            hide_gitignored = true;
          };
        };
      };
    };

    # Trouble (diagnostics panel)
    plugins.trouble.enable = true;

    # mini.nvim modules
    plugins.mini = {
      enable = true;
      modules = {
        pairs = {}; # Auto-close brackets
        surround = {}; # Surround motions
        comment = {}; # gcc to comment
        indentscope = { symbol = "│"; }; # Indent guides
        cursorword = {}; # Highlight word under cursor
      };
    };

    # DAP (Debug Adapter Protocol)
    plugins.dap.enable = true;
    plugins.dap-ui.enable = true;
    plugins.dap-virtual-text.enable = true;

    # Misc
    plugins.web-devicons.enable = true;
    plugins.indent-blankline.enable = true;
    plugins.sleuth.enable = true; # Auto-detect indent
    plugins.todo-comments.enable = true;
  };
}
