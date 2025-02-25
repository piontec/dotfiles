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
        kcl = {},
        marksman = {},
        pyright = {},
        tflint = {},
        terraformls = {},
        helm_ls = {
          yamlls = {
            settings = {
              path = "yaml-language-server",
            },
          },
        },
      },
    },
  },
}
