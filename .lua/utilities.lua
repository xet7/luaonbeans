Unix = require "unix"
Re = require "re"
Etlua = require "etlua"
Multipart = require "multipart"
JWT = require("jwt")

require "utilities.table"
require "utilities.string"
require "utilities.multipart"
require "utilities.csrf"
require "luaonbeans"

ENV = {}
for _, var in pairs(unix.environ()) do
  var = string.split(var, "=")
  ENV[var[1]] = var[2]
end

BeansEnv = ENV['BEANS_ENV'] or "development"