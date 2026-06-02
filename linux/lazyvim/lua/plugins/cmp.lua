return {
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      local cmp = require("cmp")

      -- Define mapping functions for better readability
      local select_next_item = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      local select_prev_item = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
      -- local tab_mapping = cmp.mapping(function(fallback)
      --   if cmp.visible() then
      --     local entry = cmp.get_selected_entry()
      --     if not entry then
      --       cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
      --     else
      --       cmp.confirm({ select = true })
      --     end
      --   else
      --     fallback()
      --   end
      -- end, { "i" })

      -- Extend existing mappings with new mappings
      opts.mapping = vim.tbl_extend("force", opts.mapping, {
        ["<C-j>"] = select_next_item,
        ["<C-k>"] = select_prev_item,
        -- ["<Tab>"] = tab_mapping,
      })
    end,
  },
}
