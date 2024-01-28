require "luaonbeans"
unix = require "unix"
etlua = require "etlua"
multipart = require "multipart"

-- Tables

table.keys = function(t)
  local keys = {}
  for key, _ in pairs(t) do
    table.insert(keys, key)
  end
  return keys
end

table.contains = function(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

table.merge = function(t1, t2)
  for k, v in pairs(t2) do
    t1[k] = v
  end
  return t1
end

table.append = function(t1, t2)
  for _, v in ipairs(t2) do
    table.insert(t1, v)
  end
  return t1
end

-- Strings

string.split = function(inputStr, sep)
  sep = sep or "%s"
  local t = {}
  for str in string.gmatch(inputStr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

string.to_slug = function(str)
  local slug = string.gsub(string.gsub(str, "[^ A-Za-z0-9]", "-"), "[ ]+", "-")
  slug = string.gsub(slug, "[-]+", "-")
  slug = string.gsub(slug, "[-]+$", "")

  return string.lower(slug)
end

string.strip = function(str)
  return (str:gsub("^%s*(.-)%s*$", "%1"))
end

local vowels = { "a", "e", "i", "o", "u" }

local function pluralizeWord(word)
  if word:match("f$") or word:match("fe$") then
    word = word:gsub("f$", "ves"):gsub("fe$", "ves")
  elseif word:match("ch$") or word:match("sh$") or word:match("s$") or word:match("x$") or word:match("z$") or
      (not table.contains(vowels, word:sub(-2, -2)) and word:match("o$")) then
    word = word .. "es"
  elseif not table.contains(vowels, word:sub(-2, -2)) and word:match("y$") then
    word = word:gsub("y$", "ies")
  else
    word = word .. "s"
  end
  return word
end

Pluralize = function(str, deepPluralize)
  if deepPluralize then
    local newStr = ""
    for word in str:gmatch("%S+") do
      newStr = newStr .. pluralizeWord(word) .. " "
    end
    return newStr:sub(1, -1)
  else
    return pluralizeWord(str)
  end
end

local function singularizeWord(word)
  if word:match("ives$") then
    word = word:gsub("ives$", "ife")
  elseif word:match("ves$") then
    word = word:gsub("ves$", "f")
  elseif word:match("shes$") or word:match("ches$") or word:match("ses$") or word:match("xes$") or word:match("zes$") or
      (not table.contains(vowels, word:sub(-4, -4)) and word:match("oes$")) then
    word = word:gsub("es$", "")
  elseif not table.contains(vowels, word:sub(-4, -4)) and word:match("ies$") then
    word = word:gsub("ies$", "y")
  elseif word:match("s$") and word:match("ss$") == nil then
    word = word:sub(1, -2)
  end
  return word
end

Singularize = function(str, deepSingularize)
  if deepSingularize then
    local newStr = ""
    for word in str:gmatch("%S+") do
      newStr = newStr .. singularizeWord(word) .. " "
    end
    return newStr:sub(1, -1)
  else
    return singularizeWord(str)
  end
end

Capitalize = function(str)
  return (string.gsub(str, '^%l', string.upper))
end

Camelize = function(str)
  return Capitalize(string.gsub(str, '%W+(%w+)', Capitalize))
end

-- utilities

GenerateTempFilename = function()
  local filename = EncodeBase64(GetRandomBytes(32))
  filename = string.gsub(filename, "[\\/]", "")
  return "tmp/" .. filename
end

RunCommand = function(command)
  command = string.split(command)
  local prog = assert(unix.commandv(command[1]))

  local output = ""
  local reader, writer = assert(unix.pipe())
  if assert(unix.fork()) == 0 then
    unix.close(1)
    unix.dup(writer)
    unix.close(writer)
    unix.close(reader)
    unix.execve(prog, command, { 'PATH=/bin' })
    unix.exit(127)
  else
    unix.close(writer)
    while true do
      data, err = unix.read(reader)
      if data then
        if data ~= '' then
          output = output .. data
        else
          break
        end
      elseif err:errno() ~= unix.EINTR then
        Log(kLogWarn, tostring(err))
        break
      end
    end
    assert(unix.close(reader))
    unix.wait()
  end

  return output
end

GetFileExt = function(content_type)
  local allowed_types = {
    ["image/gif"] = "gif",
    ["image/jpeg"] = "jpg",
    ["image/png"] = "png",
    ["image/svg+xml"] = "svg",
    ["image/webp"] = "webp",
    ["image/x-icon"] = "ico",

    ["video/mp4"] = "mp4",
    ["video/mpeg"] = "mpeg",
    ["video/ogg"] = "ogv",
    ["video/quicktime"] = "mov",
    ["video/webm"] = "webm",
    ["video/x-flv"] = "flv",
    ["video/x-mng"] = "mng",
    ["video/x-ms-asf"] = "asx",
    ["video/x-ms-wmv"] = "wmv",
    ["video/x-msvideo"] = "avi",

    ["application/pdf"] = "pdf",
    ["text/plain"] = "txt"
  }
  return allowed_types[content_type]
end

-- Prepare MultiPart Params and merge everything in Params
PrepareMultiPartParams = function()
  if GetHeader("Content-Type") ~= nil and string.find(GetHeader("Content-Type"), "multipart") ~= nil then
    local keys = {}
    local multipart_data = multipart(GetBody(), GetHeader("Content-Type"))

    for k, _ in pairs(multipart_data:get_all_with_arrays()) do
      table.insert(keys, k)
    end

    for _, k in pairs(keys) do
      local param = multipart_data:get(k)
      if #param.headers == 1 then
        Params[k] = param.value
      else
        local m = string.find(k, "%[%]")
        if m ~= nil and m > 1 then
          local k_str = string.gsub(k, "%[%]", "")
          Params[k_str] = {}
          for _, param in pairs(multipart_data:get_as_array(k)) do
            local content_type = multipart_data:get_content_type(param.headers)
            local filename = multipart_data:get_filename(param.headers)
            local ext = GetFileExt(content_type)
            if ext then
              table.insert(Params[k_str], {
                ext = ext,
                filename = filename,
                content_type = content_type,
                size = #param.value,
                content = param.value
              })
            end
          end
        else
          local content_type = multipart_data:get_content_type(param.headers)
          local filename = multipart_data:get_filename(param.headers)
          local ext = GetFileExt(content_type)
          if ext then
            Params[k] = {
              ext = ext,
              filename = filename,
              content_type = content_type,
              size = #param.value,
              content = param.value
            }
          end
        end
      end
    end
  end
end
