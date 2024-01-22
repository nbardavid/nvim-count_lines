local M = {}
M.active = true

function M.desa()	
	M.active=false
end

function M.acti()
	M.active=true
end

function M.count_lines()

	if M.active==false then
		return
	end
    local buffer_id = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(buffer_id, -1, 0, -1)
    local lines = vim.api.nvim_buf_get_lines(buffer_id, 0, -1, false)
    local trigger = 0
    local ligne_debut = nil
    for i, line in ipairs(lines) do
        if line:match("^{$") then
            trigger = 1
            ligne_debut = i
        elseif line:match("^}$") and trigger == 1 then
            trigger = 0
            local nbr_lignes = i - ligne_debut - 1
			if nbr_lignes > 25 then
				vim.api.nvim_buf_set_virtual_text(buffer_id, -1, i - 1, {{ "//------" .. nbr_lignes .. " lines /!\\ ------", "Comment" }}, {})
			else
				vim.api.nvim_buf_set_virtual_text(buffer_id, -1, i - 1, {{ "//------" .. nbr_lignes .. " lines------", "Comment" }}, {})
			end
        end
    end
end

vim.api.nvim_set_keymap('n', '<leader>cls', ':lua require("nvim-count_lines").acti()<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>clh', ':lua require("nvim-count_lines").desa()<CR>', { noremap = true, silent = true })
vim.api.nvim_create_autocmd({"BufEnter", "BufRead", "TextChanged", "TextChangedI", "BufWritePost"}, {
    pattern = "*",
    callback = M.count_lines
})

return M
