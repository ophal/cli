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
    local cmd, output
    local commands, aliases = m.commands, m.aliases

    -- TODO: detect and bootstrap Ophal.

    m.build_aliases()

    -- Execute command
    cmd = commands[arg[1]]
    alias = aliases[arg[1]]
    if type(cmd) == 'table' then
      output = cmd.exec()
    elseif type(alias) == 'table' then
      output = alias.exec()
    end

    print(output)
  end,
}

return m