local lang_utils = require('treesj.langs.utils')

local no_space_in_brackets_list = lang_utils.set_preset_for_list({
  join = { space_in_brackets = false },
})
local no_space_in_brackets_dict = lang_utils.set_preset_for_dict({
  join = { space_in_brackets = false },
})

-- `:`-introduced indented block; single-statement bodies only on join
local body = lang_utils.set_preset_for_non_bracket({
  both = {
    non_bracket_node = { left = '', right = '', outer_framing = false },
    format_resulted_lines = function(lines)
      for i, l in ipairs(lines) do
        lines[i] = l:gsub('%s+$', '')
      end
      while #lines > 1 and lines[#lines] == '' do
        table.remove(lines)
      end
      return lines
    end,
  },
  join = {
    enable = function(node)
      return node:named_child_count() == 1
    end,
  },
})

return {
  arguments = lang_utils.set_preset_for_args(),
  parameters = lang_utils.set_preset_for_args(),
  array = no_space_in_brackets_list,
  dictionary = no_space_in_brackets_dict,
  enumerator_list = no_space_in_brackets_dict,
  body = body,

  -- no `call` redirect: a bare call statement toggles its enclosing block;
  -- its args still split with the cursor inside `()`
  lambda = {
    target_nodes = { 'parameters' },
  },
  function_definition = {
    target_nodes = { 'parameters' },
  },
  enum_definition = {
    target_nodes = { 'enumerator_list' },
  },

  -- block owners with no bracketed child redirect to their body
  if_statement = {
    target_nodes = { 'body' },
  },
  elif_clause = {
    target_nodes = { 'body' },
  },
  else_clause = {
    target_nodes = { 'body' },
  },
  for_statement = {
    target_nodes = { 'body' },
  },
  while_statement = {
    target_nodes = { 'body' },
  },
  pattern_section = {
    target_nodes = { 'body' },
  },

  assignment = {
    target_nodes = { 'array', 'dictionary' },
  },
  augmented_assignment = {
    target_nodes = { 'array', 'dictionary' },
  },
  variable_statement = {
    target_nodes = { 'array', 'dictionary' },
  },
  const_statement = {
    target_nodes = { 'array', 'dictionary' },
  },
  return_statement = {
    target_nodes = { 'array', 'dictionary' },
  },
}
