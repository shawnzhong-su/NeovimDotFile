# LSP 模块化配置

这个模块化的 LSP 配置结构旨在提高代码的可维护性和扩展性。

## 文件结构

```
lua/plugins/lsp/
├── init.lua              # 主配置文件
├── capabilities.lua      # LSP capabilities 配置
├── utils.lua            # 工具函数
├── servers/
│   ├── init.lua         # 服务器配置入口
│   ├── python.lua       # Python (Pyright, Ruff)
│   ├── typescript.lua   # TypeScript/JavaScript
│   ├── vue.lua          # Vue.js
│   └── toml.lua         # TOML
└── README.md           # 说明文档

lua/config/
└── treesitter.lua       # TreeSitter 配置
```

## 使用方法

在您的 LazyVim 插件配置中，确保引入这些配置：

```lua
-- 在您的 plugins 目录中或 init.lua 中
return {
  require("plugins.lsp"),
  require("config.treesitter"),
}
```

## 添加新的语言支持

1. 在 `servers/` 目录中创建新的语言配置文件
2. 在 `servers/init.lua` 中导入并添加到配置中
3. 如需要，在 `config/treesitter.lua` 中添加相应的解析器

## 修改现有配置

直接编辑对应语言的配置文件即可，例如修改 Python 配置就编辑 `servers/python.lua`。

## 注意事项

- 所有配置都保持了原有的功能
- 如果遇到问题，检查备份目录中的原始配置
- 可以根据需要调整各个模块的配置
