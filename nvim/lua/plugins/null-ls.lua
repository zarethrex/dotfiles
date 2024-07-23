return {
  "jose-elias-alvarez/null-ls.nvim",
  config = function()
    local null_ls = require("null-ls")
    local lfs = require("lfs")

    -- Function to check if .venv directory exists
    local function check_venv_directory()
      local path = ".venv"
      local attr = lfs.attributes(path)
      return attr and attr.mode == "directory"
    end

    -- Function to get the current Python executable
    local function get_python_executable()
      local handle = io.popen("which python 2>&1") -- For Unix-like systems
      -- For Windows, use: local handle = io.popen("where python 2>&1")
      local result = handle:read("*a")
      handle:close()
      return result:match("^%s*(.-)%s*$") -- Trim any leading or trailing whitespace
    end

    -- Function to get the Python executable from the .venv directory
    local function get_venv_python_executable()
      local venv_python
      if package.config:sub(1, 1) == "\\" then
        venv_python = ".venv\\Scripts\\python.exe" -- Windows
      else
        venv_python = ".venv/bin/python" -- Unix-like systems
      end

      local attr = lfs.attributes(venv_python)
      return attr and attr.mode == "file" and venv_python or nil
    end

    local venv_python = get_venv_python_executable()

    -- Using ternary-like approach
    local result = venv_python and venv_python or get_python_executable()

    null_ls.setup({
      sources = {
        null_ls.builtins.diagnostics.mypy.with({
          extra_args = {
            "--python-executable=" .. result,
          },
        }),
        null_ls.builtins.diagnostics.cppcheck,
        null_ls.builtins.diagnostics.cpplint,
        null_ls.builtins.formatting.ruff,
      },
    })
  end,
}
