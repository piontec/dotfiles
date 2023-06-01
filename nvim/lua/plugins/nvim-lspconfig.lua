return {
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        bashls = {},
        dagger = {},
        dockerls = {},
        gopls = {},
        marksman = {},
        pyright = {},
        tflint = {},
        terraformls = {},
      },
    },
  },
}
