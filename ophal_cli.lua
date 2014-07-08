local seawolf = {
  contrib = require 'seawolf.contrib',
}
local table_shift = seawolf.contrib.table_shift

local m; m = {

  aliases = {},

  build_aliases = function()
    for _, command in pairs(m.commands) do
      if command.alias ~= nil then
        m.aliases[command.alias] = command
      end
    end
  end,

  bootstrap = function(arg)
    local cmd, output, arguments
    local commands, aliases = m.commands, m.aliases

    -- TODO: detect and bootstrap Ophal.

    m.build_aliases()

    -- Execute command
    cmd = commands[arg[1]]
    alias = aliases[arg[1]]
    arguments = table_shift(arg)
    if type(cmd) == 'table' then
      output = cmd.exec(arguments)
    elseif type(alias) == 'table' then
      output = alias.exec(arguments)
    end

    print(output)
  end,

  commands = {
    ['uuid-generate'] = {
      description = 'Generate a new UUID (depends on luuid Lua module).',
      alias = 'uuid',
      exec = function()
        local uuid = require 'uuid'
        if uuid ~= nil then
          return uuid.new()
        else
          return 'Error: Can not generate a new uuid. Please make sure to have the uuid Lua module installed in your system and try again.'
        end
      end
    },
  },
}

return m