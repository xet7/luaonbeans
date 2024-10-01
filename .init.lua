package.path = package.path .. ";.lua/?.lua"
package.path = package.path .. ";app/models/?.lua;/zip/app/models/?.lua"
package.path = package.path .. ";config/?.lua;/zip/config/?.lua"

-- OTP = require("otp") -- OTP functions
require("utilities")
require("routes")

-- ArangoDB connection
local db_config = DecodeJson(LoadAsset("config/database.json"))
InitDB(db_config)

function OnServerReload()
  require("utilities")
  require("routes")
end

function OnWorkerStart()
  HandleSqliteFork(db_config) -- you can remove it if you do not use SQLite
end

-- OnError hook
function OnError(status, message)
  -- Define the error for an API
  -- WriteJSON({ status = status, message = message })

  -- Define the error page via a page with a layout
  Params.status = status
  Params.message = message
  Page("errors/index", "app")
end

-- OnHttpRequest hook
function OnHttpRequest()
  Params = GetParams()
  PrepareMultiPartParams() -- if you handle file uploads

  -- Remove code if you do not use arangodb
  if (db_config ~= nil and db_config["engine"] == "arangodb") then
    Adb.RefreshToken(db_config[BeansEnv]) -- reconnect to arangoDB if needed
  end

  -- Remove code if you do not use surrealdb
  if (db_config ~= nil and db_config["engine"] == "surrealdb") then
    Surreal.refresh_token(db_config[BeansEnv]) -- reconnect to surrealdb if needed
  end

  DefineRoutes(GetPath(), GetMethod())
end
