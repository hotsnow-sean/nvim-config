# Nvim configuration

personal nvim configuration file.

---

## Structure

```shell
lua
├── config
│   ├── cmp_color.lua   # some prefefine color
│   ├── init.lua        # load other config
│   ├── keymaps.lua     # key mappings
│   ├── lazy.lua        # load lazy plugin
│   └── options.lua     # basic options
└── plugins
    ├── coding.lua      # auto completion & format
    ├── editor.lua      # auto pairs & comment & terminal & git signs
    ├── lsp.lua         # language server protocol
    ├── telescope.lua   # telescope
    ├── treesitter.lua  # treesitter
    └── ui.lua          # status line & buffer line & file explorer
```

## Mappings

+ `<TAB>`, `<S-TAB>`: prev or next buffer
+ `<F7>`: toggle file explorer
+ `<F8>`: toggle terminal
+ `<space>fm`: format current buffer
+ `<space>ff`: search file in workspace
+ `<space>fg`: search word in workspace
+ `<space><space>`: search word in current buffer
+ `<space>gg`: open lazygit terminal
+ `[d`, `]d`: prev or next diagnostic
+ `[h`, `]h`: prev or next modify (git)
