# dir-telescope.nvim

Perform [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) functions in selected directories

https://user-images.githubusercontent.com/47204120/196644189-ceb442bd-9528-4069-89dc-511ab1c98788.mp4

## Installation

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

## Usage

1. `dir-telescope` creates two user commands `:GrepInDirectory` and `:FileInDirectory` which you can map to any liking you want.
2. the commands will open a telescope picker with the list of directories in your current working directory.
3. you can select a directory by hitting `Enter` or select multiple directories to filter with `Tab`
4. it will then perform either a `live_grep` or `find_files` on your selected directories
5. `(tip)`: `<C-q>` will save your queries in a quickfix list. this is the default binding for `telescope.nvim`

### Setting keymaps

```lua
vim.keymap.set("n", "<leader>fd", "<cmd>GrepInDirectory<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "<leader>pd", "<cmd>FileInDirectory<CR>", { noremap = true, silent = true })
```

### Contributing

Intructions for contributing is documented in th [CONTRIBUTING.md](./CONTRIBUTING.md) guide

---

Made with ☕ by Prince Carlo Juguilon
