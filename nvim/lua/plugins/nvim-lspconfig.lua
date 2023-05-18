return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        bashls = {},
        gopls = {},
        marksman = {},
        pyright = {},
        tflint = {},
        terraformls = {},
      },
    },
  },
}
