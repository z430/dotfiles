return {
  {
    "linux-cultist/venv-selector.nvim",
    opts = {
      auto_refresh = true,
      anaconda_base_path = "$HOME/miniconda3/",
      anaconda_envs_path = "$HOME/miniconda3/envs/",
      anaconda = { python_parent_dir = "" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pyright = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "openFilesOnly",
              useLibraryCodeForTypes = true,
            },
          },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "bash",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "markdown_inline",
        "python",
        "typescript",
        "vim",
        "yaml",
      },
    },
  },
}
