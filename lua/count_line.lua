local M = {}

function M.count_lines()
    print("Debug: count_lines triggered")  -- Message de débogage

    local buffer_id = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(buffer_id, -1, 0, -1)
    local lines = vim.api.nvim_buf_get_lines(buffer_id, 0, -1, false)
    local trigger = 0
    local ligne_debut = nil

    for i, line in ipairs(lines) do
        if line:match("^{$") then
            trigger = 1
            ligne_debut = i
            print("Debug: Start bracket found at line", i)  -- Message de débogage
        elseif line:match("^}$") and trigger == 1 then
            trigger = 0
            local nbr_lignes = i - ligne_debut - 1
            print("Debug: End bracket found at line", i, "Number of lines:", nbr_lignes)  -- Message de débogage
            vim.api.nvim_buf_set_virtual_text(buffer_id, -1, i, {{ "//------" .. nbr_lignes .. " lignes------", "Comment" }}, {})
        end
    end
end

vim.api.nvim_create_autocmd({"BufEnter", "BufRead", "TextChanged", "TextChangedI", "BufWritePost"}, {
    pattern = "*",
    callback = M.count_lines
})

return M
