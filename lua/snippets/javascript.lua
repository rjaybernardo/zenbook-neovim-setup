-- ==========================================================================
-- CUSTOM JS / TS / REACT SNIPPETS
-- ==========================================================================

local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt
local rep = require("luasnip.extras").rep

return {
	-- Arrow function
	s("af", fmt("({}) => {{\n  {}\n}}", { i(1, "args"), i(0) })),

	-- Const arrow function
	s("caf", fmt("const {} = ({}) => {{\n  {}\n}};", { i(1, "fnName"), i(2, "args"), i(0) })),

	-- Async arrow function with try/catch
	s(
		"afc",
		fmt(
			"const {} = async ({}) => {{\n  try {{\n    {}\n  }} catch (error) {{\n    console.error(error);\n  }}\n}};",
			{ i(1, "fnName"), i(2, "args"), i(0) }
		)
	),

	-- Export function
	s("ef", fmt("export function {}({}) {{\n  {}\n}}", { i(1, "functionName"), i(2, "args"), i(0) })),

	-- Export const arrow function
	s("eaf", fmt("export const {} = ({}) => {{\n  {}\n}};", { i(1, "functionName"), i(2, "args"), i(0) })),

	-- Export const
	s("ec", fmt("export const {} = {};", { i(1, "name"), i(0, "value") })),

	-- Export default function
	s("edf", fmt("export default function {}({}) {{\n  {}\n}}", { i(1, "functionName"), i(2, "args"), i(0) })),

	-- console.log / console.error (label mirrors the variable)
	s("clg", fmt('console.log("{}", {});', { rep(1), i(1, "variable") })),
	s("cle", fmt('console.error("{}", {});', { rep(1), i(1, "variable") })),

	-- React hooks
	s("us", fmt("const [{}, set{}] = useState({});", { i(1, "state"), i(2, "State"), i(3, "null") })),
	s("ue", fmt("useEffect(() => {{\n  {}\n}}, [{}]);", { i(1), i(2) })),
	s("ur", fmt("const {} = useRef({});", { i(1, "refName"), i(2, "null") })),

	-- React component
	s(
		"rafce",
		fmt(
			[[
const {} = () => {{
  return (
    <div>
      {}
    </div>
  );
}};

export default {};
]],
			{ i(1, "ComponentName"), i(0), rep(1) }
		)
	),
}
