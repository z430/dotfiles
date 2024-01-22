local function applyFoldsAndThenCloseAllFolds(bufnr, providerName)
  require("async")(function()
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    -- make sure buffer is attached
    require("ufo").attach(bufnr)
    -- getFolds return Promise if providerName == 'lsp'
    local ok, ranges = pcall(await, require("ufo").getFolds(bufnr, providerName))
    if ok and ranges then
      ok = require("ufo").applyFolds(bufnr, ranges)
      if ok then
        require("ufo").closeAllFolds()
      end
    else
      local ranges = await(require("ufo").getFolds(bufnr, "indent"))
      local ok = require("ufo").applyFolds(bufnr, ranges)
      if ok then
        require("ufo").closeAllFolds()
      end
    end
  end)
end

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*",
  callback = function(e)
    applyFoldsAndThenCloseAllFolds(e.buf, "lsp")
  end,
})

return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = "kevinhwang91/promise-async",
    event = "VeryLazy",
    opts = {
      -- INFO: Uncomment to use tresitter as fold provider, otherwise nvim lsp is used
      provider_selector = function(bufnr, filetype, buftype)
        return { "lsp", "indent" }
      end,
      open_fold_hl_timeout = 400,
      close_fold_kinds = { "imports", "comments" },
      preview = {
        win_config = {
          border = { "", "─", "", "", "", "─", "", "" },
          -- winhighlight = "Normal:Folded",
          winblend = 0,
        },
        mappings = {
          scrollU = "<C-u>",
          scrollD = "<C-d>",
          jumpTop = "[",
          jumpBot = "]",
        },
      },
    },
    init = function()
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      vim.o.foldcolumn = "1" -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a larger value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,
    config = function(_, opts)
      require("ufo").setup(opts)
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
      vim.keymap.set("n", "K", function()
        local winid = require("ufo").peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end)
    end,
  },
}
