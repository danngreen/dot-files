let g:clang_format#auto_format = 1
let g:clang_format#detect_style_file = 1
let g:clang_format#enable_fallback_style = 1
let g:clang_format#style_options = {
\ "BasedOnStyle" : "LLVM",
\ "Standard" : "c++17",
\ "UseTab" : "Always",
\ "TabWidth" :  4,
\ "IndentWidth" :  4,
\ "ColumnLimit" :  0,
\ "AccessModifierOffset" :  "-4",
\ "AlignAfterOpenBracket" : "Align",
\ "AlignEscapedNewlines" : "Left",
\ "AlignOperands" : "AlignAfterOperator",
\ "AllowAllArgumentsOnNextLine" : "true",
\ "AllowShortBlocksOnASingleLine" : "true",
\ "AllowShortFunctionsOnASingleLine" : "All",
\ "AllowShortIfStatementsOnASingleLine" : "Never",
\ "AlwaysBreakTemplateDeclarations" : "true",
\ "BinPackArguments" :  "false",
\ "BinPackParameters" :  "false",
\ "BreakBeforeBraces" : "Custom",
\ "BraceWrapping" : { 
	\ "AfterCaseLabel" :  "false",
	\ "AfterClass" :  "false",
	\ "AfterControlStatement" :  "MultiLine",
	\ "AfterEnum" :  "false",
	\ "AfterFunction" :  "false",
	\ "AfterNamespace" :  "true",
	\ "AfterStruct" :  "false",
	\ "AfterUnion" :  "false",
	\ "AfterExternBlock" :  "false",
	\ "BeforeCatch" :  "false",
	\ "BeforeElse" :  "false",
	\ "IndentBraces" :  "false",
	\ "SplitEmptyFunction" :  "false",
	\ "SplitEmptyRecord" :  "false",
	\ "SplitEmptyNamespace" :  "false",
\ },
\ "BreakBeforeTernaryOperators" : "false",
\ "BreakConstructorInitializers" : "BeforeComma",
\ "BreakInheritanceList" : "AfterColon",
\ "ConstructorInitializerIndentWidth" :  4,
\ "ContinuationIndentWidth" : 4,
\ "IndentCaseLabels" : "true",
\ "IndentPPDirectives" : "BeforeHash",
\ "SpaceAfterCStyleCast" : "false",
\ "SpaceAfterTemplateKeyword" : "false",
\ "SpaceBeforeAssignmentOperators" : "true",
\ "SpaceBeforeCtorInitializerColon" : "true",
\ "SpaceBeforeInheritanceColon" : "true",
\ "SpaceBeforeParens" : "ControlStatements",
\ "SpaceBeforeRangeBasedForLoopColon" : "true",
\ "SpaceInEmptyParentheses" : "false",
\ "SpacesInAngles" : "false",
\ "SpacesInCStyleCastParentheses" : "false",
\ }