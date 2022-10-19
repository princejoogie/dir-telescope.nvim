# dir-telescope.nvim

grep or find files in selected directory with telescope

https://user-images.githubusercontent.com/47204120/196644189-ceb442bd-9528-4069-89dc-511ab1c98788.mp4

## Usage

dir-telescope creates two user commands `:GrepInDirectory` and `:FileInDirectory` which you can map to any liking you want

hit the `Tab` key to select multiple directories

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

```lua
vim.keymap.set("n", "<leader>fd", "<cmd>GrepInDirectory<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>pd", "<cmd>FileInDirectory<CR>", { noremap = true, silent = true })
```

---

Made by Prince Carlo Juguilon
