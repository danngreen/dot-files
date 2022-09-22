local M={}

M.config = {
    languages = {
        c = { compiler = "arm1121", options = {} },
        cpp = { compiler = "arm1121",
			options = {
			-- userArguments = "-mfloat-abi=hard -mthumb-interwork -mno-unaligned-access -funsafe-math-optimizations -Ofast -mfpu=fpv5-d16 -mcpu=cortex-m7"
			userArguments = "-std=c++20 -mfloat-abi=hard -mthumb-interwork -mno-unaligned-access -funsafe-math-optimizations -Ofast -mvectorize-with-neon-quad -mfpu=neon-vfpv4 -mtune=cortex-a7 -mcpu=cortex-a7"
		} },
    },
    quickfix = {
        enable = true,
        auto_open = true
    },
    url = "https://godbolt.org"
}

return M

