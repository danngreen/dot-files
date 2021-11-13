vim.cmd[[
hi BufferCurrent guifg=#080808 guibg=#e6db74
hi BufferCurrentIndex guifg=#080808 guibg=#e6db74
hi BufferCurrentSign guifg=grey guibg=#e6db74
hi BufferCurrentMod guifg=#080808 guibg=#e6db74
hi BufferCurrentTarget guifg=red guibg=#e6db74
hi BufferVisible guifg=#080808 guibg=#808080
hi BufferVisibleIndex guifg=#080808 guibg=#808080
hi BufferVisibleSign guifg=#080808 guibg=#808080
hi BufferVisibleMod guifg=#080808 guibg=#808080
hi BufferVisibleTarget guifg=red guibg=#808080
hi BufferInactive guifg=grey guibg=#080808
hi BufferInactiveIndex guifg=grey guibg=#080808
hi BufferInactiveSign guifg=grey guibg=#080808
hi BufferInactiveMod guifg=grey guibg=#080808
hi BufferInactiveTarget guifg=red guibg=#080808
hi BufferTabpageFill guibg=#080808
hi Visual guibg=#803D3D
hi MatchParen term=bold cterm=bold gui=bold,underline guibg=#446644 guifg=red
hi Search guibg=#94FFF9
hi IncSearch guibg=#D6B000
hi! TelescopeMatching guifg=red
hi! TelescopePromptBorder guifg=cyan

hi diffAdded guibg=#447744 
hi diffRemoved guibg=#774444
hi! ErrorMsg guifg=#F92622 guibg=#232526 gui=none
hi! WarningMsg guifg=#FD971F guibg=#232526 gui=none
hi! InfoMsg guifg=#E6DB74 guibg=#232526 gui=none 
hi! HintMsg guifg=#A6E22E guibg=#232526 gui=none 
hi! link LspDiagnosticsVirtualTextError ErrorMsg
hi! link LspDiagnosticsVirtualTextWarning WarningMsg
hi! link LspDiagnosticsVirtualTextInformation InfoMsg
hi! link LspDiagnosticsVirtualTextHint HintMsg
hi! link DiagnosticsVirtualTextError ErrorMsg
hi! link DiagnosticsVirtualTextWarning WarningMsg
hi! link DiagnosticsVirtualTextInformation InfoMsg
hi! link DiagnosticsVirtualTextHint HintMsg
hi LspSignatureActiveParameter guifg=red
hi! LspReferenceText guibg=#433536

hi Pmenu guibg=#434546 
]]
