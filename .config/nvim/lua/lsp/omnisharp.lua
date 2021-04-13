local pid = vim.fn.getpid()

local omnisharp_bin = DATA_PATH .. "/lspinstall/omnisharp/run"

require'lspconfig'.omnisharp.setup{
    cmd ={ omnisharp_bin, "--languageserver", "--hostPID", tostring(pid) }
}
