local seawolf = {
  contrib = require 'seawolf.contrib',
  other = require 'seawolf.other',
}
local table_shift = seawolf.contrib.table_shift
local tconcat = table.concat

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
    else
      output = commands.help.exec()
    end

    print(output)
  end,

  commands = {
    help = {
      description = 'Display help information about ophal-cli',
      exec = function(arg)
        local output = {
          "usage: ophal <command> [<args>]\n",
          "Commands:",
        }
        for k, v in pairs(m.commands) do
          output[#output + 1] = ('  %s    %s'):format(k, v.description)
          if v.alias then
            output[#output + 1] = ('  %s'):format(v.alias)
          end
          output[#output + 1] = ''
        end

        return tconcat(output, "\n")
      end
    },

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

    ['sha256-hash'] = {
      description = 'Generate a sha256 hash (depends on lsha2 Lua module).',
      alias = 'sha256',
      exec = function(arg)
        local sha2 = require 'lsha2'

        if sha2 == nil then
          return 'Error: Can not generate a new sha256 hash. Please make sure to have the crypto Lua module installed in your system and try again.'
        end

        if arg[1] == nil then
          return 'Error: Can not generate a new sha256 hash for empty string. Usage: sha256-hash [yoursecret]'
        end

        return seawolf.other.hash('sha256', arg[1])
      end
    },

    ['md5-hash'] = {
      description = 'Generate an md5 hash (depends on md5 Lua module).',
      alias = 'md5',
      exec = function(arg)
        local md5 = require 'md5'

        if md5 == nil then
          return 'Error: Can not generate a new md5 hash. Please make sure to have the crypto Lua module installed in your system and try again.'
        end

        if arg[1] == nil then
          return 'Error: Can not generate a new md5 hash for empty string. Usage: md5-hash [yoursecret]'
        end

        return seawolf.other.hash('md5', arg[1])
      end
    },
  },
}

return m