# dir-telescope.nvim

grep or find files in selected directory with telescope

## Usage

- [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use({
  "princejoogie/dir-telescope.nvim",
  -- telescope.nvim is a required dependency
  requires = {"nvim-telescope/telescope.nvim"},
  config = function()
    require("dir-telescope").setup({
      hidden = true,
      respect_gitignore = true,
    })
  end,
})
```

### Setting keymaps

dir-telescope creates two user commands `:GrepInDirectory` and `:FileInDirectory` which you can map to any liking you want

```lua
vim.keymap.set("n", "<leader>fd", "<cmd>GrepInDirectory<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>pd", "<cmd>FileInDirectory<CR>", { noremap = true, silent = true })
```

---

Made by Prince Carlo Juguilon
